const fs = require("fs");
const os = require("os");
const path = require("path");
const { spawnSync } = require("child_process");

const ROOT = path.join(__dirname, "..");
const DEFAULT_TARGETS = ["src", "scripts"];
const DEFAULT_SOURCEMAP_PATH = "sourcemap.json";
const LUAU_LSP_STORAGE_DIR = "johnnymorganz.luau-lsp";
const ROBLOX_DEFINITIONS_FILE = "globalTypes.None.d.luau";
const ROBLOX_DEFINITIONS_ENV_VAR = "LUAU_LSP_ROBLOX_DEFS_PATH";
const WINDOWS_EDITOR_STORAGE_DIRS = ["Code", "Code - Insiders", "VSCodium", "Cursor"];
const ACTIONABLE_RECOVERY_MESSAGE =
  "Roblox engine definitions were not found in the Luau LSP cache. Open VS Code, run 'Luau: Download API Types', then rerun this command.";

function fileExists(filePath) {
  return fs.existsSync(filePath) && fs.statSync(filePath).isFile();
}

function resolveOverridePath() {
  const overridePath = process.env[ROBLOX_DEFINITIONS_ENV_VAR];

  if (!overridePath) {
    return null;
  }

  const resolvedPath = path.isAbsolute(overridePath)
    ? path.normalize(overridePath)
    : path.resolve(ROOT, overridePath);

  if (fileExists(resolvedPath)) {
    return resolvedPath;
  }

  throw new Error(
    `${ROBLOX_DEFINITIONS_ENV_VAR} does not point to an existing file: ${resolvedPath}`
  );
}

function collectGlobalStorageRoots() {
  const roots = [];

  if (process.platform === "win32" && process.env.APPDATA) {
    for (const editorDir of WINDOWS_EDITOR_STORAGE_DIRS) {
      roots.push(path.join(process.env.APPDATA, editorDir, "User", "globalStorage"));
    }

    return roots;
  }

  if (process.platform === "darwin") {
    const appSupportDir = path.join(os.homedir(), "Library", "Application Support");

    for (const editorDir of WINDOWS_EDITOR_STORAGE_DIRS) {
      roots.push(path.join(appSupportDir, editorDir, "User", "globalStorage"));
    }

    return roots;
  }

  const configRoot = process.env.XDG_CONFIG_HOME || path.join(os.homedir(), ".config");

  for (const editorDir of WINDOWS_EDITOR_STORAGE_DIRS) {
    roots.push(path.join(configRoot, editorDir, "User", "globalStorage"));
  }

  return roots;
}

function resolveRobloxDefinitionsPath() {
  const overridePath = resolveOverridePath();

  if (overridePath) {
    return overridePath;
  }

  for (const storageRoot of collectGlobalStorageRoots()) {
    const candidatePath = path.join(
      storageRoot,
      LUAU_LSP_STORAGE_DIR,
      ROBLOX_DEFINITIONS_FILE
    );

    if (fileExists(candidatePath)) {
      return candidatePath;
    }
  }

  throw new Error(ACTIONABLE_RECOVERY_MESSAGE);
}

function buildLuauAnalyzeArgs(options = {}) {
  const args = ["analyze"];
  const formatter = options.formatter ?? null;
  const sourcemapPath = options.sourcemapPath ?? DEFAULT_SOURCEMAP_PATH;
  const targets = options.targets && options.targets.length > 0 ? options.targets : DEFAULT_TARGETS;
  const robloxDefinitionsPath = resolveRobloxDefinitionsPath();

  if (formatter) {
    args.push("--formatter", formatter);
  }

  args.push(
    "--platform",
    "roblox",
    "--sourcemap",
    sourcemapPath,
    "--definitions",
    `@roblox=${robloxDefinitionsPath}`,
    "--definitions",
    "@testez=testez.d.luau",
    ...targets
  );

  return args;
}

function runLuauAnalyze(options = {}) {
  const args = buildLuauAnalyzeArgs(options);
  const result = spawnSync("luau-lsp", args, {
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

  return {
    args,
    status: result.status ?? 0,
    stdout,
    stderr,
    combinedOutput,
  };
}

function parseCliArgs(argv) {
  const args = {
    formatter: null,
    targets: [],
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];

    if (arg === "--formatter") {
      const value = argv[index + 1];

      if (!value || value.startsWith("--")) {
        throw new Error("Missing value for --formatter.");
      }

      args.formatter = value;
      index += 1;
      continue;
    }

    args.targets.push(arg);
  }

  return args;
}

function main() {
  const cliArgs = parseCliArgs(process.argv.slice(2));
  const result = runLuauAnalyze({
    formatter: cliArgs.formatter,
    targets: cliArgs.targets,
  });

  if (result.stdout) {
    process.stdout.write(result.stdout);
  }

  if (result.stderr) {
    process.stderr.write(result.stderr);
  }

  if (result.status !== 0) {
    process.exit(result.status);
  }
}

module.exports = {
  ACTIONABLE_RECOVERY_MESSAGE,
  buildLuauAnalyzeArgs,
  resolveRobloxDefinitionsPath,
  runLuauAnalyze,
};

if (require.main === module) {
  try {
    main();
  } catch (error) {
    console.error(error.message);
    process.exit(1);
  }
}