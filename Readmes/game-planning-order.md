# Game Planning Order

Use this checklist when starting a new Roblox game in this repository. It is written for early planning, prototyping, and first playable milestones, not for every production task.

Skip steps that do not fit the game, but keep the order conservative: prove the core loop first, then add durable systems when the loop creates data worth owning, showing, or saving.

## Default Build Order

1. Define the core loop.
   - Write one sentence in this shape: "The player does X to earn Y, then uses Y to unlock Z."
   - Decide the first five-minute goal, expected session length, initial server size, and primary devices.
   - Decide what counts as success, failure, reset, and reward.

2. Prototype the core mechanic.
   - Build one repeatable action before broad progression, shops, menus, or final art.
   - Examples: place one object, collect one resource, defeat one enemy, finish one route, craft one item, solve one puzzle, or win one short round.
   - Put deterministic rules in `src/Modules/Game`, `src/Modules/Math`, or service-local helpers.
   - Create a service only when the mechanic needs lifecycle, networking, player state, validation, cooldowns, or authority.

3. Make the first playable loop.
   - Add spawn, input, feedback, reward, failure, and reset.
   - Use a greybox map, simple parts, temporary effects, and placeholder numbers.
   - Keep the loop playable with at least two players if the final game is multiplayer.

4. Add server authority and networking.
   - Use `Networker` for service-level client/server communication before adding raw remotes.
   - Keep client code focused on input, prediction, local presentation, and UI requests.
   - Keep server code responsible for validation, trusted writes, rewards, cooldowns, ownership, and player lifecycle.
   - Good early service examples: `BuildService`, `CombatService`, `HarvestService`, `RaceService`, `RoundService`, or another service named after the main action.

5. Add minimal HUD and readable feedback.
   - Show only information needed to understand and repeat the loop.
   - Examples: resource count, health, timer, current objective, placement preview state, cooldown state, or round result.
   - Put always-visible gameplay UI under `src/UI/hud`.
   - Put reusable UI building blocks under `src/UI/core`, for example `src/UI/core/components/Button.luau` or `src/UI/core/components/IconButton.luau`.

6. Add progression rules.
   - Add progression only after the core action can produce rewards repeatedly.
   - Start with one or two progression axes: coins, XP, levels, item unlocks, upgrades, quests, rank, or map access.
   - Keep formulas, requirements, reward tables, and item definitions testable in `src/Modules/Game`.
   - Example modules: `LevelRules.luau`, `RewardRules.luau`, `UpgradeRules.luau`, `InventoryRules.luau`, or `Items.luau`.

7. Add gameplay services for owned state.
   - Add services when a feature must own player data, enforce rules, or coordinate multiple modules.
   - Common examples: `LevelService`, `InventoryService`, `EconomyService`, `QuestService`, `ShopService`, `TutorialService`, `NotificationService`, and `SettingsService`.
   - Avoid creating placeholder services for systems that are not used by the current playable loop.

8. Add persistence.
   - Add persistence after the data shape is clear enough to keep across sessions.
   - Use `Dataservice` plus `ServicePlayerData` for standard per-player persistence.
   - Persist only server-owned data such as level, XP, currency, inventory, unlocked upgrades, quest progress, settings, and durable stats.
   - Keep defaults, schemas, migrations, and serialization rules small and testable.

9. Add feature screens and meta UI.
   - Build screens that let the player use the progression systems already present.
   - Examples: inventory, upgrade shop, quest log, settings, tutorial prompts, rewards screen, leaderboard, trading, or cosmetics.
   - Put feature-owned screens under `src/UI/features/<feature>`.
   - Put domain-aware widgets reused by multiple features under `src/UI/shared`.

10. Expand content.
   - Add more map segments, items, enemies, resources, quests, hazards, upgrades, or round variants.
   - Add content by extending existing rules and data tables before creating new systems.
   - Playtest pacing after every meaningful content batch.

11. Polish, optimize, and widen device support.
   - Improve animation, sound, VFX, camera, controls, onboarding, mobile layout, console prompts, and accessibility.
   - Check cleanup, repeated allocations, polling, remote volume, startup work, replication cost, and UI churn.
   - Raise player count only after readability, server cost, and reward contention are proven.

## Service Creation Order

Use this as a default service order for many Roblox games. Some games will skip several items.

1. Main mechanic service, such as `BuildService`, `CombatService`, `HarvestService`, or `RaceService`.
2. Session or round service, such as `RoundService`, only if the game has timed rounds, matches, waves, or reset phases.
3. Reward or economy service, such as `EconomyService`, once the main loop grants spendable rewards.
4. Level service, such as `LevelService`, once XP, ranks, unlocks, or gates affect the loop.
5. Inventory or equipment service, such as `InventoryService`, once items can be earned, spent, equipped, crafted, or consumed.
6. Persistence integration once the owned data is stable enough to save.
7. Quest, tutorial, shop, settings, notification, social, monetization, and leaderboard services after the core loop and progression need them.

## Concrete Work Packages

### Core Mechanic

- Create or extend the main mechanic service under `src/Services/<Mechanic>Service`.
- Put shared validation and formulas in `Utils.luau` or focused modules under `src/Modules/Game`.
- Add focused TestEZ specs for deterministic rules.
- Wire startup only when the service has real boot behavior.

### Levels

- Create `src/Modules/Game/LevelRules.luau` for XP thresholds, level caps, rewards, and unlock checks.
- Create `src/Services/LevelService` when levels are player-owned state, must be replicated to UI, or unlock server-authoritative actions.
- Persist level and XP only after the leveling flow is used by the playable loop.

### Inventory

- Define item IDs, display metadata, limits, and categories in `src/Modules/Game/Items.luau` or nearby item modules.
- Create `src/Modules/Game/InventoryRules.luau` for stack limits, equip rules, crafting requirements, and validation.
- Create `src/Services/InventoryService` when items can be granted, consumed, equipped, traded, crafted, or saved.
- Keep grants, ownership checks, and trusted inventory writes on the server.

### Persistence

- Define default player data before saving live data.
- Persist server-owned fields, not client presentation state.
- Add schema or migration helpers before changing saved shapes.
- Test serialization, defaults, and migration rules when they are deterministic.

### UI Foundation

- Create reusable primitives in `src/UI/core/primitives` only when multiple components need them.
- Create shared components in `src/UI/core/components`, such as a project button, icon button, modal shell, tab bar, or number badge.
- Create feature UI under `src/UI/features/<feature>` once a screen owns feature state or workflow.
- Keep HUD regions under `src/UI/hud`, such as resource counters, health, objective, timer, or build mode controls.

## First Playable Milestone

The first useful milestone should prove these items:

- One repeated player action.
- One visible reward or failure result.
- One reset or retry path.
- One server-authoritative validation path if multiplayer matters.
- One minimal HUD element.
- One small greybox play area.
- One focused test file for deterministic rules touched by the milestone.

## Ordering Notes

- Do not build persistence first unless the game is primarily about saved data.
- Do not build a full inventory before there are items to earn, equip, consume, or display.
- Do not build a full shop before there is a reward currency and at least one meaningful purchase.
- Do not build final UI before the loop and progression names are stable.
- Prefer a thin complete loop over many disconnected placeholder systems.
