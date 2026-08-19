do $$

declare
    v_story_id uuid;
    v_olas uuid;
    v_brocha uuid;
    v_pasos_museo uuid;

begin

    select id into v_story_id
    from stories
    where slug='la-huella-que-queria-ser-la-primera'
    limit 1;

    if v_story_id is null then
        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)
        values
        (
            'La huella que quería ser la primera',
            'la-huella-que-queria-ser-la-primera',
            '2-7 años',
            true,
            '/images/portadas/la-huella-que-queria-ser-la-primera.webp'
        )
        returning id into v_story_id;
    else
        update stories
        set titulo='La huella que quería ser la primera',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/la-huella-que-queria-ser-la-primera.webp'
        where id=v_story_id;
    end if;

    if not exists (
        select 1 from sound_effects where nombre='brocha sobre piedra'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('brocha sobre piedra', '/sounds/brocha-sobre-piedra.mp3', 'efecto');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='pasos de museo'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pasos de museo', '/sounds/pasos-de-museo.mp3', 'efecto');
    end if;

    select id into v_olas
    from sound_effects
    where nombre='olas tranquilas'
    limit 1;

    select id into v_brocha
    from sound_effects
    where nombre='brocha sobre piedra'
    limit 1;

    select id into v_pasos_museo
    from sound_effects
    where nombre='pasos de museo'
    limit 1;

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)
    values
        (v_story_id, 'nombre_huella', 'texto', array['Media', 'Rastro', 'Piedrita', 'Paso']),
        (v_story_id, 'animal_antiguo', 'animal', array['lagarto', 'ave', 'tortuga', 'armadillo']),
        (v_story_id, 'nombre_nina', 'texto', array['Mara', 'Inés', 'Eva', 'Salomé']),
        (v_story_id, 'nombre_museo', 'texto', array['Mareas Antiguas', 'Piedra y Tiempo', 'Costa Fósil', 'Pasos del Mar']);

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
    values

        (v_story_id, 1,
        'En un acantilado donde las olas conversaban con la piedra, dormía un rastro antiquísimo. Pertenecía a {animal_antiguo}, una criatura que había cruzado la arena hacía millones de años. En medio de aquellas marcas estaba {nombre_huella}, firme, redonda y bastante inconforme con su lugar.',
        v_olas, array['olas'],
        '/images/la-huella-que-queria-ser-la-primera/01-rastro-en-el-acantilado.webp'),

        (v_story_id, 2,
        'La primera huella señalaba dónde comenzaba el viaje. La última guardaba el misterio de adónde había ido la criatura. Los visitantes hablaban siempre de esas dos. {nombre_huella}, situada exactamente en la mitad, escuchaba y pensaba: «Nadie pregunta por los pasos que simplemente continúan».',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/02-huella-en-la-mitad.webp'),

        (v_story_id, 3,
        'Un equipo llevó el rastro completo al museo {nombre_museo}, antes de que las tormentas alcanzaran el acantilado. Cada fragmento viajó en una caja acolchada. {nombre_huella} quedó entre la marca anterior y la siguiente, como siempre. Ni siquiera el viaje cambió su posición.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/03-traslado-al-museo.webp'),

        (v_story_id, 4,
        'En el museo trabajaba {nombre_nina}, una niña que ayudaba a ordenar pinceles y etiquetas. Al ver las piedras, recorrió el rastro con un dedo sin tocarlo. —Primero salió del agua —imaginó—. Después caminó hacia las dunas. {nombre_huella} esperó que dijera algo sobre la mitad.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/04-nina-observa-el-rastro.webp'),

        (v_story_id, 5,
        'Pero {nombre_nina} corrió a mirar la última marca, donde apenas se distinguían tres dedos. Aquella noche, cuando las lámparas se apagaron, {nombre_huella} empujó el polvo de sus bordes. Si lograba esconderse, pensó, quizá los cuidadores la colocarían al principio al encontrarla de nuevo.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/05-huella-empuja-polvo.webp'),

        (v_story_id, 6,
        'A la mañana siguiente, una capa gris cubría la marca. {nombre_nina} tomó una brocha pequeña y limpió la piedra: frr-frr alrededor, frr-frr en el centro. {nombre_huella} contuvo la respiración mineral. Cuando volvió a aparecer, la niña sonrió, pero continuó trabajando sin cambiarla de lugar.',
        v_brocha, array['frr-frr'],
        '/images/la-huella-que-queria-ser-la-primera/06-brocha-retira-el-polvo.webp'),

        (v_story_id, 7,
        'Entonces la huella probó algo más arriesgado. Aflojó un granito de piedra bajo uno de sus dedos. Luego otro. Quería separarse del fragmento y rodar hasta la cabecera del rastro. Sin embargo, una grieta delgada apareció a su lado y avanzó hacia las marcas vecinas.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/07-grieta-entre-las-marcas.webp'),

        (v_story_id, 8,
        '{nombre_huella} se quedó inmóvil. No quería romper a nadie. Los restauradores protegieron la grieta con una venda suave y cerraron la sala. Sin la marca del centro visible, el rastro parecía dividido: cinco pasos venían desde el mar y otros cinco partían hacia ninguna parte.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/08-rastro-interrumpido.webp'),

        (v_story_id, 9,
        '{nombre_nina} intentó reconstruir el recorrido sobre su cuaderno. Dibujó el comienzo y el final, pero no supo cuánto había girado {animal_antiguo} entre ambos. La distancia tampoco coincidía. —Nos falta el paso que une las dos partes —dijo. Debajo de la venda, {nombre_huella} escuchó atentamente.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/09-dibujo-sin-conexion.webp'),

        (v_story_id, 10,
        'Por primera vez comprendió que estar en medio no significaba sobrar. Su profundidad indicaba cuánto pesaba la criatura. Su inclinación mostraba el instante exacto en que había cambiado de rumbo. Sin ella, el viaje no tenía continuidad. Era un puente pequeño hecho de piedra y tiempo.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/10-huella-comprende-su-lugar.webp'),

        (v_story_id, 11,
        'Esa noche, {nombre_huella} dejó de empujar sus bordes. Acomodó cada granito suelto y mantuvo quieta la grieta mientras el adhesivo de los restauradores se secaba. No podía reparar sola la piedra, pero sí podía dejar de dañarla y conservar completo aquello que aún permanecía unido.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/11-huella-cuida-la-grieta.webp'),

        (v_story_id, 12,
        'Al retirar la venda, {nombre_nina} midió aquella marca con especial cuidado. Gracias a su ángulo, pudo orientar los fragmentos vecinos. La línea recuperó su curva y el rastro volvió a cruzar la sala sin interrupciones. Nadie tuvo que convertir a {nombre_huella} en la primera.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/12-rastro-reconstruido.webp'),

        (v_story_id, 13,
        'Aquella tarde, la luna entró por los ventanales bajos. Cada huella proyectó una sombra sobre la pared. Una tras otra, las sombras parecieron levantar patas invisibles y caminar alrededor de la sala. Al llegar a {nombre_huella}, la criatura completa cambió de dirección sin perder un solo paso.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/13-sombras-que-caminan.webp'),

        (v_story_id, 14,
        'Cuando el museo abrió, los pasos de los visitantes hicieron tac-tac sobre el piso. {nombre_nina} no comenzó la explicación por la primera marca. Señaló la del centro. Mostró su profundidad, su giro y la grieta reparada. Muchos se inclinaron para observarla con nuevos ojos.',
        v_pasos_museo, array['tac-tac'],
        '/images/la-huella-que-queria-ser-la-primera/14-visitantes-miran-el-centro.webp'),

        (v_story_id, 15,
        '—Una historia no se sostiene solamente con su comienzo y su final —dijo {nombre_nina}—. Necesita cada paso que los mantiene conectados. {nombre_huella} no pudo sonreír, porque las huellas fósiles no tienen boca, pero dejó de desear cualquier lugar distinto del suyo.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/15-nina-explica-cada-paso.webp'),

        (v_story_id, 16,
        'Desde entonces, cuando alguien corría hacia la primera o la última marca, {nombre_huella} esperaba tranquila. Sabía que pronto los ojos regresarían por todo el recorrido. Había comprendido que no hace falta encabezar una historia para ser importante: también podemos ser el paso que permite continuarla.',
        null, array[]::text[],
        '/images/la-huella-que-queria-ser-la-primera/16-rastro-completo-y-sereno.webp');

end $$;

-- Assets
-- Portada: /images/portadas/la-huella-que-queria-ser-la-primera.webp
-- Sonidos nuevos:
-- /sounds/brocha-sobre-piedra.mp3
-- /sounds/pasos-de-museo.mp3
