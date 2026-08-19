"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { useSupabaseClient } from "@/lib/supabase/client";
import { LibroVolador } from "@/components/LibroVolador";

const TONOS = ["oro", "esmeralda", "ciruela", "baya"] as const;
type Tono = (typeof TONOS)[number];

const FONDO_PORTADA: Record<Tono, string> = {
  oro: "from-[#F5D596] via-[#D79A45] to-[#6F4323]",
  esmeralda: "from-[#B8D5C3] via-[#5F8E77] to-[#233F35]",
  ciruela: "from-[#C4AAD8] via-[#76518F] to-[#302342]",
  baya: "from-[#E7A3AD] via-[#B64D61] to-[#54242E]",
};

type Cuento = {
  id: string;
  titulo: string;
  portada_url: string | null;
  categoria: string | null;
  edad_recomendada: string | null;
  minutos: number;
};

function normalizar(texto: string) {
  return texto.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
}

export function BibliotecaGrid({ cuentos, favoritosIniciales, familyId }: {
  cuentos: Cuento[];
  favoritosIniciales: string[];
  familyId: string;
}) {
  const supabase = useSupabaseClient();
  const [categoriaActiva, setCategoriaActiva] = useState("Todos");
  const [soloFavoritos, setSoloFavoritos] = useState(false);
  const [busqueda, setBusqueda] = useState("");
  const [favoritos, setFavoritos] = useState(() => new Set(favoritosIniciales));

  const categorias = useMemo(() => {
    const vistas = new Set(cuentos.map((c) => c.categoria).filter((c): c is string => !!c));
    return ["Todos", ...Array.from(vistas)];
  }, [cuentos]);

  const cuentosFiltrados = useMemo(() => {
    const termino = normalizar(busqueda.trim());
    return cuentos.filter((cuento) => {
      const coincideCategoria = categoriaActiva === "Todos" || cuento.categoria === categoriaActiva;
      const coincideFavorito = !soloFavoritos || favoritos.has(cuento.id);
      const coincideBusqueda = !termino || normalizar(cuento.titulo).includes(termino);
      return coincideCategoria && coincideFavorito && coincideBusqueda;
    });
  }, [busqueda, categoriaActiva, cuentos, favoritos, soloFavoritos]);

  async function alternarFavorito(storyId: string, e: React.MouseEvent) {
    e.preventDefault();
    e.stopPropagation();
    const yaEsFavorito = favoritos.has(storyId);
    const siguiente = new Set(favoritos);
    yaEsFavorito ? siguiente.delete(storyId) : siguiente.add(storyId);
    setFavoritos(siguiente);

    if (yaEsFavorito) {
      await supabase.from("story_favorites").delete().eq("family_id", familyId).eq("story_id", storyId);
    } else {
      await supabase.from("story_favorites").insert({ family_id: familyId, story_id: storyId });
    }
  }

  return (
    <div>
      <div className="rounded-[28px] border border-pergamino-200/80 bg-white/75 p-4 shadow-[0_18px_60px_rgba(69,43,24,0.08)] backdrop-blur sm:p-5 dark:border-white/10 dark:bg-white/[0.04]">
        <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
          <label className="flex min-h-12 flex-1 items-center gap-3 rounded-2xl border border-pergamino-200 bg-pergamino-50/80 px-4 transition focus-within:border-oro-500 focus-within:ring-4 focus-within:ring-oro-300/20 dark:border-white/10 dark:bg-tinta-950/50">
            <span aria-hidden className="text-base text-oro-600 dark:text-oro-300">⌕</span>
            <span className="sr-only">Buscar un cuento</span>
            <input value={busqueda} onChange={(e) => setBusqueda(e.target.value)} placeholder="Busca por título…" className="w-full bg-transparent text-sm text-tinta-900 outline-none placeholder:text-tinta-900/35 dark:text-pergamino-50 dark:placeholder:text-pergamino-50/35" />
            {busqueda && <button type="button" onClick={() => setBusqueda("")} className="rounded-full p-1 text-tinta-900/40 hover:bg-pergamino-200 dark:text-pergamino-50/40 dark:hover:bg-white/10" aria-label="Limpiar búsqueda">×</button>}
          </label>
          <button type="button" onClick={() => setSoloFavoritos((v) => !v)} aria-pressed={soloFavoritos} className={`flex min-h-12 items-center justify-center gap-2 rounded-2xl border px-5 text-sm font-semibold transition focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-baya-300/25 ${soloFavoritos ? "border-baya-300 bg-baya-100 text-baya-700 dark:border-baya-300/50 dark:bg-baya-500/15 dark:text-baya-100" : "border-pergamino-200 bg-white text-tinta-900/60 hover:border-baya-200 hover:text-baya-600 dark:border-white/10 dark:bg-white/5 dark:text-pergamino-50/65"}`}>
            <span aria-hidden>{soloFavoritos ? "♥" : "♡"}</span> Mis favoritos
          </button>
        </div>
        <div className="mt-4 flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
          {categorias.map((categoria) => <button key={categoria} type="button" onClick={() => setCategoriaActiva(categoria)} className={`shrink-0 rounded-full px-4 py-2 text-xs font-bold transition focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-oro-300/25 ${categoriaActiva === categoria ? "bg-tinta-950 text-pergamino-50 shadow-sm dark:bg-oro-400 dark:text-tinta-950" : "bg-pergamino-100 text-tinta-900/55 hover:bg-pergamino-200 hover:text-tinta-900 dark:bg-white/5 dark:text-pergamino-50/55 dark:hover:bg-white/10"}`}>{categoria}</button>)}
        </div>
      </div>

      <div className="mb-4 mt-7 flex items-end justify-between gap-4">
        <p className="font-mono text-[10px] font-semibold uppercase tracking-[0.16em] text-tinta-900/40 dark:text-pergamino-50/40">{cuentosFiltrados.length} {cuentosFiltrados.length === 1 ? "historia encontrada" : "historias encontradas"}</p>
        {(busqueda || soloFavoritos || categoriaActiva !== "Todos") && <button type="button" onClick={() => { setBusqueda(""); setSoloFavoritos(false); setCategoriaActiva("Todos"); }} className="text-xs font-bold text-oro-700 underline decoration-oro-300 underline-offset-4 dark:text-oro-300">Ver toda la biblioteca</button>}
      </div>

      {cuentosFiltrados.length === 0 ? (
        <div className="rounded-[28px] border border-dashed border-oro-400/50 bg-oro-100/45 px-6 py-14 text-center dark:bg-oro-500/5">
          <span aria-hidden className="text-4xl">📖</span>
          <h3 className="mt-4 font-display text-xl italic text-tinta-900 dark:text-pergamino-50">Aquí todavía queda espacio para una historia</h3>
          <p className="mx-auto mt-2 max-w-sm text-sm text-tinta-900/55 dark:text-pergamino-50/55">Prueba otra categoría, limpia la búsqueda o guarda primero un cuento como favorito.</p>
        </div>
      ) : (
        <div className="relative">
          <div className="grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-3 lg:grid-cols-4 2xl:grid-cols-5">
            {cuentosFiltrados.map((cuento, indice) => {
              const tono = TONOS[indice % TONOS.length];
              const esFavorito = favoritos.has(cuento.id);
              return (
                <article key={cuento.id} className="group relative min-w-0">
                  <Link href={`/story/${cuento.id}`} className="block rounded-[22px] focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-oro-300/40">
                    <div className="relative aspect-[3/4] overflow-hidden rounded-[22px] border-[3px] border-white bg-white shadow-[0_16px_30px_rgba(61,40,23,0.15)] transition duration-300 group-hover:-translate-y-2 group-hover:-rotate-1 group-hover:shadow-[0_24px_42px_rgba(61,40,23,0.24)] dark:border-white/10 dark:bg-tinta-900">
                      {cuento.portada_url ? <img src={cuento.portada_url} alt={`Portada de ${cuento.titulo}`} className="absolute inset-0 h-full w-full object-cover transition duration-700 group-hover:scale-105" /> : <div className={`absolute inset-0 flex items-center justify-center bg-gradient-to-br ${FONDO_PORTADA[tono]}`}><LibroVolador size={42} variante={tono === "baya" ? "oro" : tono} className="opacity-90" /></div>}
                      <div className="absolute inset-x-0 bottom-0 h-1/2 bg-gradient-to-t from-tinta-950 via-tinta-950/70 to-transparent" />
                      <div className="absolute inset-x-0 bottom-0 p-3.5 sm:p-4">
                        <div className="mb-2 flex items-center gap-1.5 text-[9px] font-bold uppercase tracking-[0.12em] text-oro-200"><span className="h-1 w-1 rounded-full bg-oro-300" />{cuento.categoria || "Cuento"}</div>
                        <h3 className="line-clamp-3 font-display text-[17px] font-semibold italic leading-[1.08] text-white sm:text-xl">{cuento.titulo}</h3>
                      </div>
                      <span className="absolute right-3 top-3 translate-y-1 rounded-full bg-tinta-950/65 px-2.5 py-1 font-mono text-[9px] font-semibold text-white opacity-0 backdrop-blur transition duration-300 group-hover:translate-y-0 group-hover:opacity-100">Leer ahora →</span>
                    </div>
                  </Link>
                  <div className="mt-3 flex items-center justify-between gap-2 px-1">
                    <div className="flex min-w-0 items-center gap-2 text-[11px] font-semibold text-tinta-900/45 dark:text-pergamino-50/45"><span>{cuento.edad_recomendada || "2-7 años"}</span><span className="h-1 w-1 rounded-full bg-oro-400" /><span>{cuento.minutos} min</span></div>
                    <button type="button" onClick={(e) => alternarFavorito(cuento.id, e)} aria-label={esFavorito ? `Quitar ${cuento.titulo} de favoritos` : `Guardar ${cuento.titulo} en favoritos`} className={`flex h-9 w-9 shrink-0 items-center justify-center rounded-full border text-lg transition focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-baya-300/25 ${esFavorito ? "border-baya-200 bg-baya-100 text-baya-600 dark:border-baya-400/30 dark:bg-baya-500/15 dark:text-baya-200" : "border-pergamino-200 bg-white text-tinta-900/25 hover:border-baya-200 hover:text-baya-500 dark:border-white/10 dark:bg-white/5 dark:text-pergamino-50/30"}`}>{esFavorito ? "♥" : "♡"}</button>
                  </div>
                </article>
              );
            })}
          </div>
          <div aria-hidden className="pointer-events-none mt-3 h-3 rounded-[50%] bg-gradient-to-b from-[#B67B3E]/25 to-transparent blur-sm dark:from-black/30" />
        </div>
      )}
    </div>
  );
}
