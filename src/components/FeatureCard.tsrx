import { createSignal } from 'solid-js';

type Mode = 'tsrx' | 'jsx';

type Props = {
  index: string;
  kind: string;
  title: string;
  summary: string;
  insight: string;
  tsrxCode: string;
  jsxCode: string;
  marker?: any;
  children?: any;
};

export default component FeatureCard(
  &{ index, kind, title, summary, insight, tsrxCode, jsxCode, marker, children }: Props,
) {
  let &[mode, setMode] = createSignal<Mode>('tsrx');
  let &[open, setOpen] = createSignal(false);

  <article class="card">
    <div class="card-inner">
      <header class="card-head">
        <div class="card-eyebrow">
          <span class="card-index mono">{index}</span>
          <span class="card-kind mono">{kind}</span>
          if (marker) {
            <span class="card-marker">{marker}</span>
          }
        </div>
        <h2 class="card-title">{title}</h2>
        <p class="card-summary">{summary}</p>
      </header>

      <div class="card-sandbox">{children}</div>

      <div class="card-insight">
        <span class="mono insight-tag">{'//'}</span>
        <p>{insight}</p>
      </div>

      <div class="card-code">
        <div class="code-head">
          <span class="mono code-head-label">{'[ SNIPPET ]'}</span>
          <div class="code-toggle">
            <button
              type="button"
              class={mode() === 'tsrx' ? 'code-tab on' : 'code-tab'}
              aria-pressed={mode() === 'tsrx'}
              onClick={() => setMode('tsrx')}
            >
              {'.TSRX'}
            </button>
            <button
              type="button"
              class={mode() === 'jsx' ? 'code-tab on' : 'code-tab'}
              aria-pressed={mode() === 'jsx'}
              onClick={() => setMode('jsx')}
            >
              {'.JSX'}
            </button>
            <button
              type="button"
              class="code-collapse"
              onClick={() => setOpen(!open())}
              aria-expanded={open()}
            >
              {open() ? '[ HIDE ]' : '[ SHOW ]'}
            </button>
          </div>
        </div>

        if (open()) {
          <pre class="code-block"><code>{mode() === 'tsrx' ? tsrxCode : jsxCode}</code></pre>
        }
      </div>
    </div>
  </article>

  <style>
    .card {
      display: flex;
      border-top: 1px solid var(--border-visible);
      border-right: 1px solid var(--border);
    }

    .card:nth-child(2n) {
      border-right: none;
    }

    @media (max-width: 899px) {
      .card {
        border-right: none !important;
      }
    }

    @media (min-width: 1800px) {
      .card:nth-child(2n) {
        border-right: 1px solid var(--border);
      }

      .card:nth-child(3n) {
        border-right: none;
      }
    }

    .card-inner {
      display: grid;
      gap: 32px;
      padding: 48px 40px;
      width: 100%;
    }

    @media (max-width: 899px) {
      .card-inner {
        padding: 32px 24px;
      }
    }

    @media (min-width: 1800px) {
      .card-inner {
        padding: 56px 48px;
        gap: 36px;
      }
    }

    .card-head {
      display: grid;
      gap: 16px;
    }

    .card-eyebrow {
      display: flex;
      align-items: center;
      gap: 12px;
      flex-wrap: wrap;
    }

    .card-index {
      display: inline-grid;
      place-items: center;
      min-width: 48px;
      height: 48px;
      padding: 0 14px;
      background: var(--text-display);
      color: var(--black);
      font-size: 16px;
      letter-spacing: 0.08em;
      font-weight: 700;
    }

    .card-kind {
      font-size: 12px;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      color: var(--text-secondary);
    }

    .card-marker {
      margin-left: auto;
    }

    .card-title {
      font-family: var(--font-body);
      font-size: clamp(26px, 2.4vw, 34px);
      font-weight: 500;
      line-height: 1.15;
      letter-spacing: -0.02em;
      color: var(--text-display);
      max-width: 24ch;
    }

    .card-summary {
      font-size: 16px;
      line-height: 1.6;
      color: var(--text-secondary);
      max-width: 58ch;
    }

    .card-sandbox {
      display: grid;
      padding: 32px 0;
      border-top: 1px solid var(--border);
      border-bottom: 1px solid var(--border);
    }

    .card-insight {
      display: grid;
      grid-template-columns: auto 1fr;
      gap: 14px;
      align-items: baseline;
    }

    .insight-tag {
      color: var(--text-display);
      font-size: 16px;
      letter-spacing: 0;
    }

    .card-insight p {
      font-size: 15px;
      line-height: 1.6;
      color: var(--text-primary);
      max-width: 58ch;
    }

    .card-code {
      display: grid;
      gap: 12px;
    }

    .code-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding-top: 16px;
      border-top: 1px solid var(--border);
    }

    .code-head-label {
      font-size: 11px;
      letter-spacing: 0.14em;
      color: var(--text-disabled);
      text-transform: uppercase;
    }

    .code-toggle {
      display: inline-flex;
      align-items: center;
      gap: 0;
    }

    .code-tab {
      appearance: none;
      background: transparent;
      border: 1px solid var(--border-visible);
      border-right: none;
      padding: 8px 14px;
      font-family: var(--font-mono);
      font-size: 11px;
      letter-spacing: 0.14em;
      color: var(--text-secondary);
      cursor: pointer;
      min-height: 36px;
    }

    .code-tab:hover {
      color: var(--text-primary);
    }

    .code-tab.on {
      background: var(--text-display);
      color: var(--black);
      border-color: var(--text-display);
    }

    .code-collapse {
      appearance: none;
      background: transparent;
      border: 1px solid var(--border-visible);
      padding: 8px 14px;
      font-family: var(--font-mono);
      font-size: 11px;
      letter-spacing: 0.14em;
      color: var(--text-secondary);
      cursor: pointer;
      margin-left: 10px;
      min-height: 36px;
    }

    .code-collapse:hover {
      color: var(--text-primary);
      border-color: var(--text-primary);
    }

    .code-block {
      margin: 0;
      padding: 24px;
      background: var(--surface);
      border: 1px solid var(--border);
      font-family: var(--font-mono);
      font-size: 13.5px;
      line-height: 1.65;
      color: var(--text-primary);
      overflow: auto;
      white-space: pre-wrap;
      word-break: break-word;
      max-height: 28rem;
    }
  </style>
}
