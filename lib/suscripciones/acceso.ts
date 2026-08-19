export type SuscripcionParaAcceso = {
  estado: string;
  fecha_renovacion: string | null;
} | null;

const ESTADOS_CANCELADOS = new Set(["canceled", "cancelled"]);

export function periodoSigueVigente(fechaFin: string | null, ahora = Date.now()) {
  if (!fechaFin) return false;
  const fin = new Date(fechaFin).getTime();
  return Number.isFinite(fin) && fin > ahora;
}

export function tieneAccesoPremium(
  planFamilia: string,
  suscripcion: SuscripcionParaAcceso,
  ahora = Date.now()
) {
  if (planFamilia !== "premium") return false;

  // Conserva compatibilidad con cuentas Premium administrativas antiguas.
  if (!suscripcion) return true;
  if (suscripcion.estado === "authorized") return true;

  return (
    ESTADOS_CANCELADOS.has(suscripcion.estado) &&
    periodoSigueVigente(suscripcion.fecha_renovacion, ahora)
  );
}
