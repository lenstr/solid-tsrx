# Practical Solid 2 beta rules for this repo

This is the short operational guide for Solid 2 beta while working in this project.

## 1. Import the DOM runtime from `@solidjs/web`

Use:

```ts
import { render, hydrate } from '@solidjs/web'
```

Do not use old `solid-js/web` imports in this repo's runtime code.

## 2. Effects are split-phase in Solid 2 beta

Prefer the Solid 2 form:

```ts
createEffect(
  () => count(),
  (value) => {
    console.log(value)
  },
)
```

Do not assume the old one-function mental model is always appropriate.

## 3. Lifecycle assumptions changed

Use `onSettled` for mount/settled work in this repo:

```ts
onSettled(() => {
  const onResize = () => measure()
  window.addEventListener('resize', onResize)
  return () => window.removeEventListener('resize', onResize)
})
```

Do not casually reach for `onMount` based on Solid 1.x habits.

## 4. Writes are batched; reads lag until flush

After a setter:

```ts
setCount(1)
count() // may still be old value until the batch flushes
```

Do not write code that depends on immediate synchronous reads after every setter unless you have verified it is safe.

## 5. Be careful writing under reactive scope

Solid 2 beta is stricter about writes inside owned/reactive scopes.

If you truly need an internal writable signal updated from effect/lifecycle code, use that pattern deliberately and document it. Example from this repo:

```ts
const [effectRuns, setEffectRuns] = createSignal(0, { pureWrite: true })
```

Do not use `pureWrite` as a blanket escape hatch for app state.

## 6. Async and error boundaries are different now

Solid 2 beta uses `Loading` and `Errored`.

This matters directly in this repo because TSRX lowers `try / pending / catch` into those primitives.

Validate in the browser after changing boundary-related code.

## 7. List rendering/accessor behavior may differ from 1.x intuition

In Solid 2 style control-flow APIs, list children often receive accessors.

Be ready for forms like:

```ts
item()
i()
```

instead of assuming plain values everywhere.

If the UI looks wrong but compiles, inspect lowered behavior and verify what is an accessor.

## 8. Reactivity only happens in reactive/render positions

Do not assume that passing a signal value or accessor into arbitrary plain JS code makes that code reactive by itself.

If something must update reactively, ensure it is read in the correct reactive/render context.

## 9. Browser verification is required for tricky reactive changes

For these changes, browser validation is mandatory:

- effects
- lifecycle work
- boundaries
- dynamic lists
- focus/measurement/ref logic
- bootstrap/runtime integration

## 10. Prefer explicitness when migrating old habits

When in doubt, prefer:

- explicit `createEffect(compute, effect)`
- explicit `onSettled`
- explicit runtime verification
- explicit note in summary that the change is Solid 2 beta specific
