const NOTAS = [
  {
    pregunta: "¿Es otra pantalla más?",
    respuesta:
      "Está pensado para que la pantalla se apague en cuanto empieza la lectura. El protagonismo es tu voz, no la aplicación.",
  },
  {
    pregunta: "¿Se graba la voz de mi hijo?",
    respuesta:
      "No. El modo escucha detecta palabras clave para activar reacciones, pero no graba ni guarda audio, nunca.",
  },
  {
    pregunta: "¿Realmente ayuda a su desarrollo?",
    respuesta:
      "Está diseñado con acompañamiento profesional en mente, para reforzar el vínculo afectivo y el lenguaje en la primera infancia.",
  },
];

export function SeccionPreocupaciones() {
  return (
    <section className="bg-pergamino-100 py-24 dark:bg-tinta-900">
      <div className="mx-auto max-w-5xl px-6 sm:px-8">
        <div className="mx-auto mb-14 max-w-xl text-center">
          <span className="font-mono text-xs uppercase tracking-[0.14em] text-esmeralda-700 dark:text-esmeralda-300">
            Notas al margen
          </span>
          <h2 className="mt-4 font-display text-3xl italic text-tinta-900 dark:text-pergamino-50 sm:text-4xl">
            Las preguntas que se hace todo padre
          </h2>
        </div>

        <div className="grid gap-9 sm:grid-cols-3">
          {NOTAS.map((n) => (
            <div key={n.pregunta} className="border-l-2 border-esmeralda-500 pl-5">
              <p className="font-display text-lg italic text-tinta-900 dark:text-pergamino-50">
                {n.pregunta}
              </p>
              <p className="mt-2.5 text-sm leading-relaxed text-tinta-900/70 dark:text-pergamino-50/70">
                {n.respuesta}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
