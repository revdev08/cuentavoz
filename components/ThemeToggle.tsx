"use client";

import { useEffect, useState } from "react";

export function ThemeToggle({ sobreOscuro = false }: { sobreOscuro?: boolean }) {
  const [oscuro, setOscuro] = useState(false);

  useEffect(() => {
    setOscuro(document.documentElement.classList.contains("dark"));
  }, []);

  function alternar() {
    const nuevoOscuro = !oscuro;
    setOscuro(nuevoOscuro);
    document.documentElement.classList.toggle("dark", nuevoOscuro);
    localStorage.setItem("tema", nuevoOscuro ? "oscuro" : "claro");
  }

  return (
    <button
      type="button"
      onClick={alternar}
      aria-label={oscuro ? "Cambiar a modo día" : "Cambiar a modo noche"}
      title={oscuro ? "Modo día" : "Modo noche"}
      className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-full border text-lg backdrop-blur transition ${
        sobreOscuro
          ? "border-pergamino-50/25 bg-tinta-950/40 hover:bg-tinta-950/60"
          : "border-pergamino-200 bg-white hover:bg-pergamino-100 dark:border-tinta-600 dark:bg-tinta-800 dark:hover:bg-tinta-700"
      }`}
    >
      {oscuro ? "🌙" : "☀️"}
    </button>
  );
}
