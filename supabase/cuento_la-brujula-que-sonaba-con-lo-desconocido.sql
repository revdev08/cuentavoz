-- Segundo cuento generado con el sistema escritor-cuentavoz/.
--
-- "La brújula que soñaba con lo desconocido"
--
-- Protagonista: una brújula (objeto, distinto a la cuchara y la gota de
-- tinta anteriores). Escenario: caminos y campo abierto, de día a
-- noche -- primer cuento al aire libre del catálogo nuevo, no interior.
-- Conflicto: no escuchar / anteponer el propio deseo (la brújula desvía
-- a propósito al cartógrafo hacia lo desconocido) -- no usado antes.
-- Magia: estrellas (la aguja se alinea con la estrella polar) -- nunca
-- resuelve el conflicto, la brújula decide señalar lo verdadero por su
-- cuenta antes de que la magia aparezca. Quién inicia el cambio: la
-- propia brújula, al ver la preocupación real del cartógrafo. Quién
-- expresa la enseñanza: el cartógrafo (persona, no un animal ni un
-- objeto sabio). Emoción dominante: asombro (distinta a la ternura de
-- los dos cuentos anteriores). Regalo/cierre: un nuevo camino dibujado
-- en el mapa (no una costumbre -- eso ya se usó en "La cuchara...").
--
-- Escena inolvidable: la aguja de la brújula tiembla como si bailara al
-- alinearse con la estrella más brillante del cielo.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro (aunque el protagonista trabaja con mapas, es un mapa de
-- trabajo real, no un mapa del tesoro).
--
-- Sonidos: reutiliza 4 del catálogo existente (pasos sobre hojas,
-- viento entre árboles, crujido, grillos nocturnos). No necesita ningún
-- sonido nuevo.
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
    v_hojas uuid;
    v_viento uuid;
    v_crujido uuid;
    v_grillos uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-brujula-que-sonaba-con-lo-desconocido'
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
            'La brújula que soñaba con lo desconocido',
            'la-brujula-que-sonaba-con-lo-desconocido',
            '2-7 años',
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

    (v_story_id, 'nombre_brujula', 'texto', array['Rumbo','Norte','Estela','Polaris','Vientos','Camino']),
    (v_story_id, 'color_brujula', 'color', array['dorado','plateado','azul','verde','rojo','cobre','turquesa','morado']),
    (v_story_id, 'pueblo_destino', 'texto', array['Piedra Alta','Río Claro','Los Sauces','Vallehondo','Puente Viejo','Tres Robles']);

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
      'En la alforja de cuero de un viejo cartógrafo vivía {nombre_brujula}, una brújula de color {color_brujula} que llevaba años señalando caminos verdaderos. Los conocía casi todos. Pero en las noches tranquilas, cuando nadie la miraba, su aguja temblaba un poco hacia direcciones que nunca había recorrido.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/01-brujula-alforja-cartografo.png'),

    (v_story_id, 2,
      'Cada mañana, el cartógrafo abría su alforja, consultaba a {nombre_brujula} y se ponía en marcha. Dibujaba los caminos exactamente como ella los señalaba: sin errores, sin desvíos. Era un trabajo honesto. Pero {nombre_brujula}, en el fondo, soñaba con señalar algo que todavía nadie hubiera dibujado.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/02-cartografo-dibuja-camino.png'),

    (v_story_id, 3,
      '—Una brújula que solo conoce caminos ya trazados —murmuró una noche el cartógrafo, mirando las estrellas— es apenas la mitad de una brújula. {nombre_brujula} sintió que esas palabras le quedaban grandes, como un abrigo prestado. Todavía no sabía qué hacer con ellas.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/03-cartografo-mira-estrellas.png'),

    (v_story_id, 4,
      'Una tarde llegó un mensajero sin aliento: en {pueblo_destino} alguien estaba enfermo, y necesitaba con urgencia el remedio que el cartógrafo guardaba. Debían llegar antes de que cayera la noche. El cartógrafo tomó su alforja, respiró hondo, y confió, como siempre, en {nombre_brujula}.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/04-mensajero-pueblo-enfermo.png'),

    (v_story_id, 5,
      'Caminaron rápido por el sendero conocido, con los pasos crujiendo sobre las hojas del otoño. A mitad de camino, {nombre_brujula} notó un desvío estrecho que nunca habían tomado, cubierto de flores silvestres. Sin decir nada, dejó que su aguja se inclinara apenas hacia allá.',
      v_hojas, array['hojas'],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/05-sendero-hojas-desvio-flores.png'),

    (v_story_id, 6,
      'El cartógrafo, sin sospechar nada, siguió la dirección que {nombre_brujula} le mostraba. El sendero angosto los alejaba, poco a poco, del camino más corto hacia {pueblo_destino}. {nombre_brujula} sintió una punzada de duda, pero el desvío olía a algo nuevo, y no dijo nada.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/06-brujula-senala-desvio.png'),

    (v_story_id, 7,
      'Cuando el cartógrafo se dio cuenta de la distancia recorrida, el sol ya se inclinaba bajo entre los árboles. —Vamos más lentos de lo que pensaba —dijo, apretando el paso. {nombre_brujula} sintió que el peso de la alforja, esa tarde, pesaba distinto.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/07-sol-bajo-entre-arboles.png'),

    (v_story_id, 8,
      'El viento empezó a moverse entre los árboles, cada vez más frío, anunciando que la noche llegaría antes de lo previsto. El cartógrafo miró el cielo, preocupado, y volvió a consultar a {nombre_brujula}, confiando en que ella sabría, como siempre, mostrarle el camino correcto.',
      v_viento, array['viento'],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/08-viento-frio-anochecer.png'),

    (v_story_id, 9,
      '{nombre_brujula} vio la preocupación en las manos del cartógrafo, en la forma en que apretaba la alforja contra su pecho. Por primera vez entendió lo que había hecho: él no sabía que ella lo había desviado. Confiaba en ella exactamente como siempre había confiado.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/09-brujula-ve-preocupacion.png'),

    (v_story_id, 10,
      'Llegaron a un cruce de caminos marcado por un poste de madera vieja, que crujió al moverse con el viento. Uno de los senderos llevaba, sin duda, directo a {pueblo_destino}. El otro seguía siendo un misterio. {nombre_brujula} tuvo que decidir, por fin, hacia dónde señalar.',
      v_crujido, array['crujió'],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/10-cruce-caminos-poste-madera.png'),

    (v_story_id, 11,
      'Por primera vez en mucho tiempo, {nombre_brujula} dejó que su aguja se quedara completamente quieta, señalando lo verdadero sin dudar. No fue fácil soltar el otro camino. Pero pensó en quien esperaba en {pueblo_destino}, y entendió que ese, esa noche, era el desvío que de verdad importaba.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/11-brujula-decide-senalar-verdad.png'),

    (v_story_id, 12,
      'El cartógrafo, sin saber por qué, sintió de pronto que caminaban más ligero. Apretaron el paso por el sendero correcto, dejando atrás el misterio de flores silvestres. {nombre_brujula} lo siguió señalando, firme, sin ninguna duda, mientras el cielo se oscurecía sobre ellos.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/12-caminan-ligero-sendero-correcto.png'),

    (v_story_id, 13,
      'Cayó la noche por completo, y los grillos empezaron a cantar entre la hierba alta a los lados del camino. El cartógrafo encendió un pequeño farol. {nombre_brujula}, sujeta con firmeza en su mano, siguió trabajando en la oscuridad como si la noche no le diera ningún miedo.',
      v_grillos, array['grillos'],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/13-noche-grillos-farol-encendido.png'),

    (v_story_id, 14,
      'Sobre ellos, apareció la estrella más brillante del cielo. Y entonces ocurrió algo que {nombre_brujula} nunca había sentido: su aguja tembló, como si bailara, alineándose sola con esa luz lejana. Por primera vez, señalar lo verdadero y desear lo maravilloso fueron, durante un instante, la misma cosa.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/14-aguja-tiembla-estrella.png'),

    (v_story_id, 15,
      'Guiados por el camino correcto y por esa única estrella, llegaron por fin a {pueblo_destino} antes de que fuera demasiado tarde. El cartógrafo entregó el remedio con las manos temblando de cansancio y alivio. {nombre_brujula}, en su bolsillo, sintió que también ella podía descansar.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/15-entregan-remedio-pueblo.png'),

    (v_story_id, 16,
      'Esa noche, ya de regreso, el cartógrafo miró las estrellas y dijo, más para sí mismo que para nadie: —A veces el camino correcto y el camino maravilloso son el mismo camino, si sabes cuándo mirar hacia arriba. {nombre_brujula} escuchó cada palabra.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/16-cartografo-mira-estrellas-final.png'),

    (v_story_id, 17,
      'Al llegar a casa, el cartógrafo dibujó con cuidado el sendero de flores silvestres en su mapa, marcándolo para explorarlo otro día, sin prisa. {nombre_brujula} entendió, por fin, que señalar lo verdadero y soñar con lo desconocido nunca habían sido enemigos — solo necesitaban, cada uno, su propio momento.',
      null, array[]::text[],
      '/images/la-brujula-que-sonaba-con-lo-desconocido/17-nuevo-camino-dibujado-mapa.png');

end $$;
