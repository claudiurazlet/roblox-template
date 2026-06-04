const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");
const { runLuauAnalyze } = require("./runLuauAnalyze");

const ROOT = path.join(__dirname, "..");
const SRC_DIR = path.join(ROOT, "src");
const REPORT_DIR = path.join(ROOT, "tasks", "local", "diagnostics");
const GNU_DIAGNOSTIC_PATTERN = /^(?<file>.+?)(?: \[(?<modulePath>[^\]]+)\])?:(?<startLine>\d+)\.(?<startColumn>\d+)-(?<endLine>\d+)\.(?<endColumn>\d+): (?<rawMessage>.+)$/;

function parseArgs(argv) {
  const args = {
    scope: "changed",
    help: false,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];

    if (arg === "--help" || arg === "-h") {
      args.help = true;
      continue;
    }

    if (arg === "--scope") {
      const value = argv[index + 1];

      if (!value || value.startsWith("--")) {
        throw new Error("Missing value for --scope.");
      }

      if (!["changed", "all"].includes(value)) {
        throw new Error(`Unsupported scope: ${value}`);
      }

      args.scope = value;
      index += 1;
      continue;
    }

    throw new Error(`Unknown argument: ${arg}`);
  }

  return args;
}

function printHelp() {
  console.log(`Export saved-file Luau diagnostics for src/**.\n\nUsage:\n  node tools/exportLuauDiagnostics.js [--scope changed|all]\n\nOptions:\n  --scope <changed|all>  Select git-changed src files or all src files. Defaults to changed.\n  --help                 Show this message.`);
}

function normalizeSlashes(value) {
  return value.replace(/\\/g, "/");
}

function normalizeAbsolute(filePath) {
  const resolved = path.resolve(filePath);

  return process.platform === "win32" ? resolved.toLowerCase() : resolved;
}

function toRelative(filePath) {
  return normalizeSlashes(path.relative(ROOT, filePath));
}

function isUnderSrc(relativePath) {
  return relativePath === "src" || relativePath.startsWith("src/");
}

function isAnalyzableLuauFile(filePath) {
  const extension = path.extname(filePath).toLowerCase();

  return extension === ".lua" || extension === ".luau";
}

function comparePaths(left, right) {
  return left.relativePath.localeCompare(right.relativePath);
}

function runCommand(command, args, options = {}) {
  const result = spawnSync(command, args, {
    cwd: ROOT,
    encoding: "utf8",
    shell: process.platform === "win32",
  });

  if (result.error) {
    throw result.error;
  }

  const stdout = result.stdout || "";
  const stderr = result.stderr || "";
  const combinedOutput = [stdout, stderr].filter(Boolean).join("\n").trim();

  if (result.status !== 0 && !options.allowFailure) {
    const details = combinedOutput ? `\n${combinedOutput}` : "";
    throw new Error(`Command failed: ${command} ${args.join(" ")}${details}`);
  }

  return {
    status: result.status ?? 0,
    stdout,
    stderr,
    combinedOutput,
  };
}

function makeCandidateFile(relativePath) {
  const absolutePath = path.resolve(ROOT, relativePath);

  return {
    absolutePath,
    normalizedPath: normalizeAbsolute(absolutePath),
    relativePath: normalizeSlashes(relativePath),
    analyzable: isAnalyzableLuauFile(relativePath),
  };
}

