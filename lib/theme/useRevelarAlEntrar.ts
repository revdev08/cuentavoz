"use client";

import { useEffect, useRef } from "react";

/**
 * Agrega la clase "revelar-visible" (ver .revelar en globals.css) la
 * primera vez que el elemento entra en el viewport. Un solo efecto
 * orquestado de scroll, no una animación por cada elemento suelto.
 */
export function useRevelarAlEntrar<T extends HTMLElement>() {
  const ref = useRef<T | null>(null);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;

    const observer = new IntersectionObserver(
      ([entrada]) => {
        if (entrada.isIntersecting) {
          el.classList.add("revelar-visible");
          observer.disconnect();
        }
      },
      { threshold: 0.15 }
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  return ref;
}
