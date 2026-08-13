-- Séptimo cuento generado con el sistema escritor-cuentavoz/.
--
-- "El barco que no miraba de cerca"
--
-- Protagonista: un barco de papel (vuelve a ser objeto, después de dos
-- cuentos seguidos con elementos naturales -- nube y semilla).
-- Escenario: un río, de la orilla a una ensenada escondida (primer
-- cuento de agua/río -- los anteriores fueron cocina, caminos, pueblo
-- nevado, valle de montaña, jardín). Conflicto: exceso de confianza --
-- no usado antes. Magia: sombras (el río tiene fama de revelar cosas
-- ciertas a quien se atreve a mirarlas de cerca en vez de huir --
-- nunca resuelve el conflicto sola, el barco igual tiene que decidir
-- mirar). Quién inicia el cambio: una libélula (personaje secundario
-- nuevo -- ni familia de animales, ni niño, ni semilla par, ni la
-- protagonista sola). Quién expresa la enseñanza: una tortuga vieja
-- tomando sol en una piedra (personaje nuevo). Emoción dominante:
-- misterio (distinta a ternura/asombro/esperanza/alegría/curiosidad ya
-- usadas). Regalo/cierre: un lugar descubierto -- una ensenada
-- escondida (no costumbre, camino, canción, árbol ni amistad como
-- cierre principal, aunque la amistad con la libélula también nace).
--
-- Escena inolvidable: el barco se asoma por primera vez a mirar su
-- propio reflejo en el agua quieta de la ensenada -- arrugado, húmedo
-- en las esquinas, pero entero todavía, flotando.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro.
--
-- Sonidos: reutiliza 5 del catálogo existente (pájaros del bosque,
-- arroyo, chapoteo, crujido, grillos nocturnos). No necesita ningún
-- sonido nuevo.
--
-- Requiere: supabase/schema.sql, supabase/migracion_agregar_slug.sql y
-- supabase/migracion_progreso_y_favoritos.sql ya corridos.
--
-- Idempotente: seguro de correr varias veces. Identifica el cuento por
-- slug, sigue el orden oficial de escritor-cuentavoz/05-plantilla-sql.md.
--
-- Ejecutar en Supabase -> SQL Editor.

do $$

