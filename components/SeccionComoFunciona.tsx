const PAGINAS = [
  {
    num: "Página 1",
    titulo: "Eligen juntos",
    texto:
      "Tu hijo escoge el héroe, el compañero y el escenario. Tú escoges cuánto dura el cuento esta noche.",
    icono: "📖",
  },
  {
    num: "Página 2",
    titulo: "Lees en voz alta",
    texto:
      "Sin pantalla en la cara de tu hijo. Solo tu voz, el texto frente a ti, y él o ella mirándote a los ojos.",
    icono: "🗣️",
  },
  {
    num: "Página 3",
    titulo: "El cuento reacciona",
    texto:
      "Ciertas palabras activan sonido cuando las dices en voz alta, o las tocas con el dedo. El cuento responde a cómo lo cuentas.",
    icono: "✨",
  },
];

export function SeccionComoFunciona() {
  return (
    <section id="como-funciona" className="py-24">
      <div className="mx-auto max-w-2xl px-6 text-center sm:px-8">
        <span className="font-mono text-xs uppercase tracking-[0.14em] text-baya-500">
          Cómo se lee un cuento aquí
        </span>
        <h2 className="mt-4 font-display text-3xl italic text-tinta-900 dark:text-pergamino-50 sm:text-4xl">
          Tres páginas. Una sola voz: la de ustedes.
        </h2>
      </div>

      <div className="mx-auto mt-14 max-w-4xl border-y border-pergamino-200 dark:border-tinta-700">
        <div className="grid sm:grid-cols-3">
          {PAGINAS.map((p, i) => (
            <div
              key={p.num}
              className={`px-8 py-11 ${
                i < PAGINAS.length - 1
                  ? "border-b border-pergamino-200 dark:border-tinta-700 sm:border-b-0 sm:border-r"
                  : ""
              }`}
            >
              <p className="font-mono text-xs uppercase tracking-[0.1em] text-baya-500">{p.num}</p>
              <h3 className="mt-3.5 font-display text-xl italic text-tinta-900 dark:text-pergamino-50">
                {p.titulo}
              </h3>
              <p className="mt-2.5 text-[15px] leading-relaxed text-tinta-900/70 dark:text-pergamino-50/70">
                {p.texto}
              </p>
              <div className="mt-5 text-2xl">{p.icono}</div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
