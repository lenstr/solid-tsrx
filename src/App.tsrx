import { createEffect, createMemo, createSignal, lazy, onSettled } from 'solid-js';
import FeatureCard from './components/FeatureCard.tsrx';
import ToneChip from './components/ToneChip.tsrx';
import { delayImport } from './lib/delay';
import { snippets } from './snippets';

type Phase = 'idle' | 'active' | 'error';
type Filter = 'all' | 'queued' | 'live';
type HeadingTag = 'h2' | 'h3' | 'p';

type Probe = {
  id: number;
  name: string;
  stage: 'queued' | 'live' | 'archived';
  score: number;
};

const LazyPreview = lazy(() => delayImport(() => import('./components/AsyncPreview.tsrx'), 1350));

component SessionGate(&{ armed, phase }: { armed: boolean; phase: Phase }) {
  if (!armed) {
    <div class="guard-fallback">
      <strong>{'Guard clause:'}</strong>
      <p>{'ранний return; рендерит предупреждение и обрывает оставшуюся ветку компонента.'}</p>
    </div>
    return;
  }

  <div class="phase-output">
    switch (phase) {
      case 'idle':
        <p>{'Стенд тихий. Можно безопасно менять состояние.'}</p>
        break;
      case 'active':
        <p>{'Стенд активен. TSRX даёт обычный if/switch без Show и Match.'}</p>
        break;
      default:
        <p>{'Стенд поймал ошибочный режим. Хороший кандидат для try/catch boundary.'}</p>
    }
  </div>
}

component FuseBox(&{ attempts }: { attempts: number }) {
  if (attempts >= 4) {
    throw new Error('FuseBox перегрелся: граница ошибки сработала после 4-го импульса.');
  }

  <div class="fuse-box">
    <strong>{'FuseBox stable'}</strong>
    <p>{`Текущих импульсов: ${attempts} / 4`}</p>
  </div>
}

