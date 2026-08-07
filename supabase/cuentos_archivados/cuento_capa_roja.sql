-- Cuento 3: "La Capa Roja". Estilo fábula clásica (Hermanos Grimm /
-- Caperucita), pero con escenario y moraleja propios: no juzgar a nadie
-- por su apariencia. Sigue el mismo arco de 7 pasos que los otros dos
-- cuentos (ver supabase/GUIA_NUEVOS_CUENTOS.md), en un bosque sombrío
-- muy distinto al jardín luminoso de "El Huerto Encantado" o al bosque
-- mágico de "El Bosque Encantado".
--
-- Script único y autocontenido: crea el catálogo de sonidos que necesita
-- (si no existe todavía), crea el cuento (si no existe todavía) y
-- reemplaza sus variables y bloques con la versión más reciente de este
-- archivo. No depende de ningún otro script haber corrido antes.
--
-- trigger_keywords: siempre UNA sola palabra por bloque, que sea
-- literalmente el sonido (no una palabra auxiliar de la frase) y que
-- aparezca tal cual en el texto, describiendo el mismo sonido que
-- dispara. Varios bloques de la primera versión de este cuento tenían un
-- sonido pegado a una escena que no lo pedía (ej. "destello mágico"
-- durante un diálogo sin nada que brille, o "arbustos" -- un sustantivo,
-- no un sonido -- disparando un crujido) -- esos bloques se quedaron sin
-- sonido, o se les agregó una frase corta con la palabra honesta, en vez
-- de forzar una que no tenía nada que ver.
--
-- No necesita sonidos nuevos: reutiliza los que ya existen en el
-- catálogo (creados aquí mismo si el cuento se instala solo).
--
-- Requiere haber corrido antes supabase/schema.sql.
-- Seguro de correr varias veces: los sonidos solo se insertan si no
-- existen todavía, y las variables/bloques del cuento se borran y se
-- vuelven a crear desde cero cada vez (no se tocan story_sessions ya
-- guardadas -- el cuento conserva siempre el mismo id).
--
-- Ejecutar en Supabase -> SQL Editor.

do $$
declare
  v_story_id uuid;
  v_crujido uuid;
  v_destello uuid;
  v_grillos uuid;