function collectChangedSrcFiles() {
  const result = runCommand("git", ["status", "--porcelain", "--untracked-files=all", "--", "src"]);
  const filesByPath = new Map();

  for (const rawLine of result.combinedOutput.split(/\r?\n/)) {
    if (!rawLine.trim() || rawLine.startsWith("!!")) {
      continue;
    }

    let relativePath = rawLine.slice(3).trim();

    if (relativePath.includes(" -> ")) {
      const parts = relativePath.split(" -> ");
      relativePath = parts[parts.length - 1].trim();
    }

    if (
      (relativePath.startsWith('"') && relativePath.endsWith('"')) ||
      (relativePath.startsWith("'") && relativePath.endsWith("'"))
    ) {
      relativePath = relativePath.slice(1, -1);
    }

    const absolutePath = path.resolve(ROOT, relativePath);

    if (!fs.existsSync(absolutePath) || !fs.statSync(absolutePath).isFile()) {
      continue;
    }

    const normalizedRelativePath = toRelative(absolutePath);

    if (!isUnderSrc(normalizedRelativePath)) {
      continue;
    }

    filesByPath.set(normalizeAbsolute(absolutePath), makeCandidateFile(normalizedRelativePath));
  }

  return Array.from(filesByPath.values()).sort(comparePaths);
}

function walkFiles(rootDir) {
  const files = [];

  if (!fs.existsSync(rootDir)) {
    return files;
  }

  for (const entry of fs.readdirSync(rootDir, { withFileTypes: true })) {
    const absolutePath = path.join(rootDir, entry.name);

    if (entry.isDirectory()) {
      files.push(...walkFiles(absolutePath));
      continue;
    }

    if (entry.isFile()) {
      files.push(absolutePath);
    }
  }

  return files;
}

function collectAllSrcFiles() {
  return walkFiles(SRC_DIR)
    .map((absolutePath) => makeCandidateFile(toRelative(absolutePath)))
    .sort(comparePaths);
}

function runAnalyzerPrerequisites() {
  runCommand("npm", ["run", "build:rojo"]);
  runCommand("npm", ["run", "build:luau:sourcemap"]);
}

function runAnalyzer() {
  return runLuauAnalyze({
    formatter: "gnu",
  });
}

function splitDiagnosticMessage(rawMessage) {
  const separatorIndex = rawMessage.indexOf(": ");

  if (separatorIndex === -1) {
    return {
      kind: "Diagnostic",
      message: rawMessage,
    };
  }

  return {
    kind: rawMessage.slice(0, separatorIndex),
    message: rawMessage.slice(separatorIndex + 2),
  };
}

function parseAnalyzerOutput(output) {
  const diagnostics = [];
  const unparsedLines = [];

  for (const rawLine of output.split(/\r?\n/)) {
    const line = rawLine.trim();

    if (!line) {
      continue;
    }

    const match = GNU_DIAGNOSTIC_PATTERN.exec(line);

    if (!match || !match.groups) {
      unparsedLines.push(rawLine);
      continue;
    }

    const absolutePath = path.resolve(match.groups.file);
    const relativePath = toRelative(absolutePath);
    const normalizedPath = normalizeAbsolute(absolutePath);
    const splitMessage = splitDiagnosticMessage(match.groups.rawMessage);

    diagnostics.push({
      absolutePath,
      normalizedPath,
      relativePath,
      modulePath: match.groups.modulePath || null,
      startLine: Number(match.groups.startLine),
      startColumn: Number(match.groups.startColumn),
      endLine: Number(match.groups.endLine),
      endColumn: Number(match.groups.endColumn),
      kind: splitMessage.kind,
      message: splitMessage.message,
      rawMessage: match.groups.rawMessage,
    });
  }

  return {
    diagnostics,
    unparsedLines,
  };
}

function makeDiagnosticKey(diagnostic) {
  return [
    diagnostic.normalizedPath,
    diagnostic.startLine,
    diagnostic.startColumn,
    diagnostic.endLine,
    diagnostic.endColumn,
    diagnostic.rawMessage,
  ].join(":");
}

function dedupeDiagnostics(diagnostics) {
  const dedupedDiagnostics = [];
  const seenDiagnostics = new Set();

  for (const diagnostic of diagnostics) {
    const key = makeDiagnosticKey(diagnostic);

    if (seenDiagnostics.has(key)) {
      continue;
    }

    seenDiagnostics.add(key);
    dedupedDiagnostics.push(diagnostic);
  }

  return dedupedDiagnostics;
}

