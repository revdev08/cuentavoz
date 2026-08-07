-- Esquema inicial MVP. Ejecutar en Supabase -> SQL Editor.
-- Requiere haber configurado Clerk como proveedor JWT externo
-- (Authentication -> Providers -> Third Party) para que auth.jwt() funcione.

create table if not exists families (
  id uuid primary key default gen_random_uuid(),
  clerk_user_id text unique not null,
  plan text not null default 'free' check (plan in ('free', 'premium')),
  created_at timestamptz not null default now()
);

create table if not exists children_profiles (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references families(id) on delete cascade,
  nombre text not null,
  edad int,
  avatar text,
  color_favorito text,
  created_at timestamptz not null default now()
);

create table if not exists sound_effects (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  archivo_url text not null,
  categoria text
);

create table if not exists stories (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  slug text unique,
  edad_recomendada text,
  es_personalizable boolean not null default false,
  portada_url text,
  created_at timestamptz not null default now()
);

create table if not exists story_blocks (
  id uuid primary key default gen_random_uuid(),
  story_id uuid not null references stories(id) on delete cascade,
  orden int not null,
  texto_bloque text not null,
  sound_effect_id uuid references sound_effects(id),
  trigger_keywords text[] default '{}',
  imagen_url text
);

create table if not exists story_variables (
  id uuid primary key default gen_random_uuid(),
  story_id uuid not null references stories(id) on delete cascade,
  variable_key text not null,
  tipo text not null check (tipo in ('texto', 'color', 'animal')),
  opciones_sugeridas text[] default '{}'
);

create table if not exists story_sessions (
  id uuid primary key default gen_random_uuid(),
  child_profile_id uuid not null references children_profiles(id) on delete cascade,
  story_id uuid not null references stories(id),
  variables_usadas jsonb default '{}',
  completado boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists subscriptions (
  id uuid primary key default gen_random_uuid(),
  family_id uuid not null references families(id) on delete cascade,
  proveedor text not null check (proveedor in ('mercadopago', 'lemonsqueezy')),
  estado text not null default 'active',
  plan text not null,
  fecha_renovacion timestamptz,
  created_at timestamptz not null default now()
);

-- Row Level Security: cada familia solo ve sus propios datos.
alter table families enable row level security;
alter table children_profiles enable row level security;
alter table story_sessions enable row level security;
alter table subscriptions enable row level security;

-- stories, story_blocks, sound_effects y story_variables son catálogo
-- público de lectura (todo usuario logueado puede leerlos, solo el
-- backend con service_role los escribe).
alter table stories enable row level security;
alter table story_blocks enable row level security;
alter table sound_effects enable row level security;
alter table story_variables enable row level security;

create policy "familia ve su propio registro"
  on families for select
  using (clerk_user_id = auth.jwt() ->> 'sub');

create policy "familia gestiona sus perfiles de hijos"
  on children_profiles for all
  using (family_id in (select id from families where clerk_user_id = auth.jwt() ->> 'sub'));

create policy "familia gestiona sus sesiones de cuento"
  on story_sessions for all
  using (
    child_profile_id in (
      select cp.id from children_profiles cp
      join families f on f.id = cp.family_id
      where f.clerk_user_id = auth.jwt() ->> 'sub'
    )
  );

create policy "familia ve su propia suscripcion"
  on subscriptions for select
  using (family_id in (select id from families where clerk_user_id = auth.jwt() ->> 'sub'));

create policy "catalogo de cuentos es de lectura publica"
  on stories for select using (true);

create policy "catalogo de bloques es de lectura publica"
  on story_blocks for select using (true);

create policy "catalogo de sonidos es de lectura publica"
  on sound_effects for select using (true);

create policy "catalogo de variables es de lectura publica"
  on story_variables for select using (true);
