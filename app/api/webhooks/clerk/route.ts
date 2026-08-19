import { headers } from "next/headers";
import { Webhook } from "svix";
import { createServiceRoleClient } from "@/lib/supabase/server";

/**
 * Recibe el evento "user.created" de Clerk y crea la fila correspondiente
 * en la tabla `families` de Supabase.
 *
 * Configurar en Clerk Dashboard -> Webhooks:
 *   URL: https://www.cuentavoz.com/api/webhooks/clerk
 *   Eventos: user.created
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

  let event: { type: string; data: { id: string } };
  try {
    event = wh.verify(body, {
      "svix-id": svixId,
      "svix-timestamp": svixTimestamp,
      "svix-signature": svixSignature,
    }) as typeof event;
  } catch {
    return new Response("Firma inválida", { status: 400 });
  }

  if (event.type === "user.created") {
    const supabase = createServiceRoleClient();
    const { error } = await supabase
      .from("families")
      .upsert(
        { clerk_user_id: event.data.id, plan: "inactive" },
        { onConflict: "clerk_user_id", ignoreDuplicates: true }
      );

    if (error) {
      console.error("Error creando familia en Supabase:", error);
      return new Response("Error de base de datos", { status: 500 });
    }
  }

  return new Response("ok", { status: 200 });
}
