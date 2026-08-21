"use client";

import { useEffect, useRef, useState } from "react";

type Categoria = "Todas" | "Aventuras" | "Naturaleza" | "Momentos" | "Misterio";

const CUENTOS = [
  { titulo: "El cactus que aprendió a abrazar", categoria: "Naturaleza", minutos: "7 min", imagen: "/images/portadas/el-cactus-que-aprendio-a-abrazar.webp", tono: "Ternura" },
  { titulo: "La maleta que dejó espacio para la sorpresa", categoria: "Aventuras", minutos: "7 min", imagen: "/images/portadas/la-maleta-que-dejo-espacio-para-la-sorpresa.webp", tono: "Curiosidad" },
  { titulo: "El banquito que aprendió a sostener aplausos", categoria: "Momentos", minutos: "7 min", imagen: "/images/portadas/el-banquito-que-aprendio-a-sostener-aplausos.webp", tono: "Alegría" },
  { titulo: "La luciérnaga que inventaba respuestas", categoria: "Misterio", minutos: "6 min", imagen: "/images/portadas/la-luciernaga-que-inventaba-respuestas.webp", tono: "Misterio" },
  { titulo: "El ascensor que tenía vértigo", categoria: "Aventuras", minutos: "7 min", imagen: "/images/portadas/el-ascensor-que-tenia-vertigo.webp", tono: "Valentía" },
  { titulo: "La semilla que aprendió a cantar", categoria: "Naturaleza", minutos: "6 min", imagen: "/images/portadas/la-semilla-que-aprendio-a-cantar.webp", tono: "Esperanza" },
  { titulo: "La almohada que guardaba demasiadas preocupaciones", categoria: "Momentos", minutos: "6 min", imagen: "/images/portadas/la-almohada-que-guardaba-demasiadas-preocupaciones.webp", tono: "Calma" },
  { titulo: "El eco que aprendió a dejar espacio", categoria: "Misterio", minutos: "7 min", imagen: "/images/portadas/el-eco-que-aprendio-a-dejar-espacio.webp", tono: "Sorpresa" },
] as const;

const CATEGORIAS: Categoria[] = ["Todas", "Aventuras", "Naturaleza", "Momentos", "Misterio"];
const VERSION_PORTADAS = "20260821";

