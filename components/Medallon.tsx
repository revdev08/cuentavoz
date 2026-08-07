export function Medallon({
  size = 40,
  className = "",
  animado = false,
}: {
  size?: number;
  className?: string;
  animado?: boolean;
}) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 100 100"
      className={`${animado ? "medallon-brillo" : ""} ${className}`}
      aria-hidden="true"
    >
      <defs>
        <radialGradient id="medallonOro" cx="50%" cy="38%" r="70%">
          <stop offset="0%" stopColor="#F4E8D2" />
          <stop offset="100%" stopColor="#D4A24C" />
        </radialGradient>
      </defs>

      <circle cx="50" cy="50" r="48" fill="url(#medallonOro)" />
      <circle cx="50" cy="50" r="48" fill="none" stroke="#120E1C" strokeOpacity="0.15" strokeWidth="2" />
      <circle cx="50" cy="50" r="40" fill="none" stroke="#120E1C" strokeOpacity="0.1" strokeWidth="1" />

      {/* libro abierto */}
      <path
        d="M14 68 C 28 58, 42 60, 50 68 C 58 60, 72 58, 86 68 L 86 78 C 72 69, 58 70, 50 78 C 42 70, 28 69, 14 78 Z"
        fill="#FCF6EA"
      />
      <path d="M50 68 L50 78" stroke="#9C6F22" strokeWidth="1.6" opacity="0.6" />
      <path d="M22 66 Q34 60 46 66" stroke="#9C6F22" strokeWidth="1.2" fill="none" opacity="0.4" />
      <path d="M54 66 Q66 60 78 66" stroke="#9C6F22" strokeWidth="1.2" fill="none" opacity="0.4" />

      {/* zorrito asomándose -- la mascota de Cuentavoz */}
      <g transform="translate(50,44)">
        <path d="M-24 -14 L-18 6 L-6 -2 Z" fill="#9C6F22" />
        <path d="M24 -14 L18 6 L6 -2 Z" fill="#9C6F22" />
        <path d="M-19 -8 L-15 4 L-8 -1 Z" fill="#EFC873" />
        <path d="M19 -8 L15 4 L8 -1 Z" fill="#EFC873" />
        <ellipse cx="0" cy="6" rx="19" ry="16" fill="#C1782B" />
        <path d="M-11 14 Q0 24 11 14 Q7 9 0 11 Q-7 9 -11 14 Z" fill="#FCF6EA" />
        <circle cx="-7" cy="3" r="2.6" fill="#1C1730" />
        <circle cx="7" cy="3" r="2.6" fill="#1C1730" />
        <circle cx="-6" cy="2" r="0.8" fill="#FCF6EA" />
        <circle cx="8" cy="2" r="0.8" fill="#FCF6EA" />
        <path d="M0 12 q1.5 1.5 0 3 q-1.5 -1.5 0 -3 Z" fill="#1C1730" />
      </g>

      {/* ondas de voz a los lados -- "Cuentavoz" */}
      <g stroke="#2EB894" strokeWidth="2.4" fill="none" strokeLinecap="round" opacity="0.85">
        <path d="M28 48 Q21 40 28 32" />
        <path d="M20 50 Q12 40 20 30" />
        <path d="M72 48 Q79 40 72 32" />
        <path d="M80 50 Q88 40 80 30" />
      </g>

      {/* chispas */}
      <g fill="#EFC873">
        <path d="M76 22 l3 8 8 3 -8 3 -3 8 -3 -8 -8 -3 8 -3 Z" />
        <circle cx="26" cy="18" r="2.6" />
      </g>
    </svg>
  );
}
