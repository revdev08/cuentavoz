import Link from "next/link";
import { redirect } from "next/navigation";
import { auth, currentUser } from "@clerk/nextjs/server";
import { UserButton } from "@clerk/nextjs";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { SidebarNav } from "@/components/SidebarNav";
import { ThemeToggle } from "@/components/ThemeToggle";
import { EscenaLecturaNocturna } from "@/components/EscenaLecturaNocturna";
import { BibliotecaGrid } from "@/components/BibliotecaGrid";
import { ProtagonistasPanel } from "@/components/ProtagonistasPanel";
import { Medallon } from "@/components/Medallon";
import { estimarMinutosLectura, formatearMinSeg } from "@/lib/texto/tiempoLectura";

export default async function DashboardPage() {
  const { userId } = auth();
  const user = await currentUser();
  const email = user?.primaryEmailAddress?.emailAddress.toLowerCase() ?? null;
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
      .insert({ clerk_user_id: userId!, email, plan: "inactive" })
      .select()
      .single();
    family = nuevaFamilia;
  } else if (family.email !== email) {
    await supabase.from("families").update({ email }).eq("id", family.id);
    family = { ...family, email };
  }

  if (family?.plan !== "premium") {
    redirect("/planes");
  }

  const [{ data: hijos }, { data: cuentos }, { data: favoritos }] = await Promise.all([
    supabase.from("children_profiles").select("*").eq("family_id", family!.id),
    supabase
      .from("stories")
      .select("id, titulo, edad_recomendada, categoria, portada_url")
      // La biblioteca debe recibir el catálogo completo. El límite anterior
      // dejaba fuera cualquier cuento a partir del número 21.
      .order("created_at", { ascending: false }),
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
    <div className="flex min-h-screen bg-[#F7EEDC] dark:bg-[#0B0A17]">
      <SidebarNav nombreFamilia={nombreFamilia} />

      <main className="relative min-w-0 flex-1 overflow-hidden px-5 py-6 sm:px-8 sm:py-8 lg:px-10 xl:px-14">
        <div aria-hidden className="pointer-events-none absolute -right-40 top-[540px] h-[520px] w-[520px] rounded-full bg-esmeralda-300/15 blur-3xl dark:bg-esmeralda-500/5" />
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
                href="/api/checkout/mercadopago?plan=mensual"
                className="mt-4 block font-display text-sm italic text-pergamino-50/60 underline decoration-oro-400 decoration-1 underline-offset-4 transition hover:text-oro-300"
              >
                Ver la biblioteca completa desde $60.000/mes →
              </Link>
            )}
          </div>
        </section>

        {/* ---------- Últimos escuchados ---------- */}
        <section id="escuchados" className="relative mb-16 scroll-mt-8">
          <div className="mb-6 flex items-end justify-between gap-4">
            <div>
              <p className="font-mono text-[9px] font-bold uppercase tracking-[0.2em] text-oro-700 dark:text-oro-300">La historia continúa</p>
              <h2 className="mt-1 font-display text-3xl italic text-tinta-900 dark:text-pergamino-50">Volvamos a donde quedaron</h2>
            </div>
            {escuchados.length > 0 && <span className="hidden text-xs font-semibold text-tinta-900/40 sm:block dark:text-pergamino-50/40">Desliza para ver más →</span>}
          </div>

          {escuchados.length > 0 ? (
            <div className="flex snap-x snap-mandatory gap-5 overflow-x-auto pb-5 pt-1 scrollbar-hide">
              {escuchados.map(({ sesion, cuento, hijo, minutosTotales, minutosTranscurridos, fraccion }) => (
                <Link
                  key={sesion.id}
                  href={
                    sesion.completado
                      ? `/story/${cuento.id}`
                      : `/story/${cuento.id}?continuar=${sesion.child_profile_id}`
                  }
                  className="group relative flex w-[310px] shrink-0 snap-start items-center gap-4 overflow-hidden rounded-[26px] border border-white/80 bg-white/75 p-3.5 shadow-[0_16px_45px_rgba(67,43,24,0.1)] backdrop-blur transition hover:-translate-y-1 hover:shadow-[0_22px_55px_rgba(67,43,24,0.16)] sm:w-[360px] dark:border-white/10 dark:bg-white/[0.05]"
                >
                  <div className="relative h-28 w-24 shrink-0 overflow-hidden rounded-[18px] shadow-md">
                    <img 
                      src={cuento.portada_url || `/images/portadas/gota-tinta.png`} 
                      className="h-full w-full object-cover transition duration-500 group-hover:scale-110" 
                      alt="" 
                    />
                    <div className="absolute inset-0 flex items-center justify-center bg-tinta-950/15 transition group-hover:bg-tinta-950/25">
                      <span className="flex h-10 w-10 items-center justify-center rounded-full bg-white/90 pl-0.5 text-sm text-tinta-900 shadow-lg backdrop-blur transition group-hover:scale-110">
                        ▶
                      </span>
                    </div>
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="line-clamp-2 font-display text-lg font-semibold italic leading-tight text-tinta-900 dark:text-pergamino-50">
                      {cuento.titulo}
                    </p>
                    <p className="mt-1 text-[10px] font-semibold uppercase tracking-wide text-tinta-900/40 dark:text-pergamino-50/40">Leyendo con {hijo?.nombre || "tu familia"}</p>
                    <div className="mt-4 h-1.5 w-full overflow-hidden rounded-full bg-pergamino-200 dark:bg-white/10">
                      <div
                        className="h-full rounded-full bg-oro-400"
                        style={{ width: `${fraccion * 100}%` }}
                      />
                    </div>
                    <div className="mt-2 flex items-center justify-between text-[10px] font-semibold text-tinta-900/45 dark:text-pergamino-50/45">
                      <span>{Math.round(fraccion * 100)}% leído</span>
                      <span>
                        {formatearMinSeg(minutosTranscurridos)} / {formatearMinSeg(minutosTotales)}
                      </span>
                    </div>
                  </div>
                </Link>
              ))}
            </div>
          ) : (
            <div className="flex flex-col items-center justify-between gap-5 rounded-[28px] border border-dashed border-oro-400/45 bg-gradient-to-r from-white/70 to-oro-100/50 px-7 py-8 text-center sm:flex-row sm:text-left dark:from-white/5 dark:to-oro-500/5">
              <div><p className="font-display text-xl italic text-tinta-900 dark:text-pergamino-50">Su primera historia está esperando</p><p className="mt-1 text-sm text-tinta-900/50 dark:text-pergamino-50/50">Elijan una portada juntos y hagan de esta noche un recuerdo.</p></div>
              <a href="#biblioteca" className="shrink-0 rounded-full bg-tinta-950 px-6 py-3 text-xs font-bold text-white transition hover:-translate-y-0.5 dark:bg-oro-400 dark:text-tinta-950">Elegir un cuento ↓</a>
            </div>
          )}
        </section>

        {/* ---------- Biblioteca ---------- */}
        <section id="biblioteca" className="relative mb-20 scroll-mt-8">
          <div className="mb-7 max-w-2xl">
            <p className="font-mono text-[9px] font-bold uppercase tracking-[0.2em] text-esmeralda-700 dark:text-esmeralda-300">Elijan la próxima aventura</p>
            <h2 className="mt-1 font-display text-4xl italic text-tinta-900 dark:text-pergamino-50">Una biblioteca para leer juntos</h2>
            <p className="mt-2 text-sm leading-relaxed text-tinta-900/55 dark:text-pergamino-50/55">Busquen por título, exploren una emoción o guarden las historias que quieran volver a escuchar.</p>
          </div>

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
        <section id="protagonistas" className="relative mb-10 scroll-mt-8 overflow-hidden rounded-[32px] bg-[#203B32] px-6 py-8 shadow-[0_24px_70px_rgba(25,49,41,0.2)] sm:px-9 sm:py-10 dark:bg-[#141E1B]">
          <div aria-hidden className="absolute -right-16 -top-20 h-64 w-64 rounded-full border border-white/10" />
          <div aria-hidden className="absolute -right-6 -top-8 h-44 w-44 rounded-full border border-oro-300/15" />
          <div className="relative mb-7 max-w-xl">
            <p className="font-mono text-[9px] font-bold uppercase tracking-[0.2em] text-oro-300">Cada nombre cambia la historia</p>
            <h2 className="mt-1 font-display text-3xl italic text-white">¿Quién será protagonista esta noche?</h2>
            <p className="mt-2 text-sm text-white/55">Cuentavoz recuerda para quién leen y convierte cada aventura en algo propio.</p>
          </div>

          <ProtagonistasPanel perfilesIniciales={hijos ?? []} familyId={family!.id} />
        </section>
      </main>
    </div>
  );
}
