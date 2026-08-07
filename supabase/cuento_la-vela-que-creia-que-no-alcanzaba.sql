-- Tercer cuento generado con el sistema escritor-cuentavoz/.
--
-- "La vela que creía que no alcanzaba"
--
-- Protagonista: una vela delgada (objeto, distinto a la cuchara y la
-- brújula anteriores). Escenario: un pueblo en invierno, la noche de
-- una tradición local -- de tienda a ventana de casa, primer cuento de
-- noche fría/nieve del catálogo. Conflicto: creer que uno no sirve /
-- no alcanza (por ser pequeña) -- no usado antes. Magia: reflejos (la
-- escarcha del vidrio multiplica la luz de una sola llama pequeña) --
-- nunca resuelve el conflicto, la vela ya había sido elegida y
-- encendida por decisión de {nombre_niño} antes de que aparezca la
-- escarcha. Quién inicia el cambio: {nombre_niño} (un niño, no la
-- propia protagonista -- varía de los dos cuentos anteriores, donde el
-- cambio lo iniciaba el objeto mismo). Quién expresa la enseñanza:
-- {nombre_niño}, con sus propias palabras de niño (no un adulto como en
-- los cuentos anteriores). Emoción dominante: esperanza (distinta a
-- ternura y asombro ya usados). Regalo/cierre: una canción nueva que
-- empieza a cantarse en el pueblo (no una costumbre ni un camino en un
-- mapa -- eso ya se usó).
--
-- Escena inolvidable: la escarcha del vidrio atrapa la luz de una sola
-- vela delgada y la reparte en cientos de lucecitas, como si la
-- ventana sostuviera su propio cielo estrellado.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro.
--
-- Cuidado de género: {nombre_niño} es texto libre (puede ser niño o
-- niña), así que ningún adjetivo/participio del texto concuerda
-- directamente con {nombre_niño} -- donde hacía falta uno (ej. "con la
-- nariz pegada al vidrio"), se ancló a un sustantivo de género fijo en
-- vez de al nombre.
--
-- Sonidos: reutiliza 2 del catálogo existente (campanita mágica, viento
-- entre árboles) y crea 1 nuevo: "nieve crujiendo" (no existía ningún
-- sonido de nieve/pasos en nieve, y "crujido" del catálogo explícitamente
-- no debe usarse para pasos).
--
-- Requiere: supabase/schema.sql y supabase/migracion_agregar_slug.sql
-- ya corridos (columna "slug" en stories).
--
-- Idempotente: seguro de correr varias veces. Identifica el cuento por
-- slug, sigue el orden oficial de escritor-cuentavoz/05-plantilla-sql.md.
--
-- Ejecutar en Supabase -> SQL Editor.

do $$

declare

    v_story_id uuid;
    v_campanita uuid;
    v_nieve uuid;
    v_viento uuid;
    v_crujido uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-vela-que-creia-que-no-alcanzaba'
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
            es_personalizable,
            portada_url
        )

        values
        (
            'La vela que creía que no alcanzaba',
            'la-vela-que-creia-que-no-alcanzaba',
            '2-7 años',
            true,
            null
        )

        returning id
        into v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='campanita magica') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('campanita magica', '/sounds/campanita.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='viento entre arboles') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('viento entre arboles', '/sounds/viento.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='crujido') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('crujido', '/sounds/crujido.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='nieve crujiendo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('nieve crujiendo', '/sounds/nieve-crujiendo.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_campanita from sound_effects where nombre='campanita magica' limit 1;
    select id into v_viento from sound_effects where nombre='viento entre arboles' limit 1;
    select id into v_crujido from sound_effects where nombre='crujido' limit 1;
    select id into v_nieve from sound_effects where nombre='nieve crujiendo' limit 1;

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

    (v_story_id, 'nombre_vela', 'texto', array['Lucía','Migaja','Delgadita','Chispa','Tenue','Alba']),
    (v_story_id, 'nombre_niño', 'texto', array['Sofía','Mateo','Valentina','Samuel','Emma','Lucas']),
    (v_story_id, 'color_vela', 'color', array['blanco','rojo','dorado','azul','verde','morado','plateado','rosado']);

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
      'En la tienda de velas del pueblo vivía {nombre_vela}, la más delgada de todo el estante. Cada Noche de los Deseos, las familias elegían siempre las velas más gruesas, convencidas de que una llama grande cargaba un deseo más fuerte. {nombre_vela} llevaba tres inviernos esperando que alguien la mirara dos veces.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/01-vela-delgada-estante-tienda.png'),

    (v_story_id, 2,
      'Esa noche era distinta a cualquier otra del año: cada casa del pueblo ponía una vela encendida en su ventana, y se decía que la llama más brillante llevaba su deseo más alto hacia el cielo. Nadie sabía muy bien si era cierto. Pero nadie, tampoco, se atrevía a comprobarlo con una vela pequeña.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/02-ventanas-pueblo-noche-deseos.png'),

    (v_story_id, 3,
      '—El tamaño —le dijo una tarde la vieja tendera, sacudiendo el polvo del estante— nunca ha apagado un deseo. {nombre_vela} quiso creerle. Pero llevaba tantos inviernos quieta en el mismo rincón que las palabras, por bonitas que fueran, no bastaban para convencerla del todo.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/03-tendera-sacude-estante.png'),

    (v_story_id, 4,
      'Esa tarde, cuando ya casi anochecía, entró a la tienda una familia que llegaba tarde: los padres, cansados del viaje, y {nombre_niño}, que corría un paso por delante de todos, con las mejillas rojas de frío.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/04-familia-llega-tarde-nieve.png'),

    (v_story_id, 5,
      'La campanita de la puerta sonó al entrar, y la tendera levantó la vista, algo apenada. —Me temo que ya casi no quedan velas grandes —dijo—. Solo esta pequeñita. {nombre_niño} caminó directo hacia el estante, sin dudarlo, hacia donde {nombre_vela} esperaba, sola.',
      v_campanita, array['campanita'],
      '/images/la-vela-que-creia-que-no-alcanzaba/05-campanita-puerta-tienda.png'),

    (v_story_id, 6,
      '—Esta —dijo {nombre_niño}, tomando a {nombre_vela} entre las manos con mucho cuidado—. Se ve triste ahí solita. Los padres se miraron, no muy convencidos. Una vela tan delgada, pensaron, apenas duraría encendida la mitad de la noche que hacía falta.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/06-nino-elige-vela-pequena.png'),

    (v_story_id, 7,
      '—Quizás deberíamos volver mañana, cuando lleguen velas más grandes —propuso el padre, dudando. Pero {nombre_niño} sujetó a {nombre_vela} contra el pecho y no soltó. —Esta —repitió, sin más explicación—. Esta es la que quiero llevar a casa.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/07-padres-dudan-vela-delgada.png'),

    (v_story_id, 8,
      'Caminaron de regreso bajo la primera nieve del invierno, que crujía suave bajo cada paso. {nombre_vela}, envuelta con cuidado en un pañuelo, sentía el frío colarse de todos modos. Y sentía, también, el peso de haber sido elegida por alguien que de verdad la quería ahí.',
      v_nieve, array['crujía'],
      '/images/la-vela-que-creia-que-no-alcanzaba/08-caminan-nieve-camino-casa.png'),

    (v_story_id, 9,
      'El viento empezó a soplar entre los árboles pelados de la plaza, cada vez más frío, mientras las primeras ventanas del pueblo empezaban a encenderse una por una, con llamas grandes y seguras. {nombre_vela}, todavía sin encender, sintió que el miedo de siempre volvía a asomarse.',
      v_viento, array['viento'],
      '/images/la-vela-que-creia-que-no-alcanzaba/09-viento-frio-ventanas-encendidas.png'),

    (v_story_id, 10,
      'En su ventana, {nombre_niño} encendió a {nombre_vela}, de color {color_vela}, con las manos temblando un poco por la emoción. La llama prendió, pequeña y honesta, mucho más delgada que las de las ventanas vecinas. {nombre_vela} sintió que, comparada con las demás, apenas se notaba.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/10-nino-enciende-vela-ventana.png'),

    (v_story_id, 11,
      'La noche se puso más fría todavía, y el vidrio de la ventana empezó a cubrirse de escarcha, crujiendo despacio con cada nuevo dibujo helado que se formaba sobre él. {nombre_vela}, ajena a lo que ocurría a sus espaldas, solo pensaba en lo pequeña que se sentía.',
      v_crujido, array['crujiendo'],
      '/images/la-vela-que-creia-que-no-alcanzaba/11-escarcha-cubre-vidrio-frio.png'),

    (v_story_id, 12,
      'Pero la escarcha, formada en delicadas ramas heladas sobre el vidrio, atrapó la luz de {nombre_vela} y la repartió en cientos de pedacitos diminutos. De pronto, la ventana entera parecía sostener un cielo propio, lleno de estrellas pequeñas nacidas de una sola llama delgada.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/12-luz-vela-reflejada-escarcha.png'),

    (v_story_id, 13,
      'Desde la plaza, algunos vecinos se detuvieron a mirar, señalando esa ventana distinta a todas las demás. Por dentro, con la nariz casi pegada al vidrio, {nombre_niño} sonreía sin decir nada, como si hubiera sabido todo el tiempo que esto iba a pasar.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/13-vecinos-miran-ventana-brillante.png'),

    (v_story_id, 14,
      '—¿Ves? —le dijo {nombre_niño} a {nombre_vela}, apoyando la frente contra el vidrio frío—. Las pequeñas también pueden ser las más brillantes. Nadie más lo escuchó. Pero {nombre_vela}, por primera vez en tres inviernos, sintió que esas palabras sí le quedaban justas.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/14-nino-frente-vidrio-sonrie.png'),

    (v_story_id, 15,
      'Desde esa Noche de los Deseos, en el pueblo empezó a cantarse una canción nueva y corta sobre la vela más delgada de la tienda, que un niño había elegido solo porque se veía sola. Cada invierno, alguien la tarareaba al pasar frente al estante de velas.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/15-pueblo-canta-cancion-nueva.png'),

    (v_story_id, 16,
      '{nombre_vela} entendió, por fin, que nunca había sido cuestión de tamaño. Una llama pequeña, bien acompañada, podía llenar una ventana entera de estrellas — y eso, descubrió, era exactamente del tamaño de un deseo cumplido.',
      null, array[]::text[],
      '/images/la-vela-que-creia-que-no-alcanzaba/16-vela-reflexion-final.png');

end $$;
