import { createSignal } from 'solid-js';

type Mode = 'tsrx' | 'jsx';

type Props = {
  label: string;
  title: string;
  summary: string;
  insight: string;
  tsrxCode: string;
  jsxCode: string;
  marker?: any;
  children?: any;
};

export default component FeatureCard(
  &{ label, title, summary, insight, tsrxCode, jsxCode, marker, children }: Props,
) {
  let &[mode, setMode] = createSignal<Mode>('tsrx');

  <article class="feature-card">
    <header class="card-head">
      <div>
        <p class="eyebrow">{label}</p>
        <div class="title-row">
          <h2>{title}</h2>
          if (marker) {
            <div class="marker">{marker}</div>
          }
        </div>
        <p class="summary">{summary}</p>
      </div>

      <div class="tabs" role="tablist" aria-label={`${title} code mode`}>
        <button
          type="button"
          class={mode() === 'tsrx' ? 'tab active' : 'tab'}
          aria-pressed={mode() === 'tsrx'}
          onClick={() => setMode('tsrx')}
        >
          {'TSRX'}
        </button>
        <button
          type="button"
          class={mode() === 'jsx' ? 'tab active' : 'tab'}
          aria-pressed={mode() === 'jsx'}
          onClick={() => setMode('jsx')}
        >
          {'JSX mental model'}
        </button>
      </div>
    </header>

    <div class="sandbox">{children}</div>

    <div class="insight-strip">
      <span class="insight-label">{'Зачем это интересно'}</span>
      <p>{insight}</p>
    </div>

    <div class="code-wrap">
      <pre>
        <code>{mode() === 'tsrx' ? tsrxCode : jsxCode}</code>
      </pre>
    </div>
  </article>

  <style>
    .feature-card {
      position: relative;
      display: grid;
      gap: 1.2rem;
      padding: 1.35rem;
      border-radius: 1.5rem;
      border: 1px solid rgba(255, 255, 255, 0.1);
      background:
        radial-gradient(circle at top right, rgba(118, 120, 255, 0.18), transparent 32%),
        linear-gradient(180deg, rgba(14, 17, 31, 0.95), rgba(8, 11, 22, 0.92));
      box-shadow:
        0 24px 60px rgba(1, 4, 15, 0.45),
        inset 0 1px 0 rgba(255, 255, 255, 0.06);
      overflow: hidden;
    }

    .feature-card::before {
      content: '';
      position: absolute;
      inset: 0;
      background:
        linear-gradient(125deg, rgba(255, 255, 255, 0.06), transparent 28%),
        linear-gradient(transparent 55%, rgba(255, 255, 255, 0.03));
      pointer-events: none;
    }

    .card-head {
      display: grid;
      gap: 1rem;
    }

    .eyebrow {
      margin: 0;
      color: rgba(151, 162, 255, 0.88);
      font-size: 0.78rem;
      text-transform: uppercase;
      letter-spacing: 0.18em;
    }

    .title-row {
      display: flex;
      align-items: center;
      gap: 0.85rem;
      flex-wrap: wrap;
    }

    h2 {
      margin: 0;
      font-size: clamp(1.25rem, 1rem + 1vw, 1.8rem);
      line-height: 1;
    }

    .marker {
      display: inline-flex;
      align-items: center;
      gap: 0.45rem;
      min-height: 2rem;
    }

    .summary {
      margin: 0;
      max-width: 64ch;
      color: rgba(217, 222, 255, 0.72);
      line-height: 1.6;
    }

    .tabs {
      display: inline-flex;
      flex-wrap: wrap;
      gap: 0.55rem;
    }

    .tab {
      appearance: none;
      border: 1px solid rgba(255, 255, 255, 0.12);
      background: rgba(5, 8, 16, 0.66);
      color: rgba(235, 238, 255, 0.7);
      border-radius: 999px;
      padding: 0.6rem 0.9rem;
      font: inherit;
      font-size: 0.78rem;
      letter-spacing: 0.04em;
      cursor: pointer;
      transition:
        transform 180ms ease,
        border-color 180ms ease,
        color 180ms ease,
        background 180ms ease;
    }

    .tab:hover,
    .tab:focus-visible {
      transform: translateY(-1px);
      border-color: rgba(160, 170, 255, 0.4);
      color: rgba(244, 246, 255, 0.95);
      outline: none;
    }

    .active {
      background: linear-gradient(135deg, rgba(120, 122, 255, 0.28), rgba(255, 122, 210, 0.18));
      border-color: rgba(164, 169, 255, 0.4);
      color: white;
      box-shadow: 0 12px 24px rgba(87, 90, 255, 0.18);
    }

    .sandbox {
      position: relative;
      display: grid;
      gap: 1rem;
      padding: 1rem;
      border-radius: 1.1rem;
      border: 1px solid rgba(255, 255, 255, 0.08);
      background:
        linear-gradient(180deg, rgba(255, 255, 255, 0.04), transparent 24%),
        rgba(3, 5, 12, 0.84);
    }

    .insight-strip {
      display: grid;
      gap: 0.4rem;
      padding: 0.95rem 1rem;
      border-radius: 1rem;
      background: rgba(95, 102, 255, 0.12);
      border: 1px solid rgba(147, 156, 255, 0.18);
    }

    .insight-strip p {
      margin: 0;
      color: rgba(236, 239, 255, 0.82);
      line-height: 1.55;
    }

    .insight-label {
      color: rgba(182, 190, 255, 0.88);
      font-size: 0.76rem;
      text-transform: uppercase;
      letter-spacing: 0.18em;
    }

    .code-wrap {
      position: relative;
      border-radius: 1.05rem;
      border: 1px solid rgba(255, 255, 255, 0.08);
      background: rgba(1, 3, 10, 0.92);
      overflow: auto;
    }

    pre {
      margin: 0;
      padding: 1rem;
      min-height: 14rem;
      font-size: 0.82rem;
      line-height: 1.65;
      color: rgba(228, 232, 255, 0.88);
      white-space: pre-wrap;
      word-break: break-word;
    }

    @media (min-width: 760px) {
      .card-head {
        grid-template-columns: minmax(0, 1fr) auto;
        align-items: start;
      }
    }
  </style>
}
