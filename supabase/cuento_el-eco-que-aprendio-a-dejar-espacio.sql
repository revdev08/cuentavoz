-- Cuentavoz: El eco que aprendió a dejar espacio
-- Edad: 2-7 años
-- Emoción dominante: asombro sereno.
-- Enseñanza: escuchar también significa dejar espacio para que la voz de los demás llegue completa.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_eco_cueva uuid;
    v_olas uuid;
    v_gotas_cueva uuid;
    v_campana_boya uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-eco-que-aprendio-a-dejar-espacio'
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
            'El eco que aprendió a dejar espacio',
            'el-eco-que-aprendio-a-dejar-espacio',
            '2-7 años',
            'Valores',
            true,
            '/images/portadas/el-eco-que-aprendio-a-dejar-espacio.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='El eco que aprendió a dejar espacio',
        edad_recomendada='2-7 años',
        categoria='Valores',
        es_personalizable=true,
        portada_url='/images/portadas/el-eco-que-aprendio-a-dejar-espacio.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='eco en cueva') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('eco en cueva', '/sounds/eco-en-cueva.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='olas tranquilas') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('olas tranquilas', '/sounds/olas-tranquilas.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='gotas en cueva') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('gotas en cueva', '/sounds/gotas-en-cueva.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='campana de boya') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('campana de boya', '/sounds/campana-de-boya.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_eco_cueva from sound_effects where nombre='eco en cueva' limit 1;
    select id into v_olas from sound_effects where nombre='olas tranquilas' limit 1;
    select id into v_gotas_cueva from sound_effects where nombre='gotas en cueva' limit 1;
    select id into v_campana_boya from sound_effects where nombre='campana de boya' limit 1;

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

        (v_story_id, 'nombre_eco', 'texto', array['Rebote', 'Coro', 'Vuelta', 'Resueno']),
        (v_story_id, 'nombre_nino', 'texto', array['Marina', 'Nicolás', 'Luna', 'Simón']),
        (v_story_id, 'nombre_cala', 'texto', array['Cala Azul', 'Cala de las Conchas', 'Cala Redonda', 'Cala del Faro']),
        (v_story_id, 'palabra_favorita', 'texto', array['hola', 'caracola', 'aventura', 'familia', 'mariposa']);

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
        'En las cuevas azules de {nombre_cala} vivía {nombre_eco}, un eco redondo y veloz. No tenía manos, sombrero ni cama. Existía cuando alguien hablaba, y su mayor alegría era devolver cada palabra antes de que el silencio pudiera acomodarse entre las rocas.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/01-eco-en-cueva-azul.webp'),

        (v_story_id, 2,
        'Su palabra preferida era {palabra_favorita}. Podía hacerla saltar por siete paredes y regresar convertida en un pequeño coro. {nombre_eco} pensaba que escuchar bien significaba contestar siempre. Si una voz terminaba, él corría a llenar el hueco, orgulloso de no desperdiciar ningún sonido.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/02-palabra-entre-rocas.webp'),

        (v_story_id, 3,
        'Una mañana llegó {nombre_nino} en una barca roja. Se acercó a la entrada y llamó: —¿Hay alguien? El eco respondió con otro «¿alguien?» que rodó por la piedra. El niño sonrió y gritó {palabra_favorita}. Entonces apareció un eco juguetón, repetido una y otra vez.',
        v_eco_cueva,
        array['eco'],
        '/images/el-eco-que-aprendio-a-dejar-espacio/03-primer-juego-de-voces.webp'),

        (v_story_id, 4,
        'Pasaron la mañana inventando mensajes. Las olas llevaban la barca hacia una pared y luego hacia otra. {nombre_nino} decía palabras largas; {nombre_eco} las devolvía pequeñas. Decía palabras diminutas; él las estiraba hasta que parecían cintas sonoras colgadas del techo de la cueva.',
        v_olas,
        array['olas'],
        '/images/el-eco-que-aprendio-a-dejar-espacio/04-cintas-de-palabras.webp'),

        (v_story_id, 5,
        'Al mediodía entraron dos pescadores. Para atravesar los túneles, uno llamaba desde adelante y el otro respondía desde atrás. Así sabían dónde estaba cada barca. {nombre_eco} repitió ambos llamados con entusiasmo. Los pescadores rieron, aunque tuvieron que preguntar dos veces quién había contestado realmente.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/05-barcas-en-los-tuneles.webp'),

        (v_story_id, 6,
        'Por la tarde descendió una niebla espesa. La entrada desapareció detrás de un velo blanco y la campana de una boya comenzó a balancearse mar adentro. Su voz metálica indicaba el canal seguro. Dentro de la cueva, todos bajaron la voz para distinguirla con cuidado.',
        v_campana_boya,
        array['campana'],
        '/images/el-eco-que-aprendio-a-dejar-espacio/06-niebla-y-campana.webp'),

        (v_story_id, 7,
        '{nombre_eco} creyó que aquel silencio era un escenario preparado para él. Repitió la campana, el roce de los remos y hasta un estornudo. Cada sonido volvió desde direcciones distintas. Las barcas redujeron la marcha. Ya nadie sabía cuál llamada venía del canal y cuál de las paredes.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/07-sonidos-enredados.webp'),

        (v_story_id, 8,
        '—Necesitamos escuchar el primer sonido completo —pidió {nombre_nino}—. Después podrás responder. Pero {nombre_eco} temió desaparecer si dejaba pasar una sola voz. Contestó enseguida, más fuerte que antes. Su respuesta chocó contra las rocas y regresó convertida en un ovillo imposible de desenredar.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/08-ovillo-de-sonidos.webp'),

        (v_story_id, 9,
        'Desde la niebla llegaron dos llamadas: una corta desde el canal seguro y otra larga desde una ensenada estrecha. {nombre_eco} las mezcló sin querer. Una barca giró hacia las piedras. {nombre_nino} levantó el remo, pero no podía señalar un camino que tampoco lograba oír.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/09-barca-hacia-las-piedras.webp'),

        (v_story_id, 10,
        'El eco vio las caras preocupadas y comprendió que devolver todas las voces no era lo mismo que escucharlas. Hizo algo que nunca había intentado: dejó pasar la siguiente llamada sin perseguirla. Sintió un gran espacio abrirse dentro de la cueva, pero no desapareció.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/10-eco-elige-el-silencio.webp'),

        (v_story_id, 11,
        'En aquel silencio, las gotas del techo comenzaron a oírse una por una. Cada gota encendía un círculo plateado sobre el agua, y juntas parecían una constelación que podía escucharse. {nombre_eco} permaneció quieto, maravillado: el mundo guardaba músicas que él siempre había cubierto con su propia voz.',
        v_gotas_cueva,
        array['gotas'],
        '/images/el-eco-que-aprendio-a-dejar-espacio/11-constelacion-de-gotas.webp'),

        (v_story_id, 12,
        'La llamada corta volvió, limpia y clara. Los pescadores orientaron las barcas hacia el canal. Cuando todos estuvieron lejos de las piedras, {nombre_eco} devolvió solamente la última sílaba, suave como una despedida. Esta vez nadie se confundió. La niebla seguía allí, pero el camino podía oírse.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/12-canal-en-la-niebla.webp'),

        (v_story_id, 13,
        'Al salir de la cueva, {nombre_nino} acarició la pared húmeda. —Escuchar no es correr para contestar —dijo—. A veces es dejar que la voz del otro llegue entera. {nombre_eco} esperó hasta el final de la frase. Solo entonces respondió «entera», con una delicadeza nueva.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/13-frase-que-llega-entera.webp'),

        (v_story_id, 14,
        'Cuando la niebla se levantó, el mar volvió a mostrar sus azules. {nombre_eco} descubrió que las pausas no eran agujeros vacíos. En ellas cabían remos, respiraciones, alas y preguntas. Podía elegir qué devolver, cuánto esperar y cuándo dejar una palabra descansando donde había nacido.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/14-mar-despues-de-la-niebla.webp'),

        (v_story_id, 15,
        'Desde aquel día, {nombre_nino} y {nombre_eco} inventaron un juego distinto. El niño decía tres palabras y guardaba una pausa. El eco devolvía solo la que más le había gustado. A veces elegía {palabra_favorita}; otras veces no elegía ninguna, y juntos escuchaban el mar.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/15-juego-de-las-pausas.webp'),

        (v_story_id, 16,
        'Quienes visitaban {nombre_cala} todavía encontraban un eco alegre entre las cuevas. Pero ahora sus respuestas llegaban después de un instante tranquilo. {nombre_eco} había comprendido que una conversación no crece al llenarla por completo: crece cuando cada voz encuentra espacio para llegar, quedarse y ser escuchada.',
        null,
        array[]::text[],
        '/images/el-eco-que-aprendio-a-dejar-espacio/16-voces-con-espacio.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/el-eco-que-aprendio-a-dejar-espacio.webp
-- Imágenes:
-- 01-eco-en-cueva-azul.webp
-- 02-palabra-entre-rocas.webp
-- 03-primer-juego-de-voces.webp
-- 04-cintas-de-palabras.webp
-- 05-barcas-en-los-tuneles.webp
-- 06-niebla-y-campana.webp
-- 07-sonidos-enredados.webp
-- 08-ovillo-de-sonidos.webp
-- 09-barca-hacia-las-piedras.webp
-- 10-eco-elige-el-silencio.webp
-- 11-constelacion-de-gotas.webp
-- 12-canal-en-la-niebla.webp
-- 13-frase-que-llega-entera.webp
-- 14-mar-despues-de-la-niebla.webp
-- 15-juego-de-las-pausas.webp
-- 16-voces-con-espacio.webp
-- Sonidos nuevos:
-- eco-en-cueva.mp3
-- gotas-en-cueva.mp3
-- campana-de-boya.mp3
