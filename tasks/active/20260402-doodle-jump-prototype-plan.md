# Task: First game direction and Doodle Jump-style MVP

## Metadata

- Status: draft
- Created: 2026-04-02
- Owner: Claudiu
- Related issue: none
- Related files: tasks/backlog.md, src/Services/, src/Modules/, src/Startup/, src/UI/

## Objective

Choose the first game direction for this repository and define an MVP that is small enough to ship quickly without locking the project identity too early.

## Context

This repository is the working Roblox game project. The next step is to keep the project name flexible and start with a concept that teaches the gameplay loop, Roblox workflow, and source structure without requiring heavy networking or large content pipelines.

The current candidate is a Doodle Jump-style vertical platformer with later power-ups.

## Constraints

- Do not optimize for a final brand name yet.
- Prefer a first game that can be validated in single-player before multiplayer expansion.
- Keep server authority and replication boundaries explicit if score, progression, or shared competition are added later.
- Treat default.project.json as generated output if structural work starts later.
- Power systems are in scope later, not in the first MVP unless they are required to prove the core loop.

## Open Questions

- Mobile-first, desktop-first, or both from day one?
- Endless score chase only, or level-based stages?
- Should the first release stay purely single-player?
- Should runs be round-based with restart, or persistent until fail?

## Planner Section

## Planning Notes

- From the current candidate list, a Doodle Jump-style game is one of the lowest-risk starting points because it has a compact core loop: jump, land, climb, survive.
- It avoids the immediate complexity of networking, kart physics, PvP balance, large maps, or multi-team rules.
- It fits this project well because the first slice can live mostly in shared modules plus a small gameplay service and lightweight UI.
- Power-ups can be layered cleanly after the movement and platform spawning loop is stable.
- Repository identity can be updated later by re-running the project initialization script with a new display name, repo slug, and optional Wally scope.

## Approved Plan

1. Keep the repository identity provisional until the core loop is playable.
2. Run `npm run init:project -- --name "Working Title" --repo "owner/repo"` only when project metadata needs to be updated.
3. Build a Doodle Jump-style MVP focused on one satisfying movement loop.
4. Defer powers, cosmetics, progression, and social features until the MVP feels good.
5. Re-evaluate the project identity after the core loop is playable.

## Parallelization

- Track A: movement feel, camera, jump tuning, fail condition.
- Track B: procedural platform spawning and cleanup.
- Track C: score UI, restart flow, and simple round state.

## Implementation Handoff

Start with a deliberately small scope:

- Character or controller that auto-bounces on valid platforms.
- Platform generator that keeps enough future platforms above the player and cleans old ones below.
- Camera logic that supports readable upward play.
- Score based on max height reached.
- Lose condition when the player falls below the safe threshold.
- Minimal UI for score, restart, and title.

Recommended early boundaries:

- Keep the first slice single-player.
- Put reusable movement and spawn rules in `src/Modules`.
- Use one gameplay service under `src/Services` to own round state and orchestration.
- Add powers only after the plain version is fun.

## Coder Section

## Implementation Notes

NONE

## Verification

NONE

## Manual Studio Setup

NONE

## Review Findings

NONE

## Discovered Follow-Ups

Add future power-up ideas to tasks/backlog.md only after the base jump loop is validated.

## Governance Section

## AI Context Updates

Nothing yet.

## Workflow or Docs Impact

This task establishes a recommended early-project pattern: provisional naming, compact MVP, and delayed power-system design.

## Closeout Decision

Keep active until the first playable direction is accepted or the concept is replaced.

## Completion Summary

Initial planning complete. Recommended starting direction is a Doodle Jump-style MVP because it is small, fast to validate, and does not force early multiplayer or heavy content decisions.
