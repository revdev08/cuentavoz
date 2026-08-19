import { auth, currentUser } from "@clerk/nextjs/server";
import { NextResponse } from "next/server";
import {
  crearSuscripcion,
  emailPuedeUsarPlanDesarrollador,
  esPlanKey,
  getMpToken,
} from "@/lib/mercadopago";
import { createServiceRoleClient } from "@/lib/supabase/server";

export async function GET(req: Request) {
  try {
    const { userId } = auth();
    const user = await currentUser();

    if (!userId || !user) {
      return NextResponse.redirect(new URL("/sign-in", req.url));
    }

    if (!getMpToken()) {
      return new NextResponse("MELI_ACCESS_TOKEN no configurado", { status: 500 });
    }

    const email = user.primaryEmailAddress?.emailAddress ?? user.emailAddresses[0]?.emailAddress;
    if (!email) {
      return new NextResponse("Tu cuenta necesita un correo electrónico", { status: 400 });
    }

    const url = new URL(req.url);
    const plan = url.searchParams.get("plan") ?? "mensual";
    if (!esPlanKey(plan)) {
      return new NextResponse('Plan inválido. Usa "mensual" o "semestral".', { status: 400 });
    }

    // El plan de pruebas nunca se anuncia. Una persona que descubra la URL
    // recibe 404 salvo que su correo principal esté en la lista privada.
    if (plan === "desarrollador" && !emailPuedeUsarPlanDesarrollador(email)) {
      return new NextResponse("No encontrado", { status: 404 });
    }

    const supabase = createServiceRoleClient();
    let { data: family, error: familyError } = await supabase
      .from("families")
      .select("id, plan")
      .eq("clerk_user_id", userId)
      .maybeSingle();

    if (familyError) throw familyError;

    if (!family) {
      const result = await supabase
        .from("families")
        .insert({ clerk_user_id: userId, plan: "inactive" })
        .select("id, plan")
        .single();
      if (result.error) throw result.error;
      family = result.data;
    }

    if (family.plan === "premium") {
      return NextResponse.redirect(new URL("/dashboard", req.url));
    }

    const appUrl = (process.env.NEXT_PUBLIC_APP_URL ?? url.origin).replace(/\/$/, "");
    const suscripcion = await crearSuscripcion({
      planKey: plan,
      clerkUserId: userId,
      familyId: family.id,
      email,
      appUrl,
    });

    const { error: subscriptionError } = await supabase.from("subscriptions").upsert(
      {
        family_id: family.id,
        proveedor: "mercadopago",
        estado: "pending",
        plan,
        mp_preapproval_id: suscripcion.id,
        fecha_renovacion: null,
        updated_at: new Date().toISOString(),
      },
      { onConflict: "family_id,proveedor" }
    );

    if (subscriptionError) throw subscriptionError;

    return NextResponse.redirect(suscripcion.init_point!);
  } catch (error: unknown) {
    const detalle = error instanceof Error ? error.message : String(error);
    console.error("[Mercado Pago checkout]", detalle);
    return NextResponse.json(
      { error: "No pudimos iniciar el pago", detalle },
      { status: 500 }
    );
  }
}
