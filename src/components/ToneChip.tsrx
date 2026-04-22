type Props = {
  label: string;
  className?: string;
  muted?: boolean;
};

export default component ToneChip(&{ label, className, muted = false }: Props) {
  <span class={`tone-chip ${muted ? 'muted' : ''} ${className ?? ''}`}>
    {label}
  </span>

  <style>
    .tone-chip {
      display: inline-flex;
      align-items: center;
      gap: 0.4rem;
      min-height: 2rem;
      padding: 0.45rem 0.8rem;
      border-radius: 999px;
      border: 1px solid rgba(255, 255, 255, 0.14);
      background:
        linear-gradient(180deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0.04)),
        rgba(7, 10, 18, 0.8);
      color: rgba(236, 239, 255, 0.92);
      font-size: 0.75rem;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      white-space: nowrap;
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.06);
    }

    .muted {
      opacity: 0.72;
    }
  </style>
}
