# Solid × TSRX field lab

Небольшой Vite-проект на TypeScript, собранный как исследовательский стенд для `tsrx` на Solid.

## Что внутри

Проект показывает и сравнивает:

- `createSignal` + `createMemo`
- `if / switch / return;` прямо в шаблоне
- `for...of` с `index` и `key`
- `ref` в виде `{ref node}`
- `try / pending / catch` для lazy/error boundaries
- scoped `<style>` в `.tsrx`
- `<tsx>` для JSX-as-value
- dynamic elements через `<@tag>`
- style composition через `#style.className`

У каждого стенда есть переключатель между:

- `TSRX`
- `JSX mental model`

чтобы было проще понять, где новая запись действительно удобнее.

## Почему здесь Solid 2 beta

Согласно документации TSRX для Solid target, конструкции

- `try { ... } catch { ... }`
- `try { ... } pending { ... }`

компилируются в `Errored` и `Loading`, а они доступны в Solid 2.

Поэтому проект использует связку:

- `solid-js@2.0.0-beta.7`
- `@solidjs/web@2.0.0-beta.7`
- `vite-plugin-solid@3.0.0-next.5`

На текущем состоянии экосистемы это самый рабочий вариант для Solid 2 beta.

## Настройка TSRX + Solid + Vite

Конфиг основан на свежем getting started из `tsrx.dev`:

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

Порядок важен: сначала `tsrxSolid()`, потом `solid()`.

`optimizeDeps.noDiscovery` здесь включён как практический workaround для dev-режима Vite 8 + Rolldown, чтобы dependency scan не ломался на виртуальных `.tsrx.tsx` модулях.

## Команды

```bash
pnpm install
pnpm dev
pnpm build
pnpm check
```

## Что важно знать про текущее состояние TSRX

TSRX очень свежий, поэтому в проекте отдельно зафиксированы практические caveats:

1. `tsc` сам по себе ещё не воспринимает `.tsrx` как такой же нативный source type, как `.tsx`.
   - поэтому production build идёт через `vite build`
   - для TS-импортов добавлен `src/tsrx.d.ts`
2. `{html ...}` для Solid target не поддерживается — нужно использовать `innerHTML`
3. Самый интересный синтаксис boundary-веток сейчас завязан на Solid 2 beta

## Полезные источники, которые были использованы

- `https://tsrx.dev/getting-started`
- `https://tsrx.dev/features`
- `https://tsrx.dev/llms.txt`
- `vite-plugin-solid`
- Solid 2 control-flow RFC / docs про `Loading` и `Errored`

## Структура

- `src/App.tsrx` — основной экран со всеми демо
- `src/components/FeatureCard.tsrx` — карточка стенда с переключением TSRX/JSX
- `src/components/ToneChip.tsrx` — мелкий компонент для style composition
- `src/components/AsyncPreview.tsrx` — lazy-модуль для pending boundary
- `src/snippets.ts` — строки с примерами TSRX vs JSX

## Вывод после первой сборки

Если смотреть именно на Solid target, то самые сильные стороны TSRX здесь такие:

- control flow выглядит как обычный язык, а не как набор JSX-хелперов
- scoped styles встроены очень естественно
- `#style` и `<tsx>` закрывают реальные эргономические дыры

Самые спорные моменты пока такие:

- экосистема ещё сырая
- typecheck и toolchain вокруг `.tsrx` пока не так отполированы, как вокруг `.tsx`
- для advanced features уже приходится думать о версии Solid и совместимости плагинов
