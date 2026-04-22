---
name: tsrx-solid
description: Work effectively with TSRX in this Solid + Vite project. Use when creating, editing, refactoring, debugging, or reviewing any `.tsrx` file or TSRX-specific Vite/Solid wiring in this repository.
license: MIT
metadata:
  category: frontend
  stack:
    - tsrx
    - solid
    - vite
    - typescript
---

# TSRX + Solid project skill

Use this skill for any task in this repository that touches:

- `.tsrx` components
- TSRX syntax or semantics
- Solid 2 beta behavior used by TSRX output
- Vite wiring for `@tsrx/vite-plugin-solid`
- runtime issues that may actually come from TSRX codegen or Solid 2 beta behavior

## When to use this skill

Use this skill when the user wants to:

- create or edit a `.tsrx` component
- migrate a `.tsx` or JSX component to TSRX
- understand why a TSRX construct works or fails in this repo
- add demos for TSRX features
- debug Solid runtime issues caused by TSRX output
- change TSRX/Vite/Solid integration files such as `vite.config.ts`, `src/main.ts`, or `src/tsrx.d.ts`

## Workflow

1. Confirm the task touches TSRX or this repo's Solid+TSRX integration.
2. Read `references/project-context.md` for repo-specific rules before changing code.
3. If the task is about syntax or uncertain TSRX behavior, read `references/tsrx-rules.md`.
4. Make the smallest correct change.
5. Validate with:
   - `pnpm check`
   - `pnpm build`
6. If the change affects visible UI or interaction flow, also run a dev-server smoke check and browser verification when available.
7. Summarize both the code change and any TSRX-specific caveats discovered.

## Output expectations

Produce:

- correct `.tsrx` code aligned with this repo's current TSRX + Solid setup
- minimal supporting config changes when needed
- a short note if the implementation is using a known workaround or avoiding a fragile TSRX feature

## Constraints

- Prefer ordinary Solid patterns unless TSRX adds clear value.
- Do not use `let &[] = createSignal(...)` just to be clever; prefer standard `const [x, setX] = createSignal(...)` unless there is a concrete reason otherwise.
- Keep text nodes in TSRX wrapped in `{ ... }`.
- Do not assume that a construct documented by TSRX is fully stable in this repo; validate it here.
- Treat dynamic `<@tag>` usage as suspicious until verified in this project.
- For anything UI-visible, do not stop at typecheck only; verify runtime behavior.

## Additional resources

- See [references/project-context.md](references/project-context.md) for repo wiring and validation steps.
- See [references/tsrx-rules.md](references/tsrx-rules.md) for practical syntax rules and gotchas.