begin
  select id into v_story_id from stories where titulo = 'La Capa Roja' limit 1;

  if v_story_id is null then
    insert into stories (titulo, edad_recomendada, es_personalizable, portada_url)
    values ('La Capa Roja', '4-7 años', true, null)
    returning id into v_story_id;
  end if;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_niño', 'texto', '{}'),
    (v_story_id, 'color_favorito', 'color', array['rojo','azul','verde','amarillo','morado','rosado','dorado','turquesa','plateado','arcoíris']),
    -- Animales con "apariencia que asusta" a propósito -- son el corazón
    -- de la moraleja de este cuento. El campo sigue siendo texto libre,
    -- así que el niño puede escribir cualquier otro animal si prefiere.
    (v_story_id, 'animal_amigo', 'animal', array['lobo','oso','cuervo','murciélago','araña']);

  if not exists (select 1 from sound_effects where nombre = 'crujido') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('crujido', '/sounds/crujido.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'destello magico') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('destello magico', '/sounds/destello.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'grillos nocturnos') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
  end if;

  select id into v_crujido from sound_effects where nombre = 'crujido' limit 1;
  select id into v_destello from sound_effects where nombre = 'destello magico' limit 1;
  select id into v_grillos from sound_effects where nombre = 'grillos nocturnos' limit 1;

  delete from story_blocks where story_id = v_story_id;

  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
  values
    (v_story_id, 1,
      'Había una vez alguien muy querido por su abuela, llamado {nombre_niño}, a quien un día le regalaron una capa de color {color_favorito} con una capucha bien calientita. —Llévale esta canasta a tu abuela, que vive al otro lado del bosque —le dijo su mamá.',
      null, array[]::text[],
      '/images/capa-roja/01-capa.svg'),

    (v_story_id, 2,
      'El bosque del otro lado era distinto a cualquiera que hubiera visto: los árboles se enredaban entre sí y la luz apenas se colaba entre las hojas. Aun así, {nombre_niño} respiró hondo y siguió el sendero de piedras.',
      null, array[]::text[],
      '/images/capa-roja/02-bosque-sombrio.svg'),

    (v_story_id, 3,
      'El sendero se dividía en dos frente a una piedra cubierta de musgo. Alguien, hace mucho tiempo, había tallado unas palabras que brillaban tenuemente: "Solo cruza este bosque quien promete no juzgar por lo que ve, sino por lo que encuentra." {nombre_niño} pasó la mano sobre las letras, y en voz baja, prometió que sí.',
      v_destello, array['brillaban'],
      '/images/capa-roja/03-piedra.svg'),

    (v_story_id, 4,
      'El sendero se cortaba de repente frente a un puente viejo hecho de troncos y cuerdas, que crujía con cada paso. Con cuidado de no mirar hacia abajo, {nombre_niño} cruzó paso a paso hasta el otro lado.',
      v_crujido, array['crujía'],
      '/images/capa-roja/04-puente.svg'),

    (v_story_id, 5,
      'Detrás de un tronco caído, una sombra enorme se movió. Dos ojos amarillos brillaron entre las ramas, y un gruñido grave resonó por todo el bosque.',
      null, array[]::text[],
      '/images/capa-roja/05-sombra.svg'),

    (v_story_id, 6,
      '{nombre_niño} se acordó de su promesa. En vez de salir corriendo, respiró hondo y preguntó con voz temblorosa: —¿Quién eres? De entre las sombras salió {un_animal_amigo} {animal_amigo}, mucho más grande de lo que esperaba... pero con una mirada más triste que peligrosa.',
      null, array[]::text[],
      '/images/capa-roja/06-revelacion.svg'),

    (v_story_id, 7,
      '—Perdón por asustarte —dijo {el_animal_amigo} {animal_amigo} con vergüenza—. Todos huyen antes de conocerme. Solo quería compañía. {nombre_niño} sonrió y le ofreció caminar juntos el resto del camino.',
      null, array[]::text[],
      '/images/capa-roja/07-amistad.svg'),

    (v_story_id, 8,
      'Resultó que {el_animal_amigo} {animal_amigo} conocía cada rincón de ese bosque, y les mostró un atajo lleno de flores que {nombre_niño} nunca hubiera encontrado solo.',
      null, array[]::text[],
      '/images/capa-roja/08-atajo.svg'),

    (v_story_id, 9,
      'Pero de repente, el pie de {nombre_niño} tropezó con una raíz, ¡y la canasta salió volando! Las manzanas rodaron por todo el sendero y el pan cayó entre los arbustos con un crujido de ramas.',
      v_crujido, array['crujido'],
      '/images/capa-roja/09-canasta.svg'),

    (v_story_id, 10,
      '{el_animal_amigo} {animal_amigo} no dudó ni un segundo: con sus patas grandes, ayudó a recoger cada manzana y cada pedazo de pan, uno por uno, hasta que la canasta quedó llena otra vez.',
      null, array[]::text[],
      '/images/capa-roja/10-recoger.svg'),

    (v_story_id, 11,
      'Por fin, entre los árboles apareció una casita de techo puntiagudo con humo saliendo de la chimenea. Era la casa de la abuela, y las ventanas brillaban con una luz calientita.',
      null, array[]::text[],
      '/images/capa-roja/11-casita.svg'),

    (v_story_id, 12,
      'La abuela abrió la puerta y, al ver a {el_animal_amigo} {animal_amigo} tan grande detrás de {nombre_niño}, dio un pasito hacia atrás. —Tranquila, abuela —dijo {nombre_niño}—. Es mi amigo, y me ayudó todo el camino.',
      null, array[]::text[],
      '/images/capa-roja/12-abuela.svg'),

    (v_story_id, 13,
      'La abuela sonrió y los abrazó a los dos. —Cuando yo era niña, también me enseñaron esto —dijo—: las apariencias engañan. Lo que importa de verdad es lo que alguien lleva en el corazón.',
      null, array[]::text[],
      '/images/capa-roja/13-abrazo.svg'),

    (v_story_id, 14,
      'Los tres se sentaron junto a la chimenea a compartir el pan y las manzanas de la canasta, mientras afuera, entre el canto de los grillos, el bosque sombrío ya no parecía tan sombrío.',
      v_grillos, array['grillos'],
      '/images/capa-roja/14-chimenea.svg'),

    (v_story_id, 15,
      'Antes de irse, la abuela le dio a {nombre_niño} un botón dorado que brillaba levemente para la capa. —Para que recuerdes este día cada vez que te la pongas —le dijo, guiñándole un ojo.',
      v_destello, array['brillaba'],
      '/images/capa-roja/15-boton.svg'),

    (v_story_id, 16,
      'Ya era hora de volver a casa. {el_animal_amigo} {animal_amigo} acompañó a {nombre_niño} hasta la salida del bosque, entre el canto de los grillos, esta vez sin ninguna sombra que diera miedo.',
      v_grillos, array['grillos'],
      '/images/capa-roja/16-regreso.svg'),

    (v_story_id, 17,
      '—Ven a visitarme cuando quieras —le dijo {el_animal_amigo} {animal_amigo} con una sonrisa—. Ya sabes que las apariencias no dicen toda la verdad. {nombre_niño} le dio un abrazo bien fuerte antes de despedirse.',
      null, array[]::text[],
      '/images/capa-roja/17-despedida.svg'),

    (v_story_id, 18,
      '{nombre_niño} volvió a casa con la capa de color {color_favorito} y el botón dorado brillando en el pecho. Había aprendido que no hay que juzgar a nadie por su apariencia — a veces, quien parece el más temible, termina siendo el mejor amigo.',
      null, array[]::text[],
      '/images/capa-roja/18-final.svg');
end $$;
