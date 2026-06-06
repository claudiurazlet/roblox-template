# New Game Planning Order

Use this order when starting a new Roblox game in this repository. Update it when playtests or production constraints prove a different order is better.

## Core Rule

Build the smallest multiplayer-ready version of the core fantasy before final art, large environments, full meta UI, or large economies.

## Default Order

1. Core fantasy and success metric
2. Playable vertical slice
3. Greybox world and camera
4. Multiplayer rules
5. Minimal HUD
6. Progression and economy
7. Content expansion
8. Meta UI and social systems
9. Polish, performance, and device expansion

## What Each Phase Must Prove

- Core fantasy: one-sentence player loop, first-five-minutes goal, initial server size, primary devices.
- Vertical slice: one repeatable action loop with spawn, input, win or fail state, and reward.
- Greybox world: collision, reset volumes, sightlines, spawn safety, and camera readability.
- Multiplayer rules: what is shared, what is instanced, and what must stay server-authoritative.
- Minimal HUD: only the information needed to understand the loop.
- Progression and economy: costs, rewards, pacing, and upgrade categories based on measured collection rates.
- Content expansion: hazards, power-ups, map variation, mission structure, and replay variety.
- Meta UI and social systems: menus, inventory, shop, onboarding, leaderboards, parties, and session-to-session systems.
- Polish: replication cost, cleanup, pooling, mobile readability, console prompts, audio, VFX, and final art.

## UI Order

1. HUD
2. Round or session flow
3. Shop or upgrade screen
4. Inventory or collection screen
5. Settings and accessibility
6. Cosmetic or secondary surfaces

## World Order

1. Spawn or base area
2. One playable lane, arena, loop, or route
3. Reset or fail handling
4. Reward placement
5. Additional segments, arenas, or biomes
6. Art pass

## Multiplayer Sizing

- Start small enough that the core loop stays readable and server cost is easy to reason about.
- Increase player count only after tests confirm readability, collision behavior, replication cost, and reward contention.
- Start physics-heavy or high-motion games with a lower server target than low-interaction social spaces.
- Avoid very large servers first unless the design uses separated spaces, low interaction density, and aggressive optimization.

## First Milestone

The first playable milestone should prove:

- core action loop
- reward loop
- reset and failure handling
- multiplayer readability with a small server
- minimum HUD
