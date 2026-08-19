import { headers } from "next/headers";
import { Webhook } from "svix";
import { createServiceRoleClient } from "@/lib/supabase/server";

/**
 * Recibe user.created/user.updated de Clerk y sincroniza el ID y el correo
 * principal en la tabla `families` de Supabase.
 *
 * Configurar en Clerk Dashboard -> Webhooks:
 *   URL: https://www.cuentavoz.com/api/webhooks/clerk
 *   Eventos: user.created, user.updated
 * Copiar el "Signing Secret" a CLERK_WEBHOOK_SECRET en .env
 *
 * Requiere instalar "svix": npm install svix
 */
export async function POST(req: Request) {
  const secret = process.env.CLERK_WEBHOOK_SECRET;
  if (!secret) {
    return new Response("Falta CLERK_WEBHOOK_SECRET", { status: 500 });
  }

  const headerPayload = headers();
  const svixId = headerPayload.get("svix-id");
  const svixTimestamp = headerPayload.get("svix-timestamp");
  const svixSignature = headerPayload.get("svix-signature");

  if (!svixId || !svixTimestamp || !svixSignature) {
    return new Response("Encabezados svix faltantes", { status: 400 });
  }

  const body = await req.text();
  const wh = new Webhook(secret);

  let event: {
    type: string;
    data: {
      id: string;
      primary_email_address_id?: string | null;
      email_addresses?: Array<{ id: string; email_address: string }>;
    };
  };
  try {
    event = wh.verify(body, {
      "svix-id": svixId,
      "svix-timestamp": svixTimestamp,
      "svix-signature": svixSignature,
    }) as typeof event;
  } catch {
    return new Response("Firma inválida", { status: 400 });
  }

  if (event.type === "user.created" || event.type === "user.updated") {
    const primaryEmail = event.data.email_addresses
      ?.find((item) => item.id === event.data.primary_email_address_id)
      ?.email_address.toLowerCase();
    const supabase = createServiceRoleClient();
    const { error } = await supabase
      .from("families")
      .upsert(
        { clerk_user_id: event.data.id, email: primaryEmail ?? null },
        { onConflict: "clerk_user_id" }
      );

    if (error) {
      console.error("Error creando familia en Supabase:", error);
      return new Response("Error de base de datos", { status: 500 });
    }
  }

  return new Response("ok", { status: 200 });
}
