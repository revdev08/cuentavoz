-- Guarda el correo principal de Clerk para identificar cada familia en BD.
-- Los usuarios existentes se completan al volver a iniciar sesión.

alter table families
  add column if not exists email text;

create index if not exists families_email_idx
  on families (lower(email));
