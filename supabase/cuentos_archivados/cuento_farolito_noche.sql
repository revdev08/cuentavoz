-- Cuento 5: "El farolito que le tenía miedo a la noche". Moraleja: ser
-- valiente no significa no tener miedo, significa brillar de todos
-- modos aunque el miedo siga ahí.
--
-- Primer cuento sin nombre_niño/color_favorito/animal_amigo: el
-- protagonista es un objeto (un farolito de faro, no un niño ni un
-- animal), y sus variables son propias (nombre_farol, companero_marino,
-- color_luz). Conflicto = miedo (no usado antes). Magia = un destello
-- de luz temblorosa confundida con una estrella (no una luz mágica
-- genérica que resuelve el problema sola -- el farolito decide
-- encenderse a pesar del miedo). Cierre = una tradición del pueblo
-- (canción nocturna), no un objeto para guardar.
--
-- Escena memorable: la luz temblorosa del farolito, sin querer, dibuja
-- un parpadeo que un barco perdido confunde con una estrella caída, y
-- lo sigue hasta la orilla.
--
-- Nota de gramática: para el color de la variable `color_luz` se usa
-- siempre la construcción "de color {color_luz}" (nunca pegado
-- directamente a un sustantivo como "luz {color_luz}") -- así el
-- adjetivo de color no necesita concordar en género con nada, porque
-- "color" es siempre masculino sin importar la palabra que sigue. Ver
-- supabase/GUIA_NUEVOS_CUENTOS.md para más contexto de esta regla.
--
-- Necesita UN sonido nuevo: "olas del mar" (no existía nada de
-- ambiente marino en el catálogo). El resto reutiliza sonidos
-- existentes.
--
-- Requiere haber corrido antes supabase/schema.sql.
-- Seguro de correr varias veces: los sonidos solo se insertan si no
-- existen todavía, y las variables/bloques del cuento se borran y se
-- vuelven a crear desde cero cada vez (no se tocan story_sessions ya
-- guardadas -- el cuento conserva siempre el mismo id).
--
-- PENDIENTE: las 16 ilustraciones todavía no existen. imagen_url queda
-- en null por ahora -- agrégalas en public/images/farolito-noche/ y
-- actualiza cada fila cuando estén listas.
--
-- Ejecutar en Supabase -> SQL Editor.

do $$
declare
  v_story_id uuid;
  v_olas uuid;
  v_crujido uuid;
  v_viento uuid;
  v_destello uuid;
  v_lluvia uuid;
  v_chapoteo uuid;
