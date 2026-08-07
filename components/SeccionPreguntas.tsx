const PREGUNTAS = [
  {
    pregunta: "¿Desde qué edad funciona mejor?",
    respuesta:
      "Está pensado para niños de 4 a 7 años, cuando ya siguen una historia completa pero todavía disfrutan que un adulto se las lea.",
  },
  {
    pregunta: "¿El modo escucha graba a mi hijo?",
    respuesta:
      "No. El reconocimiento de voz corre en tu navegador; Cuentavoz nunca graba ni guarda audio en ningún servidor.",
  },
  {
    pregunta: "¿En qué dispositivos funciona?",
    respuesta:
      "Cuentavoz es una app web: funciona en el navegador de tu celular, tablet o computador, sin descargar nada de una tienda de apps.",
  },
  {
    pregunta: "¿Cuántos hijos puedo agregar?",
    respuesta:
      "Puedes crear un perfil por cada hijo o hija, y cada cuento se personaliza según quién esté leyendo.",
  },
  {
    pregunta: "¿Puedo cancelar cuando quiera?",
    respuesta: "Sí, desde tu cuenta, en cualquier momento, sin llamadas ni formularios.",
  },
];

export function SeccionPreguntas() {
  return (
    <section id="preguntas" className="bg-pergamino-100 py-24 dark:bg-tinta-900">
      <div className="mx-auto max-w-2xl px-6 sm:px-8">
        <div className="mb-14 text-center">
          <span className="font-mono text-xs uppercase tracking-[0.14em] text-baya-500">
            Índice de preguntas
          </span>
          <h2 className="mt-4 font-display text-3xl italic text-tinta-900 dark:text-pergamino-50 sm:text-4xl">
            Lo que preguntan otros padres
          </h2>
        </div>

        <div className="divide-y divide-pergamino-200 dark:divide-tinta-700">
          {PREGUNTAS.map((p) => (
            <details key={p.pregunta} className="group py-1">
              <summary className="flex cursor-pointer list-none items-center justify-between py-5 font-display text-lg italic text-tinta-900 dark:text-pergamino-50">
                {p.pregunta}
                <span className="ml-4 shrink-0 font-mono text-lg text-baya-500 transition-transform duration-200 group-open:rotate-45">
                  +
                </span>
              </summary>
              <p className="pb-5 text-sm leading-relaxed text-tinta-900/70 dark:text-pergamino-50/70">
                {p.respuesta}
              </p>
            </details>
          ))}
        </div>
      </div>
    </section>
  );
}
