import Link from "next/link";
import { UserButton } from "@clerk/nextjs";
import { Medallon } from "@/components/Medallon";
import { ThemeToggle } from "@/components/ThemeToggle";

const ITEMS = [
  { href: "#inicio", icono: "⌂", etiqueta: "Inicio", activo: true },
  { href: "#escuchados", icono: "▶", etiqueta: "Seguir leyendo" },
  { href: "#biblioteca", icono: "▤", etiqueta: "Biblioteca" },
  { href: "#protagonistas", icono: "✦", etiqueta: "Protagonistas" },
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
    <aside className="sticky top-0 hidden h-[100dvh] w-[248px] shrink-0 flex-col overflow-y-auto border-r border-[#D8C6A8]/55 bg-[#F7EEDC] px-5 py-7 shadow-[12px_0_40px_rgba(76,50,30,0.04)] dark:border-white/5 dark:bg-[#0B0A17] md:flex">
      <Link href="/dashboard" className="flex items-center gap-3 rounded-2xl px-2 py-1 focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-oro-300/30">
        <Medallon size={42} />
        <div>
          <p className="font-display text-xl italic leading-tight text-tinta-900 dark:text-pergamino-50">
            Cuentavoz
          </p>
          <p className="mt-0.5 font-mono text-[8px] font-semibold uppercase tracking-[0.13em] text-tinta-900/40 dark:text-pergamino-50/40">
            Biblioteca familiar
          </p>
        </div>
      </Link>

      <div className="mx-2 mt-8 h-px bg-gradient-to-r from-transparent via-oro-600/25 to-transparent" />
      <p className="mb-3 mt-8 px-3 font-mono text-[9px] font-bold uppercase tracking-[0.18em] text-tinta-900/35 dark:text-pergamino-50/30">Esta noche</p>
      <nav className="flex flex-1 flex-col gap-1.5">
        {ITEMS.map((item) => (
          <a
            key={item.etiqueta}
            href={item.href}
            className={`group flex items-center gap-3 rounded-2xl px-3 py-3 text-sm font-semibold transition focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-oro-300/25 ${
              item.activo
                ? "bg-tinta-950 text-pergamino-50 shadow-[0_10px_24px_rgba(20,18,36,0.14)] dark:bg-oro-400 dark:text-tinta-950"
                : "text-tinta-900/55 hover:bg-white/70 hover:text-tinta-900 dark:text-pergamino-50/50 dark:hover:bg-white/5 dark:hover:text-pergamino-50"
            }`}
          >
            <span aria-hidden className={`flex h-7 w-7 items-center justify-center rounded-xl text-sm ${item.activo ? "bg-white/10 dark:bg-tinta-950/10" : "bg-white/55 group-hover:bg-white dark:bg-white/5"}`}>{item.icono}</span>
            {item.etiqueta}
          </a>
        ))}
      </nav>

      <div className="mt-6 flex flex-col gap-3">
        <div className="flex items-center justify-between px-2">
          <span className="text-[10px] font-semibold text-tinta-900/40 dark:text-pergamino-50/35">Apariencia</span>
          <ThemeToggle />
        </div>
        <div className="flex items-center gap-3 rounded-2xl border border-[#D8C6A8]/60 bg-white/65 p-2.5 shadow-sm dark:border-white/10 dark:bg-white/5">
          <UserButton afterSignOutUrl="/" />
          <span className="truncate text-sm font-medium text-tinta-900 dark:text-pergamino-50">
            {nombreFamilia}
          </span>
        </div>
      </div>
    </aside>
  );
}
