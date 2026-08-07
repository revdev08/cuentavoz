import Link from "next/link";
import { Medallon } from "@/components/Medallon";
import { ThemeToggle } from "@/components/ThemeToggle";

export function AppHeader({
  href = "/",
  children,
  sobreOscuro = false,
  absoluto = false,
}: {
  href?: string;
  children?: React.ReactNode;
  /** El header se apoya sobre un fondo siempre oscuro (ej. el hero-portada
      de la landing) sin importar el tema del sitio. */
  sobreOscuro?: boolean;
  /** Posiciona el header flotando sobre el contenido en vez de empujarlo
      hacia abajo -- para heros a pantalla completa. */
  absoluto?: boolean;
}) {
  return (
    <header
      className={`${absoluto ? "absolute inset-x-0 top-0 z-30" : "relative"} flex items-center justify-between gap-3 px-6 py-5 sm:px-8`}
    >
      <Link href={href} className="flex items-center gap-2.5">
        <Medallon size={36} animado />
        <span
          className={`font-display text-lg italic ${
            sobreOscuro ? "text-pergamino-50" : "text-tinta-900 dark:text-pergamino-50"
          }`}
        >
          Cuentavoz
        </span>
      </Link>
      {/* Bandeja de vidrio: la misma idea de los botones flotantes del
          lector, aquí conteniendo las acciones en vez de dispersarlas. */}
      <div
        className={`flex items-center gap-2 rounded-full border p-1.5 backdrop-blur-md ${
          sobreOscuro
            ? "border-pergamino-50/20 bg-tinta-950/30"
            : "border-pergamino-200/70 bg-white/50 dark:border-tinta-600/70 dark:bg-tinta-800/50"
        }`}
      >
        {children}
        <ThemeToggle sobreOscuro={sobreOscuro} />
      </div>
    </header>
  );
}
