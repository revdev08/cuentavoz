-- Undécimo cuento generado con el sistema escritor-cuentavoz/.
-- Primer cuento con imágenes en .webp (cambio de formato pedido por el
-- usuario -- más liviano que .png). Ver escritor-cuentavoz/04-reglas-
-- tecnicas.md y 05-plantilla-sql.md, ya actualizados con el nuevo
-- formato obligatorio.
--
-- "La campana que no quería sonar"
--
-- Protagonista: una campana (objeto, primer cuento de torre/pueblo con
-- campanario -- distinto a cocina, caminos, pueblo nevado de velas,
-- valle, jardín, río, bosque de otoño, huerto de cosecha, arroyo con
-- presa). Escenario: la torre de un pueblo. Conflicto: miedo a
-- equivocarse (sonar mal) -- no usado antes. Magia: colores (cuando una
-- campana suena de corazón, un hilito de color sube al cielo cada
-- atardecer -- nunca resuelve el conflicto sola, la campana igual
-- tiene que decidir sonar). Quién inicia el cambio: una familia de
-- gorriones que anida dentro de la campana silenciosa, y que se va por
-- su cuenta al sentir la tormenta, liberando a la campana de una de
-- sus dos excusas para no sonar (personaje secundario nuevo). Quién
-- expresa la enseñanza: el viejo campanero (persona -- primer hombre
-- adulto que da la enseñanza; antes fueron mujeres -abuela, tendera- o
-- personajes no-adultos). Emoción dominante: orgullo (variante fresca,
-- distinta a las siete del listado de 01-identidad.md, ya usadas
-- todas, y de "satisfacción" del cuento anterior). Regalo/cierre: una
-- nueva forma de mirar el mundo -- entender que un sonido propio e
-- imperfecto ya alcanza (no costumbre, camino, canción, árbol,
-- amistad, lugar descubierto, abrazo, promesa ni habilidad nueva).
--
-- Escena inolvidable: la primera campanada de {nombre_campana} no se
-- parece a las de las campanas viejas -- más grave, más áspera,
-- completamente propia -- pero se escucha fuerte y clara hasta el
-- último rincón del pueblo, justo a tiempo.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro.
--
-- Sonidos: reutiliza 2 del catálogo existente (viento entre árboles,
-- pájaros del bosque, crujido) y crea 1 nuevo: "campanada profunda" --
-- necesario porque "campanita mágica" del catálogo es explícitamente
-- un sonido pequeño y delicado ("pequeños descubrimientos, magia
-- delicada"), y esta escena necesita un tañido grande y urgente, no
-- una campanita.
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
    v_campanada uuid;
    v_viento uuid;
    v_pajaros uuid;
    v_crujido uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-campana-que-no-queria-sonar'
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
            'La campana que no quería sonar',
            'la-campana-que-no-queria-sonar',
            '2-7 años',
            'Valores',
            true,
            null
        )

        returning id
        into v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='campanada profunda') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('campanada profunda', '/sounds/campanada-profunda.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='viento entre arboles') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('viento entre arboles', '/sounds/viento.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='pajaros del bosque') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='crujido') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('crujido', '/sounds/crujido.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_campanada from sound_effects where nombre='campanada profunda' limit 1;
    select id into v_viento from sound_effects where nombre='viento entre arboles' limit 1;
    select id into v_pajaros from sound_effects where nombre='pajaros del bosque' limit 1;
    select id into v_crujido from sound_effects where nombre='crujido' limit 1;

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

    (v_story_id, 'nombre_campana', 'texto', array['Clara','Bronce','Melodía','Eco','Resonancia','Repique']),
    (v_story_id, 'color_campana', 'color', array['dorado','cobrizo','plateado','bronce','verde antiguo','azulado','rosado','violeta']),
    (v_story_id, 'nombre_pueblo', 'texto', array['Piedra Alta','Valle Hondo','Campo Real','Los Álamos','Puente Viejo','Torreblanca']);

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
      'En la torre de {nombre_pueblo} colgaba una campana nueva, de color {color_campana}, llamada {nombre_campana}. Todavía no había sonado ni una sola vez. Cada vez que le tocaba el turno, el miedo podía más, y se quedaba completamente quieta.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/01-campana-nueva-torre-pueblo.webp'),

    (v_story_id, 2,
      'Se decía que cuando una campana suena de corazón, un hilito de color sube al cielo cada atardecer. Las campanas viejas de la torre llevaban generaciones tiñendo el cielo de {nombre_pueblo} así, una tarde tras otra.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/02-leyenda-colores-atardecer-torre.webp'),

    (v_story_id, 3,
      '{nombre_campana} miraba esos colores todas las tardes, preguntándose si algún día tendría uno propio. O si, al intentarlo, solo saldría un sonido torcido y feo que avergonzaría a todo el pueblo.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/03-campana-mira-colores-preguntas.webp'),

    (v_story_id, 4,
      'Una familia de gorriones, buscando dónde anidar, encontró en {nombre_campana} el único rincón de la torre que nunca temblaba ni sonaba. Ahí, dentro de ella, armaron un nido tranquilo y seguro.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/04-gorriones-anidan-dentro-campana.webp'),

    (v_story_id, 5,
      '{nombre_campana} descubrió a los gorriones adentro y sintió, junto al miedo de siempre, un motivo nuevo para no sonar jamás: no quería asustarlos ni deshacer su hogar.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/05-campana-descubre-nido-nuevo-motivo.webp'),

    (v_story_id, 6,
      'Cada mañana, los gorriones cantaban desde dentro de la campana, sin saber lo cerca que habían estado de que todo cambiara.',
      v_pajaros, array['gorriones'],
      '/images/la-campana-que-no-queria-sonar/06-gorriones-cantan-manana.webp'),

    (v_story_id, 7,
      'Un día, el cielo se oscureció de repente. Un viento fuerte empezó a soplar sobre {nombre_pueblo}, anunciando una tormenta como no se veía en años.',
      v_viento, array['viento'],
      '/images/la-campana-que-no-queria-sonar/07-cielo-oscurece-viento-tormenta.webp'),

    (v_story_id, 8,
      'El viejo campanero subió corriendo a la torre. Las campanas más antiguas estaban siendo reparadas esa semana y no podían sonar. Solo quedaba {nombre_campana} para avisarle al pueblo.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/08-campanero-sube-corriendo-torre.webp'),

    (v_story_id, 9,
      'La torre entera crujió con la fuerza del viento, y {nombre_campana} sintió el miedo de siempre, multiplicado: sonar mal frente a todos, o peor, asustar a los gorriones que vivían dentro de ella.',
      v_crujido, array['crujió'],
      '/images/la-campana-que-no-queria-sonar/09-torre-cruje-viento-fuerte.webp'),

    (v_story_id, 10,
      'Pero al mirar hacia adentro, descubrió que los gorriones ya no estaban. Habían sentido la tormenta acercarse y habían volado a refugiarse ellos solos, sin que nadie tuviera que avisarles.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/10-gorriones-ya-no-estan-volaron.webp'),

    (v_story_id, 11,
      'Sin esa excusa, {nombre_campana} se quedó únicamente con el miedo de sonar mal. El campanero esperaba junto a la cuerda, sin apurarla, dándole el tiempo que necesitaba.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/11-campana-sola-miedo-campanero-espera.webp'),

    (v_story_id, 12,
      'Por fin, temblando de pies a cabeza, {nombre_campana} dejó que el badajo la tocara por primera vez en toda su vida.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/12-badajo-toca-campana-primera-vez.webp'),

    (v_story_id, 13,
      'El sonido que salió no se parecía al de las campanas viejas: fue un poco más grave, un poco más áspero, completamente propio. Pero sonó fuerte y claro hasta el último rincón de {nombre_pueblo}, justo a tiempo.',
      v_campanada, array['sonó'],
      '/images/la-campana-que-no-queria-sonar/13-campanada-profunda-suena-pueblo.webp'),

    (v_story_id, 14,
      'Gracias a esa única campanada, todo el pueblo alcanzó a resguardarse antes de que la tormenta llegara de lleno.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/14-pueblo-se-resguarda-a-tiempo.webp'),

    (v_story_id, 15,
      'Esa noche, el viejo campanero subió a la torre y le dijo, con una sonrisa cansada: —No hacía falta que sonaras igual que las demás. Hacía falta que sonaras, y punto.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/15-campanero-habla-sonrisa-cansada.webp'),

    (v_story_id, 16,
      'Al atardecer siguiente, por primera vez, {nombre_campana} vio subir al cielo su propio hilito de color -- distinto a todos los demás, pero igual de real.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/16-campana-ve-su-propio-color.webp'),

    (v_story_id, 17,
      '{nombre_campana} entendió, por fin, que el miedo a sonar mal nunca había sido cuestión de sonar perfecto. Había sido, simplemente, cuestión de sonar de todos modos -- y descubrir, después, que su propio sonido ya alcanzaba.',
      null, array[]::text[],
      '/images/la-campana-que-no-queria-sonar/17-campana-reflexion-final.webp');

end $$;
