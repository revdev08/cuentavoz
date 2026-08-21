import { auth } from "@clerk/nextjs/server";
import { NextResponse } from "next/server";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { tieneAccesoPremium } from "@/lib/suscripciones/acceso";

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
    .select("estado, fecha_renovacion")
    .eq("family_id", family.id)
    .eq("proveedor", "mercadopago")
    .maybeSingle();

  if (subscriptionError) {
    return NextResponse.json({ activo: false }, { status: 500 });
  }

  return NextResponse.json(
    {
      activo: tieneAccesoPremium(family.plan, subscription),
      estado: subscription?.estado ?? "pending",
    },
    { headers: { "Cache-Control": "no-store" } }
  );
}
