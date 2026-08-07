const TONOS = {
  oro: { tapaIzq: "#D4A24C", tapaDer: "#EFC873", lomo: "#9C6F22" },
  esmeralda: { tapaIzq: "#2EB894", tapaDer: "#8FE3CB", lomo: "#1D7A63" },
  ciruela: { tapaIzq: "#6A4C8C", tapaDer: "#8A6BAE", lomo: "#4A3468" },
} as const;

/**
 * Un libro abierto volando como si sus páginas fueran alas, con una
 * estela de chispas. Es el motivo central de "biblioteca mágica": no es
 * decoración abstracta, es literalmente lo que la marca quiere evocar.
 */
export function LibroVolador({
  size = 90,
  variante = "oro",
  aletear = false,
  className = "",
  style,
}: {
  size?: number;
  variante?: keyof typeof TONOS;
  aletear?: boolean;
  className?: string;
  style?: React.CSSProperties;
}) {
  const c = TONOS[variante];

  return (
    <svg
      width={size}
      height={(size * 100) / 140}
      viewBox="0 0 140 100"
      className={className}
      style={style}
      aria-hidden="true"
    >
      <g className={aletear ? "ala-izq" : ""} style={{ transformOrigin: "70px 34px" }}>
        <path d="M70 20 C 42 4, 10 12, 3 44 C 10 60, 42 59, 70 48 Z" fill={c.tapaIzq} />
        <path
          d="M70 24 C 46 11, 20 18, 13 43 C 20 53, 46 53, 70 45 Z"
          fill="#FCF6EA"
          opacity="0.92"
        />
        <path d="M22 30 C 34 25, 50 27, 62 32" stroke={c.lomo} strokeWidth="1.4" fill="none" opacity="0.35" />
        <path d="M20 38 C 33 34, 50 35, 62 39" stroke={c.lomo} strokeWidth="1.4" fill="none" opacity="0.35" />
      </g>
      <g className={aletear ? "ala-der" : ""} style={{ transformOrigin: "70px 34px" }}>
        <path d="M70 20 C 98 4, 130 12, 137 44 C 130 60, 98 59, 70 48 Z" fill={c.tapaDer} />
        <path
          d="M70 24 C 94 11, 120 18, 127 43 C 120 53, 94 53, 70 45 Z"
          fill="#FCF6EA"
          opacity="0.92"
        />
        <path d="M118 30 C 106 25, 90 27, 78 32" stroke={c.lomo} strokeWidth="1.4" fill="none" opacity="0.35" />
        <path d="M120 38 C 107 34, 90 35, 78 39" stroke={c.lomo} strokeWidth="1.4" fill="none" opacity="0.35" />
      </g>
      <rect x="66" y="16" width="8" height="36" rx="3" fill={c.lomo} />
      <g fill={c.tapaDer}>
        <path d="M18 62 l3 8 8 3 -8 3 -3 8 -3 -8 -8 -3 8 -3 Z" opacity="0.85" />
        <circle cx="4" cy="80" r="2.5" opacity="0.7" />
        <circle cx="34" cy="86" r="1.8" opacity="0.6" />
      </g>
    </svg>
  );
}
