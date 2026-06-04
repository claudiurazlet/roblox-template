# Game Planning Order

Use this document as a default phase order when starting a new Roblox game from this template. Update the order when playtests or production constraints invalidate the assumptions.

## Core Rule

Build the smallest multiplayer-ready version of the core fantasy before building final art, large environments, or full meta UI.

## Default Order

1. Core fantasy and success metric
   - Write the one-sentence player loop.
   - Decide what counts as a good first five minutes.
   - Lock the initial server size target and primary devices.
2. Playable vertical slice
   - Implement one repeatable action loop with spawn, input, win or fail state, and reward.
   - Use greybox assets only.
   - Add temporary debug UI only if needed.
3. Greybox world and camera
   - Build only the environment needed to prove the loop.
   - Validate sightlines, collision, reset volumes, and spawn safety.
4. Multiplayer rules
   - Define what is shared, what is instanced, and what must stay server-authoritative.
   - Validate joins, leaves, contention, and anti-exploit boundaries.
5. Minimal HUD
   - Add only the HUD needed to understand the loop: currency, progress, timer, objective, or state.
   - Delay menus, shops, inventory, and settings until the loop is fun.
6. Progression and economy
   - Add permanent upgrades, costs, and pacing once collection rates are measurable.
   - Avoid finalizing inventory structure before upgrade categories are stable.
7. Content expansion
   - Add power-ups, hazards, map variation, mission structure, and content variety.
   - Scale density carefully; do not solve boredom with raw part count.
8. Meta UI and social systems
   - Add menus, inventory, shop, onboarding, leaderboards, parties, and other session-to-session systems.
9. Polish, performance, and device expansion
   - Optimize replication, cleanup, pooling, mobile readability, console prompts, audio, VFX, and final art.

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
- Increase player count only after real tests confirm readability, collision behavior, replication cost, and reward contention.
- For physics-heavy or high-motion games, start with a lower server target than social hangouts or low-interaction games.
- Do not target very large servers first unless the design uses separated spaces, low interaction density, and aggressive optimization.

## First Milestone Template

- Prove the core action loop.
- Prove the reward loop.
- Prove reset and failure handling.
- Prove multiplayer readability with a small server.
- Prove the minimum HUD.

## Update Policy

Change the order when testing invalidates assumptions. Keep the first playable milestone small.
