# Documentation Map

This folder holds durable project guides. Task records and task-specific assets stay under `tasks/`; generated and local diagnostic output stays under `tasks/local/`.

## Start Here

- [../README.md](../README.md): setup, common commands, and source-of-truth notes.
- [src-architecture.md](src-architecture.md): source layout, Rojo mapping assumptions, and where new code belongs.
- [genrojotree-setup.md](genrojotree-setup.md): generated Rojo tree, sourcemap, Luau diagnostics, and troubleshooting.
- [new-project-checklist.md](new-project-checklist.md): bootstrap checklist for a new game repository.

## Library Guides

- [networker.md](networker.md): client-server service networking patterns used by `BuildService`.
- [testez.md](testez.md): spec layout, runner behavior, Studio usage, and headless `npm test`.
- [sift.md](sift.md): when to use Sift and where to find local examples.

## Planning And Reference

- [game-planning-order.md](game-planning-order.md): default order for growing a new Roblox game from a playable core loop.
- [references/README.md](references/README.md): durable visual references shared across tasks.
- [../tasks/README.md](../tasks/README.md): task lifecycle, backlog, archive, and task assets.

## What Belongs Where

- Put stable project guidance in `Readmes/`.
- Put active plans, reviews, and task memory in `tasks/`.
- Put one-task screenshots under `tasks/assets/<task-slug>/`.
- Put reusable visual direction under `Readmes/references/`.
- Put agent-facing operating rules in `AGENTS.md`, not in a separate README copy.
