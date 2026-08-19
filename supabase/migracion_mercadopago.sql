-- Ejecutar una sola vez en Supabase SQL Editor antes de habilitar checkout.
-- El registro sigue creando families.plan = 'free'. Premium solo lo concede
-- el webhook después de confirmar status='authorized' con Mercado Pago.

alter table subscriptions
  add column if not exists mp_preapproval_id text,
  add column if not exists updated_at timestamptz not null default now();

create unique index if not exists subscriptions_family_provider_unique
  on subscriptions (family_id, proveedor);

create unique index if not exists subscriptions_mp_preapproval_unique
  on subscriptions (mp_preapproval_id)
  where mp_preapproval_id is not null;
