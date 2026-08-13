import Link from "next/link";
import { auth } from "@clerk/nextjs/server";
import { UserButton } from "@clerk/nextjs";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { SidebarNav } from "@/components/SidebarNav";
import { ThemeToggle } from "@/components/ThemeToggle";
import { EscenaLecturaNocturna } from "@/components/EscenaLecturaNocturna";
import { BibliotecaGrid } from "@/components/BibliotecaGrid";
import { Medallon } from "@/components/Medallon";
import { estimarMinutosLectura, formatearMinSeg } from "@/lib/texto/tiempoLectura";

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

  const [{ data: hijos }, { data: cuentos }, { data: favoritos }] = await Promise.all([
    supabase.from("children_profiles").select("*").eq("family_id", family!.id),
    supabase
      .from("stories")
      .select("id, titulo, edad_recomendada, categoria, portada_url")
      .limit(20),
    supabase.from("story_favorites").select("story_id").eq("family_id", family!.id),
  ]);

  const { data: bloquesParaTiempo } =
    cuentos && cuentos.length > 0
      ? await supabase
          .from("story_blocks")
          .select("story_id, texto_bloque")
          .in("story_id", cuentos.map((c) => c.id))
      : { data: null };

  const bloquesPorCuento = new Map<string, { texto_bloque: string }[]>();
  for (const c of cuentos ?? []) {
    bloquesPorCuento.set(
      c.id,
      (bloquesParaTiempo ?? []).filter((b) => b.story_id === c.id)
    );
  }
  const minutosPorCuento = new Map<string, number>();
  for (const c of cuentos ?? []) {
    minutosPorCuento.set(c.id, estimarMinutosLectura(bloquesPorCuento.get(c.id) ?? []));
  }

  // "Últimos escuchados": la sesión más reciente por (niño, cuento),
  // ordenada por la última vez que avanzó de bloque.
  const hijoIds = (hijos ?? []).map((h) => h.id);
  const { data: sesiones } = hijoIds.length
    ? await supabase
        .from("story_sessions")
        .select("*")
        .in("child_profile_id", hijoIds)
        .order("updated_at", { ascending: false })
        .limit(3)
    : { data: [] };

  const escuchados = (sesiones ?? [])
    .map((s) => {
      const cuento = cuentos?.find((c) => c.id === s.story_id);
      const hijo = hijos?.find((h) => h.id === s.child_profile_id);
      if (!cuento) return null;
      const totalBloques = bloquesPorCuento.get(cuento.id)?.length ?? 0;
      const minutosTotales = minutosPorCuento.get(cuento.id) ?? 0;
      const fraccion = s.completado
        ? 1
        : totalBloques > 0
          ? Math.min(1, (s.ultimo_bloque + 1) / totalBloques)
          : 0;
      return {
        sesion: s,
        cuento,
        hijo,
        minutosTotales,
        minutosTranscurridos: minutosTotales * fraccion,
        fraccion,
      };
    })
    .filter((x): x is NonNullable<typeof x> => x !== null);

  const esPremium = family?.plan === "premium";
  const nombreFamilia = family?.clerk_user_id ? "Tu familia" : "Tu familia";

  return (
    <div className="flex min-h-screen bg-pergamino-50 dark:bg-[#0B0A17]">
      <SidebarNav nombreFamilia={nombreFamilia} />

      <main className="flex-1 px-5 py-6 sm:px-8 sm:py-8 lg:px-12">
        {/* Barra superior solo en móvil -- en desktop esta info ya vive en el sidebar */}
        <div className="mb-6 flex items-center justify-between md:hidden">
          <Link href="/dashboard" className="flex items-center gap-2">
            <Medallon size={32} />
            <span className="font-display text-lg italic text-tinta-900 dark:text-pergamino-50">
              Cuentavoz
            </span>
          </Link>
          <div className="flex items-center gap-2">
            <ThemeToggle />
            <UserButton afterSignOutUrl="/" />
          </div>
        </div>

        {/* ---------- Hero: siempre con ambientación nocturna, como el hero de la landing ---------- */}
        <section
          id="inicio"
          className="relative mb-12 overflow-hidden rounded-[32px] bg-[#0B0A17] px-6 py-10 shadow-lg sm:px-12 sm:py-16 lg:py-20"
        >
          <img
            src="/images/dashboard/hero-campamento.png"
            alt="Padre e hijo leyendo en tienda"
            className="absolute inset-0 h-full w-full object-cover opacity-90"
          />
          <div className="absolute inset-0 bg-gradient-to-r from-[#0B0A17] via-[#0B0A17]/80 to-transparent" />
          <div className="absolute inset-0 bg-gradient-to-t from-[#0B0A17]/60 to-transparent" />

          <div className="relative max-w-xl">
            <div className="flex items-center gap-2 font-mono text-xs font-semibold uppercase tracking-[0.15em] text-oro-300">
              <span className="text-oro-400">✦</span>
              {hijos && hijos.length > 0
                ? `¡Bienvenido de vuelta, ${hijos[0].nombre}!`
                : "¡Bienvenido!"}
            </div>
            <h1 className="mt-4 font-display text-4xl italic leading-tight text-pergamino-50 sm:text-5xl lg:text-6xl">
              Es hora de una <br />
              <span className="text-oro-300">gran aventura</span>
            </h1>
            <p className="mt-5 text-sm text-pergamino-50/80 sm:text-base lg:text-lg">
              Disfruta cuentos narrados con amor para acompañar, inspirar y crear recuerdos.
            </p>
            <a
              href="#biblioteca"
              className="mt-8 inline-flex items-center gap-2 rounded-full bg-oro-500 px-8 py-3.5 text-sm font-semibold text-tinta-950 shadow-sm transition hover:bg-oro-400 hover:shadow-[0_0_20px_rgba(231,162,61,0.3)]"
            >
              <span className="text-lg">🎧</span> Explorar biblioteca
            </a>
            {!esPremium && (
              <Link
                href="/precios"
                className="mt-4 block font-display text-sm italic text-pergamino-50/60 underline decoration-oro-400 decoration-1 underline-offset-4 transition hover:text-oro-300"
              >
                Ver la biblioteca completa desde $19.900/mes →
              </Link>
            )}
          </div>
        </section>

        {/* ---------- Últimos escuchados ---------- */}
        <section id="escuchados" className="mb-12">
          <h2 className="mb-6 flex items-center gap-2 font-display text-2xl italic text-tinta-900 dark:text-pergamino-50">
            Últimos escuchados <span aria-hidden className="text-lg text-oro-400">✦</span>
          </h2>

          {escuchados.length > 0 ? (
            <div className="flex snap-x snap-mandatory gap-5 overflow-x-auto pb-4 scrollbar-hide">
              {escuchados.map(({ sesion, cuento, hijo, minutosTotales, minutosTranscurridos, fraccion }) => (
                <Link
                  key={sesion.id}
                  href={
                    sesion.completado
                      ? `/story/${cuento.id}`
                      : `/story/${cuento.id}?continuar=${sesion.child_profile_id}`
                  }
                  className="group relative flex w-[340px] shrink-0 snap-start items-center gap-4 overflow-hidden rounded-2xl border border-pergamino-200 bg-white p-4 shadow-sm transition hover:-translate-y-1 hover:shadow-md dark:border-tinta-800/50 dark:bg-tinta-900/40"
                >
                  <div className="relative h-20 w-28 shrink-0 overflow-hidden rounded-xl">
                    <img 
                      src={cuento.portada_url || `/images/portadas/gota-tinta.png`} 
                      className="h-full w-full object-cover transition duration-500 group-hover:scale-110" 
                      alt="" 
                    />
                    <div className="absolute inset-0 flex items-center justify-center bg-black/20">
                      <span className="flex h-8 w-8 items-center justify-center rounded-full bg-white/90 text-sm text-tinta-900 shadow-sm backdrop-blur pl-0.5">
                        ▶
                      </span>
                    </div>
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-sm font-semibold text-tinta-900 dark:text-pergamino-50">
                      {cuento.titulo}
                    </p>
                    <div className="mt-3 h-1 w-full overflow-hidden rounded-full bg-pergamino-200 dark:bg-tinta-800">
                      <div
                        className="h-full rounded-full bg-oro-400"
                        style={{ width: `${fraccion * 100}%` }}
                      />
                    </div>
                    <div className="mt-1.5 flex items-center justify-between text-[10px] font-medium text-tinta-900/50 dark:text-pergamino-50/50">
                      <span>{hijo?.nombre}</span>
                      <span>
                        {formatearMinSeg(minutosTranscurridos)} / {formatearMinSeg(minutosTotales)}
                      </span>
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          ) : (
            <p className="rounded-2xl border border-dashed border-pergamino-300 bg-white/60 px-6 py-8 text-center text-sm text-tinta-900/60 dark:border-tinta-700 dark:bg-tinta-900/30 dark:text-pergamino-50/60">
              Todavía no han empezado ningún cuento -- ¡el primero está esperando abajo!
            </p>
          )}
        </section>

        {/* ---------- Biblioteca ---------- */}
        <section id="biblioteca" className="mb-10">
          <h2 className="mb-4 flex items-center gap-2 font-display text-xl italic text-tinta-900 dark:text-pergamino-50">
            Biblioteca <span aria-hidden>📚</span>
          </h2>

          {cuentos && cuentos.length > 0 ? (
            <BibliotecaGrid
              cuentos={cuentos.map((c) => ({
                ...c,
                minutos: minutosPorCuento.get(c.id) ?? 0,
              }))}
              favoritosIniciales={(favoritos ?? []).map((f) => f.story_id)}
              familyId={family!.id}
            />
          ) : (
            <p className="rounded-2xl border border-dashed border-pergamino-300 bg-white/60 px-6 py-10 text-center text-sm text-tinta-900/60 dark:border-tinta-700 dark:bg-tinta-900/30 dark:text-pergamino-50/60">
              Todavía no hay cuentos publicados. Corre uno de los scripts en{" "}
              <code>supabase/</code> para cargar el primero.
            </p>
          )}
        </section>

        {/* ---------- Protagonistas ---------- */}
        <section id="protagonistas" className="mb-10">
          <h2 className="mb-4 flex items-center gap-2 font-display text-xl italic text-tinta-900 dark:text-pergamino-50">
            Protagonistas <span aria-hidden>👥</span>
          </h2>

          {hijos && hijos.length > 0 ? (
            <div className="flex flex-wrap gap-4">
              {hijos.map((h) => (
                <div
                  key={h.id}
                  className="flex w-36 flex-col items-center gap-2 rounded-2xl border border-pergamino-200 bg-white px-4 py-5 text-center dark:border-tinta-700 dark:bg-tinta-900"
                >
                  <span className="flex h-12 w-12 items-center justify-center rounded-full bg-oro-300 font-display text-lg font-semibold text-white dark:bg-oro-500">
                    {h.nombre.charAt(0).toUpperCase()}
                  </span>
                  <p className="font-display italic text-tinta-900 dark:text-pergamino-50">
                    {h.nombre}
                  </p>
                  {h.edad && (
                    <span className="text-[10px] uppercase tracking-wide text-tinta-900/45 dark:text-pergamino-50/45">
                      {h.edad} años
                    </span>
                  )}
                </div>
              ))}
            </div>
          ) : (
            <p className="rounded-2xl border border-dashed border-pergamino-300 bg-white/60 px-6 py-8 text-center text-sm text-tinta-900/60 dark:border-tinta-700 dark:bg-tinta-900/30 dark:text-pergamino-50/60">
              Todavía nadie protagoniza un cuento aquí -- agrega el nombre de tu hijo
              o hija para que aparezca dentro de sus propias historias.
            </p>
          )}
        </section>
      </main>
    </div>
  );
}
