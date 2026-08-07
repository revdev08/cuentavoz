"use client";

import { useState } from "react";
import { articuloDefinidoPara } from "@/lib/texto/genero";

const NOMBRES = ["Sofía", "Mateo", "Luna"];
const ANIMALES = ["zorro", "búho", "ardilla"];

export function DemoInteractivo() {
  const [nombre, setNombre] = useState("Sofía");
  const [animal, setAnimal] = useState("zorro");
  const [sonando, setSonando] = useState(false);

  function tocarPalabra() {
    setSonando(true);
    try {
      const audio = new Audio("/sounds/campanita.mp3");
      audio.volume = 0.6;
      audio.play().catch(() => {});
    } catch {}
    setTimeout(() => setSonando(false), 1200);
  }

  const articulo = articuloDefinidoPara(animal);

  return (
    <div className="mx-auto max-w-3xl px-6">
      <div className="grid gap-9 rounded-[22px] bg-pergamino-50 p-8 shadow-[0_40px_90px_-30px_rgba(0,0,0,0.55)] sm:grid-cols-[1.3fr_1fr] sm:p-10">
        <div>
          <p className="font-mono text-[11px] uppercase tracking-[0.14em] text-tinta-900/50">
            Página 12 · El Bosque Encantado
          </p>
          <p className="mt-3 font-display text-xl italic leading-relaxed text-tinta-900 sm:text-2xl">
            {nombre} y {articulo} {animal} llegaron hasta un árbol gigante y
            muy antiguo. Al tocar su tronco con cuidado, sonó una{" "}
            <button
              type="button"
              onClick={tocarPalabra}
              className={`rounded border-b-2 border-dotted px-0.5 font-semibold not-italic transition ${
                sonando
                  ? "border-esmeralda-500 bg-esmeralda-500/15 text-esmeralda-700"
                  : "border-baya-500 text-baya-500 hover:text-baya-700"
              }`}
            >
              campanita mágica
            </button>{" "}
            que abrió una puertecita secreta entre sus raíces.
          </p>
          <div className="mt-6 flex items-center gap-2 font-mono text-xs text-tinta-900/60">
            <span className="h-2 w-2 animate-pulse rounded-full bg-baya-500" />
            Escuchando tu voz · modo lectura en pareja
          </div>
        </div>

        <div>
          <div className="mb-6">
            <h3 className="mb-3 font-mono text-[11px] uppercase tracking-[0.12em] text-tinta-900/50">
              Nombre del héroe
            </h3>
            <div className="flex flex-wrap gap-2">
              {NOMBRES.map((n) => (
                <button
                  key={n}
                  type="button"
                  onClick={() => setNombre(n)}
                  className={`rounded-full border-[1.5px] px-3.5 py-2 text-sm font-bold transition ${
                    nombre === n
                      ? "border-esmeralda-500 bg-esmeralda-500 text-pergamino-50"
                      : "border-pergamino-200 bg-pergamino-100 text-tinta-900/70 hover:border-esmeralda-500"
                  }`}
                >
                  {n}
                </button>
              ))}
            </div>
          </div>

          <div>
            <h3 className="mb-3 font-mono text-[11px] uppercase tracking-[0.12em] text-tinta-900/50">
              Compañero de aventura
            </h3>
            <div className="flex flex-wrap gap-2">
              {ANIMALES.map((a) => (
                <button
                  key={a}
                  type="button"
                  onClick={() => setAnimal(a)}
                  className={`rounded-full border-[1.5px] px-3.5 py-2 text-sm font-bold capitalize transition ${
                    animal === a
                      ? "border-esmeralda-500 bg-esmeralda-500 text-pergamino-50"
                      : "border-pergamino-200 bg-pergamino-100 text-tinta-900/70 hover:border-esmeralda-500"
                  }`}
                >
                  {a}
                </button>
              ))}
            </div>
          </div>

          <p className="mt-5 text-sm leading-relaxed text-tinta-900/60">
            Cada elección cambia el cuento entero, no solo el nombre — las
            escenas se acomodan al personaje que tu hijo escogió.
          </p>
        </div>
      </div>
    </div>
  );
}
