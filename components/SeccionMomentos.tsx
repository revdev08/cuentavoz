const MOMENTOS = [
  {
    texto:
      "No se trata de terminar otra actividad. Se trata de ese momento en que tu hijo te pide una página más porque quiere seguir escuchando tu voz.",
    detalle: "Lectura que se comparte",
  },
  {
    texto:
      "Una palabra que suena abre una pausa para reír, imaginar o preguntar. El cuento no reemplaza la conversación: la despierta.",
    detalle: "Conversación que nace del cuento",
  },
  {
    texto:
      "Cuando el héroe tiene el nombre, el color o la idea de tu hijo, la historia deja de sentirse lejana y empieza a sentirse suya.",
    detalle: "Un recuerdo hecho entre los dos",
  },
];

const CLAVES = [
  { icono: "▰", numero: "2–7", etiqueta: "años para acompañar" },
  { icono: "◌", numero: "2", etiqueta: "formas de activar sonidos" },
  { icono: "✦", numero: "14", etiqueta: "escenas en cada cuento" },
  { icono: "♡", numero: "Incontables", etiqueta: "momentos para compartir" },
];

export function SeccionMomentos() {
  return (
    <section className="relative overflow-hidden bg-pergamino-100 px-6 py-24 dark:bg-tinta-900 sm:px-8">
      <div className="pointer-events-none absolute inset-x-0 top-0 h-px bg-gradient-to-r from-transparent via-oro-500/70 to-transparent" />
      <div className="mx-auto max-w-6xl">
        <div className="mx-auto max-w-3xl text-center">
          <p className="font-mono text-xs font-semibold uppercase tracking-[0.14em] text-oro-700 dark:text-oro-300">
            Para leer cerca, no solo mirar
          </p>
          <h2 className="mt-4 font-display text-3xl italic leading-tight text-tinta-900 dark:text-pergamino-50 sm:text-5xl">
            A ellos les encanta imaginarlo.
            <br />
            A ti, vivirlo <span className="not-italic text-baya-500">con ellos.</span>
          </h2>
        </div>

        <div className="mt-14 grid gap-5 md:grid-cols-3">
          {MOMENTOS.map((momento, index) => (
            <article
              key={momento.detalle}
              className="relative rounded-[1.6rem] border border-oro-700/10 bg-pergamino-50 p-7 shadow-[0_14px_35px_-25px_rgba(20,18,36,0.5)] dark:border-pergamino-50/10 dark:bg-tinta-800"
            >
              <span className="font-display text-5xl leading-none text-oro-500/80" aria-hidden>
                “
              </span>
              <p className="mt-3 text-[16px] font-semibold leading-relaxed text-tinta-900/75 dark:text-pergamino-50/80">
                {momento.texto}
              </p>
              <div className="mt-7 flex items-center gap-3 border-t border-oro-700/10 pt-4 dark:border-pergamino-50/10">
                <span className="grid h-8 w-8 place-items-center rounded-full bg-baya-500/10 font-mono text-xs font-bold text-baya-600 dark:text-baya-300">
                  0{index + 1}
                </span>
                <p className="font-mono text-[11px] uppercase tracking-[0.08em] text-tinta-900/50 dark:text-pergamino-50/50">
                  {momento.detalle}
                </p>
              </div>
            </article>
          ))}
        </div>

        <div className="mt-8 grid rounded-[1.6rem] border border-oro-700/15 bg-pergamino-50/70 sm:grid-cols-2 lg:grid-cols-4 dark:border-pergamino-50/10 dark:bg-tinta-800/60">
          {CLAVES.map(({ icono, numero, etiqueta }, index) => (
            <div
              key={etiqueta}
              className={`flex items-center gap-4 px-6 py-6 ${index < CLAVES.length - 1 ? "border-b border-oro-700/10 sm:odd:border-r lg:border-b-0 lg:border-r dark:border-pergamino-50/10" : ""}`}
            >
              <span className="grid h-8 w-8 shrink-0 place-items-center font-display text-3xl leading-none text-baya-500" aria-hidden>
                {icono}
              </span>
              <div>
                <p className="font-display text-2xl font-semibold text-tinta-900 dark:text-pergamino-50">{numero}</p>
                <p className="text-sm text-tinta-900/60 dark:text-pergamino-50/60">{etiqueta}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
