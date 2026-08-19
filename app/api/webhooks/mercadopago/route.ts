import { createHmac, timingSafeEqual } from "node:crypto";
import { NextResponse } from "next/server";
import { esPlanKey, obtenerSuscripcion, PLANES } from "@/lib/mercadopago";
import { createServiceRoleClient } from "@/lib/supabase/server";

type WebhookBody = {
  type?: string;
  data?: { id?: string | number };
};

function firmaValida(req: Request, dataId: string) {
  const secret = process.env.MERCADOPAGO_WEBHOOK_SECRET?.trim();
  if (!secret) return false;

  const signature = req.headers.get("x-signature") ?? "";
  const requestId = req.headers.get("x-request-id") ?? "";
  const partes = Object.fromEntries(
    signature.split(",").map((parte) => {
      const [key, ...value] = parte.trim().split("=");
      return [key, value.join("=")];
    })
  );
  const ts = partes.ts;
  const v1 = partes.v1;
  if (!requestId || !ts || !v1) return false;

  const manifest = `id:${dataId.toLowerCase()};request-id:${requestId};ts:${ts};`;
  const esperada = createHmac("sha256", secret).update(manifest).digest("hex");
  const recibidaBuffer = Buffer.from(v1, "utf8");
  const esperadaBuffer = Buffer.from(esperada, "utf8");
  return recibidaBuffer.length === esperadaBuffer.length && timingSafeEqual(recibidaBuffer, esperadaBuffer);
}

export async function POST(req: Request) {
  try {
    const url = new URL(req.url);
    const body = (await req.json().catch(() => ({}))) as WebhookBody;
    const dataId = String(
      url.searchParams.get("data.id") ??
        url.searchParams.get("data_id") ??
        body.data?.id ??
        ""
    );

    if (!dataId) return new NextResponse("Falta data.id", { status: 400 });
    if (!firmaValida(req, dataId)) return new NextResponse("Firma inválida", { status: 401 });

    const type = url.searchParams.get("type") ?? body.type;
    if (type !== "subscription_preapproval") {
      return NextResponse.json({ ok: true, ignorado: true });
    }

    // La firma valida el aviso; esta consulta autenticada valida el estado real.
    const mpSubscription = await obtenerSuscripcion(dataId);
    const [familyId, clerkUserId, plan] = (mpSubscription.external_reference ?? "").split(":");
    if (!familyId || !clerkUserId || !esPlanKey(plan)) {
      return new NextResponse("Referencia externa inválida", { status: 400 });
    }

    const configuracion = PLANES[plan];
    const recurrencia = mpSubscription.auto_recurring;
    if (
      recurrencia?.transaction_amount !== configuracion.monto ||
      recurrencia?.currency_id !== "COP" ||
      recurrencia?.frequency !== configuracion.frecuencia ||
      recurrencia?.frequency_type !== "months"
    ) {
      return new NextResponse("La suscripción no coincide con el plan", { status: 409 });
    }

    const supabase = createServiceRoleClient();
    const { data: family, error: familyError } = await supabase
      .from("families")
      .select("id, clerk_user_id")
      .eq("id", familyId)
      .eq("clerk_user_id", clerkUserId)
      .maybeSingle();
    if (familyError) throw familyError;
    if (!family) return new NextResponse("Familia no encontrada", { status: 404 });

    const { error: subscriptionError } = await supabase.from("subscriptions").upsert(
      {
        family_id: familyId,
        proveedor: "mercadopago",
        estado: mpSubscription.status,
        plan,
        mp_preapproval_id: mpSubscription.id,
        fecha_renovacion: mpSubscription.next_payment_date ?? null,
        updated_at: new Date().toISOString(),
      },
      { onConflict: "family_id,proveedor" }
    );
    if (subscriptionError) throw subscriptionError;

    if (mpSubscription.status === "authorized") {
      const { error } = await supabase.from("families").update({ plan: "premium" }).eq("id", familyId);
      if (error) throw error;
    } else if (["cancelled", "canceled"].includes(mpSubscription.status)) {
      const { error } = await supabase.from("families").update({ plan: "inactive" }).eq("id", familyId);
      if (error) throw error;
    }

    return NextResponse.json({ ok: true });
  } catch (error: unknown) {
    const detalle = error instanceof Error ? error.message : String(error);
    console.error("[Mercado Pago webhook]", detalle);
    return NextResponse.json({ error: "Error procesando webhook" }, { status: 500 });
  }
}
