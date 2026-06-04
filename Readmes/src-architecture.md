# Source Architecture Guide

This guide documents how agents should work inside `src` for this Roblox template.

## Scope

Only the `src` folder is covered here. Other project folders exist for tooling, packages, generated output, tasks, and documentation.

The canonical top-level source layout is:

```text
src/
  Classes/
  Examples/
  Modules/
  Services/
  Startup/
  UI/
```

Use these exact top-level names and casing. Windows can hide case-only mistakes that later cause confusing Rojo or CI behavior.

## Rojo Mapping

`tools/genRojoTree.js` scans `src` and writes `default.project.json`.

- Do not edit `default.project.json` manually for normal source changes.
- `src/UI` is mapped as a whole to `ReplicatedStorage.UI`.
- `src/Startup/Client.client.luau` maps to `StarterPlayer/StarterPlayerScripts`.
- `src/Startup/Server.server.luau` maps to `ServerScriptService`.
- Generic files under `src`, except `UI` and `Startup`, are mapped by filename and folder.
- A filename containing `server` maps to `ServerScriptService`; other `.luau` files map to `ReplicatedStorage.Shared`.
- `init.luau` claims its parent folder in the generated tree. Use it deliberately because child files under that folder are no longer mapped individually by the generator.

Common service mapping examples:

```text
src/Services/FooService/Client.luau
  -> ReplicatedStorage.Shared.Services.FooService.FooServiceClient

src/Services/FooService/Server.luau
  -> ServerScriptService.Services.FooService.FooServiceServer

src/Services/FooService/Utils.luau
  -> ReplicatedStorage.Shared.Services.FooService.FooServiceUtils
```

Avoid putting the word `server` in a shared module filename unless it is intentionally server-only. For example, `ServerTime.luau` outside `src/UI` would be treated as server code by the current generator.

## Folder Responsibilities

### `src/Startup`

Entrypoints only.

- `Client.client.luau` should require and initialize client-facing services and UI boot code.
- `Server.server.luau` should require and initialize server services and test runners when appropriate.
- Do not put gameplay logic, data tables, or UI components here.
- Do not initialize placeholder services. Add startup wiring only when the service has real runtime behavior.

### `src/Services`

Use this for feature services with lifecycle, networking, authority, player data, validation, cooldowns, or cross-module orchestration.

Preferred layout:

```text
src/Services/
  InventoryService/
    Client.luau
    Server.luau
    Utils.luau       optional shared helper
    Types.luau       optional exported types
```

Rules:

- Name service folders `<Domain>Service`, for example `QuestService` or `LootService`.
- Keep server authority in `Server.luau`.
- Keep Roblox input, local UI calls, and client requests in `Client.luau`.
- Put shared calculations that are safe to replicate in `Utils.luau`.
- Add service-specific helper modules in the same folder when they are not broadly reusable.
- If a service grows multiple coherent subareas, create subfolders inside that service rather than dumping everything into `Utils.luau`.

Create a new service folder when the feature owns a separate runtime concern. Examples that commonly belong here across games:

- `InventoryService`
- `LevelService`
- `LootService`
- `QuestService`
- `NotificationService`
- `SettingsService`
- `MonetizationService`
- `TutorialService`

More game-specific services such as battle, duel, clan, clash, trading, or bot-building should be added only when that game actually needs them.

### `src/Modules`

Use this for shared modules without their own service lifecycle.

Recommended subfolders:

```text
src/Modules/
  Core/       project-wide config, data templates, codecs, base utilities
  Game/       domain config, rules, requirements, item definitions
  Math/       deterministic math helpers
  Platform/   Roblox platform wrappers and retry helpers
  Test/       TestEZ runner and specs
  UI/         UI-specific pure helpers when they are not React components
```

Create domain subfolders under `Modules/Game` when data becomes more than a single file:

```text
src/Modules/Game/Quests/
  init.luau
  DailyQuestDefinitions.luau
  QuestRewards.luau
```

