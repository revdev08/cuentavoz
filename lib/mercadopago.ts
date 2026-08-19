import "server-only";

const MP_API_URL = "https://api.mercadopago.com";

export const PLANES = {
  mensual: {
    nombre: "Cuentavoz Premium mensual",
    monto: 60_000,
    frecuencia: 1,
  },
  semestral: {
    nombre: "Cuentavoz Premium semestral",
    monto: 149_000,
    frecuencia: 6,
  },
  desarrollador: {
    nombre: "Cuentavoz Desarrollo",
    monto: 2_000,
    frecuencia: 1,
  },
} as const;

export type PlanKey = keyof typeof PLANES;

export type MpPreapproval = {
  id: string;
  init_point?: string;
  status: string;
  external_reference?: string;
  next_payment_date?: string;
  auto_recurring?: {
    frequency?: number;
    frequency_type?: string;
    transaction_amount?: number;
    currency_id?: string;
  };
};

export function getMpToken() {
  return process.env.MELI_ACCESS_TOKEN?.trim();
}

export function esPlanKey(value: string): value is PlanKey {
  return Object.prototype.hasOwnProperty.call(PLANES, value);
}

export function emailPuedeUsarPlanDesarrollador(email: string) {
  const autorizados = (process.env.MERCADOPAGO_DEV_EMAILS ?? "")
    .split(",")
    .map((item) => item.trim().toLowerCase())
    .filter(Boolean);

  return autorizados.includes(email.trim().toLowerCase());
}

async function mpRequest<T>(path: string, init?: RequestInit): Promise<T> {
  const token = getMpToken();
  if (!token) throw new Error("mp_not_configured");

  const response = await fetch(`${MP_API_URL}${path}`, {
    ...init,
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
      ...init?.headers,
    },
    cache: "no-store",
  });

  const payload = (await response.json().catch(() => null)) as
    | { message?: string; error?: string }
    | null;

  if (!response.ok) {
    const detalle = payload?.message ?? payload?.error ?? response.statusText;
    throw new Error(`mercadopago_${response.status}: ${detalle}`);
  }

  return payload as T;
}

export async function crearSuscripcion({
  planKey,
  clerkUserId,
  familyId,
  email,
  appUrl,
}: {
  planKey: PlanKey;
  clerkUserId: string;
  familyId: string;
  email: string;
  appUrl: string;
}) {
  const plan = PLANES[planKey];
  const externalReference = `${familyId}:${clerkUserId}:${planKey}`;

  const suscripcion = await mpRequest<MpPreapproval>("/preapproval", {
    method: "POST",
    body: JSON.stringify({
      reason: plan.nombre,
      external_reference: externalReference,
      payer_email: email,
      auto_recurring: {
        frequency: plan.frecuencia,
        frequency_type: "months",
        transaction_amount: plan.monto,
        currency_id: "COP",
      },
      back_url: `${appUrl}/planes?checkout=pendiente`,
      status: "pending",
    }),
  });

  if (!suscripcion.id || !suscripcion.init_point) {
    throw new Error("mercadopago_respuesta_incompleta");
  }

  return suscripcion;
}

export function obtenerSuscripcion(id: string) {
  return mpRequest<MpPreapproval>(`/preapproval/${encodeURIComponent(id)}`);
}