declare

    v_story_id uuid;
    v_pajaros uuid;
    v_arroyo uuid;
    v_chapoteo uuid;
    v_crujido uuid;
    v_grillos uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-barco-que-no-miraba-de-cerca'
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
            categoria,
            es_personalizable,
            portada_url
        )

        values
        (
            'El barco que no miraba de cerca',
            'el-barco-que-no-miraba-de-cerca',
            '2-7 años',
            'Aventuras',
            true,
            null
        )

        returning id
        into v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos (ninguno -- todos ya existen en el catálogo)
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='pajaros del bosque') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='arroyo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('arroyo', '/sounds/arroyo.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='chapoteo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='crujido') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('crujido', '/sounds/crujido.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='grillos nocturnos') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_pajaros from sound_effects where nombre='pajaros del bosque' limit 1;
    select id into v_arroyo from sound_effects where nombre='arroyo' limit 1;
    select id into v_chapoteo from sound_effects where nombre='chapoteo' limit 1;
    select id into v_crujido from sound_effects where nombre='crujido' limit 1;
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

    (v_story_id, 'nombre_barco', 'texto', array['Velero','Corriente','Rápido','Espuma','Vela','Remolino']),
    (v_story_id, 'color_barco', 'color', array['azul','rojo','amarillo','verde','blanco','naranja','turquesa','plateado']),
    (v_story_id, 'nombre_rio', 'texto', array['Río Claro','Río Manso','Aguasvivas','Río Sereno','El Cristalino','Río Hondo']);

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
      'En la orilla de {nombre_rio}, un niño dobló con cuidado un barco de papel de color {color_barco} y lo dejó flotar en la corriente. Así nació {nombre_barco}, convencido desde el primer segundo de que sería el barco más rápido y más fuerte que ese río hubiera visto jamás.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/01-nino-dobla-barco-papel.png'),

    (v_story_id, 2,
      'La corriente lo llevó entre juncos donde cantaban los pájaros de la mañana. {nombre_barco} avanzaba orgulloso, seguro de que nada en ese río podría hacerle ni un rasguño.',
      v_pajaros, array['pájaros'],
      '/images/el-barco-que-no-miraba-de-cerca/02-barco-flota-juncos-pajaros.png'),

    (v_story_id, 3,
      'Una libélula pasó volando a su lado. —El río no perdona a quien no lo mira con respeto —le dijo, casi como advertencia. {nombre_barco} soltó una carcajada de papel. —A mí el río me quiere —contestó—. Nunca me pasaría nada.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/03-libelula-advierte-barco.png'),

    (v_story_id, 4,
      'Río abajo se cruzó con ramitas y hojas que flotaban despacio, con cuidado. {nombre_barco} las adelantó a todas, presumiendo lo rápido que iba, sin detenerse a preguntar qué venía después de la curva.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/04-barco-adelanta-hojas-ramitas.png'),

    (v_story_id, 5,
      'El arroyo se volvió más angosto y rápido, dividiéndose en dos caminos: uno tranquilo y ancho, otro estrecho y lleno de espuma blanca. La libélula voló hacia el camino tranquilo, haciéndole señas para que la siguiera.',
      v_arroyo, array['arroyo'],
      '/images/el-barco-que-no-miraba-de-cerca/05-arroyo-se-divide-dos-caminos.png'),

    (v_story_id, 6,
      '—Por ahí no hay ninguna gracia —dijo {nombre_barco}, señalando el camino espumoso—. Yo voy por el rápido. Los barcos de verdad no necesitan que nadie les muestre el camino. Y sin esperar respuesta, se lanzó directo a la corriente veloz.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/06-barco-elige-camino-rapido.png'),

    (v_story_id, 7,
      'El agua lo giró de un lado a otro, chapoteando contra sus costados de papel. {nombre_barco} sintió cómo una esquina se le humedecía, luego otra. Ya no se sentía tan seguro de haber elegido bien.',
      v_chapoteo, array['chapoteando'],
      '/images/el-barco-que-no-miraba-de-cerca/07-agua-chapotea-barco-moja.png'),

    (v_story_id, 8,
      'El cielo empezó a oscurecerse, y {nombre_barco} entró flotando bajo un túnel de ramas que crujían con el viento de la tarde. Sombras extrañas se movían sobre el agua, y el corazón de papel de {nombre_barco} latió con fuerza.',
      v_crujido, array['crujían'],
      '/images/el-barco-que-no-miraba-de-cerca/08-tunel-ramas-sombras-rio.png'),

    (v_story_id, 9,
      'Quiso salir corriendo -- o mejor dicho, flotando -- lo más rápido posible, sin mirar atrás. Pero al intentarlo, chocó contra una piedra y estuvo a punto de voltearse por completo.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/09-barco-choca-piedra-asustado.png'),

    (v_story_id, 10,
      '—¡Mira de cerca, no huyas! —gritó la libélula, alcanzándolo por fin—. Eso fue lo que te dije desde el principio. {nombre_barco}, temblando, se quedó quieto por primera vez en todo el viaje.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/10-libelula-grita-mira-de-cerca.png'),

    (v_story_id, 11,
      'Con mucho miedo, miró de verdad hacia la sombra que tanto lo había asustado. No era ningún monstruo: era solo la rama de un sauce viejo, meciéndose despacio, y un pez curioso que nadaba cerca para verlo mejor.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/11-barco-descubre-sombra-no-es-monstruo.png'),

    (v_story_id, 12,
      'Avergonzado y aliviado a la vez, {nombre_barco} dejó por fin que la libélula lo guiara el resto del camino, por el canal tranquilo que había rechazado al principio.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/12-libelula-guia-canal-tranquilo.png'),

    (v_story_id, 13,
      'Juntos salieron de las sombras hacia una ensenada pequeña y escondida que {nombre_barco} nunca había imaginado que existiera, con el agua tan quieta que parecía de cristal.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/13-ensenada-escondida-agua-cristal.png'),

    (v_story_id, 14,
      '{nombre_barco} se asomó al agua quieta y, por primera vez en todo el viaje, se miró a sí mismo con calma: un poco arrugado, un poco húmedo en las esquinas, pero entero todavía, flotando.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/14-barco-se-mira-reflejo-quieto.png'),

    (v_story_id, 15,
      'Sobre una piedra tibia, una tortuga muy vieja tomaba el sol. —El río nunca castiga la valentía —dijo, sin abrir del todo los ojos—. Castiga no mirar antes de saltar.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/15-tortuga-vieja-toma-sol-habla.png'),

    (v_story_id, 16,
      'Esa noche, {nombre_barco} y la libélula se quedaron explorando cada rincón de la ensenada, mientras los grillos empezaban a cantar en la orilla. Ya no había ninguna prisa por llegar a ningún lado.',
      v_grillos, array['grillos'],
      '/images/el-barco-que-no-miraba-de-cerca/16-barco-libelula-exploran-noche.png'),

    (v_story_id, 17,
      '{nombre_barco} entendió, por fin, que ser valiente nunca había sido ir más rápido que nadie, ni no necesitar ayuda de nadie. Había sido mirar de cerca lo que daba miedo, en vez de solo confiar en que todo saldría bien.',
      null, array[]::text[],
      '/images/el-barco-que-no-miraba-de-cerca/17-barco-reflexion-final.png');

end $$;
