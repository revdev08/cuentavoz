"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { useSupabaseClient } from "@/lib/supabase/client";
import { LibroVolador } from "@/components/LibroVolador";

const TONOS = ["oro", "esmeralda", "ciruela"] as const;
type Tono = (typeof TONOS)[number];

const FONDO_PORTADA: Record<Tono, string> = {
  oro: "from-oro-300 via-oro-400 to-oro-600",
  esmeralda: "from-esmeralda-300 via-esmeralda-400 to-esmeralda-600",
  ciruela: "from-ciruela-400 via-ciruela-600 to-tinta-700",
};

type Cuento = {
  id: string;
  titulo: string;
  portada_url: string | null;
  categoria: string | null;
  edad_recomendada: string | null;
  minutos: number;
};

export function BibliotecaGrid({
  cuentos,
  favoritosIniciales,
  familyId,
}: {
  cuentos: Cuento[];
  favoritosIniciales: string[];
  familyId: string;
}) {
  const supabase = useSupabaseClient();
  const [categoriaActiva, setCategoriaActiva] = useState("Todos");
  const [favoritos, setFavoritos] = useState(() => new Set(favoritosIniciales));

  const categorias = useMemo(() => {
    const vistas = new Set(cuentos.map((c) => c.categoria).filter((c): c is string => !!c));
    return ["Todos", ...Array.from(vistas)];
  }, [cuentos]);

  const cuentosFiltrados =
    categoriaActiva === "Todos" ? cuentos : cuentos.filter((c) => c.categoria === categoriaActiva);

  async function alternarFavorito(storyId: string, e: React.MouseEvent) {
    e.preventDefault();
    e.stopPropagation();

    const yaEsFavorito = favoritos.has(storyId);
    const siguiente = new Set(favoritos);
    yaEsFavorito ? siguiente.delete(storyId) : siguiente.add(storyId);
    setFavoritos(siguiente);

    if (yaEsFavorito) {
      await supabase
        .from("story_favorites")
        .delete()
        .eq("family_id", familyId)
        .eq("story_id", storyId);
    } else {
      await supabase.from("story_favorites").insert({ family_id: familyId, story_id: storyId });
    }
  }

  return (
    <div>
      <div className="mb-6 flex flex-wrap items-center justify-between gap-4">
        <div className="flex flex-wrap gap-2">
          {categorias.map((cat) => (
            <button
              key={cat}
              type="button"
              onClick={() => setCategoriaActiva(cat)}
              className={`rounded-2xl px-5 py-2 text-sm font-medium transition ${
                categoriaActiva === cat
                  ? "bg-oro-500 text-[#0B0A17] shadow-sm"
                  : "bg-pergamino-100 text-tinta-900/70 hover:bg-pergamino-200 dark:bg-tinta-800/50 dark:text-pergamino-50/70 dark:hover:bg-tinta-700/50"
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
        
        
      </div>

      {cuentosFiltrados.length === 0 ? (
        <p className="rounded-2xl border border-dashed border-pergamino-300 bg-white/60 px-6 py-10 text-center text-sm text-tinta-900/60 dark:border-tinta-700 dark:bg-tinta-900/30 dark:text-pergamino-50/60">
          Todavía no hay cuentos en esta categoría.
        </p>
      ) : (
        <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
          {cuentosFiltrados.map((c, i) => {
            const tono = TONOS[i % TONOS.length];
            const esFavorito = favoritos.has(c.id);
            return (
              <Link
                key={c.id}
                href={`/story/${c.id}`}
                className="group relative flex flex-col overflow-hidden rounded-[20px] border border-pergamino-200 bg-white shadow-sm transition hover:-translate-y-1 hover:shadow-lg dark:border-tinta-800/50 dark:bg-tinta-900/40"
              >
                <div className="relative aspect-[4/5] w-full overflow-hidden p-1">
                  <div className="relative h-full w-full overflow-hidden rounded-2xl">
                    {c.portada_url ? (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img
                        src={c.portada_url}
                        alt=""
                        className="absolute inset-0 h-full w-full object-cover transition duration-500 group-hover:scale-110"
                      />
                    ) : (
                      <div
                        className={`absolute inset-0 flex items-center justify-center bg-gradient-to-br transition duration-500 group-hover:scale-110 ${FONDO_PORTADA[tono]}`}
                      >
                        <LibroVolador size={34} variante={tono} className="opacity-90" />
                      </div>
                    )}
                  </div>
                </div>

                <div className="flex flex-1 flex-col px-4 pt-3">
                  <p className="line-clamp-2 text-[15px] font-semibold leading-tight text-tinta-900 dark:text-pergamino-50">
                    {c.titulo}
                  </p>
                </div>
                
                <div className="flex items-center justify-between px-4 pb-4 pt-3">
                  <span className="flex items-center gap-2 text-xs font-medium text-tinta-900/50 dark:text-pergamino-50/50">
                    <span className="h-1.5 w-1.5 rounded-full bg-oro-400"></span>
                    {c.minutos} min
                  </span>
                  <button
                    type="button"
                    onClick={(e) => alternarFavorito(c.id, e)}
                    aria-label={esFavorito ? "Quitar de favoritos" : "Agregar a favoritos"}
                    className="flex items-center justify-center transition"
                  >
                    <span className={esFavorito ? "text-baya-300" : "text-tinta-900/30 hover:text-tinta-900/60 dark:text-pergamino-50/30 dark:hover:text-pergamino-50/60"}>
                      {esFavorito ? "♥" : "♡"}
                    </span>
                  </button>
                </div>
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}
