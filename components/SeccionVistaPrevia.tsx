"use client";

import { useRef, useState } from "react";

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

export function SeccionVistaPrevia() {
  const [categoria, setCategoria] = useState<Categoria>("Todas");
  const carrusel = useRef<HTMLDivElement>(null);
  const cuentos = categoria === "Todas" ? CUENTOS : CUENTOS.filter((cuento) => cuento.categoria === categoria);

  function desplazar(direccion: 1 | -1) {
    carrusel.current?.scrollBy({ left: direccion * 320, behavior: "smooth" });
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

        <div className="mt-9 flex justify-center gap-2 overflow-x-auto pb-2 scrollbar-hide">
          {CATEGORIAS.map((opcion) => (
            <button
              key={opcion}
              type="button"
              onClick={() => setCategoria(opcion)}
              className={`shrink-0 rounded-full border px-4 py-2 font-mono text-[10px] uppercase tracking-[0.08em] transition ${
                categoria === opcion
                  ? "border-esmeralda-400 bg-esmeralda-500 text-tinta-950"
                  : "border-pergamino-50/15 text-pergamino-50/55 hover:border-pergamino-50/35 hover:text-pergamino-50"
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
          <div ref={carrusel} className="flex snap-x snap-mandatory gap-4 overflow-x-auto px-1 pb-5 pt-1 scrollbar-hide">
            {cuentos.map((cuento) => (
              <article key={cuento.titulo} className="group relative w-[170px] shrink-0 snap-start overflow-hidden rounded-2xl border border-pergamino-50/10 bg-tinta-800 shadow-[0_14px_30px_rgba(0,0,0,0.25)] sm:w-[190px]">
                <div className="relative aspect-[2/3] overflow-hidden">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img src={cuento.imagen} alt={`Portada de ${cuento.titulo}`} className="h-full w-full object-cover transition duration-500 group-hover:scale-105" />
                  <div className="absolute inset-0 bg-gradient-to-t from-tinta-950 via-tinta-950/25 to-transparent" />
                  <span className="absolute left-3 top-3 rounded-full bg-tinta-950/70 px-2 py-1 font-mono text-[9px] uppercase tracking-[0.08em] text-oro-300 backdrop-blur">{cuento.tono}</span>
                  <div className="absolute inset-x-0 bottom-0 p-3.5">
                    <h3 className="line-clamp-3 font-display text-lg italic leading-[1.05] text-pergamino-50">{cuento.titulo}</h3>
                    <p className="mt-2 font-mono text-[10px] uppercase tracking-[0.08em] text-pergamino-50/60">◷ {cuento.minutos} · 2–7 años</p>
                  </div>
                </div>
              </article>
            ))}
          </div>
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
