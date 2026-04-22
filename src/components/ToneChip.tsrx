type Props = {
  label: string;
  className?: string;
  muted?: boolean;
};

export default component ToneChip(&{ label, className, muted = false }: Props) {
  <span class={`chip ${muted ? 'muted' : ''} ${className ?? ''}`}>
    <span class="chip-dot" aria-hidden="true" />
    {label}
  </span>

  <style>
    .chip {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 6px 12px;
      border: 1px solid var(--border-visible);
      font-family: var(--font-mono);
      font-size: 11px;
      letter-spacing: 0.14em;
      text-transform: uppercase;
      color: var(--text-primary);
      white-space: nowrap;
      line-height: 1.2;
      min-height: 28px;
    }

    .chip-dot {
      width: 4px;
      height: 4px;
      border-radius: 999px;
      background: currentColor;
      opacity: 0.8;
    }

    .muted {
      color: var(--text-disabled);
      border-color: var(--border);
    }
  </style>
}
