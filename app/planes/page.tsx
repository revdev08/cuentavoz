import { auth, currentUser } from "@clerk/nextjs/server";
import { redirect } from "next/navigation";
import { AppHeader } from "@/components/AppHeader";
import { SeccionPrecios } from "@/components/SeccionPrecios";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { emailPuedeUsarPlanDesarrollador } from "@/lib/mercadopago";
import { tieneAccesoPremium } from "@/lib/suscripciones/acceso";
import { ConfirmacionPago } from "@/components/ConfirmacionPago";

export default async function PlanesPage({
  searchParams,
}: {
  searchParams?: { checkout?: string };
}) {
  const { userId } = auth();
  if (!userId) redirect("/sign-in");

  const user = await currentUser();
  const email = user?.primaryEmailAddress?.emailAddress.toLowerCase() ?? "";
  const mostrarDesarrollador = emailPuedeUsarPlanDesarrollador(email);

  const supabase = createServiceRoleClient();
  let { data: family } = await supabase
    .from("families")
    .select("id, email, plan")
    .eq("clerk_user_id", userId)
    .maybeSingle();

  if (!family) {
    const result = await supabase
      .from("families")
      .insert({ clerk_user_id: userId, email: email || null, plan: "inactive" })
      .select("id, email, plan")
      .single();
    family = result.data;
  } else if (email && family.email !== email) {
    await supabase.from("families").update({ email }).eq("id", family.id);
  }

  const { data: subscription } = family
    ? await supabase
        .from("subscriptions")
        .select("estado, plan, fecha_renovacion")
        .eq("family_id", family.id)
        .eq("proveedor", "mercadopago")
        .maybeSingle()
    : { data: null };

  if (family && tieneAccesoPremium(family.plan, subscription)) {
    redirect("/dashboard");
  }
  if (family?.plan === "premium") {
    await supabase.from("families").update({ plan: "inactive" }).eq("id", family.id);
  }

  return (
    <div className="min-h-screen bg-pergamino-50 dark:bg-tinta-950">
      <AppHeader />
      <main className="px-4 pb-16">
        {(searchParams?.checkout?.startsWith("pendiente") || subscription?.estado === "pending") && (
          <ConfirmacionPago />
        )}
        <SeccionPrecios mostrarDesarrollador={mostrarDesarrollador} />
      </main>
    </div>
  );
}
