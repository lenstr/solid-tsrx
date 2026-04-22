# Solid × TSRX field lab

A small Vite + TypeScript project built as an interactive lab for exploring TSRX on Solid.

## What's inside

The project demonstrates and compares:

- `createSignal` + `createMemo`
- `if / switch / return;` directly in the template
- `for...of` with `index` and `key`
- `ref` via `{ref node}`
- `try / pending / catch` for lazy/error boundaries
- scoped `<style>` in `.tsrx`
- `<tsx>` for JSX-as-value
- dynamic elements via `<@tag>`
- style composition via `#style.className`

Each module has a toggle between:

- `.TSRX` — the actual source syntax
- `.JSX` — the equivalent mental model in classic JSX

so it's easy to see where the new syntax is genuinely better.

## Why Solid 2 beta

Per the TSRX docs for the Solid target, the constructs

- `try { ... } catch { ... }`
- `try { ... } pending { ... }`

compile to `Errored` and `Loading`, which are only available in Solid 2.

The project uses:

- `solid-js@2.0.0-beta.7`
- `@solidjs/web@2.0.0-beta.7`
- `vite-plugin-solid@3.0.0-next.5`

This is currently the most stable combination for Solid 2 beta.

## TSRX + Solid + Vite setup

Config based on the latest getting started from `tsrx.dev`:

```ts
import { defineConfig } from 'vite'
import tsrxSolid from '@tsrx/vite-plugin-solid'
import solid from 'vite-plugin-solid'

export default defineConfig({
  plugins: [tsrxSolid(), solid()],
  optimizeDeps: {
    noDiscovery: true,
  },
})
```

Plugin order matters: `tsrxSolid()` first, then `solid()`.

`optimizeDeps.noDiscovery` is enabled as a practical workaround for Vite 8 + Rolldown dev mode, preventing the dependency scanner from choking on virtual `.tsrx.tsx` modules.

## Commands

```bash
pnpm install
pnpm dev
pnpm build
pnpm check
```

## Current TSRX caveats

TSRX is very new, so the project documents several practical caveats:

1. `tsc` does not yet treat `.tsrx` as a first-class source type like `.tsx`.
   - production builds go through `vite build`
   - `src/tsrx.d.ts` is added for TS imports
2. `{html ...}` is not supported on the Solid target — use `innerHTML` instead
3. The most interesting boundary syntax currently depends on Solid 2 beta

## References

- `https://tsrx.dev/getting-started`
- `https://tsrx.dev/features`
- `https://tsrx.dev/llms.txt`
- `vite-plugin-solid`
- Solid 2 control-flow RFC / docs on `Loading` and `Errored`

## Structure

- `src/App.tsrx` — main screen with all six interactive modules
- `src/components/FeatureCard.tsrx` — module card with TSRX/JSX snippet toggle
- `src/components/ToneChip.tsrx` — small chip component for style composition
- `src/components/AsyncPreview.tsrx` — lazy module for the pending boundary demo
- `src/snippets.ts` — TSRX vs JSX code examples

## Takeaways

Strongest sides of TSRX on the Solid target:

- Control flow reads like real language constructs, not JSX helper components
- Scoped styles are built into the language naturally
- `#style` and `<tsx>` close real ergonomic gaps

Open questions:

- The ecosystem is still very early
- Typecheck and tooling around `.tsrx` is not yet as polished as `.tsx`
- Advanced features already require thinking about Solid version and plugin compatibility
