const fs = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const ROOT = path.join(__dirname, "..");
const PACKAGE_JSON_PATH = path.join(ROOT, "package.json");
const WALLY_TOML_PATH = path.join(ROOT, "wally.toml");
const ROJO_TREE_PATH = path.join(ROOT, "tools", "genRojoTree.js");
const README_PATH = path.join(ROOT, "README.md");

function parseArgs(argv) {
  const args = {
    install: true,
    dryRun: false,
    help: false,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index];

    if (arg === "--help" || arg === "-h") {
      args.help = true;
      continue;
    }

    if (arg === "--dry-run") {
      args.dryRun = true;
      continue;
    }

    if (arg === "--skip-install") {
      args.install = false;
      continue;
    }

    if (["--name", "--repo", "--wally-scope"].includes(arg)) {
      const value = argv[index + 1];

      if (!value || value.startsWith("--")) {
        throw new Error(`Missing value for ${arg}.`);
      }

      if (arg === "--name") {
        args.name = value.trim();
      }

      if (arg === "--repo") {
        args.repo = value.trim();
      }

      if (arg === "--wally-scope") {
        args.wallyScope = value.trim();
      }

      index += 1;
      continue;
    }

    throw new Error(`Unknown argument: ${arg}`);
  }

  return args;
}

function printHelp() {
  console.log(`Initialize this repository for a new Roblox project.\n\nUsage:\n  npm run init:project -- --name "My Game" --repo "your-org/my-game"\n\nOptions:\n  --name <display name>   Required. Sets the Roblox DataModel name.\n  --repo <owner/repo>     Recommended. Updates package.json repository metadata and defaults the Wally scope to <owner>.\n  --wally-scope <owner>   Optional. Overrides the Wally package scope used in wally.toml.\n  --skip-install          Skip rokit install, npm install, wally install, and Rojo regeneration.\n  --dry-run               Print the planned changes without writing files or running installs.\n  --help                  Show this message.`);
}

function slugify(value) {
  return value
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .replace(/-{2,}/g, "-");
}

function updatePackageJson(packageJson, packageName, repoSlug) {
  const next = { ...packageJson };

  next.name = packageName;

  if (packageName && packageName !== "roblox-template") {
    next.description = `${packageName} Roblox game project.`;
  }

  if (next.repository && repoSlug) {
    next.repository = {
      type: "git",
      url: `git+https://github.com/${repoSlug}.git`,
    };
  }

  if (repoSlug) {
    next.bugs = {
      url: `https://github.com/${repoSlug}/issues`,
    };

    next.homepage = `https://github.com/${repoSlug}#readme`;
  }

  return next;
}

function updateWallyToml(content, packageName) {
  return content.replace(
    /(\[package\][\s\S]*?name\s*=\s*")([^"]+)(")/,
    `$1${packageName}$3`
  );
}

function updateRojoTree(content, displayName) {
  return content.replace(/name:\s*"[^"]+",/, `name: ${JSON.stringify(displayName)},`);
}

function updateReadme(content, displayName, repoSlug) {
  if (!content.includes("npm run init:project")) {
    return content;
  }

  let next = content.replace(
    /npm run init:project -- --name "My Game" --repo "your-org\/my-game"/,
    `npm run init:project -- --name ${JSON.stringify(displayName)} --repo ${JSON.stringify(repoSlug)}`
  );

  next = next.replace(/your-org\/my-game/g, repoSlug);

  return next;
}

function writeTextFile(filePath, content) {
  fs.writeFileSync(filePath, content, "utf8");
}

function runCommand(command, args) {
  const result = spawnSync(command, args, {
    cwd: ROOT,
    stdio: "inherit",
    shell: process.platform === "win32",
  });

  if (result.status !== 0) {
    throw new Error(`Command failed: ${command} ${args.join(" ")}`);
  }
}

function main() {
  const args = parseArgs(process.argv.slice(2));

  if (args.help) {
    printHelp();
    return;
  }

  if (!args.name) {
    throw new Error("--name is required.");
  }

  const repoSlug = args.repo ? args.repo.trim() : null;
  const fallbackPackageName = slugify(args.name);

  if (!fallbackPackageName) {
    throw new Error("Could not derive a package name from the provided display name.");
  }

  const repoParts = repoSlug ? repoSlug.split("/") : [];
  const packageName = repoParts.length === 2 ? repoParts[1] : fallbackPackageName;
  const wallyScope = args.wallyScope || (repoParts.length === 2 ? repoParts[0] : null);

  if (!wallyScope) {
    throw new Error("Provide --repo owner/name or specify --wally-scope explicitly.");
  }

  const wallyPackageName = `${wallyScope}/${packageName}`;
  const packageJson = JSON.parse(fs.readFileSync(PACKAGE_JSON_PATH, "utf8"));
  const wallyToml = fs.readFileSync(WALLY_TOML_PATH, "utf8");
  const rojoTree = fs.readFileSync(ROJO_TREE_PATH, "utf8");
  const readme = fs.existsSync(README_PATH)
    ? fs.readFileSync(README_PATH, "utf8")
    : null;

  const nextPackageJson = updatePackageJson(packageJson, packageName, repoSlug);
  const nextWallyToml = updateWallyToml(wallyToml, wallyPackageName);
  const nextRojoTree = updateRojoTree(rojoTree, args.name);
  const nextReadme = readme ? updateReadme(readme, args.name, repoSlug) : null;

  console.log("Project initialization plan:");
  console.log(`- Display name: ${args.name}`);
  console.log(`- Package name: ${packageName}`);
  console.log(`- Repository slug: ${repoSlug || "not provided"}`);
  console.log(`- Wally package: ${wallyPackageName}`);
  console.log(`- Install toolchain and dependencies: ${args.install ? "yes" : "no"}`);
  console.log(`- Dry run: ${args.dryRun ? "yes" : "no"}`);

  if (args.dryRun) {
    return;
  }

  writeTextFile(PACKAGE_JSON_PATH, `${JSON.stringify(nextPackageJson, null, 2)}\n`);
  writeTextFile(WALLY_TOML_PATH, nextWallyToml);
  writeTextFile(ROJO_TREE_PATH, nextRojoTree);

  if (nextReadme) {
    writeTextFile(README_PATH, nextReadme);
  }

  if (args.install) {
    runCommand("rokit", ["install"]);
    runCommand("npm", ["install"]);
    runCommand("wally", ["install"]);
    runCommand("npm", ["run", "build:rojo"]);
  }

  console.log("Project initialization complete.");
}

try {
  main();
} catch (error) {
  console.error(error.message);
  process.exit(1);
}