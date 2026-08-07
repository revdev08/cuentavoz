"use client";

import { useEffect, useRef, useState } from "react";
import { Howl } from "howler";

const PALABRAS = [
  { palabra: "lluvia", emoji: "🌧️", archivo: "/sounds/lluvia.mp3", caption: "Así suena cuando cae una lluvia mágica en el bosque." },
  { palabra: "campanita", emoji: "🔔", archivo: "/sounds/campanita.mp3", caption: "Así suena la campanita que abre la puerta secreta del árbol." },
  { palabra: "abejas", emoji: "🐝", archivo: "/sounds/abejas.mp3", caption: "Así zumban las abejas doradas del huerto encantado." },
];

export function TiraPalabrasMagicas() {
  const [activa, setActiva] = useState<string | null>(null);
  const seleccionada = PALABRAS.find((p) => p.palabra === activa);
  const howlActivo = useRef<Howl | null>(null);

  useEffect(() => {
    return () => {
      howlActivo.current?.unload();
    };
  }, []);

  function tocar(p: (typeof PALABRAS)[number]) {
    setActiva(p.palabra);
    howlActivo.current?.stop();
    const howl = new Howl({ src: [p.archivo], volume: 0.9 });
    howlActivo.current = howl;
    howl.play();
  }

  return (
    <div>
      <div className="flex flex-wrap justify-center gap-3">
        {PALABRAS.map((p) => (
          <button
            key={p.palabra}
            type="button"
            onClick={() => tocar(p)}
            className={`rounded-full border px-5 py-2.5 font-mono text-sm transition ${
              activa === p.palabra
                ? "border-oro-500 bg-oro-500/15 text-oro-300 shadow-[0_0_0_6px_rgba(231,162,61,0.1)]"
                : "border-pergamino-50/25 bg-pergamino-50/5 text-pergamino-50 hover:border-oro-400"
            }`}
          >
            {p.palabra} {p.emoji}
          </button>
        ))}
      </div>
      <p
        className={`mt-4 min-h-[20px] text-center font-display text-sm italic text-oro-300 transition-opacity ${
          seleccionada ? "opacity-100" : "opacity-0"
        }`}
      >
        {seleccionada?.caption ?? "—"}
      </p>
    </div>
  );
}
