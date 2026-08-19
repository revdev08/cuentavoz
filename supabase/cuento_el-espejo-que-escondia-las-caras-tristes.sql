-- Cuentavoz: El espejo que escondía las caras tristes
-- Edad: 2-7 años
-- Emoción dominante: ternura.
-- Enseñanza: mostrar lo que sentimos permite que quienes nos quieren nos acompañen.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_obturador uuid;
    v_suspiro uuid;
    v_lluvia_ventana uuid;
    v_risas uuid;

begin

    select id
    into v_story_id
    from stories
    where slug='el-espejo-que-escondia-las-caras-tristes'
    limit 1;

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
            'El espejo que escondía las caras tristes',
            'el-espejo-que-escondia-las-caras-tristes',
            '2-7 años',
            'Emociones',
            true,
            '/images/portadas/el-espejo-que-escondia-las-caras-tristes.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='El espejo que escondía las caras tristes',
        edad_recomendada='2-7 años',
        categoria='Emociones',
        es_personalizable=true,
        portada_url='/images/portadas/el-espejo-que-escondia-las-caras-tristes.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos requeridos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='obturador de camara') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('obturador de camara', '/sounds/obturador-de-camara.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='suspiro suave') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('suspiro suave', '/sounds/suspiro-suave.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='lluvia sobre ventana') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('lluvia sobre ventana', '/sounds/lluvia-sobre-ventana.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='risas infantiles') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('risas infantiles', '/sounds/risas-infantiles.mp3', 'efecto');
    end if;

    select id into v_obturador from sound_effects where nombre='obturador de camara' limit 1;
    select id into v_suspiro from sound_effects where nombre='suspiro suave' limit 1;
    select id into v_lluvia_ventana from sound_effects where nombre='lluvia sobre ventana' limit 1;
    select id into v_risas from sound_effects where nombre='risas infantiles' limit 1;

    --------------------------------------------------
    -- Variables de personalización
    --------------------------------------------------

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (
        story_id,
        variable_key,
        tipo,
        opciones_sugeridas
    )

    values

        (v_story_id, 'nombre_espejo', 'texto', array['Vera', 'Reflejo', 'Luna', 'Azogue']),
        (v_story_id, 'nombre_nino', 'texto', array['Sara', 'Tomás', 'Emma', 'Leo']),
        (v_story_id, 'nombre_estudio', 'texto', array['Retratos Abril', 'La Ventana Clara', 'Casa Memoria', 'Fotos del Sol']),
        (v_story_id, 'color_marco', 'color', array['rojo cereza', 'verde jade', 'azul noche', 'dorado']);

    --------------------------------------------------
    -- Bloques
    --------------------------------------------------

    delete from story_blocks where story_id=v_story_id;

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
        'En la plaza de un pueblo lluvioso estaba {nombre_estudio}, un pequeño estudio de retratos con cortinas color mostaza. Junto a la cámara vivía {nombre_espejo}, un espejo ovalado de marco {color_marco}. Antes de cada fotografía, las familias se miraban en su cristal.',
        null,
        array[]::text[],
        '/images/el-espejo-que-escondia-las-caras-tristes/01-estudio-en-la-plaza.webp'),

        (v_story_id, 2,
        '{nombre_espejo} adoraba las sonrisas. Las estiraba un poquito, les daba brillo y borraba cualquier ceño arrugado. Si alguien llegaba preocupado, el espejo ocultaba aquella expresión bajo mejillas alegres. Creía que un retrato bonito debía guardar solamente felicidad, nunca lágrimas, miedo ni tristeza.',
        null,
        array[]::text[],
        '/images/el-espejo-que-escondia-las-caras-tristes/02-sonrisas-en-el-cristal.webp'),

        (v_story_id, 3,
        'Una mañana entró {nombre_nino} con su familia para celebrar un cumpleaños. Afuera, la lluvia dibujaba caminos torcidos sobre la ventana. Todos sacudieron los paraguas y hablaron emocionados del retrato. {nombre_nino}, en cambio, permaneció cerca de la puerta, apretando las manos dentro de los bolsillos.',
        v_lluvia_ventana,
        array['lluvia'],
        '/images/el-espejo-que-escondia-las-caras-tristes/03-llegada-bajo-la-lluvia.webp'),

        (v_story_id, 4,
        'Aquella mañana faltaba una persona muy querida que vivía lejos. {nombre_nino} deseaba tenerla junto a la familia en la fotografía. Al mirar el espejo, apareció una sonrisa perfecta, aunque por dentro quedaba un nudo. Nadie vio los ojos húmedos ni las manos escondidas.',
        null,
        array[]::text[],
        '/images/el-espejo-que-escondia-las-caras-tristes/04-sonrisa-que-esconde.webp'),

        (v_story_id, 5,
        'La fotógrafa acomodó sillas, alisó cuellos y pidió que todos miraran al frente. La cámara hizo clic. En la imagen, cada sonrisa parecía pintada con la misma brocha. La familia aplaudió, pero {nombre_nino} observó el retrato y sintió que allí faltaba algo más que una persona.',
        v_obturador,
        array['clic'],
        '/images/el-espejo-que-escondia-las-caras-tristes/05-primer-retrato-perfecto.webp'),

        (v_story_id, 6,
        '—Esa no es mi cara de hoy —dijo {nombre_nino} muy bajito. {nombre_espejo} onduló su cristal para que la sonrisa creciera todavía más. —Las caras tristes estropean los recuerdos —respondió—. Yo las escondo para que nadie tenga que mirarlas. Entonces se oyó un suspiro.',
        v_suspiro,
        array['suspiro'],
        '/images/el-espejo-que-escondia-las-caras-tristes/06-conversacion-con-el-espejo.webp'),

        (v_story_id, 7,
        'El suspiro no venía de {nombre_nino}. Salía de una fila de retratos antiguos: una abuela que extrañaba su jardín, dos hermanos que acababan de discutir y un panadero cansado. Sus sonrisas brillaban, pero ninguna contaba cómo se habían sentido realmente aquel día.',
        null,
        array[]::text[],
        '/images/el-espejo-que-escondia-las-caras-tristes/07-retratos-que-suspiran.webp'),

        (v_story_id, 8,
        '{nombre_espejo} tuvo miedo de mostrar una cara distinta. Quizá la familia rechazaría el retrato. Quizá cubrirían su marco con una tela. Cuando la fotógrafa preparó otra toma, el espejo volvió a dibujar alegría sobre {nombre_nino}. Esta vez, la sonrisa reflejada era tan grande que resultaba irreconocible.',
        null,
        array[]::text[],
        '/images/el-espejo-que-escondia-las-caras-tristes/08-sonrisa-demasiado-grande.webp'),

        (v_story_id, 9,
        '{nombre_nino} cerró los ojos y se apartó de la cámara. La familia dejó de acomodarse. —No quiero fingir —explicó—. Estoy feliz por mi cumpleaños y triste porque alguien falta. Las dos cosas caben dentro de mí. El estudio quedó silencioso, esperando la decisión del espejo.',
        null,
        array[]::text[],
        '/images/el-espejo-que-escondia-las-caras-tristes/09-dos-emociones-juntas.webp'),

        (v_story_id, 10,
        'Por primera vez, {nombre_espejo} dejó quieto su cristal. Reflejó la boca sin sonrisa, los ojos sinceros y una lágrima pequeña que no necesitaba desaparecer. La familia reconoció enseguida aquella expresión. En lugar de apartarse, acercaron sus sillas y rodearon a {nombre_nino} con los brazos.',
        null,
        array[]::text[],
        '/images/el-espejo-que-escondia-las-caras-tristes/10-primer-reflejo-sincero.webp'),

        (v_story_id, 11,
        'Alguien propuso dejar un lugar vacío en el centro y colocar allí una flor para recordar a quien estaba lejos. Otro contó una anécdota divertida. Hubo ojos húmedos, hombros juntos y risas verdaderas. Ninguna cara era perfecta; todas pertenecían al mismo momento compartido.',
        v_risas,
        array['risas'],
        '/images/el-espejo-que-escondia-las-caras-tristes/11-familia-alrededor-de-la-flor.webp'),

        (v_story_id, 12,
        'La cámara volvió a hacer clic. Esta vez, el retrato guardó una sonrisa pequeña, una lágrima, una flor y muchas manos enlazadas. Al revelarlo, la fotógrafa comprendió que la imagen parecía viva. No mostraba una felicidad inventada, sino una familia cuidándose en un día verdadero.',
        v_obturador,
        array['clic'],
        '/images/el-espejo-que-escondia-las-caras-tristes/12-segundo-retrato-verdadero.webp'),

        (v_story_id, 13,
        'Los retratos antiguos comenzaron a cambiar suavemente. La abuela recuperó su mirada nostálgica; los hermanos mostraron sus cejas enfadadas; el panadero dejó caer los párpados cansados. Sus imágenes no se volvieron feas. Al contrario, cada persona volvió a parecer única y reconocible.',
        null,
        array[]::text[],
        '/images/el-espejo-que-escondia-las-caras-tristes/13-retratos-recuperan-emociones.webp'),

        (v_story_id, 14,
        '—Una emoción no arruina un recuerdo —dijo la fotógrafa mientras colgaba la nueva foto—. Mostrarla ayuda a quienes nos quieren a saber cómo acompañarnos. {nombre_espejo} observó a {nombre_nino}, ya sin el nudo escondido, y comprendió que su cristal debía revelar, no disfrazar.',
        null,
        array[]::text[],
        '/images/el-espejo-que-escondia-las-caras-tristes/14-leccion-junto-al-retrato.webp'),

        (v_story_id, 15,
        'Desde aquel día, quienes entraban en {nombre_estudio} podían ensayar muchas caras frente a {nombre_espejo}: alegría, timidez, enojo, calma o pena. El espejo no corregía ninguna. A veces, una expresión cambiaba después de una conversación, un pañuelo ofrecido o un abrazo necesario.',
        null,
        array[]::text[],
        '/images/el-espejo-que-escondia-las-caras-tristes/15-galeria-de-caras-sinceras.webp'),

        (v_story_id, 16,
        'El retrato de aquella familia quedó junto a la ventana. Cuando la lluvia regresaba, {nombre_nino} visitaba el estudio y lo miraba con cariño. {nombre_espejo} había aprendido que no debemos esconder lo que sentimos: cuando una cara habla con verdad, alguien puede acercarse y cuidarla.',
        v_lluvia_ventana,
        array['lluvia'],
        '/images/el-espejo-que-escondia-las-caras-tristes/16-retrato-junto-a-la-ventana.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/el-espejo-que-escondia-las-caras-tristes.webp
-- Imágenes:
-- 01-estudio-en-la-plaza.webp
-- 02-sonrisas-en-el-cristal.webp
-- 03-llegada-bajo-la-lluvia.webp
-- 04-sonrisa-que-esconde.webp
-- 05-primer-retrato-perfecto.webp
-- 06-conversacion-con-el-espejo.webp
-- 07-retratos-que-suspiran.webp
-- 08-sonrisa-demasiado-grande.webp
-- 09-dos-emociones-juntas.webp
-- 10-primer-reflejo-sincero.webp
-- 11-familia-alrededor-de-la-flor.webp
-- 12-segundo-retrato-verdadero.webp
-- 13-retratos-recuperan-emociones.webp
-- 14-leccion-junto-al-retrato.webp
-- 15-galeria-de-caras-sinceras.webp
-- 16-retrato-junto-a-la-ventana.webp
-- Sonidos requeridos:
-- obturador-de-camara.mp3
-- suspiro-suave.mp3
-- lluvia-sobre-ventana.mp3
-- risas-infantiles.mp3
