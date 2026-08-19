import { auth, currentUser } from "@clerk/nextjs/server";
import { redirect } from "next/navigation";
import { AppHeader } from "@/components/AppHeader";
import { SeccionPrecios } from "@/components/SeccionPrecios";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { emailPuedeUsarPlanDesarrollador } from "@/lib/mercadopago";

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

  if (family?.plan === "premium") redirect("/dashboard");

  const { data: subscription } = family
    ? await supabase
        .from("subscriptions")
        .select("estado, plan")
        .eq("family_id", family.id)
        .eq("proveedor", "mercadopago")
        .maybeSingle()
    : { data: null };

  return (
    <div className="min-h-screen bg-pergamino-50 dark:bg-tinta-950">
      <AppHeader />
      <main className="px-4 pb-16">
        {(searchParams?.checkout === "pendiente" || subscription?.estado === "pending") && (
          <div className="mx-auto mt-6 max-w-2xl rounded-2xl border border-oro-400/40 bg-oro-100 px-5 py-4 text-center text-sm text-tinta-900 dark:bg-oro-500/10 dark:text-pergamino-50">
            Mercado Pago está confirmando tu suscripción. Cuando sea autorizada,
            tendrás acceso al dashboard. Recarga esta página en unos segundos.
          </div>
        )}
        <SeccionPrecios mostrarDesarrollador={mostrarDesarrollador} />
      </main>
    </div>
  );
}
