const FILAS = [
  { rasgo: "Tú lees la historia", papel: true, audiolibro: false, video: false, cuentavoz: true },
  { rasgo: "El niño elige protagonistas", papel: false, audiolibro: false, video: false, cuentavoz: true },
  { rasgo: "El cuento responde a una palabra", papel: false, audiolibro: false, video: false, cuentavoz: true },
  { rasgo: "Tiene ilustraciones para imaginar", papel: true, audiolibro: false, video: true, cuentavoz: true },
  { rasgo: "Cambia con sus elecciones", papel: false, audiolibro: false, video: false, cuentavoz: true },
  { rasgo: "Invita a pausar y conversar", papel: true, audiolibro: true, video: true, cuentavoz: true },
];

function Marca({ si, destacada = false }: { si: boolean; destacada?: boolean }) {
  return <span className={si ? destacada ? "text-pergamino-50" : "text-esmeralda-300" : "text-pergamino-50/25"}>{si ? "✓" : "—"}</span>;
}

export function SeccionComparacion() {
  return (
    <section className="relative overflow-hidden bg-tinta-950 px-6 py-24 text-pergamino-50 sm:px-8">
      <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(circle_at_15%_80%,rgba(180,72,90,0.16),transparent_27%),radial-gradient(circle_at_84%_18%,rgba(106,76,140,0.22),transparent_30%)]" />
      <div className="relative mx-auto grid max-w-7xl gap-14 lg:grid-cols-[0.78fr_1.5fr] lg:items-center">
        <div className="mx-auto max-w-md text-center lg:mx-0 lg:text-left">
          <p className="font-mono text-xs uppercase tracking-[0.14em] text-oro-300">Una lectura que se comparte</p>
          <h2 className="mt-4 font-display text-4xl italic leading-[1.05] sm:text-5xl">
            No reemplaza el libro de papel.
            <span className="mt-1 block not-italic text-baya-400">Lo acompaña.</span>
          </h2>
          <p className="mt-6 max-w-sm text-[16px] leading-relaxed text-pergamino-50/70 lg:mx-0">
            Cuentavoz conserva tu voz y la imaginación de tu hijo. Añade decisiones, sonidos y personajes que hacen suyo cada momento de lectura.
          </p>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src="/images/landing/lectura-acompanada.webp" alt="Libros, una taza caliente y un marcapáginas con forma de zorro" className="mx-auto mt-8 w-full max-w-[320px] mix-blend-screen lg:mx-0" />
        </div>

        <div className="overflow-x-auto rounded-[1.6rem] border border-pergamino-50/10 bg-tinta-900/50 p-3 shadow-2xl shadow-black/20">
        <table className="w-full min-w-[650px] border-separate border-spacing-0 text-sm">
          <thead>
            <tr>
              <th className="w-[38%] border-b border-pergamino-50/10 px-4 py-4" />
              <th className="border-b border-pergamino-50/10 px-3 py-4 text-center font-mono text-[10px] uppercase tracking-[0.08em] text-pergamino-50/55">Libro</th>
              <th className="border-b border-pergamino-50/10 px-3 py-4 text-center font-mono text-[10px] uppercase tracking-[0.08em] text-pergamino-50/55">Audiolibro</th>
              <th className="border-b border-pergamino-50/10 px-3 py-4 text-center font-mono text-[10px] uppercase tracking-[0.08em] text-pergamino-50/55">Video</th>
              <th className="rounded-t-2xl border-x border-t border-ciruela-400/45 bg-ciruela-500/55 px-4 py-4 text-center font-mono text-[10px] uppercase tracking-[0.1em] text-pergamino-50">✦<span className="mt-1 block">Cuentavoz</span></th>
            </tr>
          </thead>
          <tbody>
            {FILAS.map((f) => (
              <tr key={f.rasgo}>
                <td className="border-b border-pergamino-50/10 px-4 py-4 font-medium text-pergamino-50/85">
                  {f.rasgo}
                </td>
                <td className="border-b border-pergamino-50/10 px-3 py-4 text-center">
                  <Marca si={f.papel} />
                </td>
                <td className="border-b border-pergamino-50/10 px-3 py-4 text-center">
                  <Marca si={f.audiolibro} />
                </td>
                <td className="border-b border-pergamino-50/10 px-3 py-4 text-center">
                  <Marca si={f.video} />
                </td>
                <td className="border-x border-b border-ciruela-400/35 bg-ciruela-500/35 px-4 py-4 text-center last:rounded-b-2xl">
                  <Marca si={f.cuentavoz} destacada />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        </div>
      </div>
    </section>
  );
}
