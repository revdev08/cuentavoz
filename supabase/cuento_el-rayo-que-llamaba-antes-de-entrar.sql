do $$

declare

    v_story_id uuid;
    v_gorriones uuid;
    v_cortinas uuid;
    v_ronquido uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-rayo-que-llamaba-antes-de-entrar'
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
            'El rayo que llamaba antes de entrar',
            'el-rayo-que-llamaba-antes-de-entrar',
            '2-7 años',
            true,
            '/images/portadas/el-rayo-que-llamaba-antes-de-entrar.webp'
        )

        returning id
        into v_story_id;

    else

        update stories
        set titulo='El rayo que llamaba antes de entrar',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/el-rayo-que-llamaba-antes-de-entrar.webp'
        where id=v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (
        select 1 from sound_effects where nombre='cortinas deslizandose'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('cortinas deslizandose', '/sounds/cortinas-deslizandose.mp3', 'efecto');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='ronquido suave'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('ronquido suave', '/sounds/ronquido-suave.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_gorriones
    from sound_effects
    where nombre='gorriones urbanos'
    limit 1;

    select id into v_cortinas
    from sound_effects
    where nombre='cortinas deslizandose'
    limit 1;

    select id into v_ronquido
    from sound_effects
    where nombre='ronquido suave'
    limit 1;

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

        (v_story_id, 'nombre_rayo', 'texto', array['Solín', 'Clara', 'Chispa', 'Dorado']),
        (v_story_id, 'nombre_edificio', 'texto', array['Mirador', 'Azucena', 'Campanario', 'Naranjo']),
        (v_story_id, 'color_cortina', 'color', array['azul cielo', 'rojo sandía', 'verde menta', 'amarillo maíz']),
        (v_story_id, 'nombre_nino', 'texto', array['Lina', 'Tomás', 'Emilia', 'Simón']);

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
        'Cada mañana, un rayo llamado {nombre_rayo} bajaba hasta el edificio {nombre_edificio}. Le encantaba colarse por todas las ventanas y despertar los colores escondidos: las tazas rojas, las plantas verdes y las motas de polvo que bailaban cuando nadie las miraba.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/01-rayo-sobre-el-edificio.webp'),

        (v_story_id, 2,
        '{nombre_rayo} creía que una mañana bien hecha debía comenzar igual para todos. Entraba primero, preguntaba después. —¡Arriba, arriba! —decía, estirándose sobre almohadas y mesas. Casi siempre encontraba sonrisas, así que nunca imaginó que su entusiasmo pudiera llegar en un momento equivocado.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/02-visita-sin-preguntar.webp'),

        (v_story_id, 3,
        'En el tercer piso, una panadera amasaba desde temprano y agradecía aquella claridad. En el cuarto, un pintor acercaba sus cuadros a la ventana. Los gorriones saludaban desde las cornisas. Cada bienvenida convencía más a {nombre_rayo}: si su luz ayudaba allí, ayudaría en cualquier parte.',
        v_gorriones,
        array['gorriones'],
        '/images/el-rayo-que-llamaba-antes-de-entrar/03-ventanas-agradecidas.webp'),

        (v_story_id, 4,
        'Entonces llegó a la ventana de {nombre_nino}. Las cortinas de color {color_cortina} estaban cerradas, pero {nombre_rayo} encontró una rendija. Se hizo delgado como un hilo, atravesó la tela y cayó justo sobre una cuna donde por fin dormía un bebé.',
        v_cortinas,
        array['cortinas'],
        '/images/el-rayo-que-llamaba-antes-de-entrar/04-rendija-en-las-cortinas.webp'),

        (v_story_id, 5,
        'El bebé arrugó la nariz y despertó llorando. {nombre_nino}, que había pasado la noche meciendo la cuna con su familia, cubrió la ventana. —Tu luz es bonita —susurró—, pero ahora necesitábamos sombra. {nombre_rayo} salió confundido; nunca habían recibido así una mañana suya.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/05-bebe-necesita-sombra.webp'),

        (v_story_id, 6,
        'Para demostrar que todavía sabía ayudar, {nombre_rayo} corrió al apartamento siguiente. Allí encontró a un músico dormido después de trabajar de noche. Iluminó su almohada con todas sus fuerzas. Un ronquido se interrumpió, el músico se tapó la cabeza y pidió cinco minutos más.',
        v_ronquido,
        array['ronquido'],
        '/images/el-rayo-que-llamaba-antes-de-entrar/06-musico-dormido.webp'),

        (v_story_id, 7,
        'En otra casa, una abuela cultivaba helechos que preferían la penumbra. {nombre_rayo} quiso hacerlos resplandecer, pero las hojas se encogieron bajo el calor. La abuela corrió una persiana y dijo con cariño: —Dar lo mismo a todos no siempre es dar lo que necesitan.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/07-helechos-en-penumbra.webp'),

        (v_story_id, 8,
        '{nombre_rayo} se retiró hasta el muro de enfrente. Por primera vez observó el edificio sin entrar. Algunas ventanas estaban abiertas; otras mostraban apenas una esquina. Una tenía papel de colores. Otra seguía oscura. El edificio no despertaba como un reloj, sino como muchas canciones diferentes.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/08-ventanas-diferentes.webp'),

        (v_story_id, 9,
        'A media mañana, {nombre_nino} apareció en el balcón y colgó una pequeña tarjeta junto a la cortina. Había dibujado un sol cuando la familia quería claridad y una luna cuando necesitaba descanso. Los vecinos vieron la idea y comenzaron a inventar sus propias señales.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/09-senales-en-los-balcones.webp'),

        (v_story_id, 10,
        'La panadera puso una espiga para pedir calor. El músico dibujó una oreja dormida. La abuela eligió una hoja sombreada. En poco tiempo, la fachada pareció un libro de estampas. {nombre_rayo} podía leerlo, pero aún debía decidir si respetaría una respuesta que no esperaba.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/10-fachada-de-senales.webp'),

        (v_story_id, 11,
        'A la mañana siguiente, {nombre_rayo} llegó veloz hasta la cuna. La tarjeta mostraba una luna. La rendija seguía allí, tentadora. Podía atravesarla sin dificultad. En cambio, se quedó sobre el alféizar, recogió su resplandor y esperó, aunque cada minuto le parecía larguísimo.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/11-rayo-espera-afuera.webp'),

        (v_story_id, 12,
        'Mientras esperaba, descubrió otras formas de ser útil. Secó una manta en la azotea, calentó el agua de un gato y dibujó rectángulos dorados para que jugaran dos niños del patio. Ninguna tarea necesitaba invadir una habitación. La mañana seguía avanzando sin depender solamente de él.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/12-ayudas-en-la-azotea.webp'),

        (v_story_id, 13,
        'Al fin, las cortinas se deslizaron. En la tarjeta apareció el sol. {nombre_nino} abrió la ventana y {nombre_rayo} entró despacio, sin saltar sobre la cuna. Recorrió el suelo, calentó unos calcetines pequeños y dejó que el bebé despertara siguiendo una franja dorada.',
        v_cortinas,
        array['cortinas'],
        '/images/el-rayo-que-llamaba-antes-de-entrar/13-invitacion-de-sol.webp'),

        (v_story_id, 14,
        'Después, todas las ventanas comenzaron a responder. Una se abrió de golpe; otra levantó apenas su persiana. Algunas dijeron «hoy no» y otras pidieron «un poquito». {nombre_rayo} dejó de medir su bondad por cuartos iluminados. Aprendió a mirar cada señal antes de acercarse.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/14-luz-a-la-medida.webp'),

        (v_story_id, 15,
        'Aquella tarde, {nombre_nino} encontró a {nombre_rayo} descansando sobre la baranda. —Ayudar no es decidir por todos —dijo—. Es preguntar y escuchar lo que cada uno necesita. El rayo contempló las ventanas: ninguna brillaba igual, pero el edificio entero parecía tranquilo.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/15-charla-en-la-baranda.webp'),

        (v_story_id, 16,
        'Desde entonces, {nombre_rayo} tocaba primero cada vidrio con una moneda de luz. Si las cortinas se abrían, entraba. Si permanecían cerradas, buscaba otro lugar donde acompañar. Comprendió que su claridad era más cálida cuando llegaba como una invitación aceptada, no como una obligación.',
        null,
        array[]::text[],
        '/images/el-rayo-que-llamaba-antes-de-entrar/16-rayo-llama-al-vidrio.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/el-rayo-que-llamaba-antes-de-entrar.webp
-- Imágenes:
-- 01-rayo-sobre-el-edificio.webp
-- 02-visita-sin-preguntar.webp
-- 03-ventanas-agradecidas.webp
-- 04-rendija-en-las-cortinas.webp
-- 05-bebe-necesita-sombra.webp
-- 06-musico-dormido.webp
-- 07-helechos-en-penumbra.webp
-- 08-ventanas-diferentes.webp
-- 09-senales-en-los-balcones.webp
-- 10-fachada-de-senales.webp
-- 11-rayo-espera-afuera.webp
-- 12-ayudas-en-la-azotea.webp
-- 13-invitacion-de-sol.webp
-- 14-luz-a-la-medida.webp
-- 15-charla-en-la-baranda.webp
-- 16-rayo-llama-al-vidrio.webp
-- Sonidos nuevos:
-- cortinas-deslizandose.mp3
-- ronquido-suave.mp3
