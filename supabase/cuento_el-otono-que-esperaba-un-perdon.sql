-- Noveno cuento generado con el sistema escritor-cuentavoz/.
--
-- "El otoño que esperaba un perdón"
--
-- Protagonista: un niño o niña ({nombre_niño}) -- primer protagonista
-- HUMANO del catálogo nuevo. Los ocho anteriores fueron objetos,
-- elementos naturales o un animal. Escenario: el huerto/finca de la
-- familia en temporada de cosecha (primer cuento de huerta familiar
-- con dos niños). Conflicto: dificultad para perdonar -- no usado
-- antes. Magia: estaciones (en este huerto, la estación no cambia
-- hasta que los corazones estén en paz de verdad -- nunca resuelve el
-- conflicto sola, los niños igual tienen que decidir hablar). Quién
-- inicia el cambio: {nombre_amigo}, el otro niño de la pelea (no un
-- personaje secundario externo como en los cuentos anteriores -- aquí
-- son los propios protagonistas del conflicto quienes lo resuelven).
-- Quién expresa la enseñanza: una inscripción tallada hace generaciones
-- en el poste de un espantapájaros -- no un personaje que habla, sino
-- algo heredado que los niños descubren y leen juntos (varía de los
-- ocho cuentos anteriores, todos con un personaje vivo hablando).
-- Emoción dominante: admiración (la única del listado de
-- 01-identidad.md que faltaba usar). Regalo/cierre: una promesa (no
-- costumbre, camino, canción, árbol, amistad, lugar descubierto ni
-- abrazo como cierre principal -- aunque el abrazo también ocurre).
--
-- Escena inolvidable: justo cuando terminan de leer la inscripción
-- vieja, el primer copo de nieve del invierno cae despacio entre los
-- dos, como si todo el huerto hubiera estado conteniendo la respiración.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro.
--
-- Cuidado de género: {nombre_niño} y {nombre_amigo} son ambos texto
-- libre (pueden ser niño o niña). El texto evita pronombres con género
-- (lo/la, él/ella) y adjetivos que concuerden directamente con
-- cualquiera de los dos -- usa "los dos"/"ambos" (formas neutras
-- estándar del español) o repite el nombre en vez de usar un pronombre.
--
-- Sonidos: vuelve al rango habitual de 3-6 (el cuento anterior usó 7 a
-- pedido explícito, esta vez no se pidió, así que se queda en 5).
-- Reutiliza 5 del catálogo existente (pasos sobre hojas, viento entre
-- árboles, crujido, pájaros del bosque, grillos nocturnos). No necesita
-- ningún sonido nuevo.
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
    v_crujido uuid;
    v_pajaros uuid;
    v_grillos uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-otono-que-esperaba-un-perdon'
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
            'El otoño que esperaba un perdón',
            'el-otono-que-esperaba-un-perdon',
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

    if not exists (select 1 from sound_effects where nombre='crujido') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('crujido', '/sounds/crujido.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='pajaros del bosque') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='grillos nocturnos') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_hojas from sound_effects where nombre='pasos sobre hojas' limit 1;
    select id into v_viento from sound_effects where nombre='viento entre arboles' limit 1;
    select id into v_crujido from sound_effects where nombre='crujido' limit 1;
    select id into v_pajaros from sound_effects where nombre='pajaros del bosque' limit 1;
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

    (v_story_id, 'nombre_niño', 'texto', array['Sofía','Mateo','Valentina','Samuel','Emma','Lucas']),
    (v_story_id, 'nombre_amigo', 'texto', array['Nico','Dani','Vale','Santi','Emi','Cami']),
    (v_story_id, 'nombre_huerto', 'texto', array['El Manzanar','La Cosecha','Huerto del Abuelo','Finca Los Nogales','El Parral','Huerto Feliz']);

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
      'Cada otoño, {nombre_niño} y {nombre_amigo} pasaban la temporada de cosecha en {nombre_huerto}, la finca del abuelo. Eran mejores amigos desde siempre. Pero este año, por primera vez, ambos llevaban días sin hablarse.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/01-primos-huerto-cosecha-otono.png'),

    (v_story_id, 2,
      'Todo había empezado por una tontería: quién debía escoger la primera manzana del árbol grande. Ninguno de los dos quería ser quien pidiera perdón primero, así que los días pasaban y {nombre_niño} y {nombre_amigo} seguían sin dirigirse la palabra.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/02-pelea-primera-manzana-arbol.png'),

    (v_story_id, 3,
      'En medio del huerto había un espantapájaros viejísimo, con un poste de madera tallado por el bisabuelo hacía muchos años. Se decía que las estaciones de {nombre_huerto} solo cambiaban cuando todos los corazones ahí estaban en paz. {nombre_niño} había escuchado esa historia mil veces, pero nunca le había prestado atención de verdad.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/03-espantapajaros-poste-tallado-leyenda.png'),

    (v_story_id, 4,
      'Ese año, el otoño se estaba alargando de una manera extraña. Las hojas no terminaban de caer, la primera helada no llegaba nunca, y el abuelo comentaba, un poco confundido, que jamás había visto una temporada tan lenta para terminar.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/04-otono-extranamente-largo.png'),

    (v_story_id, 5,
      '{nombre_niño} caminaba solo entre los árboles, pisando las hojas que se acumulaban sin parar, extrañando los juegos de siempre pero sin animarse a buscar a {nombre_amigo} para arreglar las cosas.',
      v_hojas, array['hojas'],
      '/images/el-otono-que-esperaba-un-perdon/05-nino-camina-solo-hojas.png'),

    (v_story_id, 6,
      'Un día se cruzaron de lejos, entre los surcos del huerto. {nombre_niño} quiso saludar, pero el orgullo pudo más, y los dos giraron la mirada hacia otro lado, fingiendo no haberse visto.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/06-se-cruzan-miran-otro-lado.png'),

    (v_story_id, 7,
      'El viento sopló fuerte entre los árboles esa tarde, como si todo {nombre_huerto} estuviera igual de inquieto que ellos dos, esperando algo que todavía no llegaba.',
      v_viento, array['viento'],
      '/images/el-otono-que-esperaba-un-perdon/07-viento-fuerte-huerto-inquieto.png'),

    (v_story_id, 8,
      'Sin decir una palabra, {nombre_amigo} dejó una manzana grande y roja justo donde {nombre_niño} solía sentarse cada tarde, y se alejó corriendo, sin que nadie se diera cuenta.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/08-amigo-deja-manzana-en-silencio.png'),

    (v_story_id, 9,
      '{nombre_niño} encontró la manzana esa misma tarde, junto al poste de madera vieja del espantapájaros, que crujía suavemente con el viento. No hacía falta ninguna nota. Entendió el mensaje de todos modos.',
      v_crujido, array['crujía'],
      '/images/el-otono-que-esperaba-un-perdon/09-nino-encuentra-manzana-poste-cruje.png'),

    (v_story_id, 10,
      'Sin pensarlo dos veces, {nombre_niño} salió corriendo a buscar a {nombre_amigo}, y encontró a {nombre_amigo} justo ahí, cerca del mismo espantapájaros, como si los dos hubieran tenido la misma idea al mismo tiempo.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/10-nino-corre-buscar-amigo.png'),

    (v_story_id, 11,
      '—Perdón por lo de la manzana —dijeron casi al mismo tiempo, y después se quedaron mirándose, sin saber si reír o seguir apenados. Al final, rieron los dos juntos, como si nunca hubiera pasado nada.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/11-piden-perdon-al-mismo-tiempo.png'),

    (v_story_id, 12,
      'Mientras se abrazaban, los pájaros del huerto empezaron a cantar de golpe, como si hubieran estado esperando ese momento exacto para volver a hacerlo.',
      v_pajaros, array['pájaros'],
      '/images/el-otono-que-esperaba-un-perdon/12-abrazo-pajaros-cantan.png'),

    (v_story_id, 13,
      'Fue entonces cuando, por primera vez, se detuvieron a leer de verdad las palabras talladas en el poste del espantapájaros, gastadas por los años pero todavía legibles.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/13-leen-juntos-palabras-talladas.png'),

    (v_story_id, 14,
      '"El otoño espera a que el corazón termine primero", decían las letras talladas hacía tantos años. Y justo en ese momento, el primer copo de nieve del invierno cayó despacio entre los dos, como si todo {nombre_huerto} hubiera estado conteniendo la respiración.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/14-primera-nieve-cae-perdon.png'),

    (v_story_id, 15,
      '{nombre_niño} y {nombre_amigo} se prometieron, ahí mismo, que la próxima vez que algo los enojara, ninguno de los dos esperaría tanto tiempo para hablar primero.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/15-prometen-hablar-primero-siempre.png'),

    (v_story_id, 16,
      'Esa noche, un silencio distinto y tranquilo cayó sobre {nombre_huerto}, y los grillos por fin volvieron a cantar, como si la temporada entera hubiera estado esperando exactamente eso.',
      v_grillos, array['grillos'],
      '/images/el-otono-que-esperaba-un-perdon/16-noche-tranquila-grillos-cantan.png'),

    (v_story_id, 17,
      '{nombre_niño} entendió, por fin, que perdonar no había sido cuestión de quién tenía la razón. Había sido, simplemente, cuestión de quién se atrevía a hablar primero -- y la próxima vez, ya no pensaba esperar tanto.',
      null, array[]::text[],
      '/images/el-otono-que-esperaba-un-perdon/17-nino-reflexion-final.png');

end $$;
