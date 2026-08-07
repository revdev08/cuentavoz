-- Cuento 4: "El dragón que no quería pedir ayuda". Moraleja: pedir ayuda
-- no significa ser débil, significa confiar en los demás y permitir que
-- juntos se puedan hacer cosas que solos serían muy difíciles.
--
-- Primer cuento con variables propias fuera de nombre_niño/color_favorito
-- /animal_amigo (ver supabase/GUIA_NUEVOS_CUENTOS.md sección 2): agrega
-- nombre_dragon, lugar_secreto y objeto_especial.
--
-- Contenido recibido de un colaborador y corregido antes de publicarlo:
-- (1) bloques 15 y 16 tenían una trigger_keyword que solo aparecía en la
-- descripción de imagen, no en el texto del bloque -- se agregó la
-- palabra al texto de forma natural; (2) el bloque 3 tenía un sonido
-- "pasos sobre hojas" sin ninguna hoja en la escena (es una ladera de
-- montaña) -- se quitó el sonido; (3) las opciones sugeridas de
-- `objeto_especial` traían el artículo incluido ("una campana"), lo que
-- habría duplicado el artículo en el texto (el sistema ya calcula
-- un/una y el/la automáticamente) -- se dejaron como sustantivos
-- pelados; (4) varios usos de {objeto_especial} como complemento directo
-- no traían artículo ("transportar campana") -- se les agregó
-- {el_objeto_especial} antes.
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
-- PENDIENTE: las 16 ilustraciones todavía no existen. imagen_url queda
-- en null por ahora -- agrégalas en public/images/dragon-ayuda/ y
-- actualiza cada fila cuando estén listas (ver sección 4 de la guía).
--
-- Ejecutar en Supabase -> SQL Editor.

do $$
declare
  v_story_id uuid;
  v_crujido uuid;
  v_chapoteo uuid;
  v_arroyo uuid;
  v_viento uuid;
  v_lluvia uuid;
  v_campanita uuid;
  v_destello uuid;
  v_pajaros uuid;
