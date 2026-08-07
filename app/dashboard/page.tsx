import Link from "next/link";
import { auth } from "@clerk/nextjs/server";
import { UserButton } from "@clerk/nextjs";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { AppHeader } from "@/components/AppHeader";
import { LibroVolador } from "@/components/LibroVolador";
import { EsquinaDoblada, estiloDoblez } from "@/components/EsquinaDoblada";
import { estimarMinutosLectura } from "@/lib/texto/tiempoLectura";

const TONOS = ["oro", "esmeralda", "ciruela"] as const;
type Tono = (typeof TONOS)[number];

// Placeholder de portada cuando el cuento no tiene imagen todavía.
const FONDO_PORTADA: Record<Tono, string> = {
  oro: "from-oro-300 via-oro-400 to-oro-600",
  esmeralda: "from-esmeralda-300 via-esmeralda-400 to-esmeralda-600",
  ciruela: "from-ciruela-300 via-ciruela-400 to-ciruela-600",
};

// La cinta washi que "sostiene" cada postal en el corcho.
const CINTA: Record<Tono, string> = {
  oro: "bg-oro-300/80",
  esmeralda: "bg-esmeralda-300/80",
  ciruela: "bg-ciruela-300/70",
};

// Tailwind no puede detectar clases armadas con template strings
// (ej. `bg-${tono}-500`), así que el puntito de edad usa este mapa
// estático en vez de interpolar el nombre de la clase.
const PUNTO_EDAD: Record<Tono, string> = {
  oro: "bg-oro-500",
  esmeralda: "bg-esmeralda-500",
  ciruela: "bg-ciruela-600",
};

// Ligera rotación por índice -- así el estante se ve como cosas puestas
// a mano sobre un corcho, no como una cuadrícula perfecta.
const ROTACIONES = ["-rotate-2", "rotate-1", "rotate-2", "-rotate-1"];

