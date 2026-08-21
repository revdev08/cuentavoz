do $$

declare
    v_story_id uuid;
    v_maquina uuid;
    v_tijeras uuid;
    v_botones uuid;

begin

    select id into v_story_id
    from stories
    where slug='el-taller-de-los-bolsillos-imposibles'
    limit 1;

    if v_story_id is null then
        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)
        values
        (
            'El taller de los bolsillos imposibles',
            'el-taller-de-los-bolsillos-imposibles',
            '2-7 años',
            true,
            '/images/portadas/el-taller-de-los-bolsillos-imposibles.webp'
        )
        returning id into v_story_id;
    else
        update stories
        set titulo='El taller de los bolsillos imposibles',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/el-taller-de-los-bolsillos-imposibles.webp'
        where id=v_story_id;
    end if;

    if not exists (select 1 from sound_effects where nombre='maquina de coser') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('maquina de coser', '/sounds/maquina-de-coser.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='tijeras de tela') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('tijeras de tela', '/sounds/tijeras-de-tela.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='botones derramados') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('botones derramados', '/sounds/botones-derramados.mp3', 'efecto');
    end if;

    select id into v_maquina from sound_effects where nombre='maquina de coser' limit 1;
    select id into v_tijeras from sound_effects where nombre='tijeras de tela' limit 1;
    select id into v_botones from sound_effects where nombre='botones derramados' limit 1;

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)
    values
        (v_story_id, 'nombre_aprendiz', 'texto', array['Ada', 'Bruno', 'Lola', 'Tomás']),
        (v_story_id, 'nombre_taller', 'texto', array['Puntada Alegre', 'Retazo y Botón', 'La Aguja Viajera', 'Mil Bolsillos']),
        (v_story_id, 'color_hilo', 'color', array['rojo amapola', 'azul cobalto', 'amarillo girasol', 'verde esmeralda']),
        (v_story_id, 'objeto_bolsillo', 'texto', array['piedra brillante', 'carrito diminuto', 'concha marina', 'muñeca de trapo']);

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
    values

        (v_story_id, 1,
        'En el taller {nombre_taller}, {nombre_aprendiz} aprendía a medir, cortar y coser. Su parte favorita eran los bolsillos. Guardaban llaves, semillas, meriendas y secretos diminutos. Un lunes recibió su primer encargo importante: preparar bolsillos nuevos para todas las personas de la calle.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/01-aprendiz-entre-retazos.webp'),

        (v_story_id, 2,
        '{nombre_aprendiz} dibujó un cuadrado perfecto y anunció: —Si todos reciben el mismo bolsillo, será completamente justo. Cortó veinte piezas idénticas con hilo {color_hilo}. Las tijeras hicieron chac sobre la mesa, mientras los retazos caían como hojas muy ordenadas.',
        v_tijeras, array['chac'],
        '/images/el-taller-de-los-bolsillos-imposibles/02-veinte-bolsillos-iguales.webp'),

        (v_story_id, 3,
        'La máquina comenzó su traqueteo. Una puntada, otra puntada, otra más. Al mediodía, veinte delantales y chaquetas lucían cuadrados exactamente iguales. {nombre_aprendiz} los colgó frente al taller y contempló aquella fila perfectamente alineada con una satisfacción realmente enorme y profunda.',
        v_maquina, array['traqueteo'],
        '/images/el-taller-de-los-bolsillos-imposibles/03-fila-de-prendas-perfectas.webp'),

        (v_story_id, 4,
        'La primera clienta fue la jardinera. Intentó guardar sobres de semillas, pero el bolsillo era tan profundo que sus dedos no alcanzaban el fondo. Después llegó el panadero: su cuchara larga sobresalía, giraba con cada paso y golpeaba las puertas.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/04-primeras-pruebas-fallidas.webp'),

        (v_story_id, 5,
        'La ciclista necesitaba cerrar sus llaves para que no saltaran. El titiritero debía separar dos muñecos que enredaban sus hilos. Una niña quería llevar una canica sin perderla. El bolsillo idéntico servía un poco para todos y realmente bien para nadie.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/05-clientes-con-necesidades-distintas.webp'),

        (v_story_id, 6,
        '—Pero son iguales —protestó {nombre_aprendiz}—. ¿Cómo pueden ser injustos? Para demostrar que funcionaban, guardó su {objeto_bolsillo} en uno. Al inclinarse para recoger tela, el objeto cayó sobre una caja. Los botones rodaron haciendo clac-clac por todo el suelo.',
        v_botones, array['clac-clac'],
        '/images/el-taller-de-los-bolsillos-imposibles/06-lluvia-de-botones.webp'),

        (v_story_id, 7,
        'Nadie se rio. La jardinera se agachó para recoger botones, el panadero detuvo uno con su zapato y la ciclista atrapó otro bajo una rueda. {nombre_aprendiz} observó con atención aquellas manos diferentes resolviendo el mismo accidente de maneras distintas.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/07-todos-recogen-botones.webp'),

        (v_story_id, 8,
        'En lugar de defender su dibujo, llevó una libreta completamente vacía a la acera. —Enséñenme qué debe hacer cada bolsillo —pidió. No preguntó cuál parecía más bonito. Preguntó qué debía guardar, cómo se movía su dueño y cuándo necesitaba abrirse.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/08-preguntas-en-la-acera.webp'),

        (v_story_id, 9,
        'La jardinera pidió uno ancho y poco profundo. El panadero, una funda larga. La ciclista eligió tapa con botón. El titiritero necesitaba dos compartimentos separados. La niña trazó un pequeño círculo suave y acolchado. Cada petición cambió el dibujo original.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/09-bocetos-para-cada-persona.webp'),

        (v_story_id, 10,
        '{nombre_aprendiz} descosió muy cuidadosamente los cuadrados sin esconder el error. Después clasificó los retazos por resistencia, tamaño y suavidad. Algunas piezas se convirtieron en tapas; otras, en divisiones o correas ajustables. Nada fue desperdiciado, ni siquiera la primera idea.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/10-desarmar-para-redisenar.webp'),

        (v_story_id, 11,
        'Durante toda la tarde, la máquina repitió su traqueteo. Esta vez no produjo una fila igual, sino una familia de formas: media luna, acordeón, tubo, sobre y nido. El hilo {color_hilo} recorría todas las prendas como un camino compartido.',
        v_maquina, array['traqueteo'],
        '/images/el-taller-de-los-bolsillos-imposibles/11-bolsillos-de-muchas-formas.webp'),

        (v_story_id, 12,
        'Llegó el momento de probar. Las semillas salieron con facilidad. La cuchara permaneció firme. Las llaves pedalearon sin saltar. Los títeres dejaron de pelear y la canica descansó en su nido. El {objeto_bolsillo} de {nombre_aprendiz} también quedó seguro.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/12-segunda-prueba-exitosa.webp'),

        (v_story_id, 13,
        'Cuando todas las personas caminaron juntas por la calle, los bolsillos parecían las casas de una ciudad diminuta: altos, bajos, redondos, estrechos, con pequeñas puertas y tejados. Ninguno era idéntico, pero cada uno permitía que su dueño avanzara con libertad.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/13-ciudad-de-bolsillos.webp'),

        (v_story_id, 14,
        '—Dar lo mismo puede parecer justo —dijo {nombre_aprendiz}—, pero la justicia también escucha atentamente lo que cada persona necesita para participar. No significa conceder cualquier capricho. Significa comprender el uso, probar la solución y corregirla cuando todavía no funciona.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/14-aprendiz-explica-su-descubrimiento.webp'),

        (v_story_id, 15,
        'La pared del taller no recibió medallas. Recibió los primeros veinte cuadrados, cosidos juntos como recordatorio. Desde lejos formaban una ventana; de cerca mostraban puntadas torcidas y marcas de tiza. {nombre_aprendiz} decidió conservar también aquello que había aprendido al fallar.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/15-mural-de-primeros-intentos.webp'),

        (v_story_id, 16,
        'Desde aquel lunes, ningún bolsillo comenzaba con las tijeras. Primero venían las preguntas, luego una prueba y solamente después las puntadas finales. {nombre_aprendiz} comprendió que cuidar a todos no siempre produce formas iguales: produce soluciones donde cada persona puede llevar lo suyo.',
        null, array[]::text[],
        '/images/el-taller-de-los-bolsillos-imposibles/16-taller-lleno-de-posibilidades.webp');

end $$;

-- Assets
-- Portada: /images/portadas/el-taller-de-los-bolsillos-imposibles.webp
-- Sonidos:
-- /sounds/maquina-de-coser.mp3
-- /sounds/tijeras-de-tela.mp3
-- /sounds/botones-derramados.mp3
