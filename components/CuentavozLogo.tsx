export function CuentavozLogo({
  size = 40,
  className = "",
}: {
  size?: number;
  className?: string;
}) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 100 100"
      fill="none"
      className={className}
      aria-hidden="true"
    >
      <defs>
        <linearGradient id="cuentavozLogoBg" x1="12" y1="8" x2="86" y2="94" gradientUnits="userSpaceOnUse">
          <stop stopColor="#17152B" />
          <stop offset="0.55" stopColor="#302253" />
          <stop offset="1" stopColor="#3A5F4C" />
        </linearGradient>
        <linearGradient id="cuentavozLogoFox" x1="32" y1="30" x2="67" y2="70" gradientUnits="userSpaceOnUse">
          <stop stopColor="#F7BF68" />
          <stop offset="1" stopColor="#B85F36" />
        </linearGradient>
        <linearGradient id="cuentavozLogoPage" x1="18" y1="65" x2="81" y2="88" gradientUnits="userSpaceOnUse"><stop stopColor="#FFF8E8" /><stop offset="1" stopColor="#E9B253" /></linearGradient>
        <filter id="cuentavozLogoGlow" x="-30%" y="-30%" width="160%" height="160%"><feGaussianBlur stdDeviation="2.5" result="blur" /><feMerge><feMergeNode in="blur" /><feMergeNode in="SourceGraphic" /></feMerge></filter>
      </defs>
      <rect x="4" y="4" width="92" height="92" rx="30" fill="url(#cuentavozLogoBg)" />
      <rect x="6.5" y="6.5" width="87" height="87" rx="27.5" stroke="#F0C078" strokeOpacity=".32" strokeWidth="2" />
      <circle cx="50" cy="48" r="30" fill="#8A6BAE" opacity=".14" filter="url(#cuentavozLogoGlow)" />
      <path d="M27 60C33 54 42 54 50 61C58 54 67 54 73 60V80C65 74 57 74 50 81C43 74 35 74 27 80V60Z" fill="url(#cuentavozLogoPage)" />
      <path d="M50 61V81M32 62C38 59 44 60 48 64M68 62C62 59 56 60 52 64" stroke="#AA6A4C" strokeWidth="1.8" strokeLinecap="round" opacity=".65" />
      <path d="M30 49L35 29L45 39M70 49L65 29L55 39" fill="#B85F36" />
      <path d="M33.5 42L36 34L41 40M66.5 42L64 34L59 40" fill="#F7D69D" />
      <path d="M31 48C31 35 39 27 50 27C61 27 69 35 69 48C69 61 61 69 50 69C39 69 31 61 31 48Z" fill="url(#cuentavozLogoFox)" />
      <path d="M38 57C41.5 67 58.5 67 62 57C58 53 54 52 50 55C46 52 42 53 38 57Z" fill="#FFF2D7" />
      <ellipse cx="43.5" cy="47.5" rx="3.4" ry="3.8" fill="#17152B" /><ellipse cx="56.5" cy="47.5" rx="3.4" ry="3.8" fill="#17152B" />
      <circle cx="44.6" cy="46.3" r="1" fill="#FFF8E8" /><circle cx="57.6" cy="46.3" r="1" fill="#FFF8E8" />
      <path d="M50 55.5C52.4 55.5 52.2 58.8 50 58.8C47.8 58.8 47.6 55.5 50 55.5Z" fill="#17152B" />
      <g fill="none" strokeLinecap="round"><path d="M25 46C17 51 17 61 25 66" stroke="#8FB4A0" strokeWidth="4" /><path d="M18 42C7 50 7 63 18 71" stroke="#B9D1C4" strokeWidth="2.6" opacity=".9" /><path d="M75 46C83 51 83 61 75 66" stroke="#8FB4A0" strokeWidth="4" /><path d="M82 42C93 50 93 63 82 71" stroke="#B9D1C4" strokeWidth="2.6" opacity=".9" /></g>
      <path d="M75 16L77.2 21.1L82.3 23.3L77.2 25.5L75 30.6L72.8 25.5L67.7 23.3L72.8 21.1L75 16Z" fill="#F0C078" filter="url(#cuentavozLogoGlow)" />
      <circle cx="25" cy="23" r="2.2" fill="#F0C078" />
    </svg>
  );
}
