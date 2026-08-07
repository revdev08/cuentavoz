-- Borra TODO el contenido narrativo (cuentos, sus bloques, sus
-- variables y las sesiones de lectura guardadas) para empezar el
-- catálogo desde cero. NO toca el catálogo de sonidos (sound_effects),
-- ni families/children_profiles/subscriptions -- eso se queda igual.
--
-- Orden importa: story_sessions no tiene "on delete cascade" desde
-- stories (a propósito, para no perder sesiones por accidente en el día
-- a día), así que hay que borrarla primero a mano. story_blocks y
-- story_variables sí tienen cascade, así que se van solas al borrar
-- stories.
--
-- Seguro de correr aunque ya esté vacío -- un DELETE sobre 0 filas no
-- falla.
--
-- Ejecutar en Supabase -> SQL Editor.

delete from story_sessions;
delete from stories; -- cascada automática sobre story_blocks y story_variables
