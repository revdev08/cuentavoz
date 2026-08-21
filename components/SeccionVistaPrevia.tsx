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
  const [inicio, setInicio] = useState(0);
  const carrusel = useRef<HTMLDivElement>(null);
  const cuentos = categoria === "Todas" ? CUENTOS : CUENTOS.filter((cuento) => cuento.categoria === categoria);
  const cuentosEscritorio = cuentos.slice(inicio, inicio + 6);

  useEffect(() => {
    carrusel.current?.scrollTo({ left: 0, behavior: "smooth" });
    setInicio(0);
  }, [categoria]);

  function desplazarMovil(direccion: 1 | -1) {
    carrusel.current?.scrollBy({ left: direccion * 390, behavior: "smooth" });
  }

  function cambiarPagina(direccion: 1 | -1) {
    const ultimoInicio = Math.max(0, cuentos.length - 6);
    setInicio((actual) => {
      if (direccion === 1) return actual >= ultimoInicio ? 0 : Math.min(actual + 6, ultimoInicio);
      return actual <= 0 ? ultimoInicio : Math.max(actual - 6, 0);
    });
  }

  function Portada({ cuento }: { cuento: (typeof CUENTOS)[number] }) {
    return (
      <article className="group relative min-w-0 overflow-hidden rounded-[1.15rem] border border-pergamino-50/10 bg-tinta-800 shadow-[0_14px_30px_rgba(0,0,0,0.25)] transition duration-300 hover:-translate-y-2 hover:border-oro-300/40 hover:shadow-[0_20px_40px_rgba(0,0,0,0.36)]">
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
    );
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
                  ? "border-oro-300 bg-oro-300 text-tinta-950 shadow-[0_7px_20px_rgba(231,162,61,0.28)]"
                  : "border-pergamino-50/15 bg-tinta-950/35 text-pergamino-50/65 hover:border-pergamino-50/35 hover:text-pergamino-50"
              }`}
            >
              {opcion}
            </button>
          ))}
        </div>

        <div className="relative mt-10">
          {/* Escritorio: una estantería, no un contenedor con scroll. */}
          <button
            type="button"
            onClick={() => cambiarPagina(-1)}
            aria-label="Ver portadas anteriores"
            className="absolute -left-5 top-[42%] z-10 hidden h-11 w-11 -translate-y-1/2 rounded-full border border-pergamino-50/20 bg-tinta-900 text-2xl text-pergamino-50 shadow-[0_10px_28px_rgba(0,0,0,0.34)] transition hover:scale-105 hover:border-oro-300/60 hover:text-oro-300 lg:grid lg:place-items-center"
          >
            ‹
          </button>
          <div className="hidden grid-cols-6 gap-4 px-2 pt-2 lg:grid xl:gap-5">
            {cuentosEscritorio.map((cuento) => <Portada key={cuento.titulo} cuento={cuento} />)}
          </div>

          {/* Móvil: el gesto horizontal se conserva, pero la barra nativa no se muestra. */}
          <div ref={carrusel} className="flex snap-x snap-mandatory gap-3 overflow-x-auto scroll-px-5 px-1 pb-3 pt-2 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden lg:hidden">
            {cuentos.map((cuento) => (
              <div key={cuento.titulo} className="w-[148px] shrink-0 snap-start sm:w-[174px]">
                <Portada cuento={cuento} />
              </div>
            ))}
          </div>
          <button
            type="button"
            onClick={() => cambiarPagina(1)}
            aria-label="Ver más portadas"
            className="absolute -right-5 top-[42%] z-10 hidden h-11 w-11 -translate-y-1/2 rounded-full border border-pergamino-50/20 bg-tinta-900 text-2xl text-pergamino-50 shadow-[0_10px_28px_rgba(0,0,0,0.34)] transition hover:scale-105 hover:border-oro-300/60 hover:text-oro-300 lg:grid lg:place-items-center"
          >
            ›
          </button>
          <div className="mt-7 hidden items-center justify-center gap-2 lg:flex" aria-label="Indicador de portadas">
            {Array.from({ length: Math.max(1, Math.ceil(cuentos.length / 6)) }).map((_, indice) => (
              <span key={indice} className={`h-1.5 rounded-full transition-all ${Math.floor(inicio / 6) === indice ? "w-7 bg-oro-300" : "w-1.5 bg-pergamino-50/25"}`} />
            ))}
          </div>
        </div>

        <p className="mt-2 text-center font-mono text-[11px] uppercase tracking-[0.1em] text-pergamino-50/45">
          ✦ Estas son solo algunas portadas. La biblioteca completa se abre al crear tu cuenta. ✦
        </p>
      </div>
    </section>
  );
}
