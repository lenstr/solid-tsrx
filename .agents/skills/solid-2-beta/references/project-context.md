# Project context for Solid 2.0 beta

This repository uses Solid 2 beta because TSRX features in this repo depend on Solid 2 control-flow and async/error primitives.

## Current stack

- `solid-js@2.0.0-beta.7`
- `@solidjs/web@2.0.0-beta.7`
- `vite-plugin-solid@3.0.0-next.5`
- Vite 8
- TypeScript

## Why this matters

A lot of familiar Solid 1.x instincts are wrong or incomplete here:

- DOM runtime imports moved to `@solidjs/web`
- effect semantics changed
- lifecycle assumptions changed
- updates are batched and reads do not immediately reflect writes
- async/error boundaries use Solid 2 primitives like `Loading` and `Errored`

## Important integration files

### `src/main.ts`

This project currently mounts with:

```ts
import { createComponent } from 'solid-js'
import { render } from '@solidjs/web'

render(() => createComponent(App, {}), root)
```

Do not rewrite bootstrap casually without runtime verification.

### `vite.config.ts`

Solid is configured with `vite-plugin-solid@next` because the repo is on Solid 2 beta.

## Validation requirements

After editing Solid-reactive code, run:

```bash
pnpm check
pnpm build
```

If visible behavior changed, also run the app and verify in-browser.

## Known project-specific caveats

- Some runtime issues in this repo were caused by using Solid 1.x mental models with Solid 2 beta packages.
- Build success does not guarantee runtime correctness.
- This repo also uses TSRX; if the task touches `.tsrx` syntax or TSRX-specific lowering behavior, use the project TSRX skill too.
