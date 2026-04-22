# Project context for TSRX + Solid

This repository is a small Solid + TSRX lab. The current working setup matters because TSRX is still very new.

## Current stack

- Vite 8
- TypeScript
- `@tsrx/solid@0.0.5`
- `@tsrx/vite-plugin-solid@0.0.5`
- `solid-js@2.0.0-beta.7`
- `@solidjs/web@2.0.0-beta.7`
- `vite-plugin-solid@3.0.0-next.5`

## Important integration files

### `vite.config.ts`

Order matters:

```ts
plugins: [tsrxSolid(), solid({ dev: false, hot: false })]
```

Notes:

- `tsrxSolid()` must run before `vite-plugin-solid`.
- `optimizeDeps.noDiscovery = true` is enabled as a Vite 8 / Rolldown workaround for `.tsrx` virtual modules in dev.
- `vite-plugin-solid` dev/HMR helpers are currently disabled in this repo because the previous setup caused Solid 2 beta runtime issues during dev.

### `src/main.ts`

This project currently mounts with:

```ts
render(() => createComponent(App, {}), root)
```

Do not casually switch this back without re-testing runtime behavior.

### `src/tsrx.d.ts`

Needed so TS imports of `*.tsrx` work in the project.

## Validation requirements

After changing TSRX code, run:

```bash
pnpm check
pnpm build
```

If the change affects rendered UI, also verify with the dev server:

```bash
pnpm dev
```

and use browser automation if available to ensure there are no runtime errors.

## Known project-specific caveats

- `tsc` support around `.tsrx` is still weaker than normal `.tsx`; this project relies on Vite for the real build pipeline.
- Solid 2 beta changed some APIs used around effects and lifecycle.
- Some TSRX features work in theory but are still fragile in this repo unless explicitly validated.
