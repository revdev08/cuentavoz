-- Agrega la columna "slug" a stories, requerida por el nuevo sistema de
-- generación de cuentos (escritor-cuentavoz/04-reglas-tecnicas.md): a
-- partir de ahora los cuentos se identifican por slug, nunca por título
-- (el título puede cambiar en el futuro, el slug nunca).
--
-- No afecta filas existentes: la columna queda en null para cualquier
-- cuento viejo que no la tenga (el unique constraint permite múltiples
-- null en Postgres, así que esto no falla aunque ya existan cuentos).
--
-- Seguro de correr varias veces.
--
-- Ejecutar en Supabase -> SQL Editor.

alter table stories add column if not exists slug text unique;
