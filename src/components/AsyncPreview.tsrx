type Props = {
  cycle: number;
};

export default component AsyncPreview(&{ cycle }: Props) {
  const stagger = (index: number) => ({
    'animation-delay': `${index * 90}ms`,
  });

  <div class="preview">
    <div class="preview-head">
      <span class="preview-label">{'[ MODULE ONLINE ]'}</span>
      <span class="preview-cycle">{`CYCLE ${cycle}`}</span>
    </div>

    <div class="preview-bars" aria-hidden="true">
      for (const slot of [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]; index i; key `${cycle}-${slot}`) {
        <span class="bar" style={stagger(i())} />
      }
    </div>

    <p class="preview-copy">
      {'Arrived via lazy() + try / pending. On the Solid target this is exactly the feature that requires Solid 2 beta.'}
    </p>
  </div>

  <style>
    .preview {
      display: grid;
      gap: 14px;
      padding: 16px;
      border: 1px solid var(--border-visible);
      background: var(--surface);
    }

    .preview-head {
      display: flex;
      align-items: baseline;
      justify-content: space-between;
      gap: 16px;
    }

    .preview-label {
      font-family: var(--font-mono);
      font-size: 11px;
      letter-spacing: 0.16em;
      color: var(--text-secondary);
    }

    .preview-cycle {
      font-family: var(--font-mono);
      font-size: 16px;
      color: var(--text-display);
    }

    .preview-bars {
      display: grid;
      grid-template-columns: repeat(16, 1fr);
      gap: 2px;
      align-items: end;
      height: 40px;
    }

    .bar {
      display: block;
      width: 100%;
      background: var(--text-display);
      animation: pulse 1.1s ease-in-out infinite alternate;
      transform-origin: bottom;
    }

    .preview-copy {
      font-size: 14px;
      line-height: 1.55;
      color: var(--text-secondary);
    }

    @keyframes pulse {
      from {
        transform: scaleY(0.15);
        opacity: 0.35;
      }
      to {
        transform: scaleY(1);
        opacity: 1;
      }
    }
  </style>
}
