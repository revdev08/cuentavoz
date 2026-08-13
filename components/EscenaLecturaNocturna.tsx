/**
 * Ilustración del hero del dashboard: padre/madre e hijo leyendo juntos
 * de noche, bajo una manta-fuerte con luces cálidas. Estilo plano,
 * geométrico -- consistente con el resto de ilustraciones de la app
 * (formas simples, sin detalle fotorrealista), no una copia literal de
 * ningún mockup.
 */
export function EscenaLecturaNocturna({ className = "" }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 600 420"
      className={className}
      preserveAspectRatio="xMidYMid slice"
      aria-hidden="true"
    >
      <defs>
        <linearGradient id="cielo-noche" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor="#1B1A2E" />
          <stop offset="100%" stopColor="#241F3D" />
        </linearGradient>
        <radialGradient id="brillo-libro" cx="50%" cy="45%" r="60%">
          <stop offset="0%" stopColor="#F0C078" stopOpacity="0.55" />
          <stop offset="100%" stopColor="#F0C078" stopOpacity="0" />
        </radialGradient>
        <radialGradient id="brillo-luz" cx="50%" cy="50%" r="50%">
          <stop offset="0%" stopColor="#F0C078" stopOpacity="0.9" />
          <stop offset="100%" stopColor="#F0C078" stopOpacity="0" />
        </radialGradient>
      </defs>

      <rect width="600" height="420" fill="url(#cielo-noche)" />

      {/* estrellas */}
      {[
        [40, 40, 0.9], [90, 80, 0.5], [140, 35, 0.7], [520, 50, 0.8],
        [470, 100, 0.5], [560, 130, 0.6], [30, 140, 0.4], [200, 25, 0.5],
      ].map(([cx, cy, o], i) => (
        <circle key={i} cx={cx} cy={cy} r={1.6} fill="#FBF4E4" opacity={o} />
      ))}

      {/* luna creciente */}
      <path
        d="M 500 70 a 26 26 0 1 0 0 52 a 20 20 0 1 1 0 -52 Z"
        fill="#FBF4E4"
        opacity="0.9"
      />

      {/* manta / fuerte de tela, colgando en arco */}
      <path
        d="M -20 60 Q 300 -30 620 60 L 620 140 Q 300 60 -20 140 Z"
        fill="#8A6BAE"
        opacity="0.28"
      />
      <path
        d="M -20 80 Q 300 0 620 80 L 620 130 Q 300 60 -20 130 Z"
        fill="#6A4C8C"
        opacity="0.3"
      />

      {/* guirnalda de luces cálidas colgando del arco de tela */}
      <path
        id="curva-luces"
        d="M 10 95 Q 300 25 590 95"
        fill="none"
        stroke="none"
      />
      {[10, 90, 170, 250, 300, 350, 430, 510, 590].map((x, i) => {
        const y = 95 - Math.sin((x / 590) * Math.PI) * 62;
        return (
          <g key={i}>
            <circle cx={x} cy={y} r="9" fill="url(#brillo-luz)" />
            <circle cx={x} cy={y} r="3" fill="#F0C078" />
          </g>
        );
      })}

      {/* silueta de la montaña de cojines / suelo */}
      <path
        d="M -20 420 L -20 320 Q 150 280 300 300 Q 450 320 620 300 L 620 420 Z"
        fill="#141224"
      />

      {/* resplandor cálido general alrededor del libro */}
      <ellipse cx="300" cy="300" rx="220" ry="140" fill="url(#brillo-libro)" />

      {/* figura adulta (sentada, más grande) */}
      <g>
        <ellipse cx="205" cy="330" rx="78" ry="70" fill="#2E2850" />
        <circle cx="205" cy="245" r="34" fill="#3D3760" />
      </g>

      {/* figura del niño/a (sentada, más pequeña, apoyada en el adulto) */}
      <g>
        <ellipse cx="330" cy="345" rx="58" ry="55" fill="#8A6BAE" opacity="0.9" />
        <circle cx="330" cy="278" r="26" fill="#8A6BAE" />
      </g>

      {/* libro abierto y brillante entre los dos */}
      <g transform="translate(268,318)">
        <path d="M-42 10 Q0 -14 42 10 L42 24 Q0 4 -42 24 Z" fill="#FBF4E4" />
        <path d="M0 -3 L0 20" stroke="#C97E22" strokeWidth="1.4" opacity="0.5" />
        <ellipse cx="0" cy="6" rx="50" ry="26" fill="url(#brillo-luz)" opacity="0.6" />
      </g>

      {/* farolito apoyado al frente, como en la esquina del mockup */}
      <g transform="translate(500,330)">
        <rect x="-10" y="10" width="20" height="26" rx="3" fill="#241F3D" />
        <path d="M-12 10 L12 10 L8 -4 L-8 -4 Z" fill="#3D3760" />
        <circle cx="0" cy="10" r="16" fill="url(#brillo-luz)" />
        <circle cx="0" cy="10" r="6" fill="#F0C078" />
      </g>
    </svg>
  );
}
