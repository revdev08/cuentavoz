-- Cuentavoz: La luciérnaga que inventaba respuestas
-- Edad: 2-7 años
-- Emoción dominante: asombro.
-- Enseñanza: decir "no sé" puede ser el comienzo de un descubrimiento compartido.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_grillos uuid;
    v_chapoteo uuid;
    v_ranas uuid;
    v_aleteo uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-luciernaga-que-inventaba-respuestas'
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
            'La luciérnaga que inventaba respuestas',
            'la-luciernaga-que-inventaba-respuestas',
            '2-7 años',
            'Naturaleza',
            true,
            '/images/portadas/la-luciernaga-que-inventaba-respuestas.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='La luciérnaga que inventaba respuestas',
        edad_recomendada='2-7 años',
        categoria='Naturaleza',
        es_personalizable=true,
        portada_url='/images/portadas/la-luciernaga-que-inventaba-respuestas.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos requeridos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='grillos nocturnos') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='chapoteo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='croar de ranas') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('croar de ranas', '/sounds/croar-de-ranas.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='aleteo de luciernagas') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('aleteo de luciernagas', '/sounds/aleteo-de-luciernagas.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_grillos from sound_effects where nombre='grillos nocturnos' limit 1;
    select id into v_chapoteo from sound_effects where nombre='chapoteo' limit 1;
    select id into v_ranas from sound_effects where nombre='croar de ranas' limit 1;
    select id into v_aleteo from sound_effects where nombre='aleteo de luciernagas' limit 1;

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

        (v_story_id, 'nombre_luciernaga', 'texto', array['Luma', 'Chispa', 'Mara', 'Fito']),
        (v_story_id, 'color_luz', 'color', array['amarillo miel', 'verde limón', 'azul luna', 'naranja suave']),
        (v_story_id, 'nombre_cienaga', 'texto', array['Lunaquieta', 'Juncoalto', 'Aguaespejo', 'Estrellabaja']),
        (v_story_id, 'pregunta_favorita', 'texto', array['¿dónde duerme el viento?', '¿por qué canta el agua?', '¿quién enciende las estrellas?', '¿adónde viajan las nubes?']);

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
        'Cada noche, sobre las aguas oscuras de {nombre_cienaga}, {nombre_luciernaga} encendía su luz de color {color_luz}. Los insectos pequeños volaban detrás de ella porque conocía cada junco, cada piedra tibia y, según aseguraba con mucha seguridad, la respuesta de todas las preguntas.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/01-guia-sobre-la-cienaga.webp'),

        (v_story_id, 2,
        'Cuando alguien preguntaba «{pregunta_favorita}», {nombre_luciernaga} respondía enseguida. Si no sabía, inventaba algo tan bonito que nadie lo dudaba. Le gustaba ver todas las antenas levantarse con admiración. Decir «no sé» le parecía igual que apagar su propia luz para siempre.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/02-respuesta-inventada.webp'),

        (v_story_id, 3,
        'Una tarde llegaron tres polillas viajeras buscando la Laguna Redonda, donde florecían nenúfares solo durante una noche. —¿Qué canal debemos seguir? —preguntaron con ilusión. {nombre_luciernaga} nunca había ido allí, pero señaló el paso más oscuro. —Ese, sin duda alguna —contestó.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/03-polillas-piden-direccion.webp'),

        (v_story_id, 4,
        'Las polillas partieron antes del anochecer. {nombre_luciernaga} intentó sentirse importante, aunque su luz titiló dos veces. Los grillos comenzaron su concierto entre los juncos cercanos. Ninguno conocía la Laguna Redonda. Ninguno había visto señales que confirmaran aquella dirección tan segura.',
        v_grillos,
        array['grillos'],
        '/images/la-luciernaga-que-inventaba-respuestas/04-duda-entre-los-juncos.webp'),

        (v_story_id, 5,
        'Al subir la luna, una de las polillas regresó con las alas mojadas. El canal terminaba en barro profundo; sus hermanas esperaban sobre una raíz, sin poder continuar. {nombre_luciernaga} sintió que todas las miradas buscaban otra respuesta rápida, pero esta vez guardó silencio.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/05-polilla-regresa-mojada.webp'),

        (v_story_id, 6,
        '—Tal vez el agua cambió de lugar —murmuró {nombre_luciernaga}. Era otra respuesta inventada, y casi salió completa. Entonces vio las gotas sobre las alas de la polilla. —No —corrigió—. Yo les indiqué un camino que no conocía. No sé dónde está la laguna.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/06-confesion-bajo-la-luna.webp'),

        (v_story_id, 7,
        'Nadie se burló. Una rana parpadeó. Un mosquito acomodó sus patas. Después, todos empezaron a preguntar de otra manera: ¿qué sabemos del agua?, ¿hacia dónde vuelan las garzas?, ¿qué flores abren de noche? La oscuridad dejó de parecer un examen.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/07-preguntas-compartidas.webp'),

        (v_story_id, 8,
        'Fueron primero a rescatar a las polillas. {nombre_luciernaga} iluminó las raíces mientras una rana saltaba delante. Cerca del barro, algo chapoteó y todos se detuvieron juntos. No fingieron conocerlo: observaron hasta descubrir una tortuga pequeña apartando hojas con el caparazón.',
        v_chapoteo,
        array['chapoteó'],
        '/images/la-luciernaga-que-inventaba-respuestas/08-rescate-en-el-barro.webp'),

        (v_story_id, 9,
        'Reunidas otra vez, las tres polillas describieron el aroma de los nenúfares: dulce como fruta madura. Las ranas croaron desde distintos canales. Una de sus voces regresó acompañada por aquel perfume. —Podemos seguir el olor y comprobar cada desvío —propuso {nombre_luciernaga}.',
        v_ranas,
        array['croaron'],
        '/images/la-luciernaga-que-inventaba-respuestas/09-ranas-marcan-los-canales.webp'),

        (v_story_id, 10,
        'El grupo avanzó muy despacio. En cada bifurcación se separaban apenas unos metros, miraban el agua y volvían para contar lo visto. Algunas rutas parecían correctas y no lo eran. Cada error, en lugar de avergonzarlos, eliminaba un camino posible.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/10-exploracion-en-equipo.webp'),

        (v_story_id, 11,
        'Llegaron a un rincón sin luna. {nombre_luciernaga} quiso escoger cualquier dirección para que nadie notara su duda. Respiró y dijo: —Todavía no sé. Apagó su luz un instante. Entonces aparecieron sobre el agua cientos de reflejos diminutos que su brillo ocultaba.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/11-reflejos-en-la-oscuridad.webp'),

        (v_story_id, 12,
        'Los reflejos no eran estrellas. Eran escarabajos de agua viajando todos hacia el mismo canal, con polen de nenúfar sobre el lomo. {nombre_luciernaga} volvió a encenderse, no para anunciar una respuesta, sino para alumbrar aquella pista que todos habían encontrado.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/12-escarabajos-con-polen.webp'),

        (v_story_id, 13,
        'Al final del canal apareció la Laguna Redonda. Los nenúfares estaban cerrados, como puños verdes. Las polillas esperaron sobre una rama. Cuando la primera flor abrió sus pétalos, un aleteo suave recorrió la orilla y todas levantaron vuelo a la vez.',
        v_aleteo,
        array['aleteo'],
        '/images/la-luciernaga-que-inventaba-respuestas/13-nenufares-y-polillas.webp'),

        (v_story_id, 14,
        'La polilla de alas mojadas se acercó a {nombre_luciernaga}. —Decir que no sabías no apagó tu luz —dijo—. Nos permitió mirar también a nosotros. La luciérnaga contempló las flores, las ranas y los escarabajos. Ninguna respuesta inventada habría creado aquel recorrido.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/14-leccion-junto-a-los-nenufares.webp'),

        (v_story_id, 15,
        'De regreso, los habitantes de {nombre_cienaga} hicieron preguntas por puro gusto. Algunas encontraron respuesta; otras quedaron flotando para la noche siguiente. {nombre_luciernaga} contestó lo que sabía y sonrió ante lo demás. Ya no necesitaba parecer un faro que nunca dudaba.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/15-regreso-con-preguntas.webp'),

        (v_story_id, 16,
        'Desde entonces, cuando una pregunta era demasiado grande, {nombre_luciernaga} decía: —No lo sé todavía. Busquemos juntos. Su luz seguía siendo {color_luz}, pero ahora dejaba espacio para ver otras luces. Y cada misterio compartido convertía la ciénaga en un lugar más ancho.',
        null,
        array[]::text[],
        '/images/la-luciernaga-que-inventaba-respuestas/16-misterios-compartidos.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/la-luciernaga-que-inventaba-respuestas.webp
-- Imágenes:
-- 01-guia-sobre-la-cienaga.webp
-- 02-respuesta-inventada.webp
-- 03-polillas-piden-direccion.webp
-- 04-duda-entre-los-juncos.webp
-- 05-polilla-regresa-mojada.webp
-- 06-confesion-bajo-la-luna.webp
-- 07-preguntas-compartidas.webp
-- 08-rescate-en-el-barro.webp
-- 09-ranas-marcan-los-canales.webp
-- 10-exploracion-en-equipo.webp
-- 11-reflejos-en-la-oscuridad.webp
-- 12-escarabajos-con-polen.webp
-- 13-nenufares-y-polillas.webp
-- 14-leccion-junto-a-los-nenufares.webp
-- 15-regreso-con-preguntas.webp
-- 16-misterios-compartidos.webp
-- Sonidos requeridos:
-- grillos.mp3
-- chapoteo.mp3
-- croar-de-ranas.mp3
-- aleteo-de-luciernagas.mp3
