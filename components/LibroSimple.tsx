export function LibroSimple({
  size = 60,
  colorIzq,
  colorDer,
  className = "",
  style,
}: {
  size?: number;
  colorIzq: string;
  colorDer: string;
  className?: string;
  style?: React.CSSProperties;
}) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" className={className} style={style} aria-hidden>
      <path d="M3 4c3-1.5 6-1.5 9 0v16c-3-1.5-6-1.5-9 0V4z" fill={colorIzq} opacity="0.85" />
      <path d="M21 4c-3-1.5-6-1.5-9 0v16c3-1.5 6-1.5 9 0V4z" fill={colorDer} opacity="0.7" />
    </svg>
  );
}