function groupDiagnosticsByFile(diagnostics) {
  const groups = new Map();

  for (const diagnostic of diagnostics) {
    if (!groups.has(diagnostic.relativePath)) {
      groups.set(diagnostic.relativePath, []);
    }

    groups.get(diagnostic.relativePath).push(diagnostic);
  }

  return Object.fromEntries(
    Array.from(groups.entries())
      .sort(([left], [right]) => left.localeCompare(right))
      .map(([relativePath, entries]) => [
        relativePath,
        entries.sort((left, right) => {
          if (left.startLine !== right.startLine) {
            return left.startLine - right.startLine;
          }

          if (left.startColumn !== right.startColumn) {
            return left.startColumn - right.startColumn;
          }

          return left.rawMessage.localeCompare(right.rawMessage);
        }),
      ])
  );
}

function formatCandidateLine(candidateFile) {
  return candidateFile.analyzable
    ? `- ${candidateFile.relativePath}`
    : `- ${candidateFile.relativePath} (not a Luau script)`;
}

function formatDiagnosticLine(diagnostic) {
  const location = `${diagnostic.startLine}:${diagnostic.startColumn}-${diagnostic.endLine}:${diagnostic.endColumn}`;
  const moduleSuffix = diagnostic.modulePath ? ` [${diagnostic.modulePath}]` : "";

  return `- ${location} ${diagnostic.rawMessage}${moduleSuffix}`;
}

function buildMarkdownReport(reportData) {
  const lines = [
    "# Luau Diagnostics Export",
    "",
    `Generated: ${reportData.generatedAt}`,
    `Scope: ${reportData.scope}`,
    `Files considered: ${reportData.candidateFiles.length}`,
    `Analyzable Luau files: ${reportData.analyzableFiles.length}`,
    `Analyzer run: ${reportData.analysis.skipped ? "skipped" : "completed"}`,
    `Observed src diagnostics: ${reportData.analysis.observedSrcDiagnosticCount}`,
    `Selected diagnostics: ${reportData.selectedDiagnosticCount}`,
    `Selected files with diagnostics: ${reportData.filesWithDiagnostics.length}`,
  ];

  if (reportData.analysis.skippedReason) {
    lines.push(`Analyzer skip reason: ${reportData.analysis.skippedReason}`);
  }

  if (!reportData.analysis.skipped) {
    lines.push(`Analyzer formatter: ${reportData.analysis.formatter}`);
    lines.push(`Analyzer exit code: ${reportData.analysis.exitCode}`);
    lines.push(`Out-of-scope src diagnostics: ${reportData.analysis.outOfScopeSrcDiagnosticCount}`);
  }

  lines.push("", `Artifacts:`, `- ${reportData.artifacts.markdownRelativePath}`, `- ${reportData.artifacts.jsonRelativePath}`, "", `## Files Considered (${reportData.candidateFiles.length})`);

  if (reportData.candidateFiles.length === 0) {
    lines.push("NONE");
  } else {
    for (const candidateFile of reportData.candidateFiles) {
      lines.push(formatCandidateLine(candidateFile));
    }
  }

  lines.push("", `## Diagnostics (${reportData.selectedDiagnosticCount})`);

  if (reportData.selectedDiagnosticCount === 0) {
    lines.push("No diagnostics found for the selected scope.");
  } else {
    for (const [relativePath, diagnostics] of Object.entries(reportData.diagnosticsByFile)) {
      lines.push("", `### ${relativePath}`);

      for (const diagnostic of diagnostics) {
        lines.push(formatDiagnosticLine(diagnostic));
      }
    }
  }

  if (reportData.analysis.unparsedLines.length > 0) {
    lines.push("", `## Unparsed Analyzer Lines (${reportData.analysis.unparsedLines.length})`);

    for (const line of reportData.analysis.unparsedLines) {
      lines.push(`- ${line}`);
    }
  }

  return `${lines.join("\n")}\n`;
}

