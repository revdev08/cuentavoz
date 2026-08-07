"use client";

import { useEffect, useState } from "react";

/**
 * Detecta si el modo oscuro está activo observando la clase "dark" en
 * <html> (la pone ThemeToggle). Se usa para pasarle colores dinámicos a
 * widgets que no leen Tailwind directamente, como los componentes de Clerk.
 */
export function useTemaOscuro() {
  const [oscuro, setOscuro] = useState(false);

  useEffect(() => {
    const el = document.documentElement;
    setOscuro(el.classList.contains("dark"));

    const observer = new MutationObserver(() => {
      setOscuro(el.classList.contains("dark"));
    });
    observer.observe(el, { attributes: true, attributeFilter: ["class"] });
    return () => observer.disconnect();
  }, []);

  return oscuro;
}
