import Link from "next/link";

const PLANES = [
  {
    tag: "Para probar",
    nombre: "Gratis",
    precio: "$0",
    periodo: "",
    items: ["2-3 cuentos completos", "Personalización de personajes", "Modo escucha por voz"],
    cta: "Crear cuenta gratis",
    href: "/sign-up",
    destacado: false,
  },
  {
    tag: "Mensual",
    nombre: "Premium",
    precio: "$60.000",
    periodo: "COP / mes",
    items: ["Toda la biblioteca de cuentos", "Nuevos cuentos cada mes", "Sin permanencia mínima"],
    cta: "Empezar Premium",
    href: "/api/checkout/mercadopago?plan=mensual",
    destacado: false,
  },
  {
    tag: "Mejor valor",
    nombre: "Premium semestral",
    precio: "$149.900",
    periodo: "COP / 6 meses",
    items: ["Todo lo del plan mensual", "Equivale a $24.833 COP/mes", "Un cobro cada seis meses"],
    cta: "Empezar Premium semestral",
    href: "/api/checkout/mercadopago?plan=semestral",
    destacado: true,
  },
];

export function SeccionPrecios() {
  return (
    <section id="precios" className="mx-auto max-w-4xl px-6 py-24 sm:px-8">
      <div className="mx-auto mb-14 max-w-xl text-center">
        <span className="font-mono text-xs uppercase tracking-[0.14em] text-baya-500">Precios</span>
        <h2 className="mt-4 font-display text-3xl italic text-tinta-900 dark:text-pergamino-50 sm:text-4xl">
          Empiecen esta noche, sin compromiso
        </h2>
      </div>

      <div className="grid gap-6 sm:grid-cols-3">
        {PLANES.map((plan) => (
          <div
            key={plan.nombre}
            className={`rounded-[20px] border-[1.5px] p-8 ${
              plan.destacado
                ? "border-tinta-900 bg-tinta-900 text-pergamino-50"
                : "border-pergamino-200 bg-pergamino-50 dark:border-tinta-700 dark:bg-tinta-800"
            }`}
          >
            <span
              className={`font-mono text-[11px] uppercase tracking-[0.1em] ${
                plan.destacado ? "text-oro-300" : "text-baya-500"
              }`}
            >
              {plan.tag}
            </span>
            <h3
              className={`mt-2.5 font-display text-2xl italic ${
                plan.destacado ? "text-pergamino-50" : "text-tinta-900 dark:text-pergamino-50"
              }`}
            >
              {plan.nombre}
            </h3>
            <p className="mt-3.5">
              <span
                className={`font-display text-4xl font-semibold ${
                  plan.destacado ? "text-pergamino-50" : "text-tinta-900 dark:text-pergamino-50"
                }`}
              >
                {plan.precio}
              </span>{" "}
              {plan.periodo && (
                <span
                  className={`text-sm ${
                    plan.destacado ? "text-pergamino-50/70" : "text-tinta-900/60 dark:text-pergamino-50/60"
                  }`}
                >
                  {plan.periodo}
                </span>
              )}
            </p>
            <ul className="my-6 flex flex-col gap-2.5">
              {plan.items.map((item) => (
                <li
                  key={item}
                  className={`flex gap-2 text-sm ${
                    plan.destacado ? "text-pergamino-50/80" : "text-tinta-900/70 dark:text-pergamino-50/70"
                  }`}
                >
                  <span className={plan.destacado ? "text-oro-300" : "text-esmeralda-600 dark:text-esmeralda-300"}>
                    ✦
                  </span>
                  {item}
                </li>
              ))}
            </ul>
            <Link
              href={plan.href}
              className={`block rounded-full py-3 text-center text-sm font-extrabold transition ${
                plan.destacado
                  ? "bg-oro-500 text-tinta-950 hover:bg-oro-300"
                  : "bg-tinta-900 text-pergamino-50 hover:bg-tinta-800 dark:bg-pergamino-50 dark:text-tinta-900"
              }`}
            >
              {plan.cta}
            </Link>
          </div>
        ))}
      </div>

      <p className="mt-6 text-center text-sm text-tinta-900/50 dark:text-pergamino-50/50">
        También hay paquetes temáticos puntuales desde $9.900 COP.
      </p>
    </section>
  );
}
