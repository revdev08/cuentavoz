const ESCENAS = [
  { imagen: "/images/bosque-encantado/06-campanita.svg", texto: "La campana que abre un secreto" },
  { imagen: "/images/huerto-encantado/13-arbolmadre.svg", texto: "El árbol que lo comparte todo" },
  { imagen: "/images/bosque-encantado/07-buho.svg", texto: "El búho que dice la verdad" },
  { imagen: "/images/huerto-encantado/08-multiplica.svg", texto: "La fruta que se multiplica" },
];

export function SeccionVistaPrevia() {
  return (
    <section className="bg-tinta-900 py-24">
      <div className="mx-auto max-w-5xl px-6 sm:px-8">
        <div className="mx-auto mb-14 max-w-xl text-center">
          <span className="font-mono text-xs uppercase tracking-[0.14em] text-oro-300">Escenas</span>
          <h2 className="mt-4 font-display text-3xl italic text-pergamino-50 sm:text-4xl">
            Un vistazo a los mundos que pueden visitar
          </h2>
        </div>

        <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
          {ESCENAS.map((e) => (
            <div
              key={e.texto}
              className="relative aspect-[3/4] overflow-hidden rounded-2xl bg-tinta-800 shadow-lg"
            >
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src={e.imagen} alt="" className="absolute inset-0 h-full w-full object-cover" />
              <div className="absolute inset-0 bg-gradient-to-t from-tinta-950 via-tinta-950/15 to-transparent" />
              <p className="absolute inset-x-0 bottom-0 p-3.5 font-mono text-[11px] leading-snug text-pergamino-50">
                {e.texto}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
