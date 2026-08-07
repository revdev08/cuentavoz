-- Primer cuento generado con el sistema escritor-cuentavoz/ (identidad,
-- estilo, reglas narrativas, reglas técnicas, catálogo de sonidos y
-- validaciones -- los 8 archivos .md de esa carpeta).
--
-- "La cuchara que aprendió a hacer sitio"
--
-- Protagonista: una cuchara de madera (objeto cotidiano, no niño ni
-- animal). Escenario: la cocina de una casa de familia. Conflicto:
-- aceptar un cambio (miedo a ser reemplazada cuando llega una cuchara
-- nueva) -- no usado antes. Magia: el aroma de la cocina, que recorre
-- la casa y reúne a la familia -- nunca resuelve el conflicto entre las
-- dos cucharas, eso lo deciden ellas solas. Quién inicia el cambio: la
-- propia protagonista, por decisión propia. Quién expresa la enseñanza:
-- la abuela, cerca del final, repitiendo con naturalidad lo que ya
-- había dicho al principio. Emoción dominante: ternura. Regalo/cierre:
-- una costumbre nueva (compartir el mismo rincón del cajón), no un
-- objeto para guardar.
--
-- Escena inolvidable: el aroma nuevo de la sopa, hecha por las dos
-- cucharas juntas, recorriendo la casa entera y despertando al abuelo,
-- llamando a los niños del patio.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro (prohibiciones de 03-reglas-narrativas.md).
--
-- Sonidos: reutiliza 3 del catálogo existente (crujido, destello
-- mágico, grillos nocturnos) y 1 más (chapoteo). No necesita ningún
-- sonido nuevo.
--
-- Requiere: supabase/schema.sql y supabase/migracion_agregar_slug.sql
-- ya corridos (columna "slug" en stories).
--
-- Idempotente: seguro de correr varias veces. Identifica el cuento por
-- slug (nunca por título), sigue el orden oficial de
-- escritor-cuentavoz/05-plantilla-sql.md.
--
-- Ejecutar en Supabase -> SQL Editor.

do $$