export default component App() {
  let &[count, setCount] = createSignal(2);
  let &[effectRuns, setEffectRuns] = createSignal(0, { pureWrite: true });
  let &[phase, setPhase] = createSignal<Phase>('idle');
  let &[sessionOpen, setSessionOpen] = createSignal(true);
  let &[filter, setFilter] = createSignal<Filter>('all');
  let &[attempts, setAttempts] = createSignal(0);
  let &[asyncCycle, setAsyncCycle] = createSignal(1);
  let &[headingTag, setHeadingTag] = createSignal<HeadingTag>('h2');
  let &[noteCompact, setNoteCompact] = createSignal(false);
  let &[meterReport, setMeterReport] = createSignal('Ещё не измеряли DOM-узел.');
  let &[probes, setProbes] = createSignal<Probe[]>([
    { id: 1, name: 'Signal coil', stage: 'live', score: 82 },
    { id: 2, name: 'Boundary relay', stage: 'queued', score: 63 },
    { id: 3, name: 'Scoped paint', stage: 'queued', score: 74 },
    { id: 4, name: 'Loop matrix', stage: 'live', score: 91 },
  ]);

  let searchInput: HTMLInputElement | undefined;
  let meter: HTMLDivElement | undefined;

  const magnitude = createMemo(() => Math.min(100, Math.max(0, (count() + 4) * 8.4)));
  const temperature = createMemo(() => {
    if (count() <= 0) return 'cold';
    if (count() >= 6) return 'blazing';
    return 'steady';
  });
  const visibleProbes = createMemo(() => {
    if (filter() === 'all') return probes();
    return probes().filter((item) => item.stage === filter());
  });
  const completion = createMemo(() => {
    const liveItems = probes().filter((item) => item.stage === 'live').length;
    return `${liveItems}/${probes().length} live`;
  });
  const compositionMarker = <tsx>
    <ToneChip label="<tsx> marker" muted />
  </tsx>;

  const nudgeCount = (delta: number) => {
    setCount((value) => Math.max(-4, Math.min(8, value + delta)));
  };

  const promoteProbe = (id: number) => {
    setProbes((items) =>
      items.map((item) => {
        if (item.id !== id) return item;
        const nextStage = item.stage === 'queued' ? 'live' : 'archived';
        return {
          ...item,
          stage: nextStage,
          score: Math.min(99, item.score + 8),
        };
      }),
    );
  };

  const focusSearch = () => {
    searchInput?.focus();
    searchInput?.select();
  };

  const measureMeter = () => {
    const width = meter?.getBoundingClientRect().width ?? 0;
    setMeterReport(`DOM ref замерил ${width.toFixed(0)}px`);
  };

  createEffect(
    () => count(),
    (value) => {
      setEffectRuns((runs) => runs + 1);
      document.title = `TSRX lab · signal ${value}`;
    },
  );

  onSettled(() => {
    measureMeter();
    const onResize = () => measureMeter();
    window.addEventListener('resize', onResize);
    return () => window.removeEventListener('resize', onResize);
  });

  <div class="app-shell">
    <div class="hero-glow hero-glow-a" aria-hidden="true" />
    <div class="hero-glow hero-glow-b" aria-hidden="true" />

    <header class="hero">
      <div class="hero-copy">
        <p class="kicker">{'Solid × TSRX field lab'}</p>
        <h1>{'Шесть интерактивных стендов для изучения .tsrx вместо JSX'}</h1>
        <p class="lede">
          {'Проект специально собран вокруг реальных Solid-примитивов, но UI пишется на TSRX: с statement-based JSX, if/for/switch/try прямо в шаблоне и локальными <style> блоками.'}
        </p>

        <div class="chip-row">
          <ToneChip label="TSRX 0.0.5" />
          <ToneChip label="Solid 2 beta" />
          <ToneChip label="Vite 8" />
        </div>
      </div>

      <aside class="hero-panel">
        <div class="mini-stat">
          <span>{'Что тестируем'}</span>
          <strong>{'signals, refs, control flow, loops, boundaries, scoped styles'}</strong>
        </div>
        <div class="mini-stat">
          <span>{'Почему Solid 2 beta'}</span>
          <strong>{'TSRX переводит try/pending/catch в Loading + Errored'}</strong>
        </div>
        <div class="mini-stat">
          <span>{'Важно помнить'}</span>
          <strong>{'Build идёт через Vite: tsc пока не понимает .tsrx как полноценный source type.'}</strong>
        </div>
      </aside>
    </header>

    <section class="overview-grid">
      <div class="overview-card">
        <span>{'Reactive pulse'}</span>
        <strong>{count}{' / '}{temperature}</strong>
      </div>
      <div class="overview-card">
        <span>{'Effects fired'}</span>
        <strong>{effectRuns}</strong>
      </div>
      <div class="overview-card">
        <span>{'Probe coverage'}</span>
        <strong>{completion}</strong>
      </div>
      <div class="overview-card">
        <span>{'Current phase'}</span>
        <strong>{phase}</strong>
      </div>
    </section>

    <main class="feature-grid">
      <FeatureCard
        label="01 · signals + memos"
        title="Живая шкала на createSignal"
        summary="Сигналы и memo — тот же Solid, но инициализация состояния приятнее за счёт lazy array destructuring: let &[count, setCount]."
        insight="Самое заметное отличие — не нужен return (...) и не нужны Show-обёртки для простых ветвлений. Код течёт почти как обычный TypeScript-файл с вкраплённым UI."
        tsrxCode={snippets.signals.tsrx}
        jsxCode={snippets.signals.jsx}
      >
        <div class="signal-lab">
          <div class="signal-row">
            <button type="button" class="ghost-button" onClick={() => nudgeCount(-1)}>
              {'−1'}
            </button>
            <div class="readout">
              <strong>{count}</strong>
              <span>{temperature}</span>
            </div>
            <button type="button" class="ghost-button" onClick={() => nudgeCount(1)}>
              {'+1'}
            </button>
          </div>

          <input
            type="range"
            min="-4"
            max="8"
            value={String(count())}
            onInput={(event) => setCount(Number(event.currentTarget.value))}
          />

          <div class="meter-wrap">
            <div class="meter-bar">
              <div class="meter-fill" style={{ width: `${magnitude()}%` }} />
            </div>
            <p>{'effect() отработал '}{effectRuns}{' раз(а)'}</p>
          </div>
        </div>
      </FeatureCard>

      <FeatureCard
        label="02 · conditions + switch + return"
        title="Обычный control flow вместо JSX-хелперов"
        summary="TSRX разрешает писать if / else / switch прямо в шаблоне. Для guard clause — bare return; без return JSX."
        insight="В сравнении с JSX это ощущается как возврат к обычному языку. Ветки читаются линейно, а не через дерево из Show / Switch / Match компонентов."
        tsrxCode={snippets.controlFlow.tsrx}
        jsxCode={snippets.controlFlow.jsx}
      >
        <div class="phase-panel">
          <div class="button-group">
            <button type="button" class={phase() === 'idle' ? 'state-button active-state' : 'state-button'} onClick={() => setPhase('idle')}>
              {'idle'}
            </button>
            <button type="button" class={phase() === 'active' ? 'state-button active-state' : 'state-button'} onClick={() => setPhase('active')}>
              {'active'}
            </button>
            <button type="button" class={phase() === 'error' ? 'state-button active-state' : 'state-button'} onClick={() => setPhase('error')}>
              {'error'}
            </button>
          </div>

          <label class="toggle-line">
            <input type="checkbox" checked={sessionOpen()} onChange={() => setSessionOpen(!sessionOpen())} />
            <span>{'session armed'}</span>
          </label>

          <SessionGate armed={sessionOpen()} phase={phase()} />
        </div>
      </FeatureCard>

      <FeatureCard
        label="03 · for + lexical scope"
        title="Списки через for...of с index и key"
        summary="У цикла есть optional clauses: index и key. А внутри каждой итерации можно объявлять локальные const прямо рядом с разметкой."
        insight="Это один из самых убедительных кейсов TSRX: список выглядит как реальный цикл языка, а не callback внутри компонента-обёртки."
        tsrxCode={snippets.loops.tsrx}
        jsxCode={snippets.loops.jsx}
      >
        <div class="probe-panel">
          <div class="button-group compact">
            <button type="button" class={filter() === 'all' ? 'state-button active-state' : 'state-button'} onClick={() => setFilter('all')}>
              {'all'}
            </button>
            <button type="button" class={filter() === 'queued' ? 'state-button active-state' : 'state-button'} onClick={() => setFilter('queued')}>
              {'queued'}
            </button>
            <button type="button" class={filter() === 'live' ? 'state-button active-state' : 'state-button'} onClick={() => setFilter('live')}>
              {'live'}
            </button>
          </div>

          <ul class="probe-list">
            for (const probe of visibleProbes(); index i; key probe.id) {
              const current = probe();
              const heat = current.score >= 85 ? 'hot' : current.score >= 70 ? 'warm' : 'cold';
              <li class="probe-item">
                <div>
                  <strong>{`${i() + 1}. ${current.name}`}</strong>
                  <p>{`stage: ${current.stage} · score: ${current.score} · mood: ${heat}`}</p>
                </div>
                <button type="button" class="ghost-button small" onClick={() => promoteProbe(current.id)}>
                  {'advance'}
                </button>
              </li>
            }
          </ul>
        </div>
      </FeatureCard>

      <FeatureCard
        label="04 · refs + DOM work"
        title="DOM refs в фигурных скобках"
        summary="{ref expr} работает и с переменной, и с callback. Здесь используем ref для фокуса и измерения узла после mount/resize."
        insight="Синтаксис ref в TSRX компактный и хорошо сочетается с prop shorthand: {ref input}, {onClick}. С точки зрения ergonomics это приятнее стандартного ref={...}."
        tsrxCode={snippets.refs.tsrx}
        jsxCode={snippets.refs.jsx}
      >
        <div class="ref-panel">
          <div class="ref-controls">
            <input
              {ref searchInput}
              type="text"
              value={'TSRX feels like template-native TypeScript'}
              class="lab-input"
              aria-label="tsrx note"
            />
            <div class="button-group compact">
              <button type="button" class="ghost-button" onClick={focusSearch}>
                {'focus & select'}
              </button>
              <button type="button" class="ghost-button" onClick={measureMeter}>
                {'measure meter'}
              </button>
            </div>
          </div>

          <div class="dom-meter" {ref meter}>
            <span>{meterReport}</span>
          </div>
        </div>
      </FeatureCard>

      <FeatureCard
        label="05 · try / pending / catch"
        title="Границы загрузки и ошибок из языка"
        summary="TSRX на Solid target превращает try/pending/catch в Loading и Errored. В JSX пришлось бы писать сами boundary-компоненты вручную."
        insight="Это самая сильная 'языковая' фича TSRX. Асинхронная и error-ветка читаются как обычный control flow, а не как вложенная ceremony из компонентов."
        tsrxCode={snippets.boundaries.tsrx}
        jsxCode={snippets.boundaries.jsx}
      >
        <div class="boundary-stack">
          <div class="boundary-actions">
            <button type="button" class="ghost-button" onClick={() => setAsyncCycle((value) => value + 1)}>
              {'async cycle '}{asyncCycle}
            </button>
            <button type="button" class="ghost-button" onClick={() => setAttempts((value) => value + 1)}>
              {'fuse impulse '}{attempts}
            </button>
          </div>

          <div class="boundary-grid">
            <div>
              <p class="boundary-label">{'pending boundary'}</p>
              try {
                <LazyPreview cycle={asyncCycle()} />
              } pending {
                <div class="boundary-fallback loading-fallback">
                  <strong>{'Loading fallback'}</strong>
                  <p>{'lazy() импортируется и TSRX показывает pending-блок до резолва.'}</p>
                </div>
              } catch (error) {
                <div class="boundary-fallback error-fallback">
                  <strong>{'Async boundary failed'}</strong>
                  <p>{String(error)}</p>
                </div>
              }
            </div>

            <div>
              <p class="boundary-label">{'error boundary'}</p>
              try {
                <FuseBox attempts={attempts()} />
              } catch (error) {
                <div class="boundary-fallback error-fallback">
                  <strong>{'Error caught'}</strong>
                  <p>{String(error)}</p>
                  <button type="button" class="ghost-button small" onClick={() => setAttempts(0)}>
                    {'reset fuse'}
                  </button>
                </div>
              }
            </div>
          </div>
        </div>
      </FeatureCard>

      <FeatureCard
        label="06 · <tsx> + dynamic tag + #style"
        title="Композиция без утечек стилей"
        summary="Здесь в одном месте встречаются сразу три фирменные вещи TSRX: JSX-as-value через <tsx>, dynamic element <@tag> и style composition через #style.className."
        insight="Scoped styles внутри .tsrx ощущаются очень естественно. #style решает боль переиспользования локальных классов между компонентами без CSS Modules и без глобальных утечек."
        tsrxCode={snippets.composition.tsrx}
        jsxCode={snippets.composition.jsx}
        marker={compositionMarker}
      >
        <div class="composition-panel">
          <div class="button-group compact">
            <button type="button" class={headingTag() === 'h2' ? 'state-button active-state' : 'state-button'} onClick={() => setHeadingTag('h2')}>
              {'h2'}
            </button>
            <button type="button" class={headingTag() === 'h3' ? 'state-button active-state' : 'state-button'} onClick={() => setHeadingTag('h3')}>
              {'h3'}
            </button>
            <button type="button" class={headingTag() === 'p' ? 'state-button active-state' : 'state-button'} onClick={() => setHeadingTag('p')}>
              {'p'}
            </button>
          </div>

          <label class="toggle-line">
            <input type="checkbox" checked={noteCompact()} onChange={() => setNoteCompact(!noteCompact())} />
            <span>{'compact card mode'}</span>
          </label>

          <div class={noteCompact() ? 'composition-note compact-note' : 'composition-note'}>
            if (headingTag() === 'h2') {
              <h2 class="composition-title">{'Dynamic element picked from state'}</h2>
            } else if (headingTag() === 'h3') {
              <h3 class="composition-title">{'Dynamic element picked from state'}</h3>
            } else {
              <p class="composition-title composition-copy">{'Dynamic element picked from state'}</p>
            }
            <p>
              {'Снизу лежат ToneChip-компоненты. Они получают className, собранный через #style, поэтому родительский scoped CSS не течёт сам по себе — только по явному контракту.'}
            </p>
            <div class="chip-row">
              <ToneChip label="#style.sunrise" className={#style.sunrise} />
              <ToneChip label="#style.ocean" className={#style.ocean} />
            </div>
          </div>
        </div>
      </FeatureCard>
    </main>

    <section class="notes-grid">
      <article class="notes-card">
        <h2>{'Что особенно понравилось в TSRX'}</h2>
        <ul>
          <li>{'if / for / switch / try пишутся как реальные конструкции языка.'}</li>
          <li>{'Scoped styles встроены в язык, а #style закрывает gap для композиции.'}</li>
          <li>{'lazy destructuring (&{} и &[]) хорошо сочетается с реактивностью Solid.'}</li>
        </ul>
      </article>

      <article class="notes-card caution-card">
        <h2>{'Текущие caveats'}</h2>
        <ul>
          <li>{'Для полной поддержки try/pending/catch нужен Solid 2 beta.'}</li>
          <li>{'raw {html ...} на Solid target не поддерживается — нужен innerHTML.'}</li>
          <li>{'CLI typecheck через чистый tsc пока не покрывает .tsrx так же хорошо, как обычные .tsx файлы.'}</li>
        </ul>
      </article>
    </section>

    <style>
      .guard-fallback,
      .phase-output,
      .fuse-box,
      .boundary-fallback {
        display: grid;
        gap: 0.45rem;
        padding: 0.95rem 1rem;
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      .guard-fallback,
      .phase-output,
      .fuse-box,
      .boundary-fallback,
      .overview-card,
      .notes-card,
      .hero-panel,
      .composition-note,
      .dom-meter {
        background:
          linear-gradient(180deg, rgba(255, 255, 255, 0.05), transparent 28%),
          rgba(6, 9, 18, 0.74);
      }

      .app-shell {
        position: relative;
        width: min(1380px, calc(100vw - 2rem));
        margin: 0 auto;
        padding: 3.4rem 0 5rem;
      }

      .hero-glow {
        position: fixed;
        inset: auto;
        width: 28rem;
        aspect-ratio: 1;
        border-radius: 999px;
        filter: blur(80px);
        opacity: 0.22;
        pointer-events: none;
        z-index: -1;
      }

      .hero-glow-a {
        top: 0;
        left: -8rem;
        background: rgba(102, 110, 255, 0.6);
      }

      .hero-glow-b {
        top: 12rem;
        right: -10rem;
        background: rgba(255, 116, 215, 0.4);
      }

      .hero {
        display: grid;
        gap: 1.5rem;
        padding: 1.6rem;
        border-radius: 1.8rem;
        border: 1px solid rgba(255, 255, 255, 0.08);
        background:
          radial-gradient(circle at top left, rgba(133, 138, 255, 0.18), transparent 30%),
          linear-gradient(180deg, rgba(13, 16, 28, 0.96), rgba(8, 11, 21, 0.92));
        box-shadow: 0 30px 80px rgba(2, 6, 18, 0.45);
      }

      .hero-copy {
        display: grid;
        gap: 1rem;
      }

      .kicker {
        margin: 0;
        color: rgba(255, 183, 120, 0.86);
        text-transform: uppercase;
        letter-spacing: 0.24em;
        font-size: 0.78rem;
      }

      h1,
      h2,
      h3,
      p,
      ul {
        margin: 0;
      }

      h1 {
        max-width: 13ch;
        font-size: clamp(2.8rem, 8vw, 5.9rem);
        line-height: 0.95;
        letter-spacing: -0.05em;
      }

      .lede {
        max-width: 72ch;
        color: rgba(225, 230, 255, 0.76);
        font-size: 1.02rem;
        line-height: 1.75;
      }

      .chip-row {
        display: flex;
        flex-wrap: wrap;
        gap: 0.7rem;
      }

      .hero-panel {
        display: grid;
        gap: 0.9rem;
        padding: 1rem;
        border-radius: 1.25rem;
        border: 1px solid rgba(255, 255, 255, 0.08);
      }

      .mini-stat {
        display: grid;
        gap: 0.35rem;
      }

      .mini-stat span {
        color: rgba(182, 191, 255, 0.72);
        font-size: 0.76rem;
        text-transform: uppercase;
        letter-spacing: 0.16em;
      }

      .mini-stat strong {
        color: rgba(243, 245, 255, 0.88);
        font-size: 0.95rem;
        line-height: 1.5;
      }

      .overview-grid,
      .feature-grid,
      .notes-grid {
        display: grid;
      }

      .overview-grid {
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 0.9rem;
        margin-top: 1.1rem;
      }

      .overview-card {
        display: grid;
        gap: 0.4rem;
        padding: 1rem 1.1rem;
        border-radius: 1.15rem;
        border: 1px solid rgba(255, 255, 255, 0.08);
      }

      .overview-card span,
      .boundary-label {
        color: rgba(181, 189, 255, 0.74);
        text-transform: uppercase;
        letter-spacing: 0.16em;
        font-size: 0.72rem;
      }

      .overview-card strong {
        font-size: 1.2rem;
      }

      .feature-grid {
        grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
        gap: 1rem;
        margin-top: 1rem;
      }

      .signal-lab,
      .phase-panel,
      .probe-panel,
      .ref-panel,
      .boundary-stack,
      .composition-panel,
      .notes-card ul {
        display: grid;
        gap: 1rem;
      }

      .signal-row,
      .button-group,
      .boundary-actions,
      .ref-controls {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        flex-wrap: wrap;
      }

      .readout {
        display: grid;
        place-items: center;
        min-width: 6.5rem;
        padding: 0.8rem 1rem;
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.08);
        background: rgba(255, 255, 255, 0.03);
      }

      .readout strong {
        font-size: 2rem;
        line-height: 1;
      }

      .readout span {
        color: rgba(184, 192, 255, 0.76);
        text-transform: uppercase;
        letter-spacing: 0.18em;
        font-size: 0.72rem;
      }

      .meter-wrap,
      .probe-item,
      .toggle-line,
      .boundary-grid,
      .notes-grid {
        display: grid;
        gap: 0.85rem;
      }

      .meter-bar {
        height: 0.9rem;
        border-radius: 999px;
        background: rgba(255, 255, 255, 0.06);
        overflow: hidden;
      }

      .meter-fill {
        height: 100%;
        border-radius: inherit;
        background: linear-gradient(90deg, #65f0c7, #76a7ff, #ff8bd9);
        box-shadow: 0 0 1.4rem rgba(118, 167, 255, 0.34);
      }

      input[type='range'] {
        width: 100%;
        accent-color: #9ca4ff;
      }

      .ghost-button,
      .state-button {
        appearance: none;
        border: 1px solid rgba(255, 255, 255, 0.12);
        background: rgba(8, 12, 22, 0.88);
        color: rgba(238, 241, 255, 0.88);
        border-radius: 999px;
        padding: 0.72rem 1rem;
        font: inherit;
        cursor: pointer;
        transition:
          transform 180ms ease,
          border-color 180ms ease,
          background 180ms ease;
      }

      .ghost-button:hover,
      .ghost-button:focus-visible,
      .state-button:hover,
      .state-button:focus-visible {
        transform: translateY(-1px);
        border-color: rgba(169, 177, 255, 0.38);
        outline: none;
      }

      .small {
        padding: 0.58rem 0.82rem;
        font-size: 0.8rem;
      }

      .active-state {
        background: linear-gradient(135deg, rgba(113, 117, 255, 0.28), rgba(255, 133, 206, 0.16));
        border-color: rgba(170, 176, 255, 0.4);
      }

      .compact {
        gap: 0.55rem;
      }

      .toggle-line {
        grid-auto-flow: column;
        justify-content: start;
        align-items: center;
      }

      .toggle-line span {
        color: rgba(224, 229, 255, 0.78);
      }

      .probe-list,
      .notes-card ul {
        list-style: none;
        padding: 0;
      }

      .probe-item {
        grid-template-columns: minmax(0, 1fr) auto;
        align-items: center;
        padding: 0.9rem 1rem;
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.08);
        background: rgba(255, 255, 255, 0.03);
      }

      .probe-item p,
      .phase-output p,
      .guard-fallback p,
      .fuse-box p,
      .boundary-fallback p,
      .notes-card li,
      .composition-note p,
      .dom-meter span,
      .meter-wrap p {
        color: rgba(221, 226, 255, 0.74);
        line-height: 1.55;
      }

      .lab-input {
        flex: 1;
        min-width: 14rem;
        border-radius: 0.95rem;
        border: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(4, 8, 15, 0.92);
        color: rgba(244, 246, 255, 0.95);
        padding: 0.88rem 1rem;
        font: inherit;
      }

      .lab-input:focus {
        outline: 1px solid rgba(164, 172, 255, 0.65);
      }

      .dom-meter {
        padding: 1rem;
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.08);
      }

      .boundary-grid {
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      }

      .boundary-label {
        margin-bottom: 0.55rem;
      }

      .loading-fallback {
        border-color: rgba(101, 240, 199, 0.24);
      }

      .error-fallback {
        border-color: rgba(255, 133, 173, 0.28);
      }

      .composition-note {
        display: grid;
        gap: 0.85rem;
        padding: 1rem;
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.08);
      }

      .compact-note {
        max-width: 30rem;
      }

      .composition-title {
        margin: 0;
      }

      .sunrise {
        color: #ffc282;
        border-color: rgba(255, 194, 130, 0.35);
        box-shadow: inset 0 1px 0 rgba(255, 236, 208, 0.08);
      }

      .ocean {
        color: #97ecff;
        border-color: rgba(151, 236, 255, 0.32);
        box-shadow: inset 0 1px 0 rgba(219, 248, 255, 0.08);
      }

      .notes-grid {
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        margin-top: 1rem;
      }

      .notes-card {
        padding: 1.25rem;
        border-radius: 1.25rem;
        border: 1px solid rgba(255, 255, 255, 0.08);
      }

      .notes-card h2 {
        margin-bottom: 0.9rem;
      }

      .notes-card li + li {
        margin-top: 0.7rem;
      }

      .caution-card {
        background:
          radial-gradient(circle at top right, rgba(255, 171, 90, 0.13), transparent 35%),
          linear-gradient(180deg, rgba(255, 255, 255, 0.05), transparent 28%),
          rgba(6, 9, 18, 0.74);
      }

      @media (min-width: 980px) {
        .hero {
          grid-template-columns: minmax(0, 1.2fr) minmax(300px, 0.8fr);
          align-items: start;
        }
      }
    </style>
  </div>
}
