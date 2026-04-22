export const snippets = {
  signals: {
    tsrx: `let &[count, setCount] = createSignal(0);
const temperature = createMemo(() => (count() > 4 ? 'hot' : 'stable'));

<button onClick={() => setCount(count() + 1)}>{count()}</button>
if (count() > 0) {
  <p>{temperature()}</p>
}`,
    jsx: `const [count, setCount] = createSignal(0);
const temperature = createMemo(() => (count() > 4 ? 'hot' : 'stable'));

return (
  <>
    <button onClick={() => setCount(count() + 1)}>{count()}</button>
    <Show when={count() > 0}>
      <p>{temperature()}</p>
    </Show>
  </>
);`,
  },
  controlFlow: {
    tsrx: `if (!session()) {
  <p>{'Авторизуйся для доступа к панели.'}</p>
  return;
}

switch (phase()) {
  case 'idle':
    <p>{'Стенд ждёт команды.'}</p>
    break;
  case 'active':
    <p>{'Рендер горячий, всё реактивно.'}</p>
    break;
  default:
    <p>{'Нужен разбор ошибки.'}</p>
}`,
    jsx: `if (!session()) {
  return <p>Авторизуйся для доступа к панели.</p>;
}

return (
  <Switch>
    <Match when={phase() === 'idle'}>
      <p>Стенд ждёт команды.</p>
    </Match>
    <Match when={phase() === 'active'}>
      <p>Рендер горячий, всё реактивно.</p>
    </Match>
    <Match when={true}>
      <p>Нужен разбор ошибки.</p>
    </Match>
  </Switch>
);`,
  },
  loops: {
    tsrx: `<ul>
  for (const item of items(); index i; key item.id) {
    const current = item();
    const label = \`${'${'}i() + 1}. ${'${'}current.name}\`;
    <li>{label}</li>
  }
</ul>`,
    jsx: `<ul>
  <For each={items()}>
    {(item, i) => {
      const label = \`${'${'}i() + 1}. ${'${'}item.name}\`;
      return <li>{label}</li>;
    }}
  </For>
</ul>`,
  },
  refs: {
    tsrx: `let input: HTMLInputElement | undefined;

<input {ref input} />
<button onClick={() => input?.focus()}>{'focus()'}</button>`,
    jsx: `let input: HTMLInputElement | undefined;

<input ref={input} />
<button onClick={() => input?.focus()}>{'focus()'}</button>`,
  },
  boundaries: {
    tsrx: `const AsyncPanel = lazy(() => import('./Panel.tsrx'));

try {
  <AsyncPanel />
} pending {
  <p>{'Загрузка…'}</p>
} catch (error) {
  <p>{String(error)}</p>
}`,
    jsx: `const AsyncPanel = lazy(() => import('./Panel'));

return (
  <Errored fallback={(error) => <p>{String(error)}</p>}>
    <Loading fallback={<p>Загрузка…</p>}>
      <AsyncPanel />
    </Loading>
  </Errored>
);`,
  },
  composition: {
    tsrx: `const badge = <tsx><span class="tag">{'<tsx>'}</span></tsx>;
let tag = compact() ? 'h3' : 'h2';

<Panel marker={badge}>
  <@tag>{'Dynamic headline'}</@tag>
  <ToneChip className={#style.sunrise} label="scoped" />
</Panel>

<style>
  .sunrise { color: #ffb36b; }
</style>`,
    jsx: `const badge = <span className="tag">{'<tsx>'}</span>;
const Tag = compact() ? 'h3' : 'h2';

return (
  <Panel marker={badge}>
    <Tag>Dynamic headline</Tag>
    <ToneChip className={sunriseClass} label="scoped" />
  </Panel>
);`,
  },
} as const
