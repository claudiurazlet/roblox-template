# Task Assets

Use this folder for committed task-specific screenshots and other lightweight visual context that should stay attached to a task record.

## When To Use This Folder

- A screenshot explains a bug, camera issue, layout problem, or gameplay edge case for one specific task.
- The image must remain available after the task file moves from `tasks/active/` to `tasks/archive/`.
- The image is useful project memory, but not broad enough to belong in `Readmes/references/`.

## Recommended Organization

- Create one subfolder per task, for example `tasks/assets/20260405-one-way-platform-pass-through/`.
- Use descriptive names such as `camera-trailing-too-slow.png` or `platform-collision-from-below.jpg`.
- Keep only the few screenshots that materially help planning, implementation, review, or closeout.

## Markdown Usage

- From a task file in either `tasks/active/` or `tasks/archive/`, reference images with `../assets/<task-slug>/<image-name>`.
- Example snippet:

```markdown
![Trailing side camera feels too slow](../assets/20260405-camera-tuning/trailing-side-too-slow.png)
```

Move or copy an image to `Readmes/references/` only when it becomes a reusable cross-task visual reference.
