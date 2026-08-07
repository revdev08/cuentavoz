import "server-only";
import { createClient } from "@supabase/supabase-js";
import type { Database } from "./database.types";

/**
 * Cliente con la service_role key: ignora RLS.
 * Úsalo SOLO en código de servidor (route handlers, webhooks de pagos,
 * server actions administrativas) — nunca lo importes desde un
 * componente "use client".
 */
export function createServiceRoleClient() {
  return createClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    { auth: { persistSession: false } }
  );
}
