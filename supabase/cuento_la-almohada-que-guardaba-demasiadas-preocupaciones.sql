-- Cuentavoz: La almohada que guardaba demasiadas preocupaciones
-- Edad: 2-7 años
-- Emoción dominante: calma y seguridad.
-- Enseñanza: una preocupación compartida no desaparece de inmediato, pero deja de pesar en soledad.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_lluvia_techo uuid;
    v_tictac uuid;
    v_suspiro uuid;
    v_pasos_pasillo uuid;
    v_crujido uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-almohada-que-guardaba-demasiadas-preocupaciones'
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
            'La almohada que guardaba demasiadas preocupaciones',
            'la-almohada-que-guardaba-demasiadas-preocupaciones',
            '2-7 años',
            'Emociones',
            true,
            '/images/portadas/la-almohada-que-guardaba-demasiadas-preocupaciones.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='La almohada que guardaba demasiadas preocupaciones',
        edad_recomendada='2-7 años',
        categoria='Emociones',
        es_personalizable=true,
        portada_url='/images/portadas/la-almohada-que-guardaba-demasiadas-preocupaciones.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='lluvia sobre techo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('lluvia sobre techo', '/sounds/lluvia-sobre-techo.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='tictac de reloj') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('tictac de reloj', '/sounds/tictac-de-reloj.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='suspiro suave') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('suspiro suave', '/sounds/suspiro-suave.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='pasos en pasillo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pasos en pasillo', '/sounds/pasos-en-pasillo.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_lluvia_techo from sound_effects where nombre='lluvia sobre techo' limit 1;
    select id into v_tictac from sound_effects where nombre='tictac de reloj' limit 1;
    select id into v_suspiro from sound_effects where nombre='suspiro suave' limit 1;
    select id into v_pasos_pasillo from sound_effects where nombre='pasos en pasillo' limit 1;
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

        (v_story_id, 'nombre_almohada', 'texto', array['Nube', 'Mota', 'Pluma', 'Lunita']),
        (v_story_id, 'nombre_nino', 'texto', array['Lucía', 'Martín', 'Elena', 'Simón']),
        (v_story_id, 'color_manta', 'color', array['azul', 'verde', 'rojo', 'morado', 'dorado']),
        (v_story_id, 'reto_manana', 'texto', array['cantar frente al salón', 'visitar al dentista', 'conocer una clase nueva', 'dormir fuera de casa']);

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
        'En una habitación bajo un tejado inclinado dormía {nombre_almohada}, una almohada pequeña con esquinas redondas. Cada noche esperaba a {nombre_nino} sobre una manta de color {color_manta}. Conocía sus bostezos, sus risas escondidas y la forma exacta de acomodar una mejilla cansada.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/01-almohada-sobre-cama.webp'),

        (v_story_id, 2,
        'La familia de {nombre_nino} repetía una frase antes de apagar la lámpara: —Lo que pesa en el corazón se vuelve más liviano cuando encuentra palabras. Pero {nombre_nino} no quería interrumpir a nadie por cosas pequeñas. Entonces comenzó a contárselas en secreto a {nombre_almohada}.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/02-secreto-antes-de-dormir.webp'),

        (v_story_id, 3,
        'La primera preocupación fue diminuta: una cuchara perdida durante la merienda. {nombre_almohada} abrió un pliegue y guardó aquellas palabras entre sus plumas. Pensó que eso era cuidar. Esa noche la lluvia tamborileó sobre el techo, y {nombre_nino} se durmió abrazándola con fuerza.',
        v_lluvia_techo,
        array['lluvia'],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/03-lluvia-sobre-tejado.webp'),

        (v_story_id, 4,
        'Después llegaron otras inquietudes: un dibujo arrugado, una carrera perdida, una palabra que salió demasiado fuerte. Cada confesión entraba en {nombre_almohada} como una piedrita invisible. Ella se volvía un poco más pesada, pero sonreía. Estaba convencida de que una buena almohada debía cargarlo todo.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/04-piedritas-invisibles.webp'),

        (v_story_id, 5,
        'Una tarde, {nombre_nino} supo que al día siguiente debía {reto_manana}. Intentó jugar, cenar y ponerse el pijama como siempre. Sin embargo, la preocupación lo siguió hasta la cama. El reloj hizo tictac en la pared, contando minutos que parecían demasiado despiertos.',
        v_tictac,
        array['tictac'],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/05-reloj-en-la-pared.webp'),

        (v_story_id, 6,
        '—No quiero que nadie piense que soy cobarde —susurró {nombre_nino}. {nombre_almohada} recibió la frase y la empujó muy adentro. Aquella preocupación no era una piedrita. Era redonda y pesada como una naranja. Las costuras de la almohada se estiraron, aunque ella fingió estar cómoda.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/06-preocupacion-como-naranja.webp'),

        (v_story_id, 7,
        'Durante la madrugada, {nombre_nino} cambió de lado muchas veces. {nombre_almohada} estaba llena de bultos y ya no encontraba dónde recibir su cabeza. La cama crujió con cada vuelta. Por primera vez, guardar las preocupaciones no se pareció a proteger: se pareció a mantenerlas despiertas.',
        v_crujido,
        array['crujió'],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/07-noche-sin-descanso.webp'),

        (v_story_id, 8,
        'Al intentar acomodarse, {nombre_almohada} cayó al suelo. Estaba tan redonda que rodó debajo de la silla, cruzó la alfombra y chocó suavemente contra la puerta. De su interior salió un murmullo: cuchara, dibujo, carrera, palabra, mañana. Eran todas las cosas que había escondido.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/08-almohada-rueda-al-suelo.webp'),

        (v_story_id, 9,
        '{nombre_nino} se sentó junto a ella. —Te las conté para sentirme mejor —dijo—, pero ahora pesamos los dos. {nombre_almohada} quiso responder que podía soportar una más. En cambio, dejó escapar un largo suspiro. La costura de una esquina se abrió apenas, como una boca cansada.',
        v_suspiro,
        array['suspiro'],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/09-suspiro-en-la-alfombra.webp'),

        (v_story_id, 10,
        'Por aquella abertura salió la preocupación más pequeña convertida en un susurro: «la cuchara». Luego salió «el dibujo». No volaron ni desaparecieron; quedaron flotando cerca, suaves como pelusas a la luz de la luna. {nombre_nino} descubrió que podía mirarlas sin que crecieran.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/10-palabras-como-pelusas.webp'),

        (v_story_id, 11,
        'Cuando apareció el susurro de {reto_manana}, volvió a sentirse enorme. {nombre_almohada} comprendió que no debía esconderlo otra vez. Empujó con su última esquina hasta abrir la puerta. Desde el pasillo llegaba una línea de luz. —Esta preocupación necesita más de dos oídos —dijo.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/11-puerta-con-luz.webp'),

        (v_story_id, 12,
        '{nombre_nino} dudó. Después llamó a su familia. Unos pasos avanzaron por el pasillo y la luz se hizo más ancha. Nadie se rio ni dijo que aquello fuera pequeño. Se sentaron en la alfombra, junto a la almohada redonda, y escucharon hasta el final.',
        v_pasos_pasillo,
        array['pasos'],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/12-familia-en-el-pasillo.webp'),

        (v_story_id, 13,
        'Hablaron de lo que podía ocurrir mañana y también de lo que probablemente no ocurriría. Prepararon una frase para empezar, una pausa por si hacía falta y una mano cercana. El reto seguía existiendo, pero ya no ocupaba toda la habitación. Cabía entre varias voces tranquilas.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/13-plan-entre-varias-voces.webp'),

        (v_story_id, 14,
        'Mientras conversaban, las palabras flotantes descendieron una por una. Al tocar la alfombra se volvieron plumas corrientes. La familia las recogió y rellenó con ellas una esquina vacía de {nombre_almohada}. Ya no eran cargas escondidas: eran preocupaciones escuchadas, suaves y pequeñas en su lugar.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/14-palabras-se-vuelven-plumas.webp'),

        (v_story_id, 15,
        'Antes de volver a la cama, alguien acarició la costura reparada. —Compartir una preocupación no siempre la hace desaparecer —dijo—, pero evita que una sola persona tenga que cargarla completa. {nombre_almohada} recuperó sus esquinas. {nombre_nino} también parecía respirar con más espacio.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/15-costura-reparada.webp'),

        (v_story_id, 16,
        'Desde entonces, {nombre_nino} y {nombre_almohada} conservaron un acuerdo: los sueños podían quedarse toda la noche, pero las preocupaciones importantes debían encontrar palabras y oídos atentos. Cuando llegó el momento de {reto_manana}, el miedo seguía allí, solo que ahora era lo bastante liviano para caminar acompañado.',
        null,
        array[]::text[],
        '/images/la-almohada-que-guardaba-demasiadas-preocupaciones/16-manana-acompanada.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/la-almohada-que-guardaba-demasiadas-preocupaciones.webp
-- Imágenes:
-- 01-almohada-sobre-cama.webp
-- 02-secreto-antes-de-dormir.webp
-- 03-lluvia-sobre-tejado.webp
-- 04-piedritas-invisibles.webp
-- 05-reloj-en-la-pared.webp
-- 06-preocupacion-como-naranja.webp
-- 07-noche-sin-descanso.webp
-- 08-almohada-rueda-al-suelo.webp
-- 09-suspiro-en-la-alfombra.webp
-- 10-palabras-como-pelusas.webp
-- 11-puerta-con-luz.webp
-- 12-familia-en-el-pasillo.webp
-- 13-plan-entre-varias-voces.webp
-- 14-palabras-se-vuelven-plumas.webp
-- 15-costura-reparada.webp
-- 16-manana-acompanada.webp
-- Sonidos nuevos:
-- lluvia-sobre-techo.mp3
-- tictac-de-reloj.mp3
-- suspiro-suave.mp3
-- pasos-en-pasillo.mp3
