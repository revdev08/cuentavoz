import { auth } from "@clerk/nextjs/server";
import { NextResponse } from "next/server";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { tieneAccesoPremium } from "@/lib/suscripciones/acceso";
import { existePagoAprobado, obtenerSuscripcion } from "@/lib/mercadopago";

export const dynamic = "force-dynamic";

export async function GET() {
  const { userId } = auth();
  if (!userId) return NextResponse.json({ activo: false }, { status: 401 });

  const supabase = createServiceRoleClient();
  const { data: family, error: familyError } = await supabase
    .from("families")
    .select("id, plan")
    .eq("clerk_user_id", userId)
    .maybeSingle();

  if (familyError) {
    return NextResponse.json({ activo: false }, { status: 500 });
  }
  if (!family) return NextResponse.json({ activo: false, estado: "sin_familia" });

  const { data: subscription, error: subscriptionError } = await supabase
    .from("subscriptions")
    .select("estado, fecha_renovacion, mp_preapproval_id")
    .eq("family_id", family.id)
    .eq("proveedor", "mercadopago")
    .maybeSingle();

  if (subscriptionError) {
    return NextResponse.json({ activo: false }, { status: 500 });
  }

  let activo = tieneAccesoPremium(family.plan, subscription);

  // Reconciliación defensiva: si el pago ya fue acreditado pero el webhook
  // de factura no llegó, consultamos Mercado Pago y reparamos el estado.
  if (!activo && subscription?.estado === "pending" && subscription.mp_preapproval_id) {
    try {
      const pagoAprobado = await existePagoAprobado(subscription.mp_preapproval_id);
      if (pagoAprobado) {
        const preapproval = await obtenerSuscripcion(subscription.mp_preapproval_id);
        const fechaRenovacion = preapproval.next_payment_date ?? subscription.fecha_renovacion;
        await Promise.all([
          supabase
            .from("subscriptions")
            .update({
              estado: "authorized",
              fecha_renovacion: fechaRenovacion,
              updated_at: new Date().toISOString(),
            })
            .eq("family_id", family.id)
            .eq("proveedor", "mercadopago"),
          supabase.from("families").update({ plan: "premium" }).eq("id", family.id),
        ]);
        activo = true;
      }
    } catch (error) {
      console.error("[Mercado Pago reconciliación]", error);
    }
  }

  return NextResponse.json(
    {
      activo,
      estado: activo ? "authorized" : subscription?.estado ?? "pending",
    },
    { headers: { "Cache-Control": "no-store" } }
  );
}