export function SeccionVistaPrevia() {
  const [categoria, setCategoria] = useState<Categoria>("Todas");
  const carrusel = useRef<HTMLDivElement>(null);
  const cuentos = categoria === "Todas" ? CUENTOS : CUENTOS.filter((cuento) => cuento.categoria === categoria);

  useEffect(() => {
    carrusel.current?.scrollTo({ left: 0, behavior: "smooth" });
  }, [categoria]);

  function desplazar(direccion: 1 | -1) {
    carrusel.current?.scrollBy({ left: direccion * 390, behavior: "smooth" });
  }

  return (
    <section className="relative overflow-hidden bg-tinta-900 py-24">
      <div aria-hidden className="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_10%_20%,rgba(138,107,174,0.2),transparent_27%),radial-gradient(circle_at_88%_80%,rgba(76,122,99,0.18),transparent_25%)]" />
      <div className="relative mx-auto max-w-7xl px-6 sm:px-8">
        <div className="mx-auto max-w-2xl text-center">
          <span className="font-mono text-xs uppercase tracking-[0.14em] text-oro-300">Una biblioteca para asomarse</span>
          <h2 className="mt-4 font-display text-3xl italic text-pergamino-50 sm:text-5xl">
            Mundos para descubrir <span className="not-italic text-baya-400">juntos.</span>
          </h2>
          <p className="mt-4 text-[15px] leading-relaxed text-pergamino-50/65">
            Elige una emoción, mira las portadas y encuentra la próxima aventura que les gustaría leer.
          </p>
        </div>

        <div role="tablist" aria-label="Filtrar portadas por tipo" className="mx-auto mt-9 flex max-w-xl flex-wrap justify-center gap-2">
          {CATEGORIAS.map((opcion) => (
            <button
              key={opcion}
              type="button"
              role="tab"
              aria-selected={categoria === opcion}
              onClick={() => setCategoria(opcion)}
              className={`shrink-0 rounded-full border px-4 py-2 font-mono text-[10px] uppercase tracking-[0.08em] transition ${
                categoria === opcion
                  ? "border-esmeralda-300 bg-esmeralda-400 text-tinta-950 shadow-[0_7px_20px_rgba(143,180,160,0.22)]"
                  : "border-pergamino-50/15 bg-tinta-950/35 text-pergamino-50/65 hover:border-pergamino-50/35 hover:text-pergamino-50"
              }`}
            >
              {opcion}
            </button>
          ))}
        </div>

        <div className="relative mt-10">
          <button
            type="button"
            onClick={() => desplazar(-1)}
            aria-label="Ver portadas anteriores"
            className="absolute -left-3 top-1/2 z-10 hidden h-10 w-10 -translate-y-1/2 rounded-full border border-pergamino-50/15 bg-tinta-950/80 text-xl text-pergamino-50 shadow-lg backdrop-blur transition hover:bg-ciruela-500 lg:grid lg:place-items-center"
          >
            ‹
          </button>
          <div aria-hidden className="pointer-events-none absolute inset-y-0 left-0 z-[1] hidden w-12 bg-gradient-to-r from-tinta-900 to-transparent md:block" />
          <div aria-hidden className="pointer-events-none absolute inset-y-0 right-0 z-[1] w-12 bg-gradient-to-l from-tinta-900 to-transparent" />
          <div ref={carrusel} className="flex snap-x snap-mandatory gap-3 overflow-x-auto scroll-px-5 px-1 pb-8 pt-2 scrollbar-hide sm:gap-4">
            {cuentos.map((cuento) => (
              <article key={cuento.titulo} className="group relative w-[148px] shrink-0 snap-start overflow-hidden rounded-[1.15rem] border border-pergamino-50/10 bg-tinta-800 shadow-[0_14px_30px_rgba(0,0,0,0.25)] transition duration-300 hover:-translate-y-2 hover:border-oro-300/40 hover:shadow-[0_20px_40px_rgba(0,0,0,0.36)] sm:w-[174px] lg:w-[188px]">
                <div className="relative aspect-[2/3] overflow-hidden">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img
                    src={`${cuento.imagen}?v=${VERSION_PORTADAS}`}
                    alt={`Portada de ${cuento.titulo}`}
                    className="h-full w-full object-cover transition duration-500 group-hover:scale-105"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-tinta-950 via-tinta-950/25 to-transparent" />
                  <span className="absolute left-3 top-3 rounded-full bg-tinta-950/70 px-2 py-1 font-mono text-[9px] uppercase tracking-[0.08em] text-oro-300 backdrop-blur">{cuento.tono}</span>
                </div>
                <div className="min-h-[82px] border-t border-pergamino-50/10 px-3.5 py-3">
                  <h3 className="line-clamp-2 font-display text-[17px] italic leading-[1.02] text-pergamino-50">{cuento.titulo}</h3>
                  <p className="mt-2 font-mono text-[9px] uppercase tracking-[0.08em] text-pergamino-50/55">◷ {cuento.minutos} · 2–7 años</p>
                </div>
              </article>
            ))}
          </div>
          <div aria-hidden className="absolute inset-x-1 bottom-[15px] h-px bg-gradient-to-r from-transparent via-oro-500/45 to-transparent" />
          <button
            type="button"
            onClick={() => desplazar(1)}
            aria-label="Ver más portadas"
            className="absolute -right-3 top-1/2 z-10 hidden h-10 w-10 -translate-y-1/2 rounded-full border border-pergamino-50/15 bg-tinta-950/80 text-xl text-pergamino-50 shadow-lg backdrop-blur transition hover:bg-ciruela-500 lg:grid lg:place-items-center"
          >
            ›
          </button>
        </div>

        <p className="mt-2 text-center font-mono text-[11px] uppercase tracking-[0.1em] text-pergamino-50/45">
          ✦ Estas son solo algunas portadas. La biblioteca completa se abre al crear tu cuenta. ✦
        </p>
      </div>
    </section>
  );
}
