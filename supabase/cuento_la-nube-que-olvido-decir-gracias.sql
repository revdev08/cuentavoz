-- Quinto cuento generado con el sistema escritor-cuentavoz/.
--
-- "La nube que olvidó decir gracias"
--
-- Protagonista: una nube (primer elemento natural del catálogo nuevo --
-- los 4 cuentos anteriores usaron objetos: cuchara, brújula, vela,
-- gota de tinta). Escenario: un valle de montaña, entre picos y cielo
-- abierto (distinto a cocina/caminos/pueblo nevado/escritorio).
-- Conflicto: olvidar agradecer -- no usado antes. Magia: ecos (el eco
-- de las montañas la guía a casa, pero deja de bastarle cuando de
-- verdad se pierde -- la solución la traen las golondrinas, por
-- decisión propia, no la magia). Quién inicia el cambio: una familia
-- de golondrinas (personajes secundarios, no la protagonista ni un
-- niño -- varía de los tres cuentos anteriores). Quién expresa la
-- enseñanza: el eco mismo, repitiendo el "gracias" de la nube
-- multiplicado por todo el valle (ni un adulto ni un niño). Emoción
-- dominante: alegría (distinta a ternura/asombro/esperanza ya usadas).
-- Regalo/cierre: un árbol que crece y al que la nube visita cada tarde
-- (no una costumbre, canción ni camino en un mapa -- aunque comparte
-- espíritu con "costumbre", el vínculo aquí es con un ser vivo que
-- crece, no un hábito).
--
-- Escena inolvidable: la nube grita "¡Gracias!" hacia las montañas, y el
-- eco no lo devuelve una sola vez sino muchas, como si todo el valle
-- quisiera agradecerle también a ella.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro.
--
-- Sonidos: reutiliza 3 del catálogo existente (viento entre árboles,
-- pájaros del bosque, lluvia mágica, grillos nocturnos) y crea 1
-- nuevo: "eco del valle" (no existía ningún sonido de eco, y es
-- central para la trama -- aparece dos veces a propósito, como motivo).
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
    v_viento uuid;
    v_eco uuid;
    v_grillos uuid;
    v_pajaros uuid;
    v_lluvia uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-nube-que-olvido-decir-gracias'
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
            'La nube que olvidó decir gracias',
            'la-nube-que-olvido-decir-gracias',
            '2-7 años',
            'Naturaleza',
            true,
            null
        )

        returning id
        into v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='eco del valle') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('eco del valle', '/sounds/eco-del-valle.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='viento entre arboles') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('viento entre arboles', '/sounds/viento.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='pajaros del bosque') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='lluvia magica') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('lluvia magica', '/sounds/lluvia.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='grillos nocturnos') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_eco from sound_effects where nombre='eco del valle' limit 1;
    select id into v_viento from sound_effects where nombre='viento entre arboles' limit 1;
    select id into v_pajaros from sound_effects where nombre='pajaros del bosque' limit 1;
    select id into v_lluvia from sound_effects where nombre='lluvia magica' limit 1;
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

    (v_story_id, 'nombre_nube', 'texto', array['Pluma','Bruma','Copo','Nimbo','Deriva','Algodón']),
    (v_story_id, 'color_nube', 'color', array['rosado','dorado','lila','coral','gris perla','violeta','durazno','plateado']),
    (v_story_id, 'nombre_valle', 'texto', array['Valle Verde','Los Picos','Cañada Alta','Valle Dorado','Los Robles','Piedra Azul']);

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
      'Sobre {nombre_valle} flotaba {nombre_nube}, una nube pequeña que prefería perseguir ráfagas de viento emocionantes antes que quedarse quieta en un mismo lugar. Ninguna otra nube se alejaba tanto como ella. Y a ella, la verdad, eso le encantaba.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/01-nube-persigue-viento.png'),

    (v_story_id, 2,
      'Cada noche, para volver a casa entre los picos, {nombre_nube} hacía siempre lo mismo: gritaba su propio nombre hacia las montañas, y las montañas se lo devolvían, guiándola de regreso. Llevaba tantas noches haciéndolo que ya ni se preguntaba por qué funcionaba.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/02-nube-grita-nombre-montanas.png'),

    (v_story_id, 3,
      'Cerca de ahí, una familia de golondrinas anidaba entre las rocas y la veía pasar cada tarde. —Algún día se va a perder de verdad —murmuraba la golondrina mayor— y ese eco solo no le va a alcanzar. Pero {nombre_nube} nunca las había escuchado. Ni siquiera sabía que existían.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/03-golondrinas-observan-preocupadas.png'),

    (v_story_id, 4,
      'Pasaban los días y {nombre_nube} seguía igual: perseguía cada ráfaga nueva, cada tormenta lejana, cada remolino curioso. El eco de las montañas siempre la traía de vuelta, así que nunca pensó en darle las gracias. Ni a las montañas, ni a nadie.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/04-nube-sigue-sin-agradecer.png'),

    (v_story_id, 5,
      'Una tarde, un viento más fuerte que cualquier otro la arrastró más lejos de lo que jamás había llegado, mucho más allá de las montañas conocidas de {nombre_valle}. {nombre_nube} rió con el vuelo, sin darse cuenta de cuánto se estaba alejando.',
      v_viento, array['viento'],
      '/images/la-nube-que-olvido-decir-gracias/05-rafaga-arrastra-nube-lejos.png'),

    (v_story_id, 6,
      'Cuando por fin quiso volver, nada le resultaba familiar. Los picos tenían otra forma, las sombras caían distinto, y el cielo empezaba a oscurecerse más rápido de lo que a ella le hubiera gustado.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/06-nube-desorientada-picos-desconocidos.png'),

    (v_story_id, 7,
      'Como siempre, gritó su propio nombre hacia las rocas, esperando el eco de siempre para que la guiara de regreso a casa.',
      v_eco, array['eco'],
      '/images/la-nube-que-olvido-decir-gracias/07-nube-grita-nombre-de-siempre.png'),

    (v_story_id, 8,
      'Pero esta vez, nada respondió. {nombre_nube} gritó de nuevo, más fuerte, y solo el silencio le contestó. Por primera vez entendió que nunca había sabido, en realidad, cómo funcionaba ese truco que tanto había usado.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/08-silencio-nadie-responde.png'),

    (v_story_id, 9,
      'Cayó la noche por completo sobre montañas que no eran las suyas, y en algún valle desconocido empezaron a cantar los grillos. {nombre_nube} se sintió, por primera vez en su vida, verdaderamente pequeña.',
      v_grillos, array['grillos'],
      '/images/la-nube-que-olvido-decir-gracias/09-noche-cae-grillos-cantan.png'),

    (v_story_id, 10,
      'Cansada y asustada, dejó de gritar su nombre por costumbre. En su lugar, preguntó, en voz baja y de verdad: —¿Hay alguien ahí? Gracias por ayudarme siempre, aunque nunca lo dije.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/10-nube-pide-ayuda-agradece.png'),

    (v_story_id, 11,
      'Muy lejos de ahí, la familia de golondrinas la escuchó, transportada por el viento de la noche. La golondrina mayor abrió las alas. —Esta vez —dijo— no le va a bastar con un eco. Vamos a buscarla nosotras mismas.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/11-golondrinas-escuchan-deciden-ayudar.png'),

    (v_story_id, 12,
      'Las golondrinas volaron toda la noche, llamándola entre los picos oscuros, hasta que {nombre_nube} por fin escuchó sus voces y las siguió, poco a poco, de vuelta hacia {nombre_valle}.',
      v_pajaros, array['golondrinas'],
      '/images/la-nube-que-olvido-decir-gracias/12-golondrinas-guian-nube-noche.png'),

    (v_story_id, 13,
      'Cuando por fin reconoció las montañas de siempre, {nombre_nube} entendió algo que nunca antes había pensado: durante todo ese tiempo, no había sido solo el eco. Habían sido ellas, cuidándola en silencio, noche tras noche.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/13-nube-reconoce-montanas-casa.png'),

    (v_story_id, 14,
      'Esa madrugada, por primera vez en mucho tiempo, {nombre_nube} se dejó caer en una lluvia suave de color {color_nube}, justo sobre el arbolito más pequeño y débil que los campesinos del valle llevaban meses cuidando.',
      v_lluvia, array['lluvia'],
      '/images/la-nube-que-olvido-decir-gracias/14-nube-llueve-color-sobre-arbolito.png'),

    (v_story_id, 15,
      'Antes de irse a descansar, {nombre_nube} gritó hacia las montañas, alto y claro: —¡Gracias! Y el eco, esta vez, no se conformó con devolverle la palabra una sola vez: se la regresó una y otra vez, gracias, gracias, gracias, como si todo el valle quisiera decírselo también a ella.',
      v_eco, array['eco'],
      '/images/la-nube-que-olvido-decir-gracias/15-eco-repite-gracias-multiplicado.png'),

    (v_story_id, 16,
      'Esa noche, {nombre_nube} entendió por fin la enseñanza que el valle entero parecía repetirle en cada rebote: lo que se agradece de corazón, siempre encuentra el camino de vuelta.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/16-valle-entero-responde-eco.png'),

    (v_story_id, 17,
      'Con los años, el arbolito creció fuerte y alto, y {nombre_nube} nunca dejó de visitarlo cada tarde para regarlo con su lluvia. Y cada vez que volvía a casa, llamaba a las golondrinas por su nombre, una por una, antes de llamar al eco.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/17-arbolito-crece-anos-despues.png'),

    (v_story_id, 18,
      '{nombre_nube} entendió, por fin, que perseguir el viento nunca había sido el problema. El problema había sido olvidar mirar hacia abajo, de vez en cuando, para ver quién la estaba ayudando a encontrar siempre el camino a casa.',
      null, array[]::text[],
      '/images/la-nube-que-olvido-decir-gracias/18-nube-reflexion-final.png');

end $$;
