-- Cuentavoz: El semáforo que olvidó el amarillo
-- Edad: 2-7 años
-- Emoción dominante: alivio.
-- Enseñanza: los cambios necesitan un momento para que todos puedan prepararse.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_bocinas uuid;
    v_timbre uuid;
    v_pasos_adoquines uuid;
    v_bip_peatonal uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-semaforo-que-olvido-el-amarillo'
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
            'El semáforo que olvidó el amarillo',
            'el-semaforo-que-olvido-el-amarillo',
            '2-7 años',
            'Convivencia',
            true,
            '/images/portadas/el-semaforo-que-olvido-el-amarillo.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='El semáforo que olvidó el amarillo',
        edad_recomendada='2-7 años',
        categoria='Convivencia',
        es_personalizable=true,
        portada_url='/images/portadas/el-semaforo-que-olvido-el-amarillo.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos requeridos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='bocinas de ciudad') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('bocinas de ciudad', '/sounds/bocinas-de-ciudad.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='timbre de bicicleta') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('timbre de bicicleta', '/sounds/timbre-de-bicicleta.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='pasos sobre adoquines') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pasos sobre adoquines', '/sounds/pasos-sobre-adoquines.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='semaforo peatonal') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('semaforo peatonal', '/sounds/semaforo-peatonal.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_bocinas from sound_effects where nombre='bocinas de ciudad' limit 1;
    select id into v_timbre from sound_effects where nombre='timbre de bicicleta' limit 1;
    select id into v_pasos_adoquines from sound_effects where nombre='pasos sobre adoquines' limit 1;
    select id into v_bip_peatonal from sound_effects where nombre='semaforo peatonal' limit 1;

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

        (v_story_id, 'nombre_semaforo', 'texto', array['Tricolor', 'Faro', 'Luz', 'Pestañeo']),
        (v_story_id, 'nombre_nino', 'texto', array['Mila', 'Benjamín', 'Sara', 'Nico']),
        (v_story_id, 'nombre_avenida', 'texto', array['Avenida del Mango', 'Calle de los Balcones', 'Paseo del Sol', 'Avenida Colibrí']),
        (v_story_id, 'color_bicicleta', 'color', array['turquesa', 'roja', 'amarilla', 'violeta']);

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
        'En la esquina más concurrida de {nombre_avenida} vivía {nombre_semaforo}, un semáforo alto con tres ojos redondos. El rojo detenía autobuses. El verde soltaba bicicletas y zapatos. El amarillo ofrecía un instante para respirar. Cada luz tenía su momento, aunque no todas recibían los mismos aplausos.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/01-esquina-de-tres-luces.webp'),

        (v_story_id, 2,
        'A {nombre_semaforo} le encantaban las decisiones rápidas. Rojo significaba no. Verde significaba sí. En cambio, el amarillo parecía decir quizá, espera, prepárate. —Nadie necesita tanto rodeo —pensaba—. Una avenida moderna debería saber enseguida si avanza o se queda quieta.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/02-semaforo-impaciente.webp'),

        (v_story_id, 3,
        'Cada mañana, {nombre_nino} cruzaba aquella esquina junto a su abuelo y una bicicleta {color_bicicleta}. Antes del verde, probaban el timbre, acomodaban la canasta y miraban a ambos lados. —Ese pequeño amarillo nos ayuda a estar listos —decía el abuelo. {nombre_semaforo} fingía no escucharlo.',
        v_timbre,
        array['timbre'],
        '/images/el-semaforo-que-olvido-el-amarillo/03-bicicleta-y-abuelo.webp'),

        (v_story_id, 4,
        'Un viernes anunciaron un desfile de bicicletas para el atardecer. Pasarían ruedas con flores, cascos con cintas y canastas llenas de frutas. {nombre_semaforo} quiso demostrar que podía mover la avenida sin perder un segundo. Durante todo el día practicó cambios veloces entre rojo y verde.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/04-anuncio-del-desfile.webp'),

        (v_story_id, 5,
        'Al mediodía tomó una decisión: escondería el amarillo hasta terminar el desfile. Primero encendió el verde. Después, sin aviso, mostró el rojo. Los ciclistas frenaron, una vendedora sujetó su cesta y varias bocinas protestaron. Nadie chocó, pero todos quedaron con el corazón apurado.',
        v_bocinas,
        array['bocinas'],
        '/images/el-semaforo-que-olvido-el-amarillo/05-primer-cambio-brusco.webp'),

        (v_story_id, 6,
        '—Más rápido no siempre significa mejor —observó {nombre_nino}. {nombre_semaforo} respondió con otro verde repentino. El abuelo apenas alcanzó a levantar la bicicleta. Una señora todavía abrochaba su sandalia; un perro olfateaba el borde. Todos podían avanzar, pero no todos estaban preparados al mismo tiempo.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/06-cruce-sin-prepararse.webp'),

        (v_story_id, 7,
        'Durante la tarde, la esquina perdió su ritmo. Los peatones dudaban antes de bajar la acera. Los conductores arrancaban mirando el rojo con desconfianza. Hasta los pasos sobre los adoquines sonaban desordenados. {nombre_semaforo} seguía cambiando deprisa, convencido de que todos acabarían acostumbrándose.',
        v_pasos_adoquines,
        array['pasos'],
        '/images/el-semaforo-que-olvido-el-amarillo/07-esquina-sin-ritmo.webp'),

        (v_story_id, 8,
        'Entonces apareció el desfile. Cuarenta bicicletas llenaron {nombre_avenida} de cintas y flores. Al frente pedaleaba {nombre_nino}; detrás venía el abuelo con una cesta de panes. {nombre_semaforo} encendió verde para recibirlos y calculó que un cambio veloz mantendría perfecta la fila.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/08-desfile-de-bicicletas.webp'),

        (v_story_id, 9,
        'Pero una cinta se soltó de la bicicleta {color_bicicleta} y rozó una rueda. {nombre_nino} disminuyó la marcha para recogerla. El abuelo también frenó. La mitad del desfile había cruzado; la otra mitad seguía detrás. Justo entonces, {nombre_semaforo} pasó directamente del verde al rojo.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/09-cinta-en-la-rueda.webp'),

        (v_story_id, 10,
        'La fila quedó partida. Delante, las bicicletas esperaban a sus familias. Detrás, los más pequeños no sabían si continuar. {nombre_semaforo} vio ruedas detenidas en direcciones distintas y comprendió que sus dos respuestas no alcanzaban. A veces nadie necesitaba sí o no, sino un momento.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/10-desfile-dividido.webp'),

        (v_story_id, 11,
        'Podía insistir y obligar a todos a obedecer otro cambio. En vez de hacerlo, {nombre_semaforo} buscó dentro de su caja la luz olvidada. El amarillo despertó despacio, tibio como pan recién hecho. La avenida no avanzó ni se detuvo: respiró junta durante un instante dorado.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/11-regreso-de-la-luz-ambar.webp'),

        (v_story_id, 12,
        'Bajo aquella luz, las cintas, los radios y los reflectores devolvieron cientos de pequeños soles. {nombre_nino} retiró la cinta de la rueda. El abuelo acercó a quienes habían quedado atrás. Los conductores aflojaron las manos. Nadie había resuelto todo, pero ahora podían prepararse juntos.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/12-cientos-de-soles.webp'),

        (v_story_id, 13,
        'Cuando el cruce quedó listo, sonó el bip peatonal y apareció el verde. El desfile continuó completo, sin carreras. Las bicicletas avanzaron como una cinta larga que sabía doblarse sin romperse. {nombre_semaforo} mantuvo cada luz el tiempo necesario y la esquina recuperó su música.',
        v_bip_peatonal,
        array['bip'],
        '/images/el-semaforo-que-olvido-el-amarillo/13-desfile-reunido.webp'),

        (v_story_id, 14,
        'Al terminar, {nombre_nino} apoyó la bicicleta {color_bicicleta} junto al poste. —Prepararse también forma parte del camino —dijo—. Ese momento entre una cosa y otra permite mirar, terminar y comenzar con cuidado. {nombre_semaforo} encendió su amarillo, esta vez sin sentir que sobraba.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/14-conversacion-junto-al-poste.webp'),

        (v_story_id, 15,
        'Desde entonces, el barrio empezó a llamar al amarillo «el respiro de la esquina». En ese instante, alguien ajustaba un casco, otro tomaba una mano y alguna bicicleta enderezaba su canasta. Era breve, pero suficiente. La prisa ya no gobernaba sola sobre {nombre_avenida}.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/15-respiro-de-la-esquina.webp'),

        (v_story_id, 16,
        '{nombre_semaforo} siguió diciendo no con rojo y sí con verde. Sin embargo, nunca volvió a olvidar su tercer ojo. Había comprendido que los cambios necesitan un pequeño aviso: cuando todos tienen tiempo para prepararse, detenerse asusta menos y avanzar se vuelve mucho más seguro.',
        null,
        array[]::text[],
        '/images/el-semaforo-que-olvido-el-amarillo/16-tres-luces-al-anochecer.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/el-semaforo-que-olvido-el-amarillo.webp
-- Imágenes:
-- 01-esquina-de-tres-luces.webp
-- 02-semaforo-impaciente.webp
-- 03-bicicleta-y-abuelo.webp
-- 04-anuncio-del-desfile.webp
-- 05-primer-cambio-brusco.webp
-- 06-cruce-sin-prepararse.webp
-- 07-esquina-sin-ritmo.webp
-- 08-desfile-de-bicicletas.webp
-- 09-cinta-en-la-rueda.webp
-- 10-desfile-dividido.webp
-- 11-regreso-de-la-luz-ambar.webp
-- 12-cientos-de-soles.webp
-- 13-desfile-reunido.webp
-- 14-conversacion-junto-al-poste.webp
-- 15-respiro-de-la-esquina.webp
-- 16-tres-luces-al-anochecer.webp
-- Sonidos requeridos:
-- bocinas-de-ciudad.mp3
-- timbre-de-bicicleta.mp3
-- pasos-sobre-adoquines.mp3
-- semaforo-peatonal.mp3
