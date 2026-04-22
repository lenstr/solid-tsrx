type Props = {
  cycle: number;
};

export default component AsyncPreview(&{ cycle }: Props) {
  const stagger = (index: number) => ({
    'animation-delay': `${index * 120}ms`,
  });

  <div class="async-preview">
    <div class="preview-head">
      <p>{'Lazy module online'}</p>
      <strong>{`cycle #${cycle}`}</strong>
    </div>

    <div class="wave-grid" aria-hidden="true">
      for (const slot of [0, 1, 2, 3, 4, 5]; index i; key `${cycle}-${slot}`) {
        <span class="wave" style={stagger(i)} />
      }
    </div>

    <p class="preview-copy">
      {'Этот блок приехал через lazy() + try/pending. Для Solid target это ровно та фича, ради которой нужен Solid 2 beta.'}
    </p>
  </div>

  <style>
    .async-preview {
      display: grid;
      gap: 1rem;
      padding: 1rem;
      border-radius: 1rem;
      border: 1px solid rgba(255, 255, 255, 0.08);
      background:
        radial-gradient(circle at top right, rgba(112, 255, 217, 0.16), transparent 34%),
        linear-gradient(180deg, rgba(9, 18, 27, 0.98), rgba(5, 11, 18, 0.92));
    }

    .preview-head {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1rem;
      flex-wrap: wrap;
    }

    .preview-head p,
    .preview-copy {
      margin: 0;
    }

    .preview-head p {
      color: rgba(190, 255, 237, 0.74);
      text-transform: uppercase;
      letter-spacing: 0.16em;
      font-size: 0.78rem;
    }

    .preview-head strong {
      color: #c8fff0;
      font-size: 1rem;
    }

    .wave-grid {
      display: grid;
      grid-template-columns: repeat(6, minmax(0, 1fr));
      gap: 0.7rem;
      align-items: end;
      min-height: 4.2rem;
    }

    .wave {
      display: block;
      min-height: 1.2rem;
      border-radius: 999px;
      background: linear-gradient(180deg, #67f4c9, #57a7ff);
      box-shadow: 0 0 0.75rem rgba(103, 244, 201, 0.32);
      animation: rise 1.2s ease-in-out infinite alternate;
      transform-origin: bottom center;
    }

    .preview-copy {
      color: rgba(220, 244, 255, 0.76);
      line-height: 1.55;
    }

    @keyframes rise {
      from {
        transform: scaleY(0.35);
        opacity: 0.45;
      }

      to {
        transform: scaleY(1);
        opacity: 1;
      }
    }
  </style>
}
