// Heurística de concordancia de género para sustantivos escritos
// libremente por el usuario (ej. el animal que el niño elige como amigo).
// No es perfecta -- el español tiene excepciones que no siguen la regla
// de "termina en -a = femenino" (ej. "el ave", "la mano") -- pero cubre
// bien el vocabulario típico de animales/objetos de un cuento infantil.
// Antes de esto, el texto tenía "un" y "el" fijos en el molde, lo que
// rompía la concordancia con cualquier palabra femenina (ej. "un ardilla").

const EXCEPCIONES: Record<string, "m" | "f"> = {
  serpiente: "f",
  liebre: "f",
  ave: "f",
  aguila: "f",
  águila: "f",
  jirafa: "f",
  cebra: "f",
  gaviota: "f",
  // Objetos/lugares comunes que un niño podría escribir libremente en
  // variables que ya no son solo animales (ej. "objeto_especial",
  // "lugar_secreto") y que la regla de "termina en -a" no cubre.
  llave: "f",
  nube: "f",
  torre: "f",
  flor: "f",
  luz: "f",
  sal: "f",
  miel: "f",
};

export function generoDe(palabra: string): "m" | "f" {
  const p = palabra.trim().toLowerCase();
  if (!p) return "m";
  // Para frases de varias palabras (ej. "estrella de cristal", "pluma
  // dorada") el sustantivo que manda el género es el primero, no el
  // último -- por eso se evalúa solo la primera palabra.
  const primera = p.split(/\s+/)[0];
  if (primera in EXCEPCIONES) return EXCEPCIONES[primera];
  if (/(ción|sión|dad|tud|umbre)$/.test(primera)) return "f";
  if (primera.endsWith("a")) return "f";
  return "m";
}

/** "un" / "una" — artículo indefinido según el género inferido. */
export function articuloPara(palabra: string): "un" | "una" {
  return generoDe(palabra) === "f" ? "una" : "un";
}

/** "el" / "la" — artículo definido según el género inferido. */
export function articuloDefinidoPara(palabra: string): "el" | "la" {
  return generoDe(palabra) === "f" ? "la" : "el";
}
