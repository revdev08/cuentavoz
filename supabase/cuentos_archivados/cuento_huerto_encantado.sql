-- Cuento 2: "El Huerto Encantado". Moraleja: compartir no es perder, es
-- multiplicar. Sigue el mismo arco de fábula de 7 pasos que "El Bosque
-- Encantado" (ver supabase/GUIA_NUEVOS_CUENTOS.md), en un escenario
-- nuevo para variar la biblioteca.
--
-- Script único y autocontenido: crea el catálogo de sonidos que necesita
-- (si no existe todavía), crea el cuento (si no existe todavía) y
-- reemplaza sus variables y bloques con la versión más reciente de este
-- archivo. No depende de ningún otro script haber corrido antes.
--
-- trigger_keywords: siempre UNA sola palabra por bloque, que sea
-- literalmente el sonido (no una palabra auxiliar de la frase) y que
-- aparezca tal cual en el texto -- es la misma palabra que se subraya
-- y se puede tocar en el lector. Además tiene que describir el MISMO
-- sonido que dispara (no basta con que "suene bonito" cerca del efecto:
-- "dorado" no es un sonido, aunque el bloque tenga un destello mágico
-- asignado). Si un bloque no tiene ninguna palabra que honestamente
-- evoque su sonido, mejor quitarle el sonido que forzar una palabra que
-- no tiene nada que ver (por eso el bloque 1 se quedó sin sonido: "pasos
-- sobre hojas" no encajaba con abrir una puertita de madera entre
-- flores; y el bloque 3, con la tortuga de caparazón dorado, tampoco --
-- "dorado" es un color, no un destello).
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
  v_destello uuid;
  v_crujido uuid;
  v_pajaros uuid;
  v_abejas uuid;
  v_grillos uuid;
  v_campanita uuid;
