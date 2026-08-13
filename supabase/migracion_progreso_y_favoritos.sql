-- Agrega lo necesario para el dashboard nuevo (sidebar + "Últimos
-- escuchados" + favoritos + filtro por categoría):
--
-- 1. stories.categoria -- para las píldoras de filtro de la biblioteca.
-- 2. story_sessions.ultimo_bloque / updated_at -- para poder "continuar
--    donde quedó" y ordenar "Últimos escuchados" por fecha real. Pasa a
--    haber UNA fila por (niño, cuento) que se actualiza en cada avance,
--    en vez de una fila nueva cada vez que se completa el cuento.
-- 3. story_favorites -- tabla nueva para el corazón de favoritos.
--
-- Seguro de correr varias veces.
--
-- Ejecutar en Supabase -> SQL Editor.

alter table stories add column if not exists categoria text;

-- Categorías de los cuentos ya publicados (por slug o título, según cuál
-- tenga cada uno). Idempotente: siempre deja la categoría en el valor
-- de aquí, sin importar cuántas veces se corra.
update stories set categoria = 'Valores' where titulo = 'La gota de tinta impaciente';
update stories set categoria = 'Valores' where slug = 'la-cuchara-que-aprendio-a-hacer-sitio';
update stories set categoria = 'Aventuras' where slug = 'la-brujula-que-sonaba-con-lo-desconocido';
update stories set categoria = 'Sueños' where slug = 'la-vela-que-creia-que-no-alcanzaba';

alter table story_sessions add column if not exists ultimo_bloque int not null default 0;
alter table story_sessions add column if not exists updated_at timestamptz not null default now();

-- Antes de poner el unique constraint, si ya existían varias sesiones
-- para el mismo (niño, cuento) -- ej. de haberlo completado más de una
-- vez -- nos quedamos solo con la más reciente, para no romper el
-- constraint con filas duplicadas.
delete from story_sessions a
using story_sessions b
where a.child_profile_id = b.child_profile_id
  and a.story_id = b.story_id
  and a.created_at < b.created_at;

do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'story_sessions_child_profile_id_story_id_key'
  ) then
    alter table story_sessions
      add constraint story_sessions_child_profile_id_story_id_key
      unique (child_profile_id, story_id);
  end if;
end $$;

create table if not exists story_favorites (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references families(id) on delete cascade,
  story_id uuid not null references stories(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (family_id, story_id)
);

alter table story_favorites enable row level security;

drop policy if exists "familia gestiona sus favoritos" on story_favorites;
create policy "familia gestiona sus favoritos"
  on story_favorites for all
  using (family_id in (select id from families where clerk_user_id = auth.jwt() ->> 'sub'));
