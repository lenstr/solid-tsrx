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
    <div class="gate gate-warn">
      <p class="gate-label">{'[ GUARD ]'}</p>
      <p>{'Early return; the rest of the component branch is aborted.'}</p>
    </div>
    return;
  }

  <div class="gate">
    <p class="gate-label">{'[ PHASE OUTPUT ]'}</p>
    switch (phase) {
      case 'idle':
        <p>{'Bench is quiet. Safe to mutate state.'}</p>
        break;
      case 'active':
        <p>{'Bench is live. TSRX lets you use plain if / switch without Show or Match.'}</p>
        break;
      default:
        <p class="gate-error">{'Invalid mode detected. Good candidate for a try / catch boundary.'}</p>
    }
  </div>
}

component FuseBox(&{ attempts }: { attempts: number }) {
  if (attempts >= 4) {
    throw new Error('FuseBox overheated — error boundary triggered after pulse 4.');
  }

  <div class="gate">
    <p class="gate-label">{'[ FUSE STABLE ]'}</p>
    <p class="mono">{`PULSES ${attempts} / 4`}</p>
  </div>
}

export default component App() {
  let &[dark, setDark] = createSignal(true);

  const toggleTheme = () => {
    const next = !dark();
    setDark(next);
    document.documentElement.classList.toggle('light', !next);
  };

  let &[count, setCount] = createSignal(2);
  let &[effectRuns, setEffectRuns] = createSignal(0, { pureWrite: true });
  let &[phase, setPhase] = createSignal<Phase>('idle');
  let &[sessionOpen, setSessionOpen] = createSignal(true);
  let &[filter, setFilter] = createSignal<Filter>('all');
  let &[attempts, setAttempts] = createSignal(0);
  let &[asyncCycle, setAsyncCycle] = createSignal(1);
  let &[headingTag, setHeadingTag] = createSignal<HeadingTag>('h2');
  let &[noteCompact, setNoteCompact] = createSignal(false);
  let &[meterReport, setMeterReport] = createSignal('— not measured');
  let &[probes, setProbes] = createSignal<Probe[]>([
    { id: 1, name: 'Signal coil', stage: 'live', score: 82 },
    { id: 2, name: 'Boundary relay', stage: 'queued', score: 63 },
    { id: 3, name: 'Scoped paint', stage: 'queued', score: 74 },
    { id: 4, name: 'Loop matrix', stage: 'live', score: 91 },
  ]);

  let searchInput: HTMLInputElement | undefined;
  let meter: HTMLDivElement | undefined;

  const magnitude = createMemo(() => Math.min(100, Math.max(0, (count() + 4) * 8.4)));
  const segments = createMemo(() => Math.round(magnitude() / 5));
  const temperature = createMemo(() => {
    if (count() <= 0) return 'cold';
    if (count() >= 6) return 'blazing';
    return 'steady';
  });
  const visibleProbes = createMemo(() => {
    if (filter() === 'all') return probes();
    return probes().filter((item) => item.stage === filter());
  });
  const liveCount = createMemo(() => probes().filter((item) => item.stage === 'live').length);
  const probeTotal = createMemo(() => probes().length);
  const magnitudeDisplay = createMemo(() => Math.round(magnitude()));
  const compositionMarker = <tsx>
    <ToneChip label="<tsx>" muted />
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
    setMeterReport(`${width.toFixed(0)} PX`);
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

  <div class="app">
    <header class="top-bar">
      <span class="top-bar-left">{'[ SOLID × TSRX ]'}</span>
      <span class="top-bar-mid">{'FIELD LAB / v0.0.5'}</span>
      <div class="top-bar-right">
        <button type="button" class="theme-btn" onClick={toggleTheme} aria-label="Toggle theme">
          {dark() ? '◐ LIGHT' : '◑ DARK'}
        </button>
        <span>{'VITE 8 · SOLID 2β'}</span>
      </div>
    </header>

    <section class="hero">
      <div class="hero-index">
        <span class="hero-num">{'06'}</span>
        <span class="hero-num-label">{'INTERACTIVE MODULES'}</span>
      </div>
      <div class="hero-copy">
        <h1 class="hero-title">
          {'Six benches '}<br />{'for writing UI '}<br />{'in .tsrx, '}<em>{'not JSX.'}</em>
        </h1>
        <p class="hero-lede">
          {'A focused lab around real Solid primitives, but the UI is authored in TSRX — with statement-based JSX, if / for / switch / try in the template, and local '}<span class="mono">{'<style>'}</span>{' blocks.'}
        </p>
      </div>
      <aside class="hero-meta">
        <div class="meta-row">
          <span class="label">{'[ SCOPE ]'}</span>
          <span>{'signals · refs · control flow · loops · boundaries · scoped styles'}</span>
        </div>
        <div class="meta-row">
          <span class="label">{'[ WHY SOLID 2β ]'}</span>
          <span>{'TSRX compiles try / pending / catch → Loading + Errored.'}</span>
        </div>
        <div class="meta-row">
          <span class="label">{'[ CAVEAT ]'}</span>
          <span>{'Build runs through Vite; tsc does not yet treat .tsrx as a first-class source type.'}</span>
        </div>
      </aside>
    </section>

    <section class="telemetry">
      <div class="telemetry-head">
        <span class="label">{'[ LIVE TELEMETRY ]'}</span>
        <span class="label dim">{'— READ-ONLY'}</span>
      </div>
      <div class="telemetry-grid">
        <div class="stat">
          <span class="label">{'PULSE'}</span>
          <strong class="stat-value mono">{count}</strong>
          <span class="stat-unit">{temperature}</span>
        </div>
        <div class="stat">
          <span class="label">{'EFFECTS'}</span>
          <strong class="stat-value mono">{effectRuns}</strong>
          <span class="stat-unit">{'RUNS'}</span>
        </div>
        <div class="stat">
          <span class="label">{'PROBES LIVE'}</span>
          <strong class="stat-value mono">{liveCount}{'/'}{probeTotal}</strong>
          <span class="stat-unit">{'ACTIVE'}</span>
        </div>
        <div class="stat">
          <span class="label">{'PHASE'}</span>
          <strong class={phase() === 'error' ? 'stat-value mono stat-alert' : 'stat-value mono'}>
            {phase}
          </strong>
          <span class="stat-unit">
            if (phase() === 'error') {
              <span class="dot-red" />
            } else {
              <span class="dot-ok" />
            }
            {phase() === 'error' ? 'FAULT' : 'NOMINAL'}
          </span>
        </div>
      </div>
    </section>

    <main class="modules">
      <FeatureCard
        index="01"
        kind="SIGNALS + MEMOS"
        title="A live scale driven by createSignal"
        summary="Signals and memo are the same Solid you know — but state initialization reads nicer via lazy array destructuring: let &[count, setCount]."
        insight="No wrapping return (...) and no Show just for simple branching. Code flows almost like a regular TypeScript file with UI sprinkled in."
        tsrxCode={snippets.signals.tsrx}
        jsxCode={snippets.signals.jsx}
      >
        <div class="panel">
          <div class="big-readout">
            <span class="label">{'SIGNAL VALUE'}</span>
            <div class="readout-row">
              <button type="button" class="btn btn-ghost" onClick={() => nudgeCount(-1)}>
                {'— 1'}
              </button>
              <span class="readout-num mono">{count}</span>
              <button type="button" class="btn btn-ghost" onClick={() => nudgeCount(1)}>
                {'+ 1'}
              </button>
            </div>
            <span class="label dim">{'STATE · '}{temperature}</span>
          </div>

          <input
            type="range"
            min="-4"
            max="8"
            class="range"
            value={String(count())}
            onInput={(event) => setCount(Number(event.currentTarget.value))}
          />

          <div class="seg-meter">
            <div class="seg-meter-head">
              <span class="label">{'MAGNITUDE'}</span>
              <span class="mono">{magnitudeDisplay}{' / 100'}</span>
            </div>
            <div class="seg-bar" aria-hidden="true">
              for (const slot of [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]; index i; key slot) {
                <span class={i() < segments() ? 'seg seg-on' : 'seg'} />
              }
            </div>
            <div class="seg-meter-foot">
              <span class="label dim">{'EFFECT RUNS'}</span>
              <span class="mono">{effectRuns}</span>
            </div>
          </div>
        </div>
      </FeatureCard>

      <FeatureCard
        index="02"
        kind="CONDITIONS · SWITCH · RETURN"
        title="Plain control flow instead of JSX helpers"
        summary="TSRX accepts if / else / switch directly in the template. Guard clauses use a bare return; — no JSX inside it."
        insight="Branches read linearly, top-to-bottom, rather than as a tree of Show / Switch / Match components."
        tsrxCode={snippets.controlFlow.tsrx}
        jsxCode={snippets.controlFlow.jsx}
      >
        <div class="panel">
          <div class="field">
            <span class="label">{'PHASE'}</span>
            <div class="seg-ctrl">
              <button type="button" class={phase() === 'idle' ? 'seg-btn on' : 'seg-btn'} onClick={() => setPhase('idle')}>{'IDLE'}</button>
              <button type="button" class={phase() === 'active' ? 'seg-btn on' : 'seg-btn'} onClick={() => setPhase('active')}>{'ACTIVE'}</button>
              <button type="button" class={phase() === 'error' ? 'seg-btn on danger' : 'seg-btn'} onClick={() => setPhase('error')}>{'ERROR'}</button>
            </div>
          </div>

          <label class="toggle">
            <input type="checkbox" checked={sessionOpen()} onChange={() => setSessionOpen(!sessionOpen())} />
            <span class="toggle-track"><span class="toggle-thumb" /></span>
            <span class="label">{'SESSION ARMED'}</span>
          </label>

          <SessionGate armed={sessionOpen()} phase={phase()} />
        </div>
      </FeatureCard>

      <FeatureCard
        index="03"
        kind="FOR · LEXICAL SCOPE"
        title="Lists as real for…of loops"
        summary="Optional clauses: index and key. Local consts can be declared right next to the markup — same file, same scope."
        insight="One of the most convincing TSRX moments — the list is an actual language loop, not a callback inside a wrapper component."
        tsrxCode={snippets.loops.tsrx}
        jsxCode={snippets.loops.jsx}
      >
        <div class="panel">
          <div class="field">
            <span class="label">{'STAGE FILTER'}</span>
            <div class="seg-ctrl">
              <button type="button" class={filter() === 'all' ? 'seg-btn on' : 'seg-btn'} onClick={() => setFilter('all')}>{'ALL'}</button>
              <button type="button" class={filter() === 'queued' ? 'seg-btn on' : 'seg-btn'} onClick={() => setFilter('queued')}>{'QUEUED'}</button>
              <button type="button" class={filter() === 'live' ? 'seg-btn on' : 'seg-btn'} onClick={() => setFilter('live')}>{'LIVE'}</button>
            </div>
          </div>

          <ul class="probes">
            for (const probe of visibleProbes(); index i; key probe.id) {
              const current = probe();
              const heat = current.score >= 85 ? 'hot' : current.score >= 70 ? 'warm' : 'cold';
              <li class="probe">
                <div class="probe-id mono">{`0${i() + 1}`.slice(-2)}</div>
                <div class="probe-body">
                  <strong class="probe-name">{current.name}</strong>
                  <div class="probe-meta">
                    <span class="label">{current.stage}</span>
                    <span class="mono">{current.score}</span>
                    <span class="label dim">{heat}</span>
                  </div>
                </div>
                <button type="button" class="btn btn-ghost btn-sm" onClick={() => promoteProbe(current.id)}>
                  {'ADVANCE →'}
                </button>
              </li>
            }
          </ul>
        </div>
      </FeatureCard>

      <FeatureCard
        index="04"
        kind="REFS · DOM WORK"
        title="DOM refs in braces"
        summary="{ref expr} accepts either a variable or a callback. Here we focus and measure a node after mount and on resize."
        insight="Ref syntax is compact and pairs well with prop shorthand: {ref input}, {onClick}."
        tsrxCode={snippets.refs.tsrx}
        jsxCode={snippets.refs.jsx}
      >
        <div class="panel">
          <label class="field">
            <span class="label">{'NOTE INPUT'}</span>
            <input
              {ref searchInput}
              type="text"
              value={'TSRX feels like template-native TypeScript'}
              class="text-input mono"
              aria-label="tsrx note"
            />
          </label>

          <div class="row-actions">
            <button type="button" class="btn btn-primary" onClick={focusSearch}>
              {'FOCUS & SELECT'}
            </button>
            <button type="button" class="btn btn-ghost" onClick={measureMeter}>
              {'MEASURE'}
            </button>
          </div>

          <div class="dom-meter" {ref meter}>
            <span class="label">{'DOM REF'}</span>
            <span class="mono dom-meter-val">{meterReport}</span>
          </div>
        </div>
      </FeatureCard>

      <FeatureCard
        index="05"
        kind="TRY · PENDING · CATCH"
        title="Loading and error boundaries as language constructs"
        summary="On the Solid target TSRX compiles try / pending / catch into Loading and Errored. Classic JSX needs the boundary components wired by hand."
        insight="This is the strongest 'language' feature of TSRX. Async and error branches read as plain control flow — no component ceremony."
        tsrxCode={snippets.boundaries.tsrx}
        jsxCode={snippets.boundaries.jsx}
      >
        <div class="panel">
          <div class="row-actions">
            <button type="button" class="btn btn-ghost" onClick={() => setAsyncCycle((value) => value + 1)}>
              {'ASYNC CYCLE · '}{asyncCycle}
            </button>
            <button type="button" class="btn btn-ghost" onClick={() => setAttempts((value) => value + 1)}>
              {'FUSE PULSE · '}{attempts}
            </button>
          </div>

          <div class="boundary-grid">
            <div class="boundary">
              <span class="label">{'[ PENDING BOUNDARY ]'}</span>
              try {
                <LazyPreview cycle={asyncCycle()} />
              } pending {
                <div class="gate gate-loading">
                  <p class="gate-label">{'[ LOADING… ]'}</p>
                  <p>{'lazy() is resolving. TSRX renders the pending block until the module lands.'}</p>
                </div>
              } catch (error) {
                <div class="gate gate-err">
                  <p class="gate-label">{'[ ASYNC FAILED ]'}</p>
                  <p>{String(error)}</p>
                </div>
              }
            </div>

            <div class="boundary">
              <span class="label">{'[ ERROR BOUNDARY ]'}</span>
              try {
                <FuseBox attempts={attempts()} />
              } catch (error) {
                <div class="gate gate-err">
                  <p class="gate-label">{'[ ERROR CAUGHT ]'}</p>
                  <p>{String(error)}</p>
                  <button type="button" class="btn btn-ghost btn-sm" onClick={() => setAttempts(0)}>
                    {'RESET FUSE'}
                  </button>
                </div>
              }
            </div>
          </div>
        </div>
      </FeatureCard>

      <FeatureCard
        index="06"
        kind="<tsx> · DYNAMIC TAG · #style"
        title="Composition without style leaks"
        summary="Three TSRX-native features converge here: JSX-as-value via <tsx>, dynamic element selection, and #style.className for scoped composition."
        insight="Scoped styles feel native inside a .tsrx file. #style closes the composition gap without CSS Modules or global leaks."
        tsrxCode={snippets.composition.tsrx}
        jsxCode={snippets.composition.jsx}
        marker={compositionMarker}
      >
        <div class="panel">
          <div class="field">
            <span class="label">{'HEADING TAG'}</span>
            <div class="seg-ctrl">
              <button type="button" class={headingTag() === 'h2' ? 'seg-btn on' : 'seg-btn'} onClick={() => setHeadingTag('h2')}>{'H2'}</button>
              <button type="button" class={headingTag() === 'h3' ? 'seg-btn on' : 'seg-btn'} onClick={() => setHeadingTag('h3')}>{'H3'}</button>
              <button type="button" class={headingTag() === 'p' ? 'seg-btn on' : 'seg-btn'} onClick={() => setHeadingTag('p')}>{'P'}</button>
            </div>
          </div>

          <label class="toggle">
            <input type="checkbox" checked={noteCompact()} onChange={() => setNoteCompact(!noteCompact())} />
            <span class="toggle-track"><span class="toggle-thumb" /></span>
            <span class="label">{'COMPACT MODE'}</span>
          </label>

          <div class={noteCompact() ? 'composition-note compact' : 'composition-note'}>
            if (headingTag() === 'h2') {
              <h2 class="composition-title">{'Dynamic element picked from state'}</h2>
            } else if (headingTag() === 'h3') {
              <h3 class="composition-title-sm">{'Dynamic element picked from state'}</h3>
            } else {
              <p class="composition-copy">{'Dynamic element picked from state'}</p>
            }
            <p class="composition-body">
              {'Below sit ToneChip components. Their className is composed via #style, so the parent\'s scoped CSS only leaks across an explicit contract.'}
            </p>
            <div class="chip-row">
              <ToneChip label="#style.sunrise" className={#style.sunrise} />
              <ToneChip label="#style.ocean" className={#style.ocean} />
            </div>
          </div>
        </div>
      </FeatureCard>
    </main>

    <section class="footnotes">
      <div class="footnote">
        <span class="label">{'[ + ] WHAT LANDED WELL'}</span>
        <ul>
          <li>{'if / for / switch / try read as actual language constructs.'}</li>
          <li>{'Scoped styles live in the language; #style covers composition.'}</li>
          <li>{'Lazy destructuring (&{} and &[]) pairs cleanly with Solid reactivity.'}</li>
        </ul>
      </div>
      <div class="footnote">
        <span class="label">{'[ ! ] CAVEATS IN FLIGHT'}</span>
        <ul>
          <li>{'try / pending / catch requires Solid 2 beta.'}</li>
          <li>{'Raw {html …} is not supported on the Solid target — use innerHTML.'}</li>
          <li>{'tsc does not yet understand .tsrx the way it understands .tsx.'}</li>
        </ul>
      </div>
    </section>

    <footer class="foot">
      <span class="label">{'[ END OF FIELD LAB ]'}</span>
      <span class="label dim">{'// TSRX 0.0.5 · SOLID 2.0.0-β.7 · VITE 8'}</span>
    </footer>

    <style>
      .app {
        position: relative;
        margin: 0 auto;
        padding: 24px clamp(24px, 4vw, 80px) 128px;
        font-size: 16px;
      }

      @media (min-width: 1400px) {
        .app {
          font-size: 17px;
        }
      }

      @media (min-width: 1800px) {
        .app {
          font-size: 18px;
          padding-left: clamp(80px, 5vw, 120px);
          padding-right: clamp(80px, 5vw, 120px);
        }
      }

      .top-bar {
        display: grid;
        grid-template-columns: auto 1fr auto;
        gap: 16px;
        padding: 14px 0;
        border-bottom: 1px solid var(--border);
        font-family: var(--font-mono);
        font-size: 12px;
        letter-spacing: 0.16em;
        text-transform: uppercase;
        color: var(--text-secondary);
      }

      .top-bar-mid {
        text-align: center;
        color: var(--text-disabled);
      }

      .top-bar-right {
        display: flex;
        align-items: center;
        gap: 16px;
        justify-content: flex-end;
      }

      .theme-btn {
        appearance: none;
        background: transparent;
        border: 1px solid var(--border-visible);
        color: var(--text-secondary);
        font-family: var(--font-mono);
        font-size: 11px;
        letter-spacing: 0.14em;
        padding: 4px 10px;
        cursor: pointer;
        transition: color 150ms ease-out, border-color 150ms ease-out;
      }

      .theme-btn:hover {
        color: var(--text-display);
        border-color: var(--text-primary);
      }

      /* HERO — asymmetric, left-weighted, hero number dominates */
      .hero {
        display: grid;
        grid-template-columns: 1fr;
        gap: 56px;
        padding: 120px 0 80px;
      }

      .hero-index {
        display: flex;
        align-items: baseline;
        gap: 28px;
      }

      .hero-num {
        font-family: var(--font-display);
        font-size: clamp(140px, 20vw, 420px);
        font-weight: 500;
        line-height: 0.82;
        letter-spacing: -0.04em;
        color: var(--text-display);
      }

      .hero-num-label {
        font-family: var(--font-mono);
        font-size: 12px;
        letter-spacing: 0.22em;
        text-transform: uppercase;
        color: var(--text-secondary);
        writing-mode: vertical-rl;
        transform: rotate(180deg);
      }

      .hero-title {
        font-family: var(--font-body);
        font-size: clamp(40px, 4.8vw, 88px);
        font-weight: 300;
        line-height: 1.02;
        letter-spacing: -0.03em;
        color: var(--text-display);
        max-width: 18ch;
      }

      .hero-title em {
        font-style: normal;
        font-weight: 500;
        color: var(--text-primary);
      }

      .hero-lede {
        max-width: 60ch;
        margin-top: 28px;
        font-size: 18px;
        line-height: 1.6;
        color: var(--text-secondary);
      }

      .hero-lede .mono {
        color: var(--text-primary);
      }

      .hero-meta {
        display: grid;
        gap: 16px;
        padding-top: 24px;
        border-top: 1px solid var(--border);
      }

      .meta-row {
        display: grid;
        grid-template-columns: 220px 1fr;
        gap: 24px;
        align-items: baseline;
        padding: 16px 0;
        border-bottom: 1px solid var(--border);
      }

      .meta-row:last-child {
        border-bottom: none;
      }

      .meta-row > span:last-child {
        color: var(--text-primary);
        font-size: 16px;
        line-height: 1.55;
      }

      @media (min-width: 900px) {
        .hero {
          grid-template-columns: minmax(auto, 44%) 1fr;
          grid-template-rows: auto auto;
          gap: 48px 80px;
          align-items: end;
        }

        .hero-index {
          grid-row: 1 / span 2;
        }

        .hero-meta {
          grid-column: 2;
        }
      }

      @media (min-width: 1600px) {
        .hero {
          gap: 64px 120px;
          padding: 140px 0 100px;
        }
      }

      /* TELEMETRY — stat row with ALL CAPS labels, mono values */
      .telemetry {
        padding: 48px 0;
        border-top: 1px solid var(--border-visible);
        border-bottom: 1px solid var(--border-visible);
      }

      @media (min-width: 1600px) {
        .telemetry {
          padding: 64px 0;
        }
      }

      .telemetry-head {
        display: flex;
        justify-content: space-between;
        margin-bottom: 32px;
      }

      .dim {
        color: var(--text-disabled) !important;
      }

      .telemetry-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 0;
      }

      .stat {
        display: grid;
        gap: 12px;
        padding: 0 32px;
        border-left: 1px solid var(--border);
      }

      .stat:first-child {
        padding-left: 0;
        border-left: none;
      }

      .stat-value {
        font-size: clamp(44px, 4vw, 72px);
        font-weight: 400;
        line-height: 1;
        color: var(--text-display);
        letter-spacing: -0.02em;
      }

      .stat-alert {
        color: var(--accent) !important;
      }

      .stat-unit {
        font-family: var(--font-mono);
        font-size: 12px;
        letter-spacing: 0.16em;
        text-transform: uppercase;
        color: var(--text-disabled);
        display: inline-flex;
        align-items: center;
        gap: 8px;
      }

      .dot-red,
      .dot-ok {
        display: inline-block;
        width: 6px;
        height: 6px;
        border-radius: 999px;
      }

      .dot-red {
        background: var(--accent);
      }

      .dot-ok {
        background: var(--success);
      }

      /* MODULES grid */
      .modules {
        display: grid;
        grid-template-columns: 1fr;
        gap: 0;
        margin-top: 48px;
        align-items: start;
      }

      @media (min-width: 900px) {
        .modules {
          grid-template-columns: repeat(2, 1fr);
          gap: 0;
        }
      }

      @media (min-width: 1800px) {
        .modules {
          grid-template-columns: repeat(3, 1fr);
        }
      }

      /* Panels inside feature cards */
      .panel {
        display: grid;
        gap: 20px;
      }

      .field {
        display: grid;
        gap: 10px;
      }

      .big-readout {
        display: grid;
        gap: 8px;
      }

      .readout-row {
        display: flex;
        align-items: center;
        gap: 16px;
      }

      .readout-num {
        flex: 1;
        font-size: clamp(72px, 7vw, 96px);
        line-height: 0.9;
        letter-spacing: -0.03em;
        color: var(--text-display);
        text-align: center;
        font-weight: 400;
      }

      /* Range */
      .range {
        width: 100%;
        appearance: none;
        background: var(--border);
        height: 2px;
        cursor: pointer;
      }

      .range::-webkit-slider-thumb {
        appearance: none;
        width: 12px;
        height: 12px;
        background: var(--text-display);
        border-radius: 999px;
        border: none;
      }

      .range::-moz-range-thumb {
        width: 12px;
        height: 12px;
        background: var(--text-display);
        border-radius: 999px;
        border: none;
      }

      /* SEGMENTED METER — the signature visualization */
      .seg-meter {
        display: grid;
        gap: 10px;
        padding-top: 16px;
        border-top: 1px solid var(--border);
      }

      .seg-meter-head,
      .seg-meter-foot {
        display: flex;
        justify-content: space-between;
        align-items: baseline;
      }

      .seg-meter-head .mono,
      .seg-meter-foot .mono {
        color: var(--text-display);
        font-size: 14px;
      }

      .seg-bar {
        display: grid;
        grid-template-columns: repeat(20, 1fr);
        gap: 2px;
      }

      .seg {
        height: 20px;
        background: var(--border);
      }

      .seg-on {
        background: var(--text-display);
      }

      /* SEGMENTED CONTROL */
      .seg-ctrl {
        display: inline-flex;
        border: 1px solid var(--border-visible);
      }

      .seg-btn {
        appearance: none;
        background: transparent;
        border: none;
        border-right: 1px solid var(--border-visible);
        padding: 10px 20px;
        font-family: var(--font-mono);
        font-size: 12px;
        letter-spacing: 0.16em;
        color: var(--text-secondary);
        cursor: pointer;
        min-height: 44px;
        transition: background 150ms ease-out, color 150ms ease-out;
      }

      .seg-btn:last-child {
        border-right: none;
      }

      .seg-btn:hover {
        color: var(--text-primary);
      }

      .seg-btn.on {
        background: var(--text-display);
        color: var(--black);
      }

      .seg-btn.on.danger {
        background: var(--accent);
        color: var(--text-display);
      }

      /* BUTTONS — compact, technical, desktop-sized */
      .btn {
        appearance: none;
        font-family: var(--font-mono);
        font-size: 11px;
        letter-spacing: 0.14em;
        cursor: pointer;
        min-height: 32px;
        padding: 6px 14px;
        border-radius: 0;
        transition: background 150ms ease-out, border-color 150ms ease-out, color 150ms ease-out;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        white-space: nowrap;
      }

      .btn-primary {
        background: var(--text-display);
        color: var(--black);
        border: 1px solid var(--text-display);
      }

      .btn-primary:hover {
        background: var(--text-primary);
        border-color: var(--text-primary);
      }

      .btn-ghost {
        background: transparent;
        color: var(--text-primary);
        border: 1px solid var(--border-visible);
      }

      .btn-ghost:hover {
        border-color: var(--text-primary);
        color: var(--text-display);
      }

      .btn-sm {
        min-height: 28px;
        padding: 4px 10px;
        font-size: 10px;
      }

      .row-actions {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
      }

      /* TOGGLE */
      .toggle {
        display: inline-flex;
        align-items: center;
        gap: 12px;
        cursor: pointer;
      }

      .toggle input {
        position: absolute;
        opacity: 0;
        pointer-events: none;
      }

      .toggle-track {
        position: relative;
        width: 36px;
        height: 20px;
        border-radius: 999px;
        background: var(--border-visible);
        transition: background 150ms ease-out;
      }

      .toggle-thumb {
        position: absolute;
        top: 3px;
        left: 3px;
        width: 14px;
        height: 14px;
        border-radius: 999px;
        background: var(--text-disabled);
        transition: transform 150ms ease-out, background 150ms ease-out;
      }

      .toggle input:checked + .toggle-track {
        background: var(--text-display);
      }

      .toggle input:checked + .toggle-track .toggle-thumb {
        background: var(--black);
        transform: translateX(16px);
      }

      /* GATES — the small state boxes */
      .gate {
        display: grid;
        gap: 8px;
        padding: 18px 20px;
        border: 1px solid var(--border-visible);
        background: var(--surface);
      }

      .gate p {
        font-size: 15px;
        line-height: 1.55;
        color: var(--text-primary);
      }

      .gate-label {
        font-family: var(--font-mono);
        font-size: 11px;
        letter-spacing: 0.18em;
        text-transform: uppercase;
        color: var(--text-secondary) !important;
      }

      .gate-warn {
        border-color: var(--warning);
      }

      .gate-err {
        border-color: var(--accent);
      }

      .gate-err .gate-label {
        color: var(--accent) !important;
      }

      .gate-loading {
        border-color: var(--border-strong);
      }

      .gate-error {
        color: var(--accent) !important;
      }

      /* PROBES list */
      .probes {
        display: grid;
        gap: 0;
        border-top: 1px solid var(--border);
      }

      .probe {
        display: grid;
        grid-template-columns: auto 1fr auto;
        gap: 24px;
        align-items: center;
        padding: 18px 0;
        border-bottom: 1px solid var(--border);
      }

      .probe-id {
        color: var(--text-disabled);
        font-size: 13px;
        letter-spacing: 0.14em;
      }

      .probe-body {
        display: grid;
        gap: 6px;
      }

      .probe-name {
        font-size: 17px;
        font-weight: 500;
        color: var(--text-display);
      }

      .probe-meta {
        display: flex;
        gap: 20px;
        align-items: center;
        font-size: 12px;
      }

      .probe-meta .mono {
        color: var(--text-primary);
      }

      /* INPUT */
      .text-input {
        width: 100%;
        background: transparent;
        border: none;
        border-bottom: 1px solid var(--border-visible);
        color: var(--text-display);
        font-size: 16px;
        padding: 12px 0;
        transition: border-color 150ms ease-out;
      }

      .text-input:focus {
        outline: none;
        border-bottom-color: var(--text-display);
      }

      .dom-meter {
        display: flex;
        justify-content: space-between;
        align-items: baseline;
        padding: 14px 0;
        border-top: 1px solid var(--border);
        border-bottom: 1px solid var(--border);
      }

      .dom-meter-val {
        color: var(--text-display);
        font-size: 16px;
      }

      /* BOUNDARIES */
      .boundary-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 20px;
      }

      .boundary {
        display: grid;
        gap: 10px;
      }

      @media (min-width: 640px) {
        .boundary-grid {
          grid-template-columns: 1fr 1fr;
        }
      }

      /* COMPOSITION */
      .composition-note {
        display: grid;
        gap: 12px;
        padding: 16px;
        border: 1px solid var(--border-visible);
        background: var(--surface);
      }

      .composition-note.compact {
        max-width: 30rem;
      }

      .composition-title {
        font-family: var(--font-body);
        font-size: 28px;
        font-weight: 500;
        line-height: 1.2;
        letter-spacing: -0.02em;
        color: var(--text-display);
      }

      .composition-title-sm {
        font-family: var(--font-body);
        font-size: 20px;
        font-weight: 500;
        line-height: 1.3;
        color: var(--text-display);
      }

      .composition-copy {
        font-size: 15px;
        color: var(--text-secondary);
      }

      .composition-body {
        font-size: 14px;
        line-height: 1.55;
        color: var(--text-secondary);
      }

      .chip-row {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
      }

      .sunrise {
        color: var(--warning) !important;
        border-color: var(--warning) !important;
      }

      .ocean {
        color: #7fc7d9 !important;
        border-color: #7fc7d9 !important;
      }

      /* FOOTNOTES */
      .footnotes {
        display: grid;
        grid-template-columns: 1fr;
        gap: 56px;
        margin-top: 96px;
        padding-top: 64px;
        border-top: 1px solid var(--border-visible);
      }

      @media (min-width: 720px) {
        .footnotes {
          grid-template-columns: 1fr 1fr;
          gap: 80px;
        }
      }

      @media (min-width: 1600px) {
        .footnotes {
          gap: 160px;
        }
      }

      .footnote {
        display: grid;
        gap: 20px;
      }

      .footnote ul {
        display: grid;
        gap: 14px;
      }

      .footnote li {
        display: grid;
        grid-template-columns: auto 1fr;
        gap: 14px;
        font-size: 16px;
        line-height: 1.55;
        color: var(--text-primary);
        padding-bottom: 14px;
        border-bottom: 1px solid var(--border);
      }

      .footnote li:last-child {
        border-bottom: none;
      }

      .footnote li::before {
        content: '—';
        color: var(--text-disabled);
        font-family: var(--font-mono);
      }

      /* FOOT */
      .foot {
        display: flex;
        justify-content: space-between;
        margin-top: 64px;
        padding-top: 24px;
        border-top: 1px solid var(--border);
      }
    </style>
  </div>
}