export default async function DashboardPage() {
  const { userId } = auth();
  const supabase = createServiceRoleClient();

  // El webhook de Clerk (app/api/webhooks/clerk) ya debería haber creado
  // la familia. Este fallback la crea si por algo llegó primero el login
  // que el webhook (útil también en desarrollo local sin webhook configurado).
  let { data: family } = await supabase
    .from("families")
    .select("*")
    .eq("clerk_user_id", userId!)
    .maybeSingle();

  if (!family) {
    const { data: nuevaFamilia } = await supabase
      .from("families")
      .insert({ clerk_user_id: userId!, plan: "free" })
      .select()
      .single();
    family = nuevaFamilia;
  }

  const { data: hijos } = await supabase
    .from("children_profiles")
    .select("*")
    .eq("family_id", family!.id);

  const { data: cuentos } = await supabase
    .from("stories")
    .select("id, titulo, edad_recomendada, portada_url")
    .limit(10);

  const { data: bloquesParaTiempo } = cuentos && cuentos.length > 0
    ? await supabase
        .from("story_blocks")
        .select("story_id, texto_bloque")
        .in("story_id", cuentos.map((c) => c.id))
    : { data: null };

  const minutosPorCuento = new Map<string, number>();
  for (const c of cuentos ?? []) {
    const bloques = (bloquesParaTiempo ?? []).filter((b) => b.story_id === c.id);
    minutosPorCuento.set(c.id, estimarMinutosLectura(bloques));
  }

  const espaciosFantasma =
    cuentos && cuentos.length > 0 ? Math.max(0, 4 - cuentos.length) : 0;

  const esPremium = family?.plan === "premium";

  return (
    <div className="min-h-screen bg-pergamino-50 dark:bg-tinta-950">
      {/* Encabezado normal, sobre papel -- ya no es una portada de
          pantalla completa. Abrir el dashboard debe sentirse como abrir
          el cuaderno de la familia a plena luz del día, no como cruzar
          la puerta de una biblioteca de noche. */}
      <AppHeader href="/dashboard">
        <UserButton afterSignOutUrl="/" />
      </AppHeader>

      <main className="mx-auto max-w-5xl px-6 pb-24 pt-10 sm:px-8">
        {/* ---------- Portada del cuaderno ---------- */}
        <section className="relative mb-14 overflow-hidden rounded-[28px] border border-pergamino-200 bg-white px-7 py-9 dark:border-tinta-700 dark:bg-tinta-900 sm:px-10 sm:py-11">
          <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(212,162,76,0.14),transparent_55%)]" />
          <LibroVolador
            size={46}
            variante="esmeralda"
            className="pointer-events-none absolute right-8 top-8 opacity-70 sm:right-14"
          />

          <div className="relative flex flex-col gap-6 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <span className="font-mono text-[11px] uppercase tracking-[0.16em] text-esmeralda-600 dark:text-esmeralda-300">
                Bitácora de la familia
              </span>
              <h1 className="mt-2 max-w-md font-display text-4xl italic leading-tight text-tinta-900 dark:text-pergamino-50 sm:text-5xl">
                Hoy también los espera una aventura.
              </h1>
              {!esPremium && (
                <Link
                  href="/precios"
                  className="mt-4 inline-block font-display text-sm italic text-tinta-900/60 underline decoration-oro-400 decoration-1 underline-offset-4 transition hover:text-oro-600 dark:text-pergamino-50/60 dark:hover:text-oro-300"
                >
                  Ver la biblioteca completa desde $19.900/mes →
                </Link>
              )}
            </div>

            {/* Sello de plan, como un timbre de pasaporte */}
            <div
              className={`flex h-24 w-24 shrink-0 -rotate-6 flex-col items-center justify-center rounded-full border-[3px] border-dashed text-center font-mono text-[10px] uppercase leading-tight tracking-wide ${
                esPremium
                  ? "border-oro-500 text-oro-600 dark:border-oro-400 dark:text-oro-300"
                  : "border-esmeralda-500 text-esmeralda-600 dark:border-esmeralda-400 dark:text-esmeralda-300"
              }`}
            >
              <span>Plan</span>
              <span className="text-sm not-italic">{esPremium ? "Familia" : "Gratis"}</span>
              {!esPremium && <span className="mt-0.5 text-[8px] opacity-70">2-3 cuentos</span>}
            </div>
          </div>
        </section>

        {/* ---------- Protagonistas ---------- */}
        <section className="mb-16">
          <PestanaCarpeta color="ciruela">Protagonistas</PestanaCarpeta>

          {hijos && hijos.length > 0 ? (
            <ul className="flex flex-wrap gap-5 rounded-[24px] border border-pergamino-200 bg-pergamino-100/50 p-6 dark:border-tinta-700 dark:bg-tinta-900/40">
              {hijos.map((h, i) => (
                <li
                  key={h.id}
                  className={`relative w-40 rounded-xl border border-pergamino-200 bg-white px-4 pb-4 pt-6 text-center shadow-[0_8px_18px_-8px_rgba(42,36,56,0.3)] dark:border-tinta-600 dark:bg-tinta-800 ${
                    ROTACIONES[i % ROTACIONES.length]
                  }`}
                >
                  <span
                    className={`absolute -top-2.5 left-1/2 h-5 w-14 -translate-x-1/2 rotate-[-3deg] ${
                      CINTA[TONOS[i % TONOS.length]]
                    }`}
                    style={{ clipPath: "polygon(0 0,100% 0,94% 100%,6% 100%)" }}
                  />
                  <span className="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-oro-300 font-display text-lg font-semibold text-white dark:bg-oro-500">
                    {h.nombre.charAt(0).toUpperCase()}
                  </span>
                  <p className="mt-3 font-display italic text-tinta-900 dark:text-pergamino-50">
                    {h.nombre}
                  </p>
                  {h.edad && (
                    <span className="mt-1 inline-block font-mono text-[10px] uppercase tracking-wide text-tinta-900/50 dark:text-pergamino-50/50">
                      {h.edad} años
                    </span>
                  )}
                </li>
              ))}
            </ul>
          ) : (
            <div
              className="relative flex flex-col items-center gap-4 rounded-[24px] border border-dashed border-pergamino-300 bg-white/60 px-6 py-9 text-center dark:border-tinta-600 dark:bg-tinta-800/40 sm:flex-row sm:text-left"
              style={estiloDoblez(20)}
            >
              <EsquinaDoblada size={20} />
              <LibroVolador size={64} variante="oro" />
              <div>
                <p className="font-display text-lg italic text-tinta-900 dark:text-pergamino-50">
                  Todavía nadie protagoniza un cuento aquí.
                </p>
                <p className="mt-1 text-sm text-tinta-900/60 dark:text-pergamino-50/60">
                  Agrega el nombre de tu hijo o hija para que aparezca dentro
                  de sus propias historias.
                </p>
              </div>
            </div>
          )}
        </section>

        {/* ---------- La biblioteca, como un corcho de postales ---------- */}
        <section>
          <PestanaCarpeta color="esmeralda">La biblioteca</PestanaCarpeta>

          {cuentos && cuentos.length > 0 ? (
            <div className="rounded-[24px] border border-pergamino-200 bg-[radial-gradient(circle,rgba(42,36,56,0.06)_1px,transparent_1px)] bg-[length:14px_14px] p-6 dark:border-tinta-700 dark:bg-tinta-900/20 sm:p-8">
              <div className="grid grid-cols-2 gap-x-5 gap-y-9 sm:grid-cols-3 md:grid-cols-4">
                {cuentos.map((c, i) => {
                  const tono = TONOS[i % TONOS.length];
                  return (
                    <Link
                      key={c.id}
                      href={`/story/${c.id}`}
                      className={`group relative block rounded-lg border border-pergamino-200 bg-white p-2 pb-3 shadow-[0_10px_22px_-10px_rgba(42,36,56,0.35)] transition-all duration-300 hover:-translate-y-1.5 hover:rotate-0 hover:shadow-[0_16px_28px_-10px_rgba(42,36,56,0.4)] dark:border-tinta-600 dark:bg-tinta-800 ${
                        ROTACIONES[i % ROTACIONES.length]
                      }`}
                    >
                      <span
                        className={`absolute -top-2.5 left-1/2 h-5 w-14 -translate-x-1/2 rotate-[-3deg] ${CINTA[tono]}`}
                        style={{ clipPath: "polygon(0 0,100% 0,94% 100%,6% 100%)" }}
                      />

                      <div className="relative aspect-[4/5] overflow-hidden rounded-md">
                        {c.portada_url ? (
                          // eslint-disable-next-line @next/next/no-img-element
                          <img
                            src={c.portada_url}
                            alt=""
                            className="absolute inset-0 h-full w-full object-cover transition duration-300 group-hover:scale-105"
                          />
                        ) : (
                          <div
                            className={`absolute inset-0 flex items-center justify-center bg-gradient-to-br transition duration-300 group-hover:scale-105 ${FONDO_PORTADA[tono]}`}
                          >
                            <LibroVolador size={40} variante={tono} className="opacity-90" />
                          </div>
                        )}
                        <EsquinaDoblada
                          size={14}
                          className="opacity-0 transition group-hover:opacity-100"
                        />
                      </div>

                      <p className="mt-2 truncate font-display italic text-sm font-semibold text-tinta-900 dark:text-pergamino-50">
                        {c.titulo}
                      </p>
                      <span className="mt-0.5 inline-flex items-center gap-1.5 font-mono text-[9px] uppercase tracking-wide text-tinta-900/45 dark:text-pergamino-50/45">
                        <span className={`h-1 w-1 rounded-full ${PUNTO_EDAD[tono]}`} />
                        {c.edad_recomendada}
                        {minutosPorCuento.get(c.id) ? (
                          <>
                            <span aria-hidden>·</span>
                            {minutosPorCuento.get(c.id)} min
                          </>
                        ) : null}
                      </span>
                    </Link>
                  );
                })}

                {Array.from({ length: espaciosFantasma }).map((_, i) => (
                  <div
                    key={`fantasma-${i}`}
                    className="flex aspect-[4/5] flex-col items-center justify-center gap-2 rounded-lg border border-dashed border-pergamino-300 bg-white/40 p-4 text-center dark:border-tinta-700 dark:bg-tinta-900/30"
                  >
                    <span className="text-2xl opacity-40">✎</span>
                    <p className="font-mono text-[9px] uppercase tracking-wide text-tinta-900/40 dark:text-pergamino-50/40">
                      Muy pronto
                    </p>
                  </div>
                ))}
              </div>
            </div>
          ) : (
            <div
              className="relative flex flex-col items-center gap-4 rounded-[24px] border border-dashed border-pergamino-300 bg-white/60 px-6 py-10 text-center dark:border-tinta-600 dark:bg-tinta-800/40"
              style={estiloDoblez(20)}
            >
              <EsquinaDoblada size={20} />
              <LibroVolador size={80} variante="esmeralda" aletear />
              <div>
                <p className="font-display text-lg italic text-tinta-900 dark:text-pergamino-50">
                  El corcho está listo, pero todavía en blanco.
                </p>
                <p className="mt-1 text-sm text-tinta-900/60 dark:text-pergamino-50/60">
                  Corre el seed de supabase/schema.sql para cargar el primer
                  cuento.
                </p>
              </div>
            </div>
          )}
        </section>
      </main>
    </div>
  );
}

/**
 * Etiqueta de sección con forma de pestaña de carpeta -- reemplaza los
 * folios tipo "Página 1/2" de la versión anterior. Aquí la metáfora ya
 * no es "pasar la página" sino "abrir la pestaña del cuaderno".
 */
function PestanaCarpeta({
  color,
  children,
}: {
  color: Tono;
  children: React.ReactNode;
}) {
  const fondo: Record<Tono, string> = {
    oro: "bg-oro-500",
    esmeralda: "bg-esmeralda-500",
    ciruela: "bg-ciruela-600",
  };
  return (
    <div className="mb-5 flex">
      <span
        className={`-rotate-1 rounded-t-lg px-4 py-2 font-mono text-[11px] uppercase tracking-wide text-white shadow-sm ${fondo[color]}`}
      >
        {children}
      </span>
    </div>
  );
}