begin
  select id into v_story_id from stories where titulo = 'El dragón que no quería pedir ayuda' limit 1;

  if v_story_id is null then
    insert into stories (titulo, edad_recomendada, es_personalizable, portada_url)
    values ('El dragón que no quería pedir ayuda', '2-7 años', true, null)
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'crujido') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('crujido', '/sounds/crujido.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'chapoteo') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'arroyo') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('arroyo', '/sounds/arroyo.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'viento entre arboles') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('viento entre arboles', '/sounds/viento.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'lluvia magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('lluvia magica', '/sounds/lluvia.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'campanita magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('campanita magica', '/sounds/campanita.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'destello magico') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('destello magico', '/sounds/destello.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'pajaros del bosque') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
  end if;

  select id into v_crujido from sound_effects where nombre = 'crujido' limit 1;
  select id into v_chapoteo from sound_effects where nombre = 'chapoteo' limit 1;
  select id into v_arroyo from sound_effects where nombre = 'arroyo' limit 1;
  select id into v_viento from sound_effects where nombre = 'viento entre arboles' limit 1;
  select id into v_lluvia from sound_effects where nombre = 'lluvia magica' limit 1;
  select id into v_campanita from sound_effects where nombre = 'campanita magica' limit 1;
  select id into v_destello from sound_effects where nombre = 'destello magico' limit 1;
  select id into v_pajaros from sound_effects where nombre = 'pajaros del bosque' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_niño', 'texto', array['Sofía','Mateo','Valentina','Samuel','Emma','Lucas']),
    (v_story_id, 'nombre_dragon', 'texto', array['Brasa','Chispa','Draco','Nilo','Fuego','Coco']),
    (v_story_id, 'lugar_secreto', 'texto', array['una montaña azul','un valle de nubes','una cueva de cristales','un bosque de gigantes','una isla flotante','un volcán dormido']),
    (v_story_id, 'objeto_especial', 'animal', array['campana','brújula','corona','llave','pluma dorada','estrella de cristal']);

  delete from story_blocks where story_id = v_story_id;

  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
  values
    (v_story_id, 1,
      'En {lugar_secreto} vivía {nombre_dragon}, un pequeño dragón con alas grandes y una costumbre enorme: quería hacerlo todo solo. Si necesitaba subir una montaña, subía solo. Si tenía un problema, lo escondía. Y si alguien preguntaba si necesitaba ayuda, siempre respondía: «¡No, yo puedo!».',
      null, array[]::text[], null),

    (v_story_id, 2,
      'Una mañana, {nombre_niño} llegó hasta {lugar_secreto} y encontró al dragón intentando transportar {el_objeto_especial} {objeto_especial}. Era demasiado grande para sus pequeñas patas. El dragón resopló, empujó con el hocico y siguió avanzando. Cerca de allí, las ramas comenzaron a moverse con un suave crujido.',
      v_crujido, array['crujido'], null),

    (v_story_id, 3,
      '—Hola, {nombre_dragon} —dijo {nombre_niño}—. ¿Quieres que te ayude? El dragón se sentó rápidamente sobre {el_objeto_especial} {objeto_especial}. —¡No hace falta! —contestó—. Los dragones podemos hacerlo todo. Pero cuando quiso levantarse, el objeto rodó cuesta abajo. El dragón salió corriendo detrás de él.',
      null, array[]::text[], null),

    (v_story_id, 4,
      'El objeto llegó hasta un arroyo. ¡Plaf! Cayó dentro del agua y desapareció bajo la superficie. {nombre_dragon} abrió mucho los ojos. Miró el arroyo, miró sus patas y después miró a {nombre_niño}. Quería decir algo, pero su orgullo volvió a hablar primero: «Yo puedo sacarlo».',
      v_chapoteo, array['Plaf'], null),

    (v_story_id, 5,
      'El dragón metió una pata en el agua. Después metió las dos. Intentó atraparlo con la cola, pero el objeto escapó entre unas piedras. Entonces {nombre_dragon} respiró profundamente y lanzó una pequeña llamarada. El agua se calentó, pero el objeto siguió escondido. Esta vez, el dragón no sabía qué hacer.',
      v_arroyo, array['agua'], null),

    (v_story_id, 6,
      '—Quizá podríamos pensar juntos —propuso {nombre_niño}. {nombre_dragon} bajó la cabeza. Nunca había pedido ayuda. Le parecía difícil pronunciar esas palabras. Finalmente susurró: —Creo que... necesito ayuda. El viento pasó entre los árboles y, por primera vez, el dragón sintió que decirlo no le hacía sentirse pequeño.',
      v_viento, array['viento'], null),

    (v_story_id, 7,
      'Los dos observaron el agua. {nombre_niño} encontró una rama larga y {nombre_dragon} iluminó las piedras con su fuego. Juntos descubrieron que {el_objeto_especial} {objeto_especial} estaba atrapado detrás de una roca. El dragón empujó la roca y {nombre_niño} guio la rama. Poco a poco, lograron liberarlo.',
      null, array[]::text[], null),

    (v_story_id, 8,
      '{nombre_dragon} miró {el_objeto_especial} {objeto_especial} y sonrió. Había funcionado. Pero justo cuando iban a regresar, una nube oscura cubrió el cielo. Comenzó una lluvia suave que convirtió el sendero en barro. El dragón quiso cargar nuevamente con todo, pero sus patas resbalaron y cayó sentado.',
      v_lluvia, array['lluvia'], null),

    (v_story_id, 9,
      '—¡Yo puedo! —dijo el dragón, levantándose. Caminó unos pasos y volvió a resbalar. Esta vez no se enfadó. Miró a {nombre_niño} y recordó aquellas palabras que tanto le había costado decir. —¿Me ayudas a cruzar? —preguntó. {nombre_niño} sonrió y tomó su pata.',
      null, array[]::text[], null),

    (v_story_id, 10,
      'Juntos avanzaron hasta un puente pequeño. Pero el puente estaba roto justo en el centro. Al otro lado se veía la entrada de {lugar_secreto}. {nombre_dragon} miró sus alas. Podía volar, pero {el_objeto_especial} {objeto_especial} era demasiado pesado para llevarlo mientras volaba. Entonces tuvo una idea: no necesitaba hacer todo de una sola manera.',
      null, array[]::text[], null),

    (v_story_id, 11,
      '{nombre_dragon} llevó a {nombre_niño} hasta el otro lado volando y después regresó por {el_objeto_especial} {objeto_especial}. Cuando estaba en el aire, una ráfaga lo hizo tambalear. Esta vez no fingió estar bien. —¡Necesito ayuda! —gritó. {nombre_niño} sujetó una cuerda y juntos consiguieron aterrizar.',
      v_viento, array['ráfaga'], null),

    (v_story_id, 12,
      'Al entrar en {lugar_secreto}, encontraron una enorme puerta cubierta de dibujos. En el centro había un espacio con la forma exacta de {el_objeto_especial} {objeto_especial}. El dragón intentó abrirla solo, empujando con todas sus fuerzas. Nada ocurrió. Entonces soltó una pequeña risa y dijo: —Parece que esta puerta también quiere que trabajemos juntos.',
      null, array[]::text[], null),

    (v_story_id, 13,
      '{nombre_niño} colocó {el_objeto_especial} {objeto_especial} en el centro y {nombre_dragon} puso su pata encima. La puerta comenzó a temblar. Una campanita sonó dentro de la montaña y cientos de pequeñas luces aparecieron alrededor. El dragón abrió la boca sorprendido. La puerta no se había abierto con fuerza, sino con dos amigos trabajando juntos.',
      v_campanita, array['campanita'], null),

    (v_story_id, 14,
      'Dentro había un salón enorme lleno de mapas, nubes de colores y caminos que llegaban hasta lugares desconocidos. {nombre_dragon} comprendió algo importante. —Pedir ayuda no hizo que yo fuera menos dragón —dijo—. Me permitió llegar más lejos. {nombre_niño} asintió. El dragón había descubierto un secreto que no aparecía en ningún mapa.',
      null, array[]::text[], null),

    (v_story_id, 15,
      'Antes de marcharse, {nombre_dragon} encontró un mapa nuevo que brillaba tenuemente sobre una mesa. No era un premio por haber sido valiente. Era una invitación. En el mapa aparecían muchos lugares que todavía no conocían. El dragón lo enrolló cuidadosamente y miró a {nombre_niño}: —¿Vamos juntos? Esta vez no quiero descubrirlos solo.',
      v_destello, array['brillaba'], null),

    (v_story_id, 16,
      'De regreso, {nombre_dragon} caminó feliz por {lugar_secreto} mientras los pájaros cantaban en el cielo. Ya no intentaba esconder cada dificultad. Cuando algo parecía demasiado grande, buscaba una mano amiga. Y cuando {nombre_niño} le preguntó qué había aprendido, el dragón respondió: «Pedir ayuda no es ser débil. Es confiar en alguien y descubrir que juntos podemos llegar mucho más lejos».',
      v_pajaros, array['pájaros'], null);
end $$;
