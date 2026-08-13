"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { Howl } from "howler";

type Sonido = { archivo_url: string; categoria: string | null } | null;

const FADE_MS = 300;

function detenerConFade(howl: Howl) {
  howl.fade(howl.volume(), 0, FADE_MS);
  setTimeout(() => howl.unload(), FADE_MS + 50);
}

/**
 * Dispara el sonido de un bloque de dos maneras -- nunca solo, y nunca
 * apenas aparece el bloque (eso disparaba el sonido antes de que el
 * padre llegara siquiera a leer la palabra):
 *
 * Por voz (si modoEscucha): Web Speech API espera a que el padre diga
 * alguna de las trigger_keywords leyendo en voz alta.
 *
 * Manual: la palabra clave aparece subrayada en el texto (ver
 * partirConPalabraClave en StoryPlayer) y tocarla llama a
 * dispararManual() directamente -- funciona con o sin modoEscucha, y es
 * el respaldo si el navegador no soporta reconocimiento de voz o no hay
 * permiso de micrófono.
 */
export function useBlockAudio(
  sonido: Sonido,
  opciones: { modoEscucha: boolean; keywords: string[] }
) {
  const [detectado, setDetectado] = useState(false);
  const dispararRef = useRef<() => void>(() => {});
  const keywordsKey = opciones.keywords.join("|").toLowerCase();

  useEffect(() => {
    setDetectado(false);
    dispararRef.current = () => {};
    if (!sonido) return;

    const howlsActivos: Howl[] = [];
    let recognition: any = null;
    let cancelado = false;
    // El navegador puede seguir emitiendo onresult (con el mismo match) unos
    // milisegundos después de llamar a recognition.stop(), porque stop() no
    // es inmediato. Sin este guard, reproducir() se ejecutaba dos veces y la
    // primera instancia (Howl con loop:true para sonidos "ambiente") quedaba
    // huérfana sonando para siempre — eso era el loop/sobreposición.
    let yaSono = false;

    const reproducir = () => {
      if (cancelado || yaSono) return;
      yaSono = true;
      const loop = sonido.categoria === "ambiente";
      const howl = new Howl({ src: [sonido.archivo_url], loop, volume: loop ? 0 : 0.9 });
      howl.play();
      if (loop) howl.fade(0, 0.5, 500);
      howlsActivos.push(howl);
      setDetectado(true);
      if (recognition) {
        try {
          recognition.stop();
        } catch {}
      }
    };

    dispararRef.current = reproducir;

    const SpeechRecognition =
      typeof window !== "undefined" &&
      ((window as any).SpeechRecognition || (window as any).webkitSpeechRecognition);

    if (opciones.modoEscucha && SpeechRecognition && opciones.keywords.length > 0) {
      recognition = new SpeechRecognition();
      recognition.lang = "es-CO";
      recognition.continuous = true;
      recognition.interimResults = true;

      recognition.onresult = (event: any) => {
        if (yaSono) return;
        
        // Evaluamos todos los resultados (finales e interinos).
        // Al incluir los interinos, la detección ocurre apenas se pronuncia la
        // palabra, sin tener que esperar a que el usuario haga una pausa (isFinal).
        const transcriptTotal = Array.from(event.results as ArrayLike<any>)
          .map((r: any) => r[0].transcript)
          .join(" ")
          .toLowerCase();

        if (!transcriptTotal) return;

        if (opciones.keywords.some((k) => transcriptTotal.includes(k.toLowerCase()))) {
          reproducir();
        }
      };
      recognition.onerror = () => {};
      try {
        recognition.start();
      } catch {}
    }

    return () => {
      cancelado = true;
      dispararRef.current = () => {};
      if (recognition) {
        recognition.onresult = null;
        recognition.onerror = null;
        try {
          recognition.stop();
        } catch {}
      }
      for (const howl of howlsActivos) detenerConFade(howl);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sonido?.archivo_url, sonido?.categoria, opciones.modoEscucha, keywordsKey]);

  const dispararManual = useCallback(() => {
    dispararRef.current();
  }, []);

  return { detectado, dispararManual };
}
