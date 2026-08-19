-- Cuentavoz: La marea que quería ganar todas las carreras
-- Edad: 2-7 años
-- Emoción dominante: entusiasmo compartido.
-- Enseñanza: jugar no consiste en llegar primero, sino en cuidar que todos quieran volver a jugar.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_olas uuid;
    v_chapoteo uuid;
    v_conchas uuid;
    v_burbujeo uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-marea-que-queria-ganar'
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
            'La marea que quería ganar todas las carreras',
            'la-marea-que-queria-ganar',
            '2-7 años',
            'Valores',
            true,
            '/images/portadas/la-marea-que-queria-ganar.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='La marea que quería ganar todas las carreras',
        edad_recomendada='2-7 años',
        categoria='Valores',
        es_personalizable=true,
        portada_url='/images/portadas/la-marea-que-queria-ganar.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='olas tranquilas') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('olas tranquilas', '/sounds/olas-tranquilas.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='chapoteo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='conchas rodando') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('conchas rodando', '/sounds/conchas-rodando.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='burbujeo de poza') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('burbujeo de poza', '/sounds/burbujeo-de-poza.mp3', 'ambiente');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_olas from sound_effects where nombre='olas tranquilas' limit 1;
    select id into v_chapoteo from sound_effects where nombre='chapoteo' limit 1;
    select id into v_conchas from sound_effects where nombre='conchas rodando' limit 1;
    select id into v_burbujeo from sound_effects where nombre='burbujeo de poza' limit 1;

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

        (v_story_id, 'nombre_marea', 'texto', array['Espuma', 'Marina', 'Azulina', 'Vaivén']),
        (v_story_id, 'nombre_cangrejo', 'texto', array['Pinzas', 'Coco', 'Roque', 'Tambor']),
        (v_story_id, 'nombre_playa', 'texto', array['Playa Obsidiana', 'Playa del Tambor', 'Playa Media Luna', 'Playa de las Pozas']),
        (v_story_id, 'grito_carrera', 'texto', array['vamos', 'adelante', 'ya', 'a correr']);

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
        'En {nombre_playa}, la arena era negra y el agua verde como una hoja al sol. Allí vivía {nombre_marea}, una marea rápida que convertía cada mañana en competencia. Corría contra troncos, sombras y nubes. Incluso intentaba llegar a la orilla antes que sus propias olas.',
        v_olas,
        array['olas'],
        '/images/la-marea-que-queria-ganar/01-marea-en-arena-negra.webp'),

        (v_story_id, 2,
        'Cuando ganaba, levantaba una corona de espuma. —¡Primera otra vez! —celebraba. {nombre_cangrejo}, un cangrejo pequeño de patas veloces, prefería recorrer las pozas mirando peces. —Una carrera también puede ser bonita por el camino —decía. La marea apenas lo oía mientras preparaba la siguiente salida.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/02-corona-de-espuma.webp'),

        (v_story_id, 3,
        'Aquella tarde, {nombre_marea} dibujó una línea blanca frente a la playa. Competirían hasta la roca más alta antes del atardecer. {nombre_cangrejo} aceptó, pero pidió una condición: cualquiera podría detenerse si alguien necesitaba cuidado. La marea respondió con su mejor sonrisa y gritó: —¡{grito_carrera}!',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/03-desafio-hasta-la-roca.webp'),

        (v_story_id, 4,
        'Comenzaron. {nombre_cangrejo} avanzó de lado entre las piedras. {nombre_marea} se lanzó de frente con un enorme chapoteo, cubriendo huellas y pequeñas dunas. Pasó junto al cangrejo como una sábana verde. —¡Voy ganando! —cantó, sin mirar qué dejaba girando detrás de su espuma.',
        v_chapoteo,
        array['chapoteo'],
        '/images/la-marea-que-queria-ganar/04-salida-con-chapoteo.webp'),

        (v_story_id, 5,
        'El recorrido atravesaba un jardín de pozas redondas. Los peces diminutos se ocultaron bajo las algas al sentir la corriente. {nombre_cangrejo} rodeó cada charco con cuidado. {nombre_marea}, en cambio, saltó por encima, apurada por tocar primero la punta oscura de la gran roca.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/05-jardin-de-pozas.webp'),

        (v_story_id, 6,
        'Más adelante, unas conchas rodaron desde un castillo de arena que varios niños habían construido. {nombre_cangrejo} se detuvo para empujarlas de vuelta alrededor de las torres. La marea vio el castillo inclinarse, pero siguió corriendo. Faltaba poco y no pensaba perder su ventaja.',
        v_conchas,
        array['conchas'],
        '/images/la-marea-que-queria-ganar/06-conchas-junto-al-castillo.webp'),

        (v_story_id, 7,
        'Una estrella de mar quedó boca arriba junto a una poza. {nombre_cangrejo} abandonó el sendero y, con ambas pinzas, logró voltearla. —La carrera puede esperar un momento —dijo. {nombre_marea} ya estaba lejos. Solo escuchó «esperar» y aceleró todavía más alrededor de las piedras negras.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/07-ayuda-a-la-estrella.webp'),

        (v_story_id, 8,
        'La punta de espuma tocó la roca cuando el sol seguía alto. {nombre_marea} levantó una ola en forma de bandera y anunció su victoria. Esperó aplausos. No llegó ninguno. La playa detrás de ella estaba silenciosa, y {nombre_cangrejo} ni siquiera aparecía entre las curvas del recorrido.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/08-victoria-sin-aplausos.webp'),

        (v_story_id, 9,
        'Desde la roca, la marea contempló su camino. El castillo estaba torcido, los peces seguían escondidos y varias huellas habían desaparecido. Más lejos, niños y cangrejo arreglaban juntos lo que la carrera había desordenado. Llegar primero se sintió extrañamente parecido a llegar sola.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/09-camino-desordenado.webp'),

        (v_story_id, 10,
        '{nombre_marea} pudo quedarse junto a la roca esperando que todos reconocieran su triunfo. En cambio, dio media vuelta. Regresó despacio, dejó agua en las pozas, acercó las conchas sin derribar las torres y ayudó a borrar los surcos peligrosos que había abierto entre la arena.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/10-regreso-cuidadoso.webp'),

        (v_story_id, 11,
        'Al encontrarse con {nombre_cangrejo}, no pidió otra carrera. —Quise ganar tanto que olvidé mirar quién seguía jugando —admitió. El cangrejo señaló las huellas que ambos habían dejado: unas iban de lado y otras parecían encaje de espuma. Juntas formaban un dibujo inesperado.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/11-huellas-diferentes.webp'),

        (v_story_id, 12,
        'Entonces inventaron un recorrido sin meta. {nombre_cangrejo} caminó en círculos cada vez mayores y {nombre_marea} siguió sus pasos con una cinta blanca. Los niños añadieron conchas de colores. Al terminar, toda la playa lucía una enorme espiral que parecía guardar el atardecer en su centro.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/12-espiral-de-espuma.webp'),

        (v_story_id, 13,
        'Los peces regresaron y pequeñas burbujas subieron desde las pozas, una tras otra, como aplausos redondos. Nadie preguntó quién había ganado. Cada participante había dejado una parte distinta en la espiral. {nombre_marea} sintió una alegría nueva: la de mirar alrededor y descubrir que todos seguían allí.',
        v_burbujeo,
        array['burbujas'],
        '/images/la-marea-que-queria-ganar/13-burbujas-en-las-pozas.webp'),

        (v_story_id, 14,
        'Uno de los niños observó el dibujo desde una duna. —La mejor carrera es aquella que da ganas de volver a jugar —dijo. {nombre_marea} dejó que la frase viajara sobre su superficie. Había llegado más despacio que antes, pero esta vez nadie había quedado atrás.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/14-todos-miran-la-espiral.webp'),

        (v_story_id, 15,
        'Al día siguiente organizaron otro juego. A veces avanzaban rápido; otras, se detenían para observar un pez o reparar una torre. Si alguien gritaba «¡{grito_carrera}!», no significaba «voy a vencerte». Significaba «ven conmigo». La marea descubrió que compartir el impulso hacía más grande la aventura.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/15-nuevo-juego-en-la-orilla.webp'),

        (v_story_id, 16,
        'Desde entonces, {nombre_marea} siguió llegando y retirándose en {nombre_playa}. Conservó su velocidad y su corona de espuma, pero dejó de contar victorias. Comprendió que jugar bien no era tocar primero una roca: era cuidar el recorrido para que todos desearan comenzar juntos una vez más.',
        null,
        array[]::text[],
        '/images/la-marea-que-queria-ganar/16-marea-y-amigos-al-anochecer.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/la-marea-que-queria-ganar.webp
-- Imágenes:
-- 01-marea-en-arena-negra.webp
-- 02-corona-de-espuma.webp
-- 03-desafio-hasta-la-roca.webp
-- 04-salida-con-chapoteo.webp
-- 05-jardin-de-pozas.webp
-- 06-conchas-junto-al-castillo.webp
-- 07-ayuda-a-la-estrella.webp
-- 08-victoria-sin-aplausos.webp
-- 09-camino-desordenado.webp
-- 10-regreso-cuidadoso.webp
-- 11-huellas-diferentes.webp
-- 12-espiral-de-espuma.webp
-- 13-burbujas-en-las-pozas.webp
-- 14-todos-miran-la-espiral.webp
-- 15-nuevo-juego-en-la-orilla.webp
-- 16-marea-y-amigos-al-anochecer.webp
-- Sonidos nuevos:
-- conchas-rodando.mp3
-- burbujeo-de-poza.mp3
