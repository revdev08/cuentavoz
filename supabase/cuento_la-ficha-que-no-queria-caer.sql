-- Cuentavoz: La ficha que no quería caer
-- Edad: 2-7 años
-- Emoción dominante: expectación alegre.
-- Enseñanza: ceder por confianza no es fracasar; puede permitir que algo compartido avance.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_grillos uuid;
    v_domino uuid;
    v_aplausos uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-ficha-que-no-queria-caer'
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
            'La ficha que no quería caer',
            'la-ficha-que-no-queria-caer',
            '2-7 años',
            'Familia',
            true,
            '/images/portadas/la-ficha-que-no-queria-caer.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='La ficha que no quería caer',
        edad_recomendada='2-7 años',
        categoria='Familia',
        es_personalizable=true,
        portada_url='/images/portadas/la-ficha-que-no-queria-caer.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos requeridos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='grillos nocturnos') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='fichas de domino') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('fichas de domino', '/sounds/fichas-de-domino.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='aplausos suaves') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('aplausos suaves', '/sounds/aplausos-suaves.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_grillos from sound_effects where nombre='grillos nocturnos' limit 1;
    select id into v_domino from sound_effects where nombre='fichas de domino' limit 1;
    select id into v_aplausos from sound_effects where nombre='aplausos suaves' limit 1;

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

        (v_story_id, 'nombre_ficha', 'texto', array['Pinta', 'Doble', 'Mota', 'Dominó']),
        (v_story_id, 'color_ficha', 'color', array['azul añil', 'rojo guayaba', 'verde jade', 'amarillo mango']),
        (v_story_id, 'nombre_nino', 'texto', array['Eva', 'Nico', 'Sara', 'Leo']),
        (v_story_id, 'animal_mosaico', 'animal', array['colibrí', 'tortuga', 'mariposa', 'pez']);

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
        'En el patio de una casa antigua vivía {nombre_ficha}, una ficha de dominó de color {color_ficha}. Cada diciembre, la familia construía recorridos sobre el suelo: curvas, puentes diminutos y filas tan largas que atravesaban las macetas antes de regresar a la mesa.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/01-ficha-en-el-patio.webp'),

        (v_story_id, 2,
        '{nombre_ficha} disfrutaba quedar perfectamente derecha. Miraba sus puntos pulidos y pensaba que una ficha valiosa debía mantenerse en pie. Las demás decían que caer también formaba parte del juego. Ella respondía: —Caerse es lo que ocurre cuando alguien pierde el equilibrio.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/02-orgullosa-y-derecha.webp'),

        (v_story_id, 3,
        'Ese año, {nombre_nino} planeó un recorrido especial para la Noche de los Faroles. —Cada ficha confiará en la anterior y empujará con cuidado a la siguiente —explicó. Al final, la fila tocaría una palanca que encendería todas las luces del patio.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/03-plan-de-los-faroles.webp'),

        (v_story_id, 4,
        'Con una cuerda y tiza, {nombre_nino} dibujó sobre las baldosas la figura de {un_animal_mosaico} {animal_mosaico}. Las fichas ocuparon el contorno, separadas por la distancia exacta. {nombre_ficha} quedó en el centro de una curva, donde debía cambiar la dirección del movimiento.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/04-contorno-sobre-baldosas.webp'),

        (v_story_id, 5,
        'Durante el ensayo, doce fichas hicieron tacatacá sobre una manta. La última se detuvo justo antes de tocar a {nombre_ficha}. Ella observó cómo todas quedaron acostadas y se sintió satisfecha de seguir erguida. Nadie pareció roto, pero eso no cambió su opinión.',
        v_domino,
        array['tacatacá'],
        '/images/la-ficha-que-no-queria-caer/05-primer-ensayo.webp'),

        (v_story_id, 6,
        'Antes de la celebración, {nombre_ficha} se movió en secreto apenas medio paso. Parecía una distancia pequeña, pero bastaba para que la ficha anterior no pudiera alcanzarla. —Así conservaré mi equilibrio y quizá las luces se enciendan de todos modos —pensó.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/06-medio-paso-secreto.webp'),

        (v_story_id, 7,
        'Llegó la noche. Los grillos cantaban detrás de las materas y las familias rodearon el dibujo. {nombre_nino} empujó suavemente la primera ficha. La fila avanzó por una escalera, cruzó un puente de cartón y recorrió el lomo del animal trazado.',
        v_grillos,
        array['grillos'],
        '/images/la-ficha-que-no-queria-caer/07-comienza-la-noche.webp'),

        (v_story_id, 8,
        'La secuencia llegó a la curva. La ficha anterior cayó, pero encontró solamente aire. {nombre_ficha} continuó de pie. Delante de ella, cientos de compañeras permanecieron inmóviles; la palanca quedó lejos y los faroles siguieron apagados. Nadie entendía dónde estaba el problema.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/08-secuencia-interrumpida.webp'),

        (v_story_id, 9,
        '{nombre_nino} siguió la fila hasta descubrir el espacio. No regañó a la ficha. Se sentó en la baldosa y preguntó: —¿Te daba miedo caer? {nombre_ficha} miró a quienes descansaban detrás. —Pensé que, si seguía derecha, demostraría que era la más fuerte.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/09-conversacion-en-la-curva.webp'),

        (v_story_id, 10,
        'La ficha anterior habló desde la manta: —Yo también tuve miedo la primera vez. Después descubrí que no caía sola; recibía un impulso y entregaba otro. {nombre_ficha} contempló la larga figura incompleta. Su firmeza había protegido su posición, pero detenido el movimiento de todos.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/10-impulso-compartido.webp'),

        (v_story_id, 11,
        '{nombre_nino} colocó una manta delgada bajo la curva y levantó las fichas anteriores con paciencia. No empujó a {nombre_ficha}. Solamente reconstruyó el camino hasta su marca original. Ella podía permanecer apartada o regresar voluntariamente al lugar que había elegido antes.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/11-camino-reconstruido.webp'),

        (v_story_id, 12,
        '{nombre_ficha} volvió a la línea de tiza. Sintió cerca a la ficha anterior y miró a la siguiente. —Esta vez entregaré el movimiento —dijo. Cuando recibió el toque, no luchó por quedarse rígida: se inclinó y cayó suavemente sobre la manta.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/12-decision-en-la-linea.webp'),

        (v_story_id, 13,
        'El tacatacá despertó otra vez. Corrió por la cola, rodeó las alas, saltó un túnel y alcanzó la última ficha. Esta tocó la palanca. Uno por uno, los faroles encendieron círculos cálidos alrededor del patio, sin borrar la oscuridad del cielo.',
        v_domino,
        array['tacatacá'],
        '/images/la-ficha-que-no-queria-caer/13-recorrido-completo.webp'),

        (v_story_id, 14,
        'Desde el balcón, las fichas caídas ya no parecían derrotadas. Sus colores formaban la figura completa de {un_animal_mosaico} {animal_mosaico}, nadando entre muchas luces pequeñas. {nombre_ficha} era una mancha de color en el corazón del dibujo, exactamente donde debía estar aquella noche.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/14-animal-de-fichas-y-luz.webp'),

        (v_story_id, 15,
        'Los aplausos llenaron el patio. {nombre_nino} recogió a {nombre_ficha} y la puso derecha sobre la palma. —Ceder por confianza no fue perderte —dijo—. Permitió que el movimiento continuara a través de ti. La ficha seguía entera, con todos sus puntos en su sitio.',
        v_aplausos,
        array['aplausos'],
        '/images/la-ficha-que-no-queria-caer/15-ficha-sobre-la-palma.webp'),

        (v_story_id, 16,
        'Al terminar, todas las fichas volvieron a levantarse para otro recorrido. {nombre_ficha} comprendió que estar de pie y dejarse caer podían ser valiosos en momentos distintos. Desde entonces cuidó su equilibrio, pero también supo cuándo inclinarse para que algo hermoso siguiera avanzando.',
        null,
        array[]::text[],
        '/images/la-ficha-que-no-queria-caer/16-nuevo-recorrido.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/la-ficha-que-no-queria-caer.webp
-- Imágenes:
-- 01-ficha-en-el-patio.webp
-- 02-orgullosa-y-derecha.webp
-- 03-plan-de-los-faroles.webp
-- 04-contorno-sobre-baldosas.webp
-- 05-primer-ensayo.webp
-- 06-medio-paso-secreto.webp
-- 07-comienza-la-noche.webp
-- 08-secuencia-interrumpida.webp
-- 09-conversacion-en-la-curva.webp
-- 10-impulso-compartido.webp
-- 11-camino-reconstruido.webp
-- 12-decision-en-la-linea.webp
-- 13-recorrido-completo.webp
-- 14-animal-de-fichas-y-luz.webp
-- 15-ficha-sobre-la-palma.webp
-- 16-nuevo-recorrido.webp
-- Sonidos requeridos:
-- grillos.mp3
-- fichas-de-domino.mp3
-- aplausos-suaves.mp3
