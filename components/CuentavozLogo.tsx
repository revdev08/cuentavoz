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
      viewBox="0 0 64 64"
      fill="none"
      className={className}
      aria-hidden="true"
    >
      <defs>
        <linearGradient id="cuentavozLogoBg" x1="8" y1="6" x2="57" y2="60" gradientUnits="userSpaceOnUse">
          <stop stopColor="#8A6BAE" />
          <stop offset="1" stopColor="#4C7A63" />
        </linearGradient>
        <linearGradient id="cuentavozLogoPage" x1="18" y1="31" x2="47" y2="53" gradientUnits="userSpaceOnUse">
          <stop stopColor="#FFF8E8" />
          <stop offset="1" stopColor="#F0C078" />
        </linearGradient>
      </defs>
      <rect x="4" y="4" width="56" height="56" rx="18" fill="url(#cuentavozLogoBg)" />
      <path d="M10 18C14 13 19 10 26 9" stroke="#F0C078" strokeWidth="1.5" strokeLinecap="round" opacity=".7" />
      <path d="M37 9C45 10 51 15 54 22" stroke="#F0C078" strokeWidth="1.5" strokeLinecap="round" opacity=".7" />
      <path d="M19 34.5C23.8 31.1 28.3 31.3 32 35.5V49C28.2 45.4 23.8 45.3 19 48.5V34.5Z" fill="url(#cuentavozLogoPage)" />
      <path d="M45 34.5C40.2 31.1 35.7 31.3 32 35.5V49C35.8 45.4 40.2 45.3 45 48.5V34.5Z" fill="url(#cuentavozLogoPage)" />
      <path d="M22.5 37.5C25.3 35.7 27.8 35.7 30 37.5M41.5 37.5C38.7 35.7 36.2 35.7 34 37.5" stroke="#8A6BAE" strokeWidth="1.2" strokeLinecap="round" opacity=".75" />
      <circle cx="32" cy="23" r="4.3" fill="#FFF8E8" />
      <path d="M32 18.7V16M36.3 20.8L38.4 19.2M27.7 20.8L25.6 19.2" stroke="#F0C078" strokeWidth="1.7" strokeLinecap="round" />
      <path d="M24.8 26.2C21.1 28.6 21.1 33 24.8 35.4M39.2 26.2C42.9 28.6 42.9 33 39.2 35.4" stroke="#FFF8E8" strokeWidth="2" strokeLinecap="round" />
      <path d="M20 23.2C14.7 26.8 14.7 34.8 20 38.3M44 23.2C49.3 26.8 49.3 34.8 44 38.3" stroke="#F0C078" strokeWidth="1.5" strokeLinecap="round" opacity=".8" />
      <path d="M51 12.5L52.1 15.1L54.7 16.2L52.1 17.3L51 19.9L49.9 17.3L47.3 16.2L49.9 15.1L51 12.5Z" fill="#FFF8E8" />
    </svg>
  );
}
