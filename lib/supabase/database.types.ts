// Placeholder de tipos. Una vez tengas el proyecto Supabase creado y el
// esquema de supabase/schema.sql aplicado, regenera este archivo con:
//
//   npx supabase gen types typescript --project-id TU_PROJECT_ID > lib/supabase/database.types.ts
//
// Mientras tanto, este tipo mínimo evita errores de compilación.
//
// Nota: cada tabla necesita "Relationships: []" y el esquema necesita
// "Views"/"Functions" (aunque estén vacíos) porque @supabase/supabase-js
// exige esa forma exacta (GenericSchema) para poder inferir los tipos de
// .from(...); si falta, todos los métodos colapsan a "never" en silencio.

export type Database = {
  public: {
    Tables: {
      families: {
        Row: {
          id: string;
          clerk_user_id: string;
          plan: "free" | "premium";
          created_at: string;
        };
        Insert: {
          id?: string;
          clerk_user_id: string;
          plan?: "free" | "premium";
          created_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["families"]["Insert"]>;
        Relationships: [];
      };
      children_profiles: {
        Row: {
          id: string;
          family_id: string;
          nombre: string;
          edad: number | null;
          avatar: string | null;
          color_favorito: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          family_id: string;
          nombre: string;
          edad?: number | null;
          avatar?: string | null;
          color_favorito?: string | null;
          created_at?: string;
        };
        Update: Partial<
          Database["public"]["Tables"]["children_profiles"]["Insert"]
        >;
        Relationships: [];
      };
      stories: {
        Row: {
          id: string;
          titulo: string;
          edad_recomendada: string | null;
          es_personalizable: boolean;
          portada_url: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          titulo: string;
          edad_recomendada?: string | null;
          es_personalizable?: boolean;
          portada_url?: string | null;
          created_at?: string;
        };
        Update: Partial<Database["public"]["Tables"]["stories"]["Insert"]>;
        Relationships: [];
      };
      sound_effects: {
        Row: {
          id: string;
          nombre: string;
          archivo_url: string;
          categoria: string | null;
        };
        Insert: {
          id?: string;
          nombre: string;
          archivo_url: string;
          categoria?: string | null;
        };
        Update: Partial<
          Database["public"]["Tables"]["sound_effects"]["Insert"]
        >;
        Relationships: [];
      };
      story_blocks: {
        Row: {
          id: string;
          story_id: string;
          orden: number;
          texto_bloque: string;
          sound_effect_id: string | null;
          trigger_keywords: string[];
          imagen_url: string | null;
        };
        Insert: {
          id?: string;
          story_id: string;
          orden: number;
          texto_bloque: string;
          sound_effect_id?: string | null;
          trigger_keywords?: string[];
          imagen_url?: string | null;
        };
        Update: Partial<
          Database["public"]["Tables"]["story_blocks"]["Insert"]
        >;
        Relationships: [];
      };
      story_variables: {
        Row: {
          id: string;
          story_id: string;
          variable_key: string;
          tipo: "texto" | "color" | "animal";
          opciones_sugeridas: string[];
        };
        Insert: {
          id?: string;
          story_id: string;
          variable_key: string;
          tipo: "texto" | "color" | "animal";
          opciones_sugeridas?: string[];
        };
        Update: Partial<
          Database["public"]["Tables"]["story_variables"]["Insert"]
        >;
        Relationships: [];
      };
      story_sessions: {
        Row: {
          id: string;
          child_profile_id: string;
          story_id: string;
          variables_usadas: Record<string, string>;
          completado: boolean;
          created_at: string;
        };
        Insert: {
          id?: string;
          child_profile_id: string;
          story_id: string;
          variables_usadas?: Record<string, string>;
          completado?: boolean;
          created_at?: string;
        };
        Update: Partial<
          Database["public"]["Tables"]["story_sessions"]["Insert"]
        >;
        Relationships: [];
      };
      subscriptions: {
        Row: {
          id: string;
          family_id: string;
          proveedor: "mercadopago" | "lemonsqueezy";
          estado: string;
          plan: string;
          fecha_renovacion: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          family_id: string;
          proveedor: "mercadopago" | "lemonsqueezy";
          estado?: string;
          plan: string;
          fecha_renovacion?: string | null;
          created_at?: string;
        };
        Update: Partial<
          Database["public"]["Tables"]["subscriptions"]["Insert"]
        >;
        Relationships: [];
      };
    };
    Views: Record<string, never>;
    Functions: Record<string, never>;
    Enums: Record<string, never>;
    CompositeTypes: Record<string, never>;
  };
};
