"use client";

import { createClient } from "@supabase/supabase-js";
import { useSession } from "@clerk/nextjs";
import { useMemo } from "react";
import type { Database } from "./database.types";

/**
 * Hook que devuelve un cliente Supabase autenticado con el JWT de Clerk.
 *
 * Requiere configurar en Clerk Dashboard -> JWT Templates una plantilla
 * llamada "supabase" (ver README paso 4), y en Supabase -> Authentication
 * -> Providers activar el proveedor JWT de terceros con el issuer de Clerk.
 *
 * Esto permite que las políticas RLS de Supabase usen auth.jwt() ->> 'sub'
 * para saber qué familia está haciendo la petición, sin manejar dos
 * sistemas de sesión por separado.
 */
export function useSupabaseClient() {
  const { session } = useSession();

  return useMemo(() => {
    return createClient<Database>(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        global: {
          fetch: async (url, options = {}) => {
            const token = await session?.getToken({ template: "supabase" });
            const headers = new Headers(options?.headers);
            if (token) headers.set("Authorization", `Bearer ${token}`);
            return fetch(url, { ...options, headers });
          },
        },
      }
    );
  }, [session]);
}
