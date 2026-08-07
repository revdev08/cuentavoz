const FILAS = [
  { rasgo: "Lo lees tú, con tu voz", papel: true, audiolibro: false, cuentavoz: true },
  { rasgo: "El cuento reacciona a lo que dices", papel: false, audiolibro: false, cuentavoz: true },
  {
    rasgo: "Tu hijo elige los personajes de la historia",
    papel: false,
    audiolibro: false,
    cuentavoz: true,
    destacado: true,
  },
  { rasgo: "Sin grabar audio en ningún momento", papel: true, audiolibro: true, cuentavoz: true },
];

function Marca({ si }: { si: boolean }) {
  return si ? (
    <span className="font-bold text-esmeralda-700 dark:text-esmeralda-300">Sí</span>
  ) : (
    <span className="text-tinta-900/35 dark:text-pergamino-50/30">No</span>
  );
}

export function SeccionComparacion() {
  return (
    <section className="mx-auto max-w-3xl px-6 py-24 sm:px-8">
      <div className="mx-auto mb-14 max-w-xl text-center">
        <span className="font-mono text-xs uppercase tracking-[0.14em] text-baya-500">
          Para comparar
        </span>
        <h2 className="mt-4 font-display text-3xl italic text-tinta-900 dark:text-pergamino-50 sm:text-4xl">
          No reemplaza el libro de papel. Lo acompaña.
        </h2>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full min-w-[480px] border-collapse text-sm">
          <thead>
            <tr>
              <th className="border-b border-pergamino-200 py-4 pr-4 text-left dark:border-tinta-700" />
              <th className="border-b border-pergamino-200 px-3 py-4 text-left font-mono text-[11px] font-medium uppercase tracking-wide text-tinta-900/50 dark:border-tinta-700 dark:text-pergamino-50/50">
                Libro de papel
              </th>
              <th className="border-b border-pergamino-200 px-3 py-4 text-left font-mono text-[11px] font-medium uppercase tracking-wide text-tinta-900/50 dark:border-tinta-700 dark:text-pergamino-50/50">
                Audiolibro
              </th>
              <th className="border-b border-pergamino-200 px-3 py-4 text-left font-mono text-[11px] font-medium uppercase tracking-wide text-tinta-900/50 dark:border-tinta-700 dark:text-pergamino-50/50">
                Cuentavoz
              </th>
            </tr>
          </thead>
          <tbody>
            {FILAS.map((f) => (
              <tr key={f.rasgo} className={f.destacado ? "bg-oro-500/10" : ""}>
                <td className="border-b border-pergamino-200 py-4 pr-4 font-semibold text-tinta-900 dark:border-tinta-700 dark:text-pergamino-50">
                  {f.rasgo}
                </td>
                <td className="border-b border-pergamino-200 px-3 py-4 dark:border-tinta-700">
                  <Marca si={f.papel} />
                </td>
                <td className="border-b border-pergamino-200 px-3 py-4 dark:border-tinta-700">
                  <Marca si={f.audiolibro} />
                </td>
                <td className="border-b border-pergamino-200 px-3 py-4 dark:border-tinta-700">
                  <Marca si={f.cuentavoz} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </section>
  );
}
