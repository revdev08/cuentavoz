"use client";

import { useCallback, useEffect, useRef, useState } from "react";

type Opciones = {
  habilitada: boolean;
  texto: string;
  palabraConSonido?: string | null;
  alLlegarAlSonido: () => void;
  alTerminar: () => void;
};

/**
 * Convierte cada bloque en una pequeña pista de audiolibro usando la voz
 * instalada en el dispositivo. `onboundary` permite disparar el efecto justo
 * al llegar a la palabra subrayada; algunos navegadores no entregan límites de
 * palabra, así que se conserva una estimación de tiempo como respaldo.
 */
export function useNarracionAutomatica({
  habilitada,
  texto,
  palabraConSonido,
  alLlegarAlSonido,
  alTerminar,
}: Opciones) {
  const [reproduciendo, setReproduciendo] = useState(false);
  const [soportada, setSoportada] = useState(false);
  const idLocucion = useRef(0);
  const temporizador = useRef<ReturnType<typeof setTimeout> | null>(null);
  const callbacks = useRef({ alLlegarAlSonido, alTerminar });

  callbacks.current = { alLlegarAlSonido, alTerminar };

  const detenerVoz = useCallback(() => {
    idLocucion.current += 1;
    if (temporizador.current) clearTimeout(temporizador.current);
    temporizador.current = null;
    if (typeof window !== "undefined" && "speechSynthesis" in window) {
      window.speechSynthesis.cancel();
    }
  }, []);

  useEffect(() => {
    setSoportada(typeof window !== "undefined" && "speechSynthesis" in window);
  }, []);

  useEffect(() => {
    if (habilitada) return;
    detenerVoz();
    setReproduciendo(false);
  }, [habilitada, detenerVoz]);

  useEffect(() => {
    if (!habilitada || !reproduciendo || !soportada || !texto) return;

    detenerVoz();
    const id = idLocucion.current + 1;
    idLocucion.current = id;
    const locucion = new SpeechSynthesisUtterance(texto);
    locucion.lang = "es-CO";
    // Una lectura para 2–7 años necesita espacio para imaginar la escena;
    // 0.8 suena conversacional en las voces españolas del navegador.
    locucion.rate = 0.7;
    locucion.pitch = 1;

    const voces = window.speechSynthesis.getVoices();
    const voz =
      voces.find((v) => /^es[-_]co/i.test(v.lang)) ??
      voces.find((v) => /^es[-_]419/i.test(v.lang)) ??
      voces.find((v) => /^es/i.test(v.lang));
    if (voz) locucion.voice = voz;

    let sonidoDisparado = false;
    const dispararSonido = () => {
      if (sonidoDisparado || id !== idLocucion.current) return;
      sonidoDisparado = true;
      callbacks.current.alLlegarAlSonido();
    };

    const inicioPalabra = palabraConSonido
      ? texto.toLocaleLowerCase("es-CO").indexOf(palabraConSonido.toLocaleLowerCase("es-CO"))
      : -1;

    locucion.onboundary = (evento) => {
      if (inicioPalabra >= 0 && evento.charIndex >= inicioPalabra) dispararSonido();
    };

    // Respaldo para Safari y algunas voces móviles que no emiten onboundary.
    if (inicioPalabra >= 0) {
      const milisegundosEstimados = Math.max(350, (inicioPalabra / 12.5 / locucion.rate) * 1000);
      temporizador.current = setTimeout(dispararSonido, milisegundosEstimados);
    }

    locucion.onend = () => {
      if (id !== idLocucion.current) return;
      if (temporizador.current) clearTimeout(temporizador.current);
      temporizador.current = setTimeout(() => {
        if (id === idLocucion.current) callbacks.current.alTerminar();
      }, 1400);
    };
    locucion.onerror = () => {
      if (id === idLocucion.current) setReproduciendo(false);
    };

    window.speechSynthesis.speak(locucion);
    return detenerVoz;
  }, [habilitada, reproduciendo, soportada, texto, palabraConSonido, detenerVoz]);

  useEffect(() => () => detenerVoz(), [detenerVoz]);

  const iniciar = useCallback(() => setReproduciendo(true), []);
  const pausar = useCallback(() => {
    detenerVoz();
    setReproduciendo(false);
  }, [detenerVoz]);

  return { soportada, reproduciendo, iniciar, pausar };
}