declare

    v_story_id uuid;
    v_crujido uuid;
    v_destello uuid;
    v_chapoteo uuid;
    v_grillos uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-cuchara-que-aprendio-a-hacer-sitio'
    limit 1;

    --------------------------------------------------
    -- Crear historia
    --------------------------------------------------

    if v_story_id is null then

        insert into stories
        (
            titulo,
            slug,
            edad_recomendada,
            es_personalizable,
            portada_url
        )

        values
        (
            'La cuchara que aprendió a hacer sitio',
            'la-cuchara-que-aprendio-a-hacer-sitio',
            '2-7 años',
            true,
            null
        )

        returning id
        into v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos (ninguno -- todos ya existen en el catálogo)
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='crujido') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('crujido', '/sounds/crujido.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='destello magico') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('destello magico', '/sounds/destello.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='chapoteo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='grillos nocturnos') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_crujido from sound_effects where nombre='crujido' limit 1;
    select id into v_destello from sound_effects where nombre='destello magico' limit 1;
    select id into v_chapoteo from sound_effects where nombre='chapoteo' limit 1;
    select id into v_grillos from sound_effects where nombre='grillos nocturnos' limit 1;

    --------------------------------------------------
    -- Variables
    --------------------------------------------------

    delete
    from story_variables
    where story_id=v_story_id;

    insert into story_variables
    (
        story_id,
        variable_key,
        tipo,
        opciones_sugeridas
    )

    values

    (v_story_id, 'nombre_cuchara', 'texto', array['Canela','Nogal','Miel','Roble','Avellana','Tostada']),
    (v_story_id, 'nombre_cuchara_nueva', 'texto', array['Estrella','Perla','Luna','Cometa','Rocío','Aurora']),
    (v_story_id, 'color_cuchara_nueva', 'color', array['rojo','azul','verde','amarillo','morado','rosado','plateado','turquesa']);

    --------------------------------------------------
    -- Bloques
    --------------------------------------------------

    delete
    from story_blocks
    where story_id=v_story_id;

    insert into story_blocks
    (
        story_id,
        orden,
        texto_bloque,
        sound_effect_id,
        trigger_keywords,
        imagen_url
    )

    values

    (v_story_id, 1,
      'En una cocina que olía a mil comidas distintas, vivía {nombre_cuchara}, una cuchara de madera que llevaba años sirviendo en la misma familia. Conocía cada olla, cada receta, cada rincón del cajón de los cubiertos. Ahí dentro, se sentía exactamente donde debía estar.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/01-cuchara-cajon-cocina.png'),

    (v_story_id, 2,
      'Cada tarde, cuando el fuego se encendía, un aroma empezaba a moverse por los pasillos de la casa, subiendo escaleras, colándose bajo las puertas. Ese olor tenía algo especial: siempre lograba reunir a toda la familia alrededor de la misma mesa, sin que nadie tuviera que llamarlos.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/02-aroma-recorre-casa.png'),

    (v_story_id, 3,
      '—En esta cocina —decía siempre la abuela, revolviendo la olla— siempre ha habido lugar para una cuchara más. {nombre_cuchara} la escuchaba sin prestarle demasiada atención. Nunca había necesitado compañía para cocinar bien. ¿Para qué querría otra cuchara en su cajón?',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/03-abuela-remueve-olla.png'),

    (v_story_id, 4,
      'Una tarde llegó una cuchara nueva, de color {color_cuchara_nueva}, todavía brillante de tan poco usada. Se llamaba {nombre_cuchara_nueva}. La abuela la puso en el mismo cajón, junto a {nombre_cuchara}, como si fuera lo más natural del mundo. Para {nombre_cuchara}, no lo era.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/04-cuchara-nueva-llega.png'),

    (v_story_id, 5,
      'Esa noche, {nombre_cuchara} se las arregló para quedar siempre delante en el cajón, empujando a {nombre_cuchara_nueva} hacia el fondo. Cuando la abuela metía la mano buscando ayuda, siempre encontraba primero a la cuchara vieja. Y así, pensó {nombre_cuchara}, las cosas se quedarían para siempre.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/05-cuchara-empuja-al-fondo.png'),

    (v_story_id, 6,
      'Pero un día se preparaba la cena más grande del año, con una olla enorme que pedía dos manos y no una. La abuela buscó a {nombre_cuchara_nueva} para ayudar, pero {nombre_cuchara} se las ingenió para quedar encima de ella en el cajón, escondiéndola sin que nadie lo notara.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/06-cena-grande-olla-enorme.png'),

    (v_story_id, 7,
      'Sin ayuda, {nombre_cuchara} no alcanzó a remover toda la olla a tiempo. Un lado de la sopa se pegó al fondo, oliendo a quemado en lugar de a fiesta. La abuela frunció el ceño, buscando algo que no encontraba. {nombre_cuchara} sintió, por primera vez, que algo había salido mal.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/07-sopa-pegada-quemada.png'),

    (v_story_id, 8,
      '—¿Dónde está la otra cuchara? —preguntó la abuela, abriendo el cajón de un tirón que hizo crujir la madera vieja. Movió cucharas y tenedores hasta encontrar a {nombre_cuchara_nueva}, escondida al fondo, y la sacó sin entender cómo había llegado hasta ahí.',
      v_crujido, array['crujir'],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/08-cajon-crujiendo-buscando.png'),

    (v_story_id, 9,
      '{nombre_cuchara} vio cómo {nombre_cuchara_nueva} entraba por fin a la olla, todavía un poco insegura, sin saber bien por dónde empezar. Y sintió, junto al orgullo herido, algo parecido a la vergüenza: ella sabía exactamente por qué {nombre_cuchara_nueva} nunca había tenido su oportunidad.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/09-cuchara-nueva-insegura.png'),

    (v_story_id, 10,
      'Esa noche, {nombre_cuchara} tomó una decisión que nunca antes había tomado: se acercó a {nombre_cuchara_nueva} y, sin decir mucho, le mostró por dónde removía siempre la abuela, dónde se pegaba la sopa, qué rincón de la olla necesitaba más cariño.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/10-cuchara-vieja-decide-ayudar.png'),

    (v_story_id, 11,
      'Juntas, hundieron sus mangos en la manteca caliente, que chisporroteó al fondo de la olla. {nombre_cuchara_nueva} aprendía rápido, y {nombre_cuchara} descubrió que enseñar se sentía casi tan bien como cocinar siempre sola le había parecido.',
      v_destello, array['chisporroteó'],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/11-manteca-chisporroteando.png'),

    (v_story_id, 12,
      'Removieron la sopa a la vez, una desde un lado y otra desde el otro, con un chapoteo suave y parejo que ninguna cuchara sola habría logrado. El aroma que subió de la olla esa noche fue distinto a todos los anteriores: más redondo, más completo.',
      v_chapoteo, array['chapoteo'],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/12-dos-cucharas-removiendo.png'),

    (v_story_id, 13,
      'Ese olor nuevo salió de la cocina y recorrió la casa entera: despertó al abuelo que dormitaba en su silla, sacó a los niños de su juego en el patio, y llegó hasta la ventana donde cantaban los grillos, como invitándolos también a la mesa.',
      v_grillos, array['grillos'],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/13-aroma-despierta-casa.png'),

    (v_story_id, 14,
      'Cuando toda la familia estuvo sentada, la abuela probó la sopa y sonrió. —¿Ves? —le dijo a {nombre_cuchara}, guiñándole un ojo—. En esta cocina siempre ha habido lugar para una cuchara más. Y esta noche, entre las dos, la sirvieron mejor que nunca.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/14-abuela-sonrie-guino.png'),

    (v_story_id, 15,
      'Desde esa noche, {nombre_cuchara} y {nombre_cuchara_nueva} compartieron el mismo rincón del cajón, sin empujones ni escondites. Cada vez que el fuego se encendía, las dos entraban juntas a la olla, como si nunca hubieran cocinado de otra manera.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/15-cucharas-comparten-cajon.png'),

    (v_story_id, 16,
      '{nombre_cuchara} entendió, por fin, que una cuchara nueva en el cajón no significaba una cuchara vieja de menos. Significaba, simplemente, más manos para remover la misma sopa — y una casa donde siempre, de verdad, había lugar para una más.',
      null, array[]::text[],
      '/images/la-cuchara-que-aprendio-a-hacer-sitio/16-cuchara-reflexion-final.png');

end $$;
