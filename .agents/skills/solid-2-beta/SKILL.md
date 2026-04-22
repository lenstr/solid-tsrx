---
name: solid-2-beta
description: Work effectively with Solid 2.0 beta in this repository. Use when creating, editing, refactoring, debugging, or reviewing code that depends on Solid 2 beta APIs, semantics, lifecycle, batching, async boundaries, or `@solidjs/web` integration.
license: MIT
metadata:
  category: frontend
  stack:
    - solid-2
    - solid-js
    - "@solidjs/web"
    - typescript
---

# Solid 2.0 beta project skill

Use this skill for any task in this repository that touches Solid 2 beta behavior.

This includes:

- `solid-js@2.0.0-beta.*`
- `@solidjs/web`
- reactive primitives such as `createSignal`, `createMemo`, `createEffect`
- lifecycle and cleanup
- `Loading` / `Errored`
- batched reads and update timing
- list rendering or accessors that differ from Solid 1.x expectations
- runtime bugs that only show up because this project is on Solid 2 beta

## When to use this skill

Use this skill when the user wants to:

- add or refactor Solid reactive state
- fix a Solid runtime bug
- migrate a Solid 1.x pattern to Solid 2 beta
- understand why a Solid expression is not reactive
- work on async boundaries, error boundaries, or list rendering
- change the app bootstrap or web runtime integration

## Workflow

1. Confirm the task depends on Solid behavior rather than only generic TypeScript or CSS.
2. Read `references/project-context.md` before editing code.
3. Read `references/solid-2-rules.md` if the task touches effects, lifecycle, batching, boundaries, or list/accessor behavior.
4. Make the smallest correct change.
5. Validate with:
   - `pnpm check`
   - `pnpm build`
6. If UI behavior changed, verify runtime in the browser, not just compile output.
7. Summarize both the code change and any Solid-2-beta-specific caveat involved.

## Output expectations

Produce:

- code that matches Solid 2 beta semantics used by this repo
- minimal integration changes when needed
- explicit mention when avoiding a Solid 1.x pattern that would be misleading here

## Constraints

- Do not assume Solid 1.x behavior.
- Prefer `@solidjs/web` for DOM/web runtime imports in this repo.
- Prefer Solid 2 effect/lifecycle patterns over legacy habits.
- Validate runtime behavior when changing reactive logic.
- Be cautious with code that reads like it should be synchronous immediately after a setter; Solid 2 batches updates.

## Additional resources

- See [references/project-context.md](references/project-context.md) for the repo's current Solid wiring.
- See [references/solid-2-rules.md](references/solid-2-rules.md) for practical Solid 2 beta rules and migration notes.
