# Source Architecture

Use this guide when adding or moving files under `src/`. Tool commands and diagnostics live in [genrojotree-setup.md](genrojotree-setup.md).

## Top-Level Layout

Use these exact names and casing:

```text
src/
  Classes/
  Examples/
  Modules/
  Services/
  Startup/
  UI/
```

Windows can hide case-only mistakes, but Rojo output and CI can still behave differently. Keep casing stable.

## Rojo Mapping Rules

`tools/genRojoTree.js` scans `src/` and writes `default.project.json`.

- Do not edit `default.project.json` by hand for normal source changes.
- `src/Startup/Client.client.luau` maps to `StarterPlayer/StarterPlayerScripts/Client`.
- `src/Startup/Server.server.luau` maps to `ServerScriptService/Server`.
- `src/UI` maps as one folder to `ReplicatedStorage.UI`.
- Shared source maps under `ReplicatedStorage.Shared`.
- `Server.luau` and filenames containing `server` map to `ServerScriptService`.
- `Client.luau`, `Utils.luau`, and `Types.luau` map to replicated shared locations.
- `init.luau` claims its parent folder in the generated tree; child modules under that folder are not mapped individually.

Service example:

```text
src/Services/FooService/Client.luau -> ReplicatedStorage.Shared.Services.FooService.FooServiceClient
src/Services/FooService/Server.luau -> ServerScriptService.Services.FooService.FooServiceServer
src/Services/FooService/Utils.luau  -> ReplicatedStorage.Shared.Services.FooService.FooServiceUtils
```

Avoid putting `server` in a shared filename unless it is intentionally server-only.

## `src/Startup`

Entrypoints only.

- Use `Client.client.luau` to require and initialize client-facing services and UI boot code.
- Use `Server.server.luau` to require and initialize server services. If a test runner is wired in this file, keep it grouped after service initialization under an explicit test-runner block.
- Do not put gameplay logic, data tables, UI components, or placeholder service startup here.

## `src/Services`

Use services for feature ownership with lifecycle, networking, authority, player data, validation, cooldowns, or cross-module orchestration.

Standard layout:

```text
src/Services/
  InventoryService/
    Client.luau
    Server.luau
    Utils.luau
    Types.luau
```

Guidelines:

- Name service folders `<Domain>Service`.
- Keep server authority and trusted writes in `Server.luau`.
- Keep local input, UI requests, and client calls in `Client.luau`.
- Put shared calculations and contracts that are safe to replicate in `Utils.luau` or `Types.luau`.
- Add service-local helper modules beside the service when they are not broadly reusable.
- Split a service into subfolders when it grows coherent subareas; do not turn `Utils.luau` into a catch-all.

Common reusable services include inventory, levels, loot, quests, notifications, settings, monetization, tutorials, battle, duels, clans, trading, and build systems. Add only the services the current game actually needs.

## `src/Modules`

Use modules for shared code without a service lifecycle.

Recommended areas:

```text
src/Modules/
  Core/      project-wide config, data templates, codecs, base utilities
  Game/      domain config, rules, requirements, item definitions
  Math/      deterministic math helpers
  Platform/  Roblox platform wrappers and retry helpers
  Test/      TestEZ runner and specs
  UI/        UI-specific pure helpers that are not React components
```

Keep modules pure. If a module starts owning remotes, player connections, startup behavior, server writes, or long-lived state, move that responsibility into a service or class.

## `src/Classes`

Use classes for constructor-based modules with instance state, methods, lifetime, and cleanup.

- A single self-contained class can stay as `src/Classes/Foo.luau`.
- Create a folder for a family of classes or collaborators, for example `src/Classes/Battle/` or `src/Classes/PhysicsEngine/`.
- Use plain modules for stateless calculations and data transforms.

## `src/UI`

`src/UI` is fully replicated to `ReplicatedStorage.UI`. Do not put server-only secrets, privileged data, or server authority here.

New UI layout:

```text
src/UI/
  app/          root app composition and UI boot modules
  core/         reusable UI framework pieces
    components/
    hooks/
    primitives/
  features/     feature-owned screens, components, hooks, and state
  hud/          always-visible gameplay HUD regions
  shared/       reusable domain-aware widgets
```

Placement rules:

- Put primitive wrappers in `UI/core/primitives`.
- Put reusable framework components in `UI/core/components`.
- Put reusable hooks in `UI/core/hooks`.
- Put domain-aware widgets reused by multiple features in `UI/shared`.
- Put feature screens, feature-only components, hooks, and state in `UI/features/<feature>`.
- Put always-visible HUD regions in `UI/hud/<RegionName>`.
- Create a feature folder as soon as a UI feature has state plus screens or components.

Legacy or staging folders such as `Components`, `Hooks`, `Screens`, `Store`, `ComponentsOld`, or `ScreensOld` are reference areas. Do not add new work there unless a task explicitly asks for migration or compatibility work.

## When To Create A Folder

Create a dedicated folder when it improves ownership or reuse:

- The feature has both client and server behavior.
- The feature owns networking, player lifecycle, persistent state, validation, cooldowns, or authority.
- A UI feature has state plus components, screens, or hooks.
- A class family has multiple collaborators or variants.
- The code is already reused by multiple modules, or the task states that it must be reusable across games.

Keep a single file when the module has one public responsibility, stays pure, and has no second caller or task-stated reuse requirement.

## Implementation Checklists

When adding a service:

1. Create `src/Services/<Name>Service`.
2. Add `Server.luau` for server-owned behavior or data.
3. Add `Client.luau` for local input, UI requests, or replicated calls.
4. Add `Utils.luau` for shared behavior, `Types.luau` for shared type contracts, or smaller helper modules for concrete service-local helpers. Leave empty helper files out.
5. Wire startup after the service has an `init` path or a required boot-time side effect. Leave startup unchanged for placeholder modules.
6. Add focused TestEZ specs for deterministic logic.

When adding a UI feature:

1. Use `src/UI/app` for app infrastructure, `src/UI/hud` for always-visible HUD, `src/UI/features/<feature>` for feature-owned UI, and `src/UI/shared` for reusable widgets.
2. Create `src/UI/features/<feature>` for feature-owned UI.
3. Add `components`, `screens`, `state`, or `hooks` for concrete files. Leave empty folders out.
4. Put reusable primitives and hooks under `src/UI/core`.
5. Put domain widgets reused by multiple features under `src/UI/shared`.
6. Keep feature state in the feature folder. Move it to `src/UI/app` or `src/UI/hud` only when app composition or HUD code reads or writes it across feature boundaries.
