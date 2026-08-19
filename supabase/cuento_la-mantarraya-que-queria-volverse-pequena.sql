-- Cuentavoz: La mantarraya que quería volverse pequeña
-- Edad: 2-7 años
-- Emoción dominante: confianza serena.
-- Enseñanza: ser amable no exige hacerse pequeño; podemos ocupar nuestro lugar cuidando a los demás.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_olas uuid;
    v_burbujas uuid;
    v_chapoteo uuid;
    v_aleteo uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-mantarraya-que-queria-volverse-pequena'
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
            'La mantarraya que quería volverse pequeña',
            'la-mantarraya-que-queria-volverse-pequena',
            '2-7 años',
            'Confianza',
            true,
            '/images/portadas/la-mantarraya-que-queria-volverse-pequena.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='La mantarraya que quería volverse pequeña',
        edad_recomendada='2-7 años',
        categoria='Confianza',
        es_personalizable=true,
        portada_url='/images/portadas/la-mantarraya-que-queria-volverse-pequena.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos requeridos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='olas tranquilas') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('olas tranquilas', '/sounds/olas-tranquilas.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='burbujas submarinas') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('burbujas submarinas', '/sounds/burbujas-submarinas.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='chapoteo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='aleteo submarino') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('aleteo submarino', '/sounds/aleteo-submarino.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_olas from sound_effects where nombre='olas tranquilas' limit 1;
    select id into v_burbujas from sound_effects where nombre='burbujas submarinas' limit 1;
    select id into v_chapoteo from sound_effects where nombre='chapoteo' limit 1;
    select id into v_aleteo from sound_effects where nombre='aleteo submarino' limit 1;

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

        (v_story_id, 'nombre_mantarraya', 'texto', array['Mara', 'Nube', 'Ala', 'Coral']),
        (v_story_id, 'color_aletas', 'color', array['azul profundo', 'violeta', 'gris plateado', 'verde mar']),
        (v_story_id, 'nombre_laguna', 'texto', array['Laguna Caracola', 'Laguna Turquesa', 'Laguna del Sol', 'Laguna Cristal']),
        (v_story_id, 'nombre_caballito', 'texto', array['Rizo', 'Mimo', 'Tilo', 'Burbuja']);

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
        'Bajo las olas de {nombre_laguna} nadaba {nombre_mantarraya}, una mantarraya joven de aletas {color_aletas}. Cuando las abría por completo, parecía una cometa viajando bajo el agua. Podía cubrir tres corales, cinco caracolas y una familia entera de peces diminutos con su sombra.',
        v_olas,
        array['olas'],
        '/images/la-mantarraya-que-queria-volverse-pequena/01-mantarraya-sobre-el-arrecife.webp'),

        (v_story_id, 2,
        'A {nombre_mantarraya} le gustaba su tamaño cuando nadaba sola. Cerca de otros, plegaba las aletas y torcía la cola. Temía rozar un coral, interrumpir un juego o tapar la luz. —Si consigo volverme pequeña —pensaba—, nadie tendrá que apartarse por mí.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/02-aletas-plegadas.webp'),

        (v_story_id, 3,
        'Cada mañana visitaba un jardín de anémonas donde vivía {nombre_caballito}, un caballito de mar que cuidaba huevos transparentes entre las ramas. —Aquí cabe tu sombra —decía. Pero {nombre_mantarraya} pasaba de costado, levantando apenas unas burbujas, para ocupar el menor espacio posible.',
        v_burbujas,
        array['burbujas'],
        '/images/la-mantarraya-que-queria-volverse-pequena/03-jardin-de-anemonas.webp'),

        (v_story_id, 4,
        'Al comenzar la estación cálida, el agua descendió alrededor del arrecife. En la parte menos profunda quedaron charcos tibios, llenos de crías de pez y pequeños camarones. Todos esperaban que la marea regresara antes del mediodía. El sol, mientras tanto, subía sin ninguna prisa.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/04-laguna-en-marea-baja.webp'),

        (v_story_id, 5,
        '{nombre_mantarraya} vio a las crías nadando en círculos bajo el sol. Quiso acercarse, pero dos peces salieron apresurados de su camino. Ella plegó todavía más las aletas. —¿Ves? —se dijo—. Soy demasiado grande. Será mejor esperar detrás de las rocas hasta que vuelva el agua.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/05-mantarraya-tras-las-rocas.webp'),

        (v_story_id, 6,
        'El calor aumentó. Las anémonas cerraron sus tentáculos y los camarones buscaron huecos que ya estaban ocupados. {nombre_caballito} movía una hoja para refrescar los huevos, aunque su cola comenzaba a cansarse. Desde las rocas, {nombre_mantarraya} observaba sin atreverse a salir.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/06-calor-en-los-charcos.webp'),

        (v_story_id, 7,
        'Una ola llegó hasta el borde con un chapoteo, pero se retiró antes de alcanzar el jardín. La marea tardaría. {nombre_mantarraya} imaginó sus grandes aletas extendidas sobre el agua poco profunda. Podrían dar sombra; también podrían molestar. Por primera vez, ambas posibilidades pesaron igual.',
        v_chapoteo,
        array['chapoteo'],
        '/images/la-mantarraya-que-queria-volverse-pequena/07-ola-que-no-alcanza.webp'),

        (v_story_id, 8,
        '—No necesito que desaparezcas —dijo {nombre_caballito}, sin dejar de mover la hoja—. Necesito saber si puedes quedarte cerca sin aplastar las anémonas. No le pidió que fuera distinta. Le pidió atención. {nombre_mantarraya} miró el fondo y buscó un camino ancho entre los corales.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/08-peticion-del-caballito.webp'),

        (v_story_id, 9,
        'Avanzó despacio, diciendo dónde pondría cada aleta antes de moverla. Los peces dejaron un corredor. Los cangrejos señalaron una piedra alta. Nadie tuvo que huir. Cuando llegó al jardín, {nombre_mantarraya} todavía podía regresar a las rocas y esperar sin equivocarse.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/09-corredor-entre-corales.webp'),

        (v_story_id, 10,
        'En cambio, eligió abrirse. Con un aleteo suave, primero desplegó una aleta. Después la otra. Su cuerpo formó un techo amplio sobre las anémonas, sin tocarlas. La sombra cubrió huevos, camarones y crías de pez. Debajo, el agua dejó de arder como sopa caliente.',
        v_aleteo,
        array['aleteo'],
        '/images/la-mantarraya-que-queria-volverse-pequena/10-techo-de-aletas.webp'),

        (v_story_id, 11,
        'Durante un rato, {nombre_mantarraya} permaneció inmóvil. Entonces descubrió algo sorprendente: sobre su espalda, la luz dibujaba caminos ondulados; bajo su vientre, pequeños peces encendían puntos azules. Su sombra parecía un cielo nocturno que navegaba en pleno mediodía por la laguna.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/11-cielo-bajo-la-sombra.webp'),

        (v_story_id, 12,
        'Otros habitantes se acercaron, pero no se amontonaron. Preguntaron dónde había lugar y {nombre_mantarraya} respondió moviendo suavemente la cola. Un cangrejo sostuvo una hoja; varios peces llevaron agua fresca entre sus bocas. La sombra ayudaba porque todos la usaban con cuidado.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/12-refugio-compartido.webp'),

        (v_story_id, 13,
        'Por fin regresó la marea. El agua entró por los canales, rodeó las piedras y levantó a las crías con delicadeza. {nombre_mantarraya} esperó hasta que el último huevo quedó fresco. Luego inició un aleteo lento y dejó que la corriente la elevara sobre el arrecife.',
        v_aleteo,
        array['aleteo'],
        '/images/la-mantarraya-que-queria-volverse-pequena/13-regreso-de-la-marea.webp'),

        (v_story_id, 14,
        '—Ser cuidadosa no significa hacerte pequeña —dijo {nombre_caballito} desde su anémona—. Significa mirar, preguntar y usar bien el espacio que tienes. {nombre_mantarraya} abrió las aletas de punta a punta. Esta vez, los peces no escaparon: nadaron debajo como si siguieran una nube.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/14-nado-bajo-la-nube.webp'),

        (v_story_id, 15,
        'Desde aquel día, {nombre_mantarraya} dejó de esconderse detrás de las rocas. Avisaba antes de girar en lugares estrechos y preguntaba dónde podía descansar. También decía cuando necesitaba que alguien se apartara. Su tamaño no había cambiado; había cambiado la forma de habitarlo.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/15-mantarraya-ocupa-su-lugar.webp'),

        (v_story_id, 16,
        'Al caer la tarde, {nombre_mantarraya} cruzó {nombre_laguna} con las aletas completamente extendidas. Comprendió que no debía encogerse para ser amable. Podía ocupar su lugar, escuchar a quienes nadaban cerca y convertir su gran sombra en compañía, sin dejar de ser ella misma.',
        null,
        array[]::text[],
        '/images/la-mantarraya-que-queria-volverse-pequena/16-vuelo-al-atardecer.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/la-mantarraya-que-queria-volverse-pequena.webp
-- Imágenes:
-- 01-mantarraya-sobre-el-arrecife.webp
-- 02-aletas-plegadas.webp
-- 03-jardin-de-anemonas.webp
-- 04-laguna-en-marea-baja.webp
-- 05-mantarraya-tras-las-rocas.webp
-- 06-calor-en-los-charcos.webp
-- 07-ola-que-no-alcanza.webp
-- 08-peticion-del-caballito.webp
-- 09-corredor-entre-corales.webp
-- 10-techo-de-aletas.webp
-- 11-cielo-bajo-la-sombra.webp
-- 12-refugio-compartido.webp
-- 13-regreso-de-la-marea.webp
-- 14-nado-bajo-la-nube.webp
-- 15-mantarraya-ocupa-su-lugar.webp
-- 16-vuelo-al-atardecer.webp
-- Sonidos requeridos:
-- olas-tranquilas.mp3
-- burbujas-submarinas.mp3
-- chapoteo.mp3
-- aleteo-submarino.mp3
