do $$

declare
    v_story_id uuid;
    v_arroyo uuid;
    v_martillo uuid;
    v_campanillas uuid;

begin

    select id into v_story_id
    from stories
    where slug='el-puente-que-escuchaba-una-sola-orilla'
    limit 1;

    if v_story_id is null then
        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)
        values
        (
            'El puente que escuchaba una sola orilla',
            'el-puente-que-escuchaba-una-sola-orilla',
            '2-7 años',
            true,
            '/images/portadas/el-puente-que-escuchaba-una-sola-orilla.webp'
        )
        returning id into v_story_id;
    else
        update stories
        set titulo='El puente que escuchaba una sola orilla',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/el-puente-que-escuchaba-una-sola-orilla.webp'
        where id=v_story_id;
    end if;

    if not exists (
        select 1 from sound_effects where nombre='arroyo'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('arroyo', '/sounds/arroyo.mp3', 'ambiente');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='martillo sobre madera'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('martillo sobre madera', '/sounds/martillo-sobre-madera.mp3', 'efecto');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='campanillas de cinta'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('campanillas de cinta', '/sounds/campanillas-de-cinta.mp3', 'efecto');
    end if;

    select id into v_arroyo
    from sound_effects
    where nombre='arroyo'
    limit 1;

    select id into v_martillo
    from sound_effects
    where nombre='martillo sobre madera'
    limit 1;

    select id into v_campanillas
    from sound_effects
    where nombre='campanillas de cinta'
    limit 1;

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)
    values
        (v_story_id, 'nombre_puente', 'texto', array['Travesía', 'Madero', 'Vaivén', 'Dos Orillas']),
        (v_story_id, 'nombre_nina', 'texto', array['Luna', 'Sara', 'Emma', 'Martina']),
        (v_story_id, 'nombre_valle', 'texto', array['Valle de los Vientos', 'Valle del Colibrí', 'Valle de las Nubes', 'Valle de los Telares']),
        (v_story_id, 'color_cintas', 'color', array['azul añil', 'rojo coral', 'amarillo maíz', 'verde montaña']);

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
    values

        (v_story_id, 1,
        'Sobre el arroyo del {nombre_valle} se extendía {nombre_puente}, un puente de madera con una oreja vuelta hacia la colina soleada. Allí sonaban bicicletas, martillos y saludos. La otra orilla, cubierta de neblina, hablaba más despacio, y casi nunca conseguía que la escuchara.',
        v_arroyo, array['arroyo'],
        '/images/el-puente-que-escuchaba-una-sola-orilla/01-puente-entre-dos-colinas.webp'),

        (v_story_id, 2,
        'Cada mañana, la gente de la colina soleada cruzaba cargando canastas. —Aprieta tus tablas —le pedían—. ¡Camina sin balancearte! {nombre_puente} obedecía orgulloso. Cuando desde la neblina alguien sugería aflojar las cuerdas para el frío, él respondía con un crujido impaciente.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/02-canastas-de-la-colina-soleada.webp'),

        (v_story_id, 3,
        '{nombre_nina} vivía en la orilla nublada y tejía cintas {color_cintas} con su familia. Al cruzar, apoyaba la mano sobre la baranda. —Un puente necesita oír los pasos que llegan desde ambos lados —decía. Pero {nombre_puente} prefería las voces rápidas que ya conocía.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/03-nina-con-cintas-tejidas.webp'),

        (v_story_id, 4,
        'Ese sábado celebrarían el Encuentro de Cometas justo sobre el puente. Una colina preparó ruedas de papel; la otra, largas colas tejidas. En el centro colocarían una cometa enorme, capaz de levantar cintas desde las dos orillas y dibujar un techo de colores.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/04-preparativos-de-cometas.webp'),

        (v_story_id, 5,
        'Al amanecer, una tabla central comenzó a moverse. Desde el sol gritaron: —¡Clávala enseguida! Desde la neblina advirtieron: —¡Primero revisen la cuerda húmeda! {nombre_puente} solo atendió la voz más fuerte. Un martillo hizo toc-toc, y dos clavos sujetaron la tabla.',
        v_martillo, array['toc-toc'],
        '/images/el-puente-que-escuchaba-una-sola-orilla/05-tabla-central-aflojada.webp'),

        (v_story_id, 6,
        'Cuando llegó la primera cometa, la cuerda húmeda se encogió. La tabla recién clavada tiró de las vecinas y el puente se torció como una ceja preocupada. Nadie cayó, pero todos retrocedieron. La celebración quedó dividida, con una mitad en cada colina.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/06-puente-torcido.webp'),

        (v_story_id, 7,
        '{nombre_puente} sintió vergüenza. Quiso culpar a la cuerda, al frío y hasta a la cometa. Entonces oyó a {nombre_nina} hablando desde la neblina: —No te pedimos que ignores la otra orilla. Solo queríamos terminar nuestra explicación. El puente permaneció inmóvil.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/07-fiesta-dividida.webp'),

        (v_story_id, 8,
        'Por primera vez, {nombre_puente} dejó de prepararse para responder. Escuchó el agua, los pasos detenidos y las dos explicaciones completas. Los carpinteros conocían los clavos. Las tejedoras sabían cómo cambiaban las fibras mojadas. Ninguna orilla poseía por sí sola toda la respuesta.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/08-puente-escucha-en-silencio.webp'),

        (v_story_id, 9,
        '—Necesito que se acerquen por turnos —pidió {nombre_puente}. Primero retiraron los clavos. Después, las tejedoras secaron y trenzaron la cuerda. Finalmente, los carpinteros ajustaron una tabla más flexible. {nombre_nina} pasó de un grupo al otro llevando medidas, herramientas y preguntas.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/09-reparacion-por-turnos.webp'),

        (v_story_id, 10,
        'El martillo volvió a sonar: toc-toc, pausa, toc-toc. Esta vez cada golpe esperaba la señal de ambas orillas. {nombre_puente} descubrió un ritmo nuevo. No era la canción rápida del sol ni el murmullo lento de la niebla, sino una conversación hecha trabajo.',
        v_martillo, array['toc-toc'],
        '/images/el-puente-que-escuchaba-una-sola-orilla/10-martillos-con-ritmo.webp'),

        (v_story_id, 11,
        'Antes de permitir el paso, {nombre_puente} pidió una prueba. Una canasta cruzó desde el sol. Un telar pequeño avanzó desde la niebla. Luego ambos se encontraron en el centro sin que ninguna tabla protestara. Las dos colinas soltaron juntas el aire contenido.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/11-prueba-desde-ambas-orillas.webp'),

        (v_story_id, 12,
        'La enorme cometa subió por fin. Sus ruedas de papel giraron y las colas tejidas se desplegaron. De ellas colgaban pequeñas campanillas que hicieron tilín sobre el valle. Las cintas {color_cintas} cruzaron el cielo y enlazaron las dos colinas sin ocultar ninguna.',
        v_campanillas, array['tilín'],
        '/images/el-puente-que-escuchaba-una-sola-orilla/12-cometa-sobre-las-dos-colinas.webp'),

        (v_story_id, 13,
        'Las sombras de las cintas cayeron sobre las tablas. Cada persona que cruzaba añadía un paso al dibujo: botas, sandalias, ruedas y patas. Visto desde arriba, {nombre_puente} parecía llevar una bufanda de colores tejida con todos los caminos del valle.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/13-bufanda-de-sombras.webp'),

        (v_story_id, 14,
        '—Escuchar dos orillas no significa obedecer todo —dijo {nombre_nina}, sentada en la baranda—. Significa dejar que cada voz llegue completa antes de decidir. {nombre_puente} comprendió que había confundido lo conocido con lo correcto y lo ruidoso con lo importante.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/14-conversacion-en-la-baranda.webp'),

        (v_story_id, 15,
        'Al terminar el encuentro, nadie entregó medallas. En cambio, cada colina enseñó a la otra una parte de su oficio. Los carpinteros probaron los telares y las tejedoras midieron tablas. {nombre_puente} sostuvo aquel intercambio con sus cuerdas recién ajustadas.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/15-oficios-compartidos.webp'),

        (v_story_id, 16,
        'Desde entonces, {nombre_puente} mantuvo una oreja imaginaria hacia cada colina. Cuando surgía un problema, escuchaba primero las historias completas y después elegía con cuidado. Porque una voz diferente no estorba el camino: puede mostrar la parte que todavía no alcanzamos a ver.',
        null, array[]::text[],
        '/images/el-puente-que-escuchaba-una-sola-orilla/16-puente-de-las-dos-voces.webp');

end $$;

-- Assets
-- Portada: /images/portadas/el-puente-que-escuchaba-una-sola-orilla.webp
-- Sonidos:
-- /sounds/arroyo.mp3
-- /sounds/martillo-sobre-madera.mp3
-- /sounds/campanillas-de-cinta.mp3
