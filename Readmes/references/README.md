# Visual References

Use this folder for durable visual references that should survive across multiple tasks and help guide the overall direction of a project derived from this template.

## What belongs here

- UI style references that define a lasting direction for menus, HUDs, inventory, or onboarding.
- Environment, lighting, or mood references that are used by at least two tasks or marked as reusable in a task file.
- Reusable examples of interaction patterns, layout direction, or visual hierarchy.
- Annotated screenshots or exported stills that will be useful beyond one task.

## What should not live here

- One-off scratch screenshots taken only to discuss a single bug or temporary idea.
- Temporary work-in-progress captures with no planned reuse.
- Large collections of nearly identical images with no explanation.
- Raw video files unless a task or reference note marks the specific file as reusable.

## Shared references vs task-specific references

- Put an image here when it represents a reusable direction for the project.
- Put a task-specific screenshot under `tasks/assets/<task-slug>/` and reference it directly from the task markdown when it exists only to support that one task.
- If a task-specific image later becomes broadly useful, move or copy it here and add a short explanation.

## Recommended organization

- Use small subfolders by topic, for example `ui/`, `combat/`, `environment/`, or `lighting/`.
- Use descriptive names such as `ui-shop-grid-reference.png` or `combat-hit-feedback-reference.jpg`.
- Add a short markdown note next to groups of images when the reason for the reference is not obvious.

## Using video references

- Do not rely on a remote video link alone as the only durable reference.
- If a YouTube video matters, extract a few still frames or short written notes that capture what is relevant.
- Record what to copy from the video, such as pacing, composition, motion, readability, or interaction flow.

## How agents should use this folder

- Treat files here as design guidance, not as authoritative runtime data.
- Cite the specific reference image or note that influenced a proposal.
- If the reference conflicts with the current repository conventions, follow the task instructions or ask for clarification.
