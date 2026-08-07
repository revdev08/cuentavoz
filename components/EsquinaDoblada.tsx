/**
 * El doblez de esquina que ya usa el lector de cuentos, reutilizable en
 * cualquier superficie que quiera leerse como "una página" (tarjetas,
 * paneles). Va de la mano con estiloDoblez, que recorta el contenedor
 * padre para que el doblez encaje.
 */
export function estiloDoblez(size = 22): React.CSSProperties {
  return {
    clipPath: `polygon(0 0, calc(100% - ${size}px) 0, 100% ${size}px, 100% 100%, 0 100%)`,
  };
}

export function EsquinaDoblada({
  size = 22,
  className = "",
}: {
  size?: number;
  className?: string;
}) {
  return (
    <div
      aria-hidden
      className={`pointer-events-none absolute right-0 top-0 bg-gradient-to-br from-oro-300/60 to-transparent ${className}`}
      style={{
        width: size,
        height: size,
        clipPath: "polygon(100% 0, 0 0, 100% 100%)",
      }}
    />
  );
}