Keep modules pure where possible. If a module starts managing remotes, player connections, startup behavior, or server writes, move that concern into `src/Services`.

### `src/Classes`

Use this for class-style Luau modules with constructors, instance state, methods, and cleanup.

Examples:

```text
src/Classes/
  Battle/
  Bot/
  PhysicsEngine/
  CacheStore.luau
```

Create a folder when a class family has multiple collaborators or subclasses. A single self-contained class can stay as `src/Classes/Foo.luau`.

### `src/UI`

`src/UI` is replicated as a whole. Do not put server-only secrets or privileged data here.

Preferred new UI layout:

```text
src/UI/
  app/          root app composition and UI boot modules
  core/         reusable UI framework pieces
    components/
    hooks/
    primitives/
  features/     feature-specific UI packages
    quest/
      components/
      screens/
      state/
  hud/          always-visible gameplay HUD regions
    BottomBar/
    LeftSideBar/
    TopBar/
    state/
  shared/       reusable domain-aware UI widgets
  Stories/      story/demo entrypoints when used by tooling
```

The template may also contain broad folders such as `Components`, `Hooks`, `Screens`, and `Store`. Treat those as legacy, compatibility, or staging areas. For new reusable work, prefer `core`, `features`, `hud`, and `shared`.

UI placement rules:

- Put primitive wrappers such as buttons, labels, boxes, and scalable frames in `UI/core/primitives`.
- Put reusable framework-level components in `UI/core/components`.
- Put reusable UI hooks in `UI/core/hooks`.
- Put domain-aware reusable widgets in `UI/shared`.
- Put always-visible HUD regions in `UI/hud/<RegionName>`.
- Put feature screens, feature state, feature hooks, and feature-only components in `UI/features/<feature>`.
- If a feature UI grows state plus screens plus components, create the feature folder immediately instead of placing files in separate global folders.

HUD examples:

```text
src/UI/hud/
  BottomBar/
    init.luau
    XpBar.luau
  LeftSideBar/
    init.luau
    CurrencyDisplay.luau
  TopBar/
  state/
    hudSlice.luau
```

Feature UI examples:

```text
src/UI/features/
  loot/
    components/
    screens/
    state/
  quest/
    components/
    state/
  shop/
    components/
    screens/
    state/
```

## When To Create A Dedicated Folder

Create a dedicated folder when it improves ownership or reuse. Good triggers:

- More than one file belongs to the same feature.
- A module has both data and behavior.
- A UI feature has state plus components or screens.
- A service needs client/server/shared parts.
- The code is likely to be copied into another Roblox game.
- The name represents a product concept such as inventory, quests, loot, levels, shop, profile, tutorial, or settings.

Keep a single file when the module is tiny, pure, and unlikely to grow.

## Service Implementation Checklist

When adding a real service:

1. Create `src/Services/<Name>Service`.
2. Add `Server.luau` if the server owns behavior or data.
3. Add `Client.luau` if clients need local input, UI requests, or replicated calls.
4. Add `Utils.luau` or smaller helper modules only for shared, non-privileged logic.
5. Wire the server service in `src/Startup/Server.server.luau` only when it must run on boot.
6. Wire the client service in `src/Startup/Client.client.luau` only when it must run on boot.
7. Add focused TestEZ specs under `src/Modules/Test/Specs` when the behavior is testable outside Studio.

## UI Implementation Checklist

When adding a UI feature:

1. Decide whether it is global HUD, feature UI, shared widget, or core UI infrastructure.
2. Create `src/UI/features/<feature>` for feature-owned UI.
3. Add `components`, `screens`, `state`, `hooks`, or `hud` subfolders only when the feature actually needs them.
4. Put reusable primitives in `src/UI/core`, not inside a feature.
5. Put domain-aware widgets reused by multiple features in `src/UI/shared`.
6. Keep UI state close to the feature unless it is truly global HUD/app state.
7. Add story/demo files under `src/UI/Stories` only when the repo's UI tooling uses them.

