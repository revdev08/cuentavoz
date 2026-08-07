-- Cuento 1: "El Bosque Encantado". Moraleja: cumplir una promesa, incluso
-- cuando cuesta trabajo, es lo que abre la verdadera magia del bosque.
--
-- Script único y autocontenido: crea el catálogo de sonidos que necesita
-- (si no existe todavía), crea el cuento (si no existe todavía) y
-- reemplaza sus variables y bloques con la versión más reciente de este
-- archivo. No depende de ningún otro script haber corrido antes.
--
-- trigger_keywords: siempre UNA sola palabra por bloque. Tiene que (1)
-- aparecer tal cual en el texto de ESE bloque, (2) describir honestamente
-- el mismo sonido que dispara -- no una palabra auxiliar de la frase
-- (camino, nariz, puerta, corazón) ni un color/adjetivo que no sea el
-- propio sonido (un "botón dorado" no es un destello a menos que el
-- texto diga que brilla). Si un bloque no tiene ninguna palabra así de
-- honesta, se deja sin sonido (`sound_effect_id = null`,
-- `trigger_keywords = '{}'`) en vez de forzar una que no pega.
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
begin
  select id into v_story_id from stories where titulo = 'El Bosque Encantado' limit 1;

  if v_story_id is null then
    insert into stories (titulo, edad_recomendada, es_personalizable, portada_url)
    values ('El Bosque Encantado', '4-7 años', true, null)
    returning id into v_story_id;
  end if;

  -- Catálogo de sonidos que necesita este cuento.
  if not exists (select 1 from sound_effects where nombre = 'pasos sobre hojas') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('pasos sobre hojas', '/sounds/pasos-hojas.mp3', 'efecto');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'viento entre arboles') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('viento entre arboles', '/sounds/viento.mp3', 'ambiente');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'lluvia magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('lluvia magica', '/sounds/lluvia.mp3', 'ambiente');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'pajaros del bosque') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'campanita magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('campanita magica', '/sounds/campanita.mp3', 'efecto');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'buho sabio') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('buho sabio', '/sounds/buho.mp3', 'efecto');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'arroyo') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('arroyo', '/sounds/arroyo.mp3', 'ambiente');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'chapoteo') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
  end if;

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

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_niño', 'texto', '{}'),
    (v_story_id, 'color_favorito', 'color', array['rojo','azul','verde','amarillo','morado','rosado','dorado','turquesa','plateado','arcoíris']),
    (v_story_id, 'animal_amigo', 'animal', array['conejo','zorro','búho','ardilla','mariposa','dragón','unicornio','tigre','delfín','gato']);

  delete from story_blocks where story_id = v_story_id;

  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
  values
    (v_story_id, 1,
      'Había una vez alguien muy curioso llamado {nombre_niño}, que amaba las aventuras más que cualquier otra cosa. Un día, caminando cerca de su casa, encontró un sendero cubierto de hojas doradas que nunca había visto antes.',
      (select id from sound_effects where nombre = 'pasos sobre hojas' limit 1),
      array['hojas'],
      '/images/bosque-encantado/01-sendero.svg'),

    (v_story_id, 2,
      'El sendero lo llevó directo a un bosque enorme y misterioso. Apenas puso un pie adentro, sintió el viento moverse entre los árboles más altos, como si el bosque entero le estuviera dando la bienvenida.',
      (select id from sound_effects where nombre = 'viento entre arboles' limit 1),
      array['viento'],
      '/images/bosque-encantado/02-viento.svg'),

    (v_story_id, 3,
      'El camino se dividía en dos, y entre las hojas brilló una lucecita diminuta. —Este bosque solo muestra su verdadera magia a quien cumple su palabra —dijo la luz con una vocecita suave—. ¿Me prometes que, si encuentras a alguien que necesita ayuda hoy, lo vas a ayudar, aunque sea difícil? {nombre_niño} pensó un momentito, y prometió que sí.',
      (select id from sound_effects where nombre = 'destello magico' limit 1),
      array['brilló'],
      '/images/bosque-encantado/09-cruce.svg'),

    (v_story_id, 4,
      'Frente a él apareció un arroyo pequeño y transparente, con piedras redondas asomando entre el agua. Se quedó un momento escuchando cómo el agua corría, cantando su propia canción sin palabras.',
      (select id from sound_effects where nombre = 'arroyo' limit 1),
      array['arroyo'],
      '/images/bosque-encantado/10-arroyo.svg'),

    (v_story_id, 5,
      'Para cruzar al otro lado, {nombre_niño} tuvo que saltar de piedra en piedra, con mucho cuidado de no resbalar. En el último salto, ¡splash!, una gotita traviesa saltó y le hizo cosquillas en la nariz.',
      (select id from sound_effects where nombre = 'chapoteo' limit 1),
      array['splash'],
      '/images/bosque-encantado/11-chapoteo.svg'),

    (v_story_id, 6,
      'Al otro lado del arroyo, escuchó un crujido entre unos arbustos de color {color_favorito}. Pero esta vez no sonaba alegre: era un quejido bajito, como si alguien tuviera miedo y estuviera atrapado.',
      (select id from sound_effects where nombre = 'crujido' limit 1),
      array['crujido'],
      '/images/bosque-encantado/12-crujido.svg'),

    (v_story_id, 7,
      'Entre unas ramas enredadas, algo temblaba de miedo sin poder escapar: {un_animal_amigo} {animal_amigo}. {nombre_niño} se acordó de su promesa. Aunque las ramas picaban un poco, se acercó despacito y, con mucho cuidado, ayudó a {animal_amigo} a salir.',
      null,
      array[]::text[],
      '/images/bosque-encantado/05-amigo.svg'),

    (v_story_id, 8,
      'Sin querer separarse nunca más, {nombre_niño} y {el_animal_amigo} {animal_amigo} siguieron caminando juntos y felices. Los pájaros del bosque cantaban una melodía especial, como si celebraran esa nueva amistad.',
      (select id from sound_effects where nombre = 'pajaros del bosque' limit 1),
      array['pájaros'],
      '/images/bosque-encantado/04-pajaros.svg'),

    (v_story_id, 9,
      'De repente empezó a caer una lluvia suave y tibia, pero ni una sola gota los mojaba. ¡Era una lluvia mágica! El bosque parecía estar celebrando que {nombre_niño} había cumplido su palabra.',
      (select id from sound_effects where nombre = 'lluvia magica' limit 1),
      array['lluvia'],
      '/images/bosque-encantado/03-lluvia.svg'),

    (v_story_id, 10,
      'Pero mientras seguían caminando, el cielo se puso gris y una neblina espesa cubrió el sendero por completo. {nombre_niño} sintió un poquito de miedo: no sabía para dónde seguir.',
      null,
      array[]::text[],
      '/images/bosque-encantado/13-neblina.svg'),

    (v_story_id, 11,
      'Esta vez fue {el_animal_amigo} {animal_amigo} quien ayudó a {nombre_niño}: conocía el bosque de memoria, y siguiendo su nariz y el canto de los pájaros, encontró el camino escondido entre la neblina.',
      (select id from sound_effects where nombre = 'pajaros del bosque' limit 1),
      array['pájaros'],
      '/images/bosque-encantado/04-pajaros.svg'),

    (v_story_id, 12,
      'Guiados por {el_animal_amigo} {animal_amigo}, llegaron hasta un árbol gigante y muy antiguo. Al tocar su tronco con cuidado, sonó una campanita mágica que abrió una puertecita secreta entre sus raíces.',
      (select id from sound_effects where nombre = 'campanita magica' limit 1),
      array['campanita'],
      '/images/bosque-encantado/06-campanita.svg'),

    (v_story_id, 13,
      'Adentro, todo brillaba con una luz suave y dorada. En el centro del cuarto había un cofre pequeño, que solo se abría si alguien decía, en voz alta y de corazón, algo bonito sobre su amigo.',
      (select id from sound_effects where nombre = 'destello magico' limit 1),
      array['brillaba'],
      '/images/bosque-encantado/14-cofre.svg'),

    (v_story_id, 14,
      'Justo en ese momento, un búho muy sabio apareció en una rama y les guiñó un ojo. —Una promesa cumplida —dijo con voz suave— vale más que cualquier tesoro. Por eso el bosque te abrió sus puertas hoy, {nombre_niño}.',
      (select id from sound_effects where nombre = 'buho sabio' limit 1),
      array['búho'],
      '/images/bosque-encantado/07-buho.svg'),

    (v_story_id, 15,
      '{nombre_niño} pensó en {animal_amigo} y dijo: —Qué suerte haberte encontrado, y me alegra mucho haberte ayudado. En ese instante, el cofre se abrió solito, y adentro brillaba una piedra mágica de color {color_favorito}, un regalo para recordar esa promesa cumplida.',
      (select id from sound_effects where nombre = 'destello magico' limit 1),
      array['brillaba'],
      '/images/bosque-encantado/15-regalo.svg'),

    (v_story_id, 16,
      'Ya era hora de volver a casa. Caminaron de regreso tomados de la mano —bueno, de la mano y de la pata— mientras los grillos empezaban a cantar su canción de la noche.',
      (select id from sound_effects where nombre = 'grillos nocturnos' limit 1),
      array['grillos'],
      '/images/bosque-encantado/16-regreso.svg'),

    (v_story_id, 17,
      'Al llegar al final del sendero, {el_animal_amigo} {animal_amigo} le dio un abrazo bien apretado. —Gracias por cumplir tu promesa —le dijo—. Ven a visitarme cuando quieras, este bosque siempre va a estar aquí, esperándote.',
      null,
      array[]::text[],
      '/images/bosque-encantado/17-despedida.svg'),

    (v_story_id, 18,
      '{nombre_niño} volvió a casa con la piedra mágica guardada en el bolsillo y una sonrisa enorme. Había aprendido que cumplir una promesa, por pequeña que sea, es una de las cosas más valientes que se pueden hacer — y por eso, el Bosque Encantado siempre lo estaría esperando.',
      null,
      array[]::text[],
      '/images/bosque-encantado/08-final.svg');
end $$;
