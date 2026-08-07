import { redirect } from "next/navigation";
import { auth } from "@clerk/nextjs/server";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { StoryPlayer } from "@/components/StoryPlayer";

export default async function StoryPage({
  params,
}: {
  params: { id: string };
}) {
  const { userId } = auth();
  const supabase = createServiceRoleClient();

  const { data: story } = await supabase
    .from("stories")
    .select("*")
    .eq("id", params.id)
    .maybeSingle();

  if (!story) {
    redirect("/dashboard");
  }

  const [{ data: bloques }, { data: variables }, { data: familia }] = await Promise.all([
    supabase
      .from("story_blocks")
      .select("*")
      .eq("story_id", story.id)
      .order("orden", { ascending: true }),
    supabase.from("story_variables").select("*").eq("story_id", story.id),
    supabase.from("families").select("id").eq("clerk_user_id", userId!).maybeSingle(),
  ]);

  const sonidoIds = Array.from(
    new Set((bloques ?? []).map((b) => b.sound_effect_id).filter((id): id is string => !!id))
  );

  const { data: sonidos } = sonidoIds.length
    ? await supabase.from("sound_effects").select("*").in("id", sonidoIds)
    : { data: [] };

  const { data: hijos } = familia
    ? await supabase.from("children_profiles").select("*").eq("family_id", familia.id)
    : { data: [] };

  const bloquesConSonido = (bloques ?? []).map((b) => ({
    ...b,
    sonido: sonidos?.find((s) => s.id === b.sound_effect_id) ?? null,
  }));

  return (
    <StoryPlayer
      story={story}
      bloques={bloquesConSonido}
      variables={variables ?? []}
      hijos={hijos ?? []}
    />
  );
}