begin
  select id into v_story_id from stories where titulo = 'El Huerto Encantado' limit 1;

  if v_story_id is null then
    insert into stories (titulo, edad_recomendada, es_personalizable, portada_url)
    values ('El Huerto Encantado', '4-7 años', true, null)
    returning id into v_story_id;
  end if;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_niño', 'texto', '{}'),
    (v_story_id, 'color_favorito', 'color', array['rojo','azul','verde','amarillo','morado','rosado','dorado','turquesa','plateado','arcoíris']),
    (v_story_id, 'animal_amigo', 'animal', array['conejo','zorro','búho','ardilla','mariposa','dragón','unicornio','tigre','delfín','gato']);

  -- Sonidos reutilizados del catálogo (ya existen desde "El Bosque Encantado")
  if not exists (select 1 from sound_effects where nombre = 'destello magico') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('destello magico', '/sounds/destello.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'crujido') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('crujido', '/sounds/crujido.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'pajaros del bosque') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'grillos nocturnos') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'campanita magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('campanita magica', '/sounds/campanita.mp3', 'efecto');
  end if;

  -- Único sonido nuevo que necesita este cuento
  if not exists (select 1 from sound_effects where nombre = 'abejas del huerto') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('abejas del huerto', '/sounds/abejas.mp3', 'ambiente');
  end if;

  select id into v_destello from sound_effects where nombre = 'destello magico' limit 1;
  select id into v_crujido from sound_effects where nombre = 'crujido' limit 1;
  select id into v_pajaros from sound_effects where nombre = 'pajaros del bosque' limit 1;
  select id into v_grillos from sound_effects where nombre = 'grillos nocturnos' limit 1;
  select id into v_campanita from sound_effects where nombre = 'campanita magica' limit 1;
  select id into v_abejas from sound_effects where nombre = 'abejas del huerto' limit 1;

  delete from story_blocks where story_id = v_story_id;

  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
  values
    (v_story_id, 1,
      'Había una vez alguien muy curioso llamado {nombre_niño}, a quien le encantaba explorar cada rincón de su jardín. Un día, detrás de las plantas de su abuela, encontró una puertita de madera cubierta de flores que nunca había visto antes.',
      null, array[]::text[],
      '/images/huerto-encantado/01-puertita.svg'),

    (v_story_id, 2,
      'Al abrir la puertita, {nombre_niño} descubrió un huerto enorme y mágico, lleno de árboles con frutas de colores imposibles: moradas, doradas, y brillantes como piedras preciosas.',
      null, array[]::text[],
      '/images/huerto-encantado/02-huerto.svg'),

    (v_story_id, 3,
      'En el centro de un rosal, una tortuga viejita de caparazón dorado le habló con voz calmada: —Este huerto solo florece para quien comparte lo que encuentra. ¿Me prometes que, si hallas algo especial, lo vas a compartir? {nombre_niño} pensó un momentito, y prometió que sí.',
      null, array[]::text[],
      '/images/huerto-encantado/03-tortuga.svg'),

    (v_story_id, 4,
      'Un poco más adelante, un seto de enredaderas gigantes le cerraba el paso. Tuvo que agacharse y abrirse camino entre las hojas, con mucho cuidado de no pisar ninguna flor.',
      v_crujido, array['hojas'],
      '/images/huerto-encantado/04-seto.svg'),

    (v_story_id, 5,
      'Del otro lado, en la rama más alta de un árbol, colgaba solita una fruta única: brillaba de color {color_favorito}, como si tuviera luz propia adentro.',
      null, array[]::text[],
      '/images/huerto-encantado/05-fruta.svg'),

    (v_story_id, 6,
      'Justo cuando {nombre_niño} la alcanzó con la mano, {un_animal_amigo} {animal_amigo} se acercó despacito, con los ojos hambrientos fijos en la fruta. También la quería.',
      null, array[]::text[],
      '/images/huerto-encantado/06-encuentro.svg'),

    (v_story_id, 7,
      '{nombre_niño} se acordó de su promesa. Aunque le costó un poco decidirse, partió la fruta en dos y le dio la mitad más grande a {animal_amigo}.',
      null, array[]::text[],
      '/images/huerto-encantado/07-compartir.svg'),

    (v_story_id, 8,
      'En el momento en que compartió la fruta, ¡algo increíble pasó! El árbol entero se llenó de frutas nuevas, todas brillando del mismo color {color_favorito}. Compartir no la había hecho desaparecer: la había multiplicado.',
      v_destello, array['brillando'],
      '/images/huerto-encantado/08-multiplica.svg'),

    (v_story_id, 9,
      '{el_animal_amigo} {animal_amigo}, feliz, ya no se quiso separar de {nombre_niño}. Caminaron juntos entre los árboles, y los pájaros del huerto cantaban como si celebraran esa nueva amistad.',
      v_pajaros, array['pájaros'],
      '/images/huerto-encantado/09-pajaros.svg'),

    (v_story_id, 10,
      'Siguieron explorando y llegaron a un rincón lleno de flores enormes, donde un grupo de abejas doradas zumbaba de pétalo en pétalo, ocupadas construyendo panales brillantes.',
      v_abejas, array['abejas'],
      '/images/huerto-encantado/10-abejas.svg'),

    (v_story_id, 11,
      'Pero de repente, el cielo se oscureció y las sombras del huerto se tragaron el camino de regreso. {nombre_niño} sintió un poquito de miedo: no sabía para dónde seguir.',
      null, array[]::text[],
      '/images/huerto-encantado/11-oscurece.svg'),

    (v_story_id, 12,
      'Esta vez fue {el_animal_amigo} {animal_amigo} quien ayudó a {nombre_niño}: conocía cada rincón del huerto, y siguiendo su nariz y el canto de los grillos, encontró el camino escondido entre las sombras.',
      v_grillos, array['grillos'],
      '/images/huerto-encantado/12-guia.svg'),

    (v_story_id, 13,
      'Guiados por {el_animal_amigo} {animal_amigo}, llegaron hasta el Árbol Madre, el más grande y viejo de todo el huerto. Al tocar su tronco con cuidado, sonó una campanita mágica que abrió una puertecita secreta entre sus raíces.',
      v_campanita, array['campanita'],
      '/images/huerto-encantado/13-arbolmadre.svg'),

    (v_story_id, 14,
      'Adentro los esperaba la tortuga del principio, envuelta en una luz dorada. —Lo que compartes no desaparece —dijo con voz suave—. Se multiplica. Por eso el huerto floreció para ti hoy, {nombre_niño}.',
      v_destello, array['dorada'],
      '/images/huerto-encantado/03-tortuga.svg'),

    (v_story_id, 15,
      'La tortuga sopló suavemente, y en las manos de {nombre_niño} brilló una semillita mágica de color {color_favorito}. —Esta semilla crece el doble si la compartes con alguien más —le dijo, guiñándole un ojo.',
      v_destello, array['brilló'],
      '/images/huerto-encantado/15-semilla.svg'),

    (v_story_id, 16,
      'Ya era hora de volver a casa. Caminaron de regreso tomados de la mano —bueno, de la mano y de la pata— mientras los grillos cantaban su canción de la noche.',
      v_grillos, array['grillos'],
      '/images/huerto-encantado/16-regreso.svg'),

    (v_story_id, 17,
      'Al llegar a la puertita de madera, {el_animal_amigo} {animal_amigo} le dio un abrazo bien apretado. —Gracias por compartir conmigo —le dijo—. Ven a visitarme cuando quieras, este huerto siempre va a estar aquí, esperándote.',
      null, array[]::text[],
      '/images/huerto-encantado/17-despedida.svg'),

    (v_story_id, 18,
      '{nombre_niño} volvió a casa con la semilla mágica guardada en las manos y una sonrisa enorme. Había aprendido que compartir no es perder, es multiplicar — y ya sabía exactamente con quién iba a compartir lo que esa semilla hiciera crecer.',
      null, array[]::text[],
      '/images/huerto-encantado/18-final.svg');
end $$;
