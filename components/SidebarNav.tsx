import Link from "next/link";
import { UserButton } from "@clerk/nextjs";
import { Medallon } from "@/components/Medallon";
import { ThemeToggle } from "@/components/ThemeToggle";

const ITEMS = [
  { href: "#inicio", icono: "🏠", etiqueta: "Inicio", activo: true },
  { href: "#biblioteca", icono: "📚", etiqueta: "Biblioteca" },
  { href: "#escuchados", icono: "🎧", etiqueta: "Escuchados" },
  { href: "#biblioteca", icono: "❤️", etiqueta: "Favoritos" },
  { href: "#protagonistas", icono: "👥", etiqueta: "Protagonistas" },
];

/**
 * Sidebar fijo del dashboard. Todos los items apuntan a anclas dentro de
 * la misma página -- por ahora solo "Inicio" (el dashboard) existe como
 * página real; Biblioteca/Escuchados/Protagonistas ya son secciones
 * reales de esta misma página (por eso el ancla funciona de verdad, no
 * es un link muerto). Favoritos comparte la sección de Biblioteca,
 * donde los corazones ya son visibles y tocables.
 */
export function SidebarNav({ nombreFamilia }: { nombreFamilia: string }) {
  return (
    <aside className="sticky top-0 h-[100dvh] overflow-y-auto hidden w-64 shrink-0 flex-col border-r border-pergamino-200 bg-white px-5 py-8 dark:border-tinta-800/50 dark:bg-[#0B0A17] md:flex">
      <Link href="/dashboard" className="flex items-center gap-2.5 px-2">
        <Medallon size={38} />
        <div>
          <p className="font-display text-xl italic leading-tight text-tinta-900 dark:text-pergamino-50">
            Cuentavoz
          </p>
          <p className="text-[10px] leading-tight text-tinta-900/50 dark:text-pergamino-50/45">
            Historias que se escuchan,
            <br />
            recuerdos que perduran.
          </p>
        </div>
      </Link>

      <nav className="mt-12 flex flex-1 flex-col gap-2">
        {ITEMS.map((item) => (
          <a
            key={item.etiqueta}
            href={item.href}
            className={`flex items-center gap-3 rounded-2xl px-4 py-3 text-sm font-medium transition ${
              item.activo
                ? "border border-oro-500 bg-oro-500/5 text-oro-700 shadow-[0_0_15px_rgba(231,162,61,0.15)] dark:text-oro-300"
                : "border border-transparent text-tinta-900/60 hover:bg-pergamino-100 hover:text-tinta-900 dark:text-pergamino-50/55 dark:hover:bg-tinta-800/50 dark:hover:text-pergamino-50"
            }`}
          >
            <span aria-hidden className="text-lg">{item.icono}</span>
            {item.etiqueta}
          </a>
        ))}
      </nav>

      <div className="mt-6 flex flex-col gap-4">
        <div className="flex items-center justify-between">
          <ThemeToggle />
        </div>
        <div className="flex items-center gap-3 rounded-2xl border border-pergamino-200 bg-pergamino-50 p-2 dark:border-tinta-800/50 dark:bg-tinta-900/30">
          <UserButton afterSignOutUrl="/" />
          <span className="truncate text-sm font-medium text-tinta-900 dark:text-pergamino-50">
            {nombreFamilia}
          </span>
        </div>
      </div>
    </aside>
  );
}