begin
  select id into v_story_id from stories where titulo = 'El farolito que le tenía miedo a la noche' limit 1;

  if v_story_id is null then
    insert into stories (titulo, edad_recomendada, es_personalizable, portada_url)
    values ('El farolito que le tenía miedo a la noche', '2-7 años', true, null)
    returning id into v_story_id;
  end if;

  -- Único sonido nuevo que necesita este cuento: no había ambiente de
  -- mar/olas en el catálogo.
  if not exists (select 1 from sound_effects where nombre = 'olas del mar') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('olas del mar', '/sounds/olas.mp3', 'ambiente');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'crujido') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('crujido', '/sounds/crujido.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'viento entre arboles') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('viento entre arboles', '/sounds/viento.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'destello magico') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('destello magico', '/sounds/destello.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'lluvia magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('lluvia magica', '/sounds/lluvia.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'chapoteo') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
  end if;

  select id into v_olas from sound_effects where nombre = 'olas del mar' limit 1;
  select id into v_crujido from sound_effects where nombre = 'crujido' limit 1;
  select id into v_viento from sound_effects where nombre = 'viento entre arboles' limit 1;
  select id into v_destello from sound_effects where nombre = 'destello magico' limit 1;
  select id into v_lluvia from sound_effects where nombre = 'lluvia magica' limit 1;
  select id into v_chapoteo from sound_effects where nombre = 'chapoteo' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_farol', 'texto', array['Lucero','Chispa','Destello','Candela','Rayito','Farolín']),
    (v_story_id, 'companero_marino', 'animal', array['gaviota','delfín','foca','cangrejo','nutria','pez luna']),
    (v_story_id, 'color_luz', 'color', array['dorado','plateado','turquesa','coral','violeta','esmeralda','blanco cálido','azul profundo']);

  delete from story_blocks where story_id = v_story_id;

  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
  values
    (v_story_id, 1,
      'En el pueblo más pequeño de la costa vivía {nombre_farol}, el farolito del faro. Su trabajo era alumbrar la noche entera, pero guardaba un secreto que nadie sabía: en el fondo, {nombre_farol} le tenía miedo a la oscuridad. Cada atardecer, cuando el sol se iba, un temblor de luz de color {color_luz} recorría su mecha.',
      null, array[]::text[], null),

    (v_story_id, 2,
      'El faro se alzaba sobre unas rocas donde el mar nunca dejaba de hablar. Abajo, las olas iban y venían, contándole a {nombre_farol} historias de barcos lejanos. Él las escuchaba con atención, aunque en el fondo solo quería que alguien le contara una historia sobre no tener miedo.',
      v_olas, array['olas'], null),

    (v_story_id, 3,
      'Todas las tardes, justo antes del atardecer, {un_companero_marino} {companero_marino} asomaba la cabeza entre las rocas para saludarlo. Era quien mejor conocía el temblor de {nombre_farol}, y nunca se reía de él. —Un día no vas a tener miedo —le decía siempre—. Y yo estaré aquí para verlo.',
      null, array[]::text[], null),

    (v_story_id, 4,
      'Una noche subió el viejo farero a encender la mecha y encontró a {nombre_farol} temblando más que de costumbre. —No pasa nada por tener miedo —le dijo, sin apagar su sonrisa—. Hasta la luz más valiente conoció primero su propia oscuridad. {nombre_farol} guardó esas palabras, aunque todavía no las entendía del todo.',
      null, array[]::text[], null),

    (v_story_id, 5,
      'Pasaron semanas tranquilas. Pero una tarde el cielo cambió de color, del azul al gris, y luego a un morado espeso. La puerta vieja del faro crujió con una ráfaga que entró por debajo, como si algo grande se estuviera acercando desde el mar abierto. {nombre_farol} sintió que el temblor volvía, más fuerte que nunca.',
      v_crujido, array['crujió'], null),

    (v_story_id, 6,
      'El viento llegó primero, silbando entre las rocas y apagando cualquier calma que quedara. {companero_marino} se escondió bajo una piedra grande. El farero cerró bien las ventanas y miró el cielo con preocupación. —Esta noche va a ser larga —murmuró, mientras {nombre_farol} se apretaba contra su propio cristal.',
      v_viento, array['viento'], null),

    (v_story_id, 7,
      '{nombre_farol} no quería que lo encendieran. Si su luz temblaba tanto como él, pensaba, iba a apagarse de todos modos. Era mejor no intentarlo siquiera, mejor quedarse oscuro y a salvo, sin que nadie viera cuánto miedo tenía en realidad. Se apretó contra el cristal y deseó desaparecer.',
      null, array[]::text[], null),

    (v_story_id, 8,
      '—Hay barcos ahí afuera —dijo el farero, encendiendo la mecha con manos temblorosas—. Necesitan tu luz esta noche más que ninguna otra. {nombre_farol} quiso decir que no podía, que tenía demasiado miedo. Pero entonces recordó las palabras del farero: la luz más valiente también había temblado antes de brillar.',
      null, array[]::text[], null),

    (v_story_id, 9,
      'Con el corazón encogido, {nombre_farol} dejó que la llama subiera por su mecha. Su luz, de color {color_luz}, salió temblando: parpadeaba sin ritmo, como un corazón que no sabe si quedarse o huir. No era la luz firme de siempre. Pero era luz, y estaba ahí, brillando en medio de la tormenta.',
      v_destello, array['parpadeaba'], null),

    (v_story_id, 10,
      'La lluvia llegó con fuerza, golpeando el cristal del faro una y otra vez. {companero_marino} salió de su escondite para mirar hacia arriba, hacia esa luz que no dejaba de temblar pero tampoco se apagaba. —Sigue ahí —susurró, temblando de frío—. A pesar de todo, sigue ahí.',
      v_lluvia, array['lluvia'], null),

    (v_story_id, 11,
      'Una ola enorme chocó contra las rocas y salpicó hasta la ventana del faro. Por un instante, la mecha de {nombre_farol} chisporroteó y estuvo a punto de apagarse del todo. El miedo volvió con toda su fuerza. Pero justo cuando pensó en rendirse, escuchó una voz conocida llamándolo desde abajo.',
      v_chapoteo, array['salpicó'], null),

    (v_story_id, 12,
      '—¡No te apagues! —gritó {companero_marino} desde las rocas, con la voz quebrada por el viento—. Yo también tengo miedo, pero prefiero tener miedo mirando tu luz que sin ella. {nombre_farol} sintió algo distinto entonces: no era valentía completa, pero era suficiente para seguir intentándolo un poco más.',
      null, array[]::text[], null),

    (v_story_id, 13,
      'Su luz de color {color_luz}, temblando sin parar, empezó a parpadear en un patrón extraño, como un código secreto escrito en el cielo. Un barco perdido en la tormenta la confundió con una estrella caída sobre el agua, y siguió su parpadeo hasta encontrar la orilla sana y salva. El miedo de {nombre_farol} lo había salvado.',
      v_destello, array['parpadear'], null),

    (v_story_id, 14,
      'Cuando amaneció y la tormenta se fue, el farero subió a ver cómo estaba {nombre_farol}. —Anoche no dejaste de temblar —le dijo, sonriendo—, y aun así salvaste un barco entero. Tu luz no es valiente porque no tiemble. Es valiente porque tiembla, y aun así, decide brillar.',
      null, array[]::text[], null),

    (v_story_id, 15,
      'Desde esa noche, los niños del pueblo bajaban cada atardecer a cantarle una canción corta a {nombre_farol} antes de que lo encendieran. Las olas los acompañaban de fondo, como si también quisieran cantar. Así, {nombre_farol} nunca más tuvo que enfrentar la noche completamente solo.',
      v_olas, array['olas'], null),

    (v_story_id, 16,
      'Con el tiempo, {nombre_farol} entendió que el miedo nunca se había ido del todo, y que no hacía falta que se fuera. {un_companero_marino} {companero_marino} seguía visitándolo cada tarde, y cada noche, aunque temblara un poco, su luz seguía brillando sobre el mar — valiente, a su manera, para siempre.',
      null, array[]::text[], null);
end $$;
