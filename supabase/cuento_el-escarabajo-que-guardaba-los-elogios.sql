do $$

declare

    v_story_id uuid;
    v_abejas uuid;
    v_aplausos uuid;
    v_tierra uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-escarabajo-que-guardaba-los-elogios'
    limit 1;

    --------------------------------------------------
    -- Crear historia
    --------------------------------------------------

    if v_story_id is null then

        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)

        values
        (
            'El escarabajo que guardaba los elogios',
            'el-escarabajo-que-guardaba-los-elogios',
            '2-7 años',
            true,
            '/images/portadas/el-escarabajo-que-guardaba-los-elogios.webp'
        )

        returning id into v_story_id;

    else

        update stories
        set titulo='El escarabajo que guardaba los elogios',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/el-escarabajo-que-guardaba-los-elogios.webp'
        where id=v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (
        select 1 from sound_effects where nombre='tierra removida'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('tierra removida', '/sounds/tierra-removida.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_abejas
    from sound_effects
    where nombre='abejas del huerto'
    limit 1;

    select id into v_aplausos
    from sound_effects
    where nombre='aplausos suaves'
    limit 1;

    select id into v_tierra
    from sound_effects
    where nombre='tierra removida'
    limit 1;

    --------------------------------------------------
    -- Variables
    --------------------------------------------------

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)

    values

        (v_story_id, 'nombre_escarabajo', 'texto', array['Ónix', 'Tilo', 'Mimo', 'Joya']),
        (v_story_id, 'color_caparazon', 'color', array['verde esmeralda', 'azul zafiro', 'rojo cobre', 'violeta oscuro']),
        (v_story_id, 'nombre_vivero', 'texto', array['Neblina', 'Helecho', 'Colibrí', 'Rocío']),
        (v_story_id, 'flor_favorita', 'texto', array['orquídea', 'begonia', 'azucena', 'bromelia']);

    --------------------------------------------------
    -- Bloques
    --------------------------------------------------

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)

    values

        (v_story_id, 1,
        'En lo alto de una montaña húmeda estaba el vivero {nombre_vivero}, cubierto por cristales y helechos. Allí vivía {nombre_escarabajo}, un escarabajo joya de caparazón {color_caparazon}. Cada mañana, las abejas cruzaban las orquídeas mientras él revisaba orgulloso su reflejo en las gotas.',
        v_abejas,
        array['abejas'],
        '/images/el-escarabajo-que-guardaba-los-elogios/01-escarabajo-entre-orquideas.webp'),

        (v_story_id, 2,
        'Cuando alguien elogiaba a {nombre_escarabajo}, una gota redonda aparecía sobre su caparazón. «¡Qué bien limpiaste esa hoja!», y nacía una. «¡Qué colores tan bonitos tienes!», y nacía otra. Él las guardaba cuidadosamente dentro de una copa hecha con pétalos secos.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/02-copa-de-gotas.webp'),

        (v_story_id, 3,
        'Pronto comenzó a elegir solamente trabajos visibles. Pulía macetas cuando llegaban visitantes, enderezaba etiquetas frente a los jardineros y sacudía hojas donde todos pudieran verlo. Si una tarea ocurría detrás de un banco o debajo de la tierra, fingía no haberla escuchado.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/03-trabajos-a-la-vista.webp'),

        (v_story_id, 4,
        'Una niña llamada Alma cuidaba las plantas pequeñas. Cierta mañana pidió ayuda para airear la tierra alrededor de {flor_favorita}, la flor preferida del escarabajo. —Nadie podrá verme ahí abajo —respondió él—. Mejor adornaré la entrada para que el vivero luzca precioso.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/04-pedido-bajo-la-tierra.webp'),

        (v_story_id, 5,
        'Se acercaba la jornada de puertas abiertas. {nombre_escarabajo} colgó semillas doradas, ordenó piedras por tamaños y dejó el sendero reluciente. Los visitantes ofrecieron aplausos al entrar. Tres gotas nuevas rodaron hasta su copa, que ya pesaba más que una ciruela.',
        v_aplausos,
        array['aplausos'],
        '/images/el-escarabajo-que-guardaba-los-elogios/05-entrada-adornada.webp'),

        (v_story_id, 6,
        'Sin embargo, {flor_favorita} comenzó a inclinarse. Sus hojas seguían limpias y su maceta parecía perfecta, pero las raíces no respiraban. Alma introdujo un palito en la tierra compacta. —Necesitamos túneles pequeños —dijo—. Mis dedos podrían romper las raíces más finas.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/06-flor-inclinada.webp'),

        (v_story_id, 7,
        '{nombre_escarabajo} miró la oscuridad bajo las hojas. Allí nadie admiraría su caparazón ni vería cuánto trabajaba. En vez de entrar, pulió los pétalos caídos y colocó su copa de elogios junto a la maceta. Quizá tanta belleza bastaría para animar a la flor.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/07-copa-junto-a-la-flor.webp'),

        (v_story_id, 8,
        'No bastó. La flor bajó otro pétalo. Alma intentó abrir canales con una ramita, pero debía avanzar despacio. Alrededor, los visitantes continuaban mirando las decoraciones. {nombre_escarabajo} oyó sus elogios desde lejos; por primera vez, aquellas palabras no lograron alegrarlo.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/08-elogios-que-no-alegran.webp'),

        (v_story_id, 9,
        'El escarabajo acercó una antena a la maceta. Debajo escuchó raíces apretadas y una gota de agua que no encontraba paso. Miró su copa rebosante. Ninguna de aquellas gotas podía cavar. Ninguna sabía decidir. Esa parte del trabajo dependía solamente de él.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/09-escucha-las-raices.webp'),

        (v_story_id, 10,
        '{nombre_escarabajo} dejó la copa detrás de una piedra y se metió bajo la tierra. Allí su color desapareció por completo. Cavó alrededor de las raíces sin tocarlas: ras-ras a la izquierda, ras-ras hacia abajo, ras-ras hasta encontrar la humedad guardada en el fondo.',
        v_tierra,
        array['ras-ras'],
        '/images/el-escarabajo-que-guardaba-los-elogios/10-tuneles-en-la-tierra.webp'),

        (v_story_id, 11,
        'Trabajó durante tanto tiempo que la jornada terminó. Nadie lo vio abrir el último canal. Cuando el agua encontró el camino, avanzó entre los terrones y rodeó las raíces sedientas. Arriba, el tallo de {flor_favorita} comenzó a levantarse muy lentamente.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/11-agua-entre-las-raices.webp'),

        (v_story_id, 12,
        'Al salir, {nombre_escarabajo} estaba cubierto de barro. Las lámparas ya se apagaban y los visitantes se habían marchado. No hubo aplausos. Aun así, cuando vio la flor erguida y un brote nuevo junto al tallo, sintió una alegría silenciosa y completa.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/12-regreso-cubierto-de-barro.webp'),

        (v_story_id, 13,
        'A la mañana siguiente, Alma descubrió los túneles. Siguió sus curvas con una lupa y comprendió quién los había hecho. No reunió a nadie para celebrarlo. Simplemente dejó junto a la maceta un cuenco de agua para que el trabajador pudiera lavarse.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/13-alma-descubre-los-tuneles.webp'),

        (v_story_id, 14,
        'El sol atravesó el techo del vivero y alcanzó la copa olvidada. Sus gotas proyectaron sobre los helechos pequeños círculos de colores. Después comenzaron a evaporarse. {nombre_escarabajo} no intentó detenerlas. Los elogios habían sido agradables, pero nunca fueron la medida de su trabajo.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/14-prismas-sobre-helechos.webp'),

        (v_story_id, 15,
        'Alma se sentó junto a él mientras contemplaban {flor_favorita}. —Que nadie vea una buena acción no la vuelve pequeña —dijo—. La flor conoce el camino que abriste. {nombre_escarabajo} observó el brote y pensó que algunas respuestas crecían en silencio.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/15-conversacion-junto-a-la-flor.webp'),

        (v_story_id, 16,
        'Desde entonces, {nombre_escarabajo} siguió disfrutando cada palabra amable, pero dejó de perseguirlas. Unas veces trabajaba entre visitantes; otras, bajo macetas donde nadie podía admirarlo. Había comprendido que un elogio calienta el corazón, aunque hacer lo necesario también puede iluminarlo desde dentro.',
        null,
        array[]::text[],
        '/images/el-escarabajo-que-guardaba-los-elogios/16-trabajo-visible-e-invisible.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/el-escarabajo-que-guardaba-los-elogios.webp
-- Imágenes:
-- 01-escarabajo-entre-orquideas.webp
-- 02-copa-de-gotas.webp
-- 03-trabajos-a-la-vista.webp
-- 04-pedido-bajo-la-tierra.webp
-- 05-entrada-adornada.webp
-- 06-flor-inclinada.webp
-- 07-copa-junto-a-la-flor.webp
-- 08-elogios-que-no-alegran.webp
-- 09-escucha-las-raices.webp
-- 10-tuneles-en-la-tierra.webp
-- 11-agua-entre-las-raices.webp
-- 12-regreso-cubierto-de-barro.webp
-- 13-alma-descubre-los-tuneles.webp
-- 14-prismas-sobre-helechos.webp
-- 15-conversacion-junto-a-la-flor.webp
-- 16-trabajo-visible-e-invisible.webp
-- Sonidos nuevos:
-- tierra-removida.mp3
