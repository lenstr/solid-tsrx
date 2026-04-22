# Practical TSRX rules for this repo

This is not the full TSRX language manual. It is the short list of rules that repeatedly matter when editing this project.

## 1. Use `.tsrx` component syntax, not JSX component syntax

```tsrx
export default component App() {
  <div>{'Hello'}</div>
}
```

Do not write:

```tsx
export default function App() {
  return <div>Hello</div>
}
```

## 2. Text must be wrapped in braces

Good:

```tsrx
<h1>{'Hello'}</h1>
<p>{message}</p>
```

Bad:

```tsrx
<h1>Hello</h1>
```

## 3. `&{}` is useful for props; `&[]` is usually not needed for `createSignal`

Prefer this for props:

```tsrx
component Card(&{ title, status }: Props) {
  <h2>{title}</h2>
}
```

Prefer ordinary Solid destructuring for signals:

```ts
const [count, setCount] = createSignal(0)
```

Avoid this unless you have a specific reason:

```tsrx
let &[count, setCount] = createSignal(0)
```

Reason: `createSignal` already returns stable getter/setter functions. Using `&[]` there mainly adds confusion.

## 4. Accessors in TSRX + Solid

### Safe shorthand in child/text position

These commonly work and stay reactive:

```tsrx
<p>{count}</p>
<p>{memoValue}</p>
<p>{'Count: '}{count}</p>
```

### Still use `()` in normal JS expressions

Use `()` in places like:

```tsrx
class={phase() === 'active' ? 'on' : 'off'}
checked={enabled()}
value={String(count())}
if (count() > 0) {
  <p>{'visible'}</p>
}
<MyChild phase={phase()} />
```

Rule of thumb:

- child/text insertion: often fine without `()`
- ordinary JS expression / attribute logic / comparisons / props: use `()`

## 5. Solid 2 beta effect model applies here

Prefer Solid 2 style effects:

```ts
createEffect(
  () => count(),
  (value) => {
    console.log(value)
  },
)
```

For mount/settled work, prefer `onSettled` in this repo rather than legacy `onMount` assumptions.

## 6. `try / pending / catch` is one of the main reasons this repo uses Solid 2 beta

TSRX lowers these constructs to Solid 2 primitives such as `Loading` and `Errored`.

Validate them in browser after edits.

## 7. Be careful with dynamic `<@tag>`

TSRX documents dynamic elements, but in this repo they have already shown runtime fragility in realistic UI code.

Default behavior:

- avoid `<@tag>` unless the user specifically wants to test it
- prefer explicit `if / else if / else` rendering of `h2`, `h3`, `p`, etc.
- if you do use `<@tag>`, verify in the running app

## 8. Loops may lower to Solid accessors

In `for (...; index i; key ...)` code lowered for Solid, loop bindings may behave as accessors depending on context.

Be ready to validate whether you need forms like:

```tsrx
const current = probe()
{i() + 1}
```

instead of assuming plain values everywhere.

## 9. `raw {html ...}` is not available on the Solid target

Use Solid-style `innerHTML={...}` instead when needed.

## 10. Validate runtime, not just compile output

A TSRX edit can pass `pnpm check` and `pnpm build` but still fail in dev/runtime semantics.

For anything nontrivial:

1. run the app
2. interact with the changed screen
3. check browser errors
