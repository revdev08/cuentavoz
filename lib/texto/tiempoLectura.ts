// Estima cuánto dura leer un cuento en voz alta, a partir del texto de
// sus bloques. No es un conteo de palabras "silencioso": un padre
// leyendo con calma para un niño de 2-7 años va más despacio que una
// lectura normal, y cada bloque suma una pausa corta (mirar la imagen,
// tocar para continuar, a veces un sonido). Por eso se combinan dos
// factores en vez de solo dividir palabras entre velocidad de lectura.

const PALABRAS_POR_MINUTO = 110; // ritmo de lectura en voz alta, pausado
const SEGUNDOS_PAUSA_POR_BLOQUE = 4; // imagen + tap + respiración entre bloques

export function contarPalabras(texto: string): number {
  return texto.trim().split(/\s+/).filter(Boolean).length;
}

/** Minutos estimados de lectura en voz alta, redondeados hacia arriba. */
export function estimarMinutosLectura(bloques: { texto_bloque: string }[]): number {
  if (bloques.length === 0) return 0;
  const totalPalabras = bloques.reduce((sum, b) => sum + contarPalabras(b.texto_bloque), 0);
  const minutos =
    totalPalabras / PALABRAS_POR_MINUTO + (bloques.length * SEGUNDOS_PAUSA_POR_BLOQUE) / 60;
  return Math.max(1, Math.round(minutos));
}

/** "3:45" a partir de minutos con decimales. */
export function formatearMinSeg(minutos: number): string {
  const totalSegundos = Math.max(0, Math.round(minutos * 60));
  const m = Math.floor(totalSegundos / 60);
  const s = totalSegundos % 60;
  return `${m}:${s.toString().padStart(2, "0")}`;
}
