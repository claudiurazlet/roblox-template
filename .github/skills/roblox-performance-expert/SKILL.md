---
name: roblox-performance-expert
description: Use when investigating Roblox performance problems such as frame drops, memory leaks, excessive re-renders, heavy startup work, remote spam, connection leaks, poor cleanup, or unnecessary polling in client, server, or shared code.
user-invocable: true
---

# Roblox Performance Expert

Use this skill when a task is about diagnosing or preventing performance problems in Roblox code or game content, especially when the issue may involve memory lifetime, UI churn, startup cost, networking volume, or heavy assets.

## Primary sources

- [copilot-instructions.md](../../copilot-instructions.md)
- [roblox-project.instructions.md](../../instructions/roblox-project.instructions.md)
- [README.md](../../../Readmes/README.md)
- [networker.md](../../../Readmes/networker.md)
- [wally.toml](../../../wally.toml)

## What this skill is for

- Narrow likely causes of frame time regressions.
- Look for memory or connection leaks.
- Review startup order and startup cost.
- Check whether networking volume, polling, or state ownership is causing waste.
- Review UI code for unnecessary churn.
- Check whether textures, meshes, rigs, animations, VFX, audio, or other assets are too heavy for the use case.

## Performance checklist

1. Confirm where the problem lives: client, server, shared, UI, networking, or startup.
2. Check for repeated allocations in hot paths.
3. Check for event, signal, promise, or observer cleanup that never happens.
4. Check for polling or repeated work that could be event-driven.
5. Check whether remotes or replication are sending too often or too much data.
6. Check whether startup code is doing work that can be deferred.
7. Check whether state updates are causing avoidable UI churn.
8. Check whether art assets are oversized, too numerous, or too expensive for the scene.

## Template-specific heuristics

- Use `Janitor` consistently when objects own connections or long-lived resources.
- Keep authoritative logic server-side and avoid bouncing state back and forth unnecessarily.
- Prefer testing core logic directly instead of profiling transport code first.
- In UI, question subscriptions, state fan-out, and frequent full-tree updates.
- In services, question caches that never clear and per-player state that survives `PlayerRemoving`.
- When Studio-only assets are involved, ask whether the issue comes from code, content, or the interaction between them before changing architecture.

## Asset-side checklist

- Check whether textures and decals are larger than needed for the on-screen size.
- Check whether meshes or rigs are too detailed for how often and how closely they appear.
- Check whether many animated characters, accessories, particles, or lights are active at once.
- Check whether VFX, UI gradients, viewport frames, or transparency-heavy elements are overused.
- Check whether audio, animation, or asset preloading is happening too early or for content the player may never see.
- If the workspace does not include the asset data itself, record what should be inspected in Studio instead of guessing.

## Typical symptoms and likely directions

- Frame drops when opening UI: inspect render frequency, subscriptions, and animation/state churn.
- Memory growth over time: inspect cleanup paths, disconnections, caches, and object lifetime.
- Lag spikes on join: inspect startup order, synchronous initialization, and eager data loads.
- Intermittent server slowdown: inspect remote spam, loops over large collections, and per-player repeated work.
- Replication feels noisy: inspect ownership, update frequency, and whether the client really needs each update.
- GPU-like slowdowns in art-heavy scenes: inspect texture sizes, particle counts, lights, animated rigs, mesh complexity, and per-frame visual effects.

## Recommended workflow

1. Write down the observed symptom and when it occurs.
2. Separate suspected hot paths from cold paths.
3. Check lifecycle cleanup before micro-optimizing expressions.
4. If assets may be involved, separate code-side suspects from Studio-side suspects.
5. Reduce repeated work before introducing more complexity.
6. Prefer one clear measurement or hypothesis at a time.

## When not to use this skill

- When the issue is primarily a correctness bug rather than a performance symptom.
- When the task is just selecting a library and there is no observed performance problem.
- When the problem is mostly about project structure or Rojo tree mapping.