function writeArtifacts(scope, reportData) {
  fs.mkdirSync(REPORT_DIR, { recursive: true });

  const stem = scope === "all" ? "luau-all" : "luau-changed";
  const markdownPath = path.join(REPORT_DIR, `${stem}.md`);
  const jsonPath = path.join(REPORT_DIR, `${stem}.json`);

  reportData.artifacts = {
    markdownPath,
    jsonPath,
    markdownRelativePath: toRelative(markdownPath),
    jsonRelativePath: toRelative(jsonPath),
  };

  fs.writeFileSync(markdownPath, buildMarkdownReport(reportData), "utf8");
  fs.writeFileSync(jsonPath, `${JSON.stringify(reportData, null, 2)}\n`, "utf8");
}

function main() {
  const args = parseArgs(process.argv.slice(2));

  if (args.help) {
    printHelp();
    return;
  }

  const candidateFiles = args.scope === "all" ? collectAllSrcFiles() : collectChangedSrcFiles();
  const analyzableFiles = candidateFiles.filter((candidateFile) => candidateFile.analyzable);
  const candidatePaths = new Set(candidateFiles.map((candidateFile) => candidateFile.normalizedPath));
  const generatedAt = new Date().toISOString();

  let analysis = {
    skipped: false,
    skippedReason: null,
    formatter: "gnu",
    exitCode: 0,
    observedSrcDiagnosticCount: 0,
    outOfScopeSrcDiagnosticCount: 0,
    unparsedLines: [],
  };

  let selectedDiagnostics = [];

  if (analyzableFiles.length === 0) {
    analysis = {
      ...analysis,
      skipped: true,
      skippedReason:
        candidateFiles.length === 0
          ? "No src files matched the requested scope."
          : "The requested scope did not include any Luau files.",
    };
  } else {
    runAnalyzerPrerequisites();

    const analyzerResult = runAnalyzer();
    const parsedOutput = parseAnalyzerOutput(analyzerResult.combinedOutput);
    const srcDiagnostics = dedupeDiagnostics(
      parsedOutput.diagnostics.filter((diagnostic) => isUnderSrc(diagnostic.relativePath))
    );

    if (analyzerResult.status !== 0 && srcDiagnostics.length === 0) {
      const details = analyzerResult.combinedOutput ? `\n${analyzerResult.combinedOutput}` : "";
      throw new Error(`luau-lsp analyze failed without parseable src diagnostics.${details}`);
    }

    selectedDiagnostics = srcDiagnostics.filter((diagnostic) => candidatePaths.has(diagnostic.normalizedPath));
    analysis = {
      ...analysis,
      exitCode: analyzerResult.status,
      observedSrcDiagnosticCount: srcDiagnostics.length,
      outOfScopeSrcDiagnosticCount: srcDiagnostics.length - selectedDiagnostics.length,
      unparsedLines: parsedOutput.unparsedLines,
    };
  }

  const diagnosticsByFile = groupDiagnosticsByFile(selectedDiagnostics);
  const filesWithDiagnostics = Object.keys(diagnosticsByFile);
  const reportData = {
    generatedAt,
    scope: args.scope,
    root: ROOT,
    candidateFiles,
    analyzableFiles: analyzableFiles.map((candidateFile) => candidateFile.relativePath),
    selectedDiagnosticCount: selectedDiagnostics.length,
    filesWithDiagnostics,
    diagnosticsByFile,
    analysis,
    artifacts: {
      markdownPath: null,
      jsonPath: null,
      markdownRelativePath: null,
      jsonRelativePath: null,
    },
  };

  writeArtifacts(args.scope, reportData);

  console.log(`Luau diagnostics export complete for scope '${args.scope}'.`);
  console.log(`Markdown report: ${reportData.artifacts.markdownPath}`);
  console.log(`JSON report: ${reportData.artifacts.jsonPath}`);
  console.log(`Selected diagnostics: ${reportData.selectedDiagnosticCount}`);

  if (selectedDiagnostics.length > 0) {
    process.exitCode = 1;
  }
}

try {
  main();
} catch (error) {
  console.error(error.message);
  process.exit(1);
}