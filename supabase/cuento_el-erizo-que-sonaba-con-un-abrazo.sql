-- Octavo cuento generado con el sistema escritor-cuentavoz/.
--
-- "El erizo que soñaba con un abrazo"
--
-- Protagonista: un erizo (primer ANIMAL protagonista del catálogo
-- nuevo -- los siete anteriores fueron objetos o elementos naturales;
-- los animales solo habían aparecido como personajes secundarios).
-- Escenario: el suelo de un bosque en otoño, entre hojas caídas
-- (primer cuento de otoño/bosque terrestre -- distinto a cocina,
-- caminos, pueblo nevado, valle, jardín, río). Conflicto: dificultad
-- para dejarse acercar / pedir cercanía (el erizo quiere compañía pero
-- sus propias púas lo asustan a él primero) -- no usado antes. Magia:
-- sueños (si dos criaturas duermen cerca sin tocarse, sus sueños a
-- veces se rozan y eso basta para sentir calor de verdad -- nunca
-- resuelve el conflicto sola, el erizo igual tiene que decidir
-- quedarse quieto). Quién inicia el cambio: un ratoncillo de campo
-- (personaje secundario nuevo, no familia de animales, no niño, no
-- semilla par, no libélula, no la protagonista sola). Quién expresa la
-- enseñanza: un tejón viejo que pasa por ahí (personaje nuevo, no
-- búho -- a propósito, para no repetir el "animal sabio mentor" del
-- catálogo archivado; el búho aquí solo ulula de fondo, sin hablar ni
-- aconsejar). Emoción dominante: calma (distinta a las siete
-- anteriores). Regalo/cierre: un abrazo -- por primera vez en el
-- catálogo nuevo el cierre es literalmente un abrazo, y aquí es
-- también la resolución física del conflicto (las púas se aflojan).
--
-- Escena inolvidable: los dos se quedan dormidos sin tocarse, y esa
-- noche el erizo sueña con un calor dorado que no sabe de dónde viene
-- -- como si, entre los dos sueños, algo se hubiera rozado con cariño.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro.
--
-- Sonidos: a pedido explícito, este cuento usa un poco más de sonido
-- que los anteriores (7 apariciones en vez de las 3-6 habituales, todavía
-- dentro del rango "3 a 7" de escritor-cuentavoz/06-catalogo-sonidos.md).
-- Reutiliza 6 sonidos del catálogo existente (pasos sobre hojas, viento
-- entre árboles -- dos veces, en bloques distintos --, pájaros del
-- bosque, crujido, grillos nocturnos, búho sabio). No necesita ningún
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
    v_hojas uuid;
    v_viento uuid;
    v_pajaros uuid;
    v_crujido uuid;
    v_grillos uuid;
    v_buho uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-erizo-que-sonaba-con-un-abrazo'
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
            'El erizo que soñaba con un abrazo',
            'el-erizo-que-sonaba-con-un-abrazo',
            '2-7 años',
            'Valores',
            true,
            null
        )

        returning id
        into v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos (ninguno -- todos ya existen en el catálogo)
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='pasos sobre hojas') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pasos sobre hojas', '/sounds/pasos-hojas.mp3', 'efecto');
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

    if not exists (select 1 from sound_effects where nombre='grillos nocturnos') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='buho sabio') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('buho sabio', '/sounds/buho.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_hojas from sound_effects where nombre='pasos sobre hojas' limit 1;
    select id into v_viento from sound_effects where nombre='viento entre arboles' limit 1;
    select id into v_pajaros from sound_effects where nombre='pajaros del bosque' limit 1;
    select id into v_crujido from sound_effects where nombre='crujido' limit 1;
    select id into v_grillos from sound_effects where nombre='grillos nocturnos' limit 1;
    select id into v_buho from sound_effects where nombre='buho sabio' limit 1;

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

    (v_story_id, 'nombre_erizo', 'texto', array['Espino','Castaño','Bellota','Rufo','Otoño','Musgo']),
    (v_story_id, 'color_puas', 'color', array['café','gris','dorado','cobrizo','castaño','beige','marrón','plateado']),
    (v_story_id, 'nombre_bosque', 'texto', array['Bosque Dorado','El Robledal','Bosque Viejo','Los Castaños','Bosque de Otoño','El Encinar']);

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
      'Bajo un montón de hojas caídas, en el suelo de {nombre_bosque}, vivía {nombre_erizo}, un erizo con las púas de color {color_puas} que llevaba todo el otoño evitando a los demás. No es que no quisiera compañía. Es que cada vez que alguien se acercaba demasiado, sus propias púas lo asustaban a él más que a nadie.',
      null, array[]::text[],
      '/images/el-erizo-que-sonaba-con-un-abrazo/01-erizo-enrollado-hojas-otono.png'),

    (v_story_id, 2,
      '{nombre_bosque} se llenaba de un crujido suave cada otoño, cuando las hojas caían y cubrían el suelo entero. {nombre_erizo} caminaba despacio entre ellas, solo, escuchando sus propios pasos sobre las hojas secas.',
      v_hojas, array['hojas'],
      '/images/el-erizo-que-sonaba-con-un-abrazo/02-erizo-camina-hojas-bosque.png'),

    (v_story_id, 3,
      'Entre los animales del bosque se contaba una vieja historia: cuando dos criaturas duermen muy cerca, sin tocarse, sus sueños a veces se rozan, y eso basta para sentir calor de verdad. {nombre_erizo} la conocía de memoria, pero nunca la había probado. Nadie se quedaba cerca el tiempo suficiente.',
      null, array[]::text[],
      '/images/el-erizo-que-sonaba-con-un-abrazo/03-leyenda-suenos-compartidos.png'),

    (v_story_id, 4,
      'El viento empezó a soplar frío entre los árboles, anunciando que el invierno no estaba lejos. {nombre_erizo} se enrolló apretadamente, como hacía siempre que alguien -- o algo -- se acercaba demasiado.',
      v_viento, array['viento'],
      '/images/el-erizo-que-sonaba-con-un-abrazo/04-viento-frio-erizo-se-enrolla.png'),

    (v_story_id, 5,
      'Un ratoncillo de campo, pequeño y curioso, lo encontró así enrollado entre las hojas. Los pájaros cantaban sus últimas canciones antes del frío, y el ratón, sin miedo, se acercó a saludar.',
      v_pajaros, array['pájaros'],
      '/images/el-erizo-que-sonaba-con-un-abrazo/05-ratoncillo-encuentra-erizo-pajaros.png'),

    (v_story_id, 6,
      '—¡Cuidado! —dijo {nombre_erizo}, todavía enrollado—. Tengo púas, y no sé quedarme quieto cuando alguien se acerca. Es mejor que te alejes, antes de que te lastime sin querer.',
      null, array[]::text[],
      '/images/el-erizo-que-sonaba-con-un-abrazo/06-erizo-advierte-cuidado-puas.png'),

    (v_story_id, 7,
      'Pero el ratoncillo no se alejó. Dio un paso más, curioso, y una ramita crujió bajo sus patas. {nombre_erizo}, asustado, se apretó todavía más fuerte, y una de sus púas rozó al ratón sin querer. Los dos se quedaron quietos, apenados.',
      v_crujido, array['crujió'],
      '/images/el-erizo-que-sonaba-con-un-abrazo/07-rama-cruje-erizo-asusta-puas.png'),

    (v_story_id, 8,
      '—Lo siento —susurró {nombre_erizo}, con la voz temblorosa—. Por eso nadie se queda. Siempre pasa lo mismo: me asusto, y termino lastimando a quien solo quería estar cerca.',
      null, array[]::text[],
      '/images/el-erizo-que-sonaba-con-un-abrazo/08-erizo-se-disculpa-triste.png'),

    (v_story_id, 9,
      'Cayó la noche, y los grillos empezaron a cantar entre las hojas. El ratoncillo, en vez de irse, se acurrucó cerca -- no tocando a {nombre_erizo}, pero sí lo bastante cerca como para compartir el mismo rincón de hojas.',
      v_grillos, array['grillos'],
      '/images/el-erizo-que-sonaba-con-un-abrazo/09-noche-grillos-raton-se-acurruca.png'),

    (v_story_id, 10,
      'En algún árbol lejano, un búho ululó suavemente contra el frío de la noche. {nombre_erizo} miró al ratoncillo, dormido y confiado a su lado, y se preguntó, por primera vez, si de verdad tenía que enrollarse tan fuerte.',
      v_buho, array['ululó'],
      '/images/el-erizo-que-sonaba-con-un-abrazo/10-buho-ulula-erizo-se-pregunta.png'),

    (v_story_id, 11,
      'El viento seguía soplando, cada vez más frío. {nombre_erizo} vio al ratoncillo temblar en sueños, y decidió, muy despacio, dejar de apretarse. Respiró hondo. Y por primera vez en todo el otoño, se quedó quieto de verdad.',
      v_viento, array['viento'],
      '/images/el-erizo-que-sonaba-con-un-abrazo/11-viento-erizo-decide-quedarse-quieto.png'),

    (v_story_id, 12,
      'Poco a poco, sus púas se fueron aflojando, casi sin que él lo notara. Nunca antes se había quedado tan tranquilo cerca de nadie. El miedo seguía ahí, pero esa noche, por algún motivo, no ganaba.',
      null, array[]::text[],
      '/images/el-erizo-que-sonaba-con-un-abrazo/12-puas-se-aflojan-poco-a-poco.png'),

    (v_story_id, 13,
      'Los dos se quedaron dormidos casi al mismo tiempo, sin tocarse, uno junto al otro entre las hojas. Y esa noche, {nombre_erizo} soñó con un calor suave y dorado que no sabía de dónde venía -- como si, en algún lugar entre los dos sueños, algo se hubiera rozado con cariño.',
      null, array[]::text[],
      '/images/el-erizo-que-sonaba-con-un-abrazo/13-suenos-se-rozan-calor-dorado.png'),

    (v_story_id, 14,
      'Al amanecer, {nombre_erizo} despertó y descubrió que, durante la noche, se había acercado tanto al ratoncillo que sus costados se tocaban. Sus púas, relajadas por completo, no habían lastimado a nadie.',
      null, array[]::text[],
      '/images/el-erizo-que-sonaba-con-un-abrazo/14-amanecer-costados-se-tocan.png'),

    (v_story_id, 15,
      'Un tejón viejo que pasaba por ahí los vio y sonrió. —No hacía falta dejar de tener púas —dijo, sin detenerse del todo—. Solo hacía falta quedarse quieto el tiempo suficiente para dejar que se aflojaran.',
      null, array[]::text[],
      '/images/el-erizo-que-sonaba-con-un-abrazo/15-tejon-viejo-comenta-sonrie.png'),

    (v_story_id, 16,
      'Desde esa noche, cada vez que el frío apretaba, {nombre_erizo} y el ratoncillo se acurrucaban juntos entre las hojas de {nombre_bosque}, sin miedo, sin prisa, quietos el uno junto al otro.',
      null, array[]::text[],
      '/images/el-erizo-que-sonaba-con-un-abrazo/16-erizo-raton-se-acurrucan-siempre.png'),

    (v_story_id, 17,
      '{nombre_erizo} entendió, por fin, que no necesitaba dejar de ser un erizo para que alguien se quedara cerca. Solo necesitaba, de vez en cuando, quedarse quieto el tiempo suficiente para dejar que el miedo se aflojara también.',
      null, array[]::text[],
      '/images/el-erizo-que-sonaba-con-un-abrazo/17-erizo-reflexion-final.png');

end $$;
