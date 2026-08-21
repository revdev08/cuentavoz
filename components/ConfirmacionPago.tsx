"use client";

import { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";

export function ConfirmacionPago({ completa = false }: { completa?: boolean }) {
  const router = useRouter();
  const [demorado, setDemorado] = useState(false);
  const [intento, setIntento] = useState(0);

  const verificar = useCallback(async () => {
    try {
      const response = await fetch("/api/checkout/mercadopago/status", {
        cache: "no-store",
      });
      if (!response.ok) return false;
      const data = (await response.json()) as { activo?: boolean };
      if (data.activo) {
        router.replace("/dashboard");
        router.refresh();
        return true;
      }
    } catch {
      // El siguiente intento se ocupa de errores transitorios de red.
    }
    return false;
  }, [router]);

  useEffect(() => {
    let cancelado = false;
    let intentos = 0;

    const consultar = async () => {
      if (cancelado) return;
      const activo = await verificar();
      if (activo || cancelado) return;

      intentos += 1;
      if (intentos >= 20) {
        setDemorado(true);
        return;
      }
      window.setTimeout(consultar, 2000);
    };

    void consultar();
    return () => {
      cancelado = true;
    };
  }, [verificar, intento]);

  const contenido = (
    <div className="text-center">
      <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-oro-300/30 text-2xl">
        {demorado ? "⏳" : "✦"}
      </div>
      <h1 className="mt-5 font-display text-3xl italic text-tinta-900 dark:text-pergamino-50">
        {demorado ? "La confirmación está tardando un poco" : "Estamos abriendo tu biblioteca"}
      </h1>
      <p className="mx-auto mt-3 max-w-md text-sm leading-relaxed text-tinta-900/60 dark:text-pergamino-50/60">
        {demorado
          ? "Tu pago puede seguir procesándose en Mercado Pago. No necesitas comprar nuevamente."
          : "Mercado Pago está confirmando la suscripción. Te llevaremos automáticamente al dashboard."}
      </p>
      {!demorado && (
        <div className="mx-auto mt-7 h-1.5 w-44 overflow-hidden rounded-full bg-pergamino-200 dark:bg-white/10">
          <div className="h-full w-1/2 animate-pulse rounded-full bg-oro-500" />
        </div>
      )}
      {demorado && (
        <div className="mt-7 flex flex-wrap justify-center gap-3">
          <button
            type="button"
            onClick={() => {
              setDemorado(false);
              setIntento((valor) => valor + 1);
            }}
            className="rounded-full bg-tinta-900 px-6 py-3 text-sm font-bold text-pergamino-50 dark:bg-oro-500 dark:text-tinta-950"
          >
            Verificar nuevamente
          </button>
          <Link href="/planes" className="rounded-full border border-tinta-900/20 px-6 py-3 text-sm font-bold dark:border-white/20">
            Volver a planes
          </Link>
        </div>
      )}
    </div>
  );

  if (!completa) {
    return (
      <div className="mx-auto mt-6 max-w-2xl rounded-2xl border border-oro-400/40 bg-oro-100 px-5 py-5 dark:bg-oro-500/10">
        {contenido}
      </div>
    );
  }

  return (
    <div className="mx-auto mt-16 max-w-xl rounded-[28px] border border-pergamino-200 bg-white/80 px-7 py-12 shadow-xl dark:border-white/10 dark:bg-white/5 sm:px-12">
      {contenido}
    </div>
  );
}
