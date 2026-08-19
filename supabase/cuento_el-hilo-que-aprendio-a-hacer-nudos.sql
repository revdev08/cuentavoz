-- Cuentavoz: El hilo que aprendió a hacer nudos
-- Edad: 2-7 años
-- Emoción dominante: pertenencia.
-- Enseñanza: un lazo no siempre atrapa; a veces une lo que quiere permanecer junto.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_tijeras uuid;
    v_tela uuid;
    v_olas uuid;
    v_crujido uuid;
    v_campanita uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-hilo-que-aprendio-a-hacer-nudos'
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
            'El hilo que aprendió a hacer nudos',
            'el-hilo-que-aprendio-a-hacer-nudos',
            '2-7 años',
            'Emociones',
            true,
            '/images/portadas/el-hilo-que-aprendio-a-hacer-nudos.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='El hilo que aprendió a hacer nudos',
        edad_recomendada='2-7 años',
        categoria='Emociones',
        es_personalizable=true,
        portada_url='/images/portadas/el-hilo-que-aprendio-a-hacer-nudos.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='tijeras de costura') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('tijeras de costura', '/sounds/tijeras-de-costura.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='tela al viento') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('tela al viento', '/sounds/tela-al-viento.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='olas tranquilas') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('olas tranquilas', '/sounds/olas-tranquilas.mp3', 'ambiente');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_tijeras from sound_effects where nombre='tijeras de costura' limit 1;
    select id into v_tela from sound_effects where nombre='tela al viento' limit 1;
    select id into v_olas from sound_effects where nombre='olas tranquilas' limit 1;
    select id into v_crujido from sound_effects where nombre='crujido' limit 1;
    select id into v_campanita from sound_effects where nombre='campanita magica' limit 1;

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

        (v_story_id, 'nombre_hilo', 'texto', array['Hilván', 'Lino', 'Tris', 'Hebra']),
        (v_story_id, 'color_hilo', 'color', array['azul', 'rojo', 'verde', 'dorado', 'morado']),
        (v_story_id, 'nombre_taller', 'texto', array['Casa de las Velas', 'Puntada del Mar', 'El Dedal Azul', 'Telas del Puerto']),
        (v_story_id, 'nombre_nino', 'texto', array['Emma', 'Tomás', 'Sara', 'Nicolás']);

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
        'En el puerto de las casas blancas había un taller llamado {nombre_taller}. Allí vivía {nombre_hilo}, un carrete de hilo {color_hilo}, liso y orgulloso. Mientras otros hilos se doblaban entre agujas, él cuidaba que ni una vuelta arrugara su perfecta figura.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/01-carrete-junto-al-mar.webp'),

        (v_story_id, 2,
        'La costurera del puerto decía que un hilo valía por aquello que podía sostener. {nombre_hilo} no estaba de acuerdo. —Los nudos aprietan, abultan y dejan marcas —murmuraba desde su estante—. Yo prefiero seguir entero, sin deberle una curva a nadie.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/02-hilos-con-nudos.webp'),

        (v_story_id, 3,
        'Una mañana llegó {nombre_nino} cargando retazos de muchas familias. Con ellos harían un toldo para la Fiesta de las Historias. Las tijeras cantaron chac, chac sobre la mesa. Cada pedazo guardaba algo: un delantal, una cortina, una camisa ya pequeña.',
        v_tijeras,
        array['tijeras'],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/03-retazos-sobre-mesa.webp'),

        (v_story_id, 4,
        '—Necesitamos un hilo resistente —dijo {nombre_nino}. Todos miraron a {nombre_hilo}. Su color combinaba con el cielo y alcanzaba para cruzar el toldo entero. Él aceptó pasar por la aguja, pero puso una condición: ni un solo nudo al principio ni al final.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/04-hilo-elegido.webp'),

        (v_story_id, 5,
        'Durante horas, {nombre_nino} cosió cuadrados amarillos, verdes y encarnados. Sin nudos, cada puntada parecía limpia. Sin embargo, cuando levantaron la tela, el extremo de {nombre_hilo} escapó por el primer agujero. Detrás de él se deshicieron diez puntadas, luego veinte, luego todas.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/05-puntadas-que-escapan.webp'),

        (v_story_id, 6,
        '—Podemos intentarlo otra vez —propuso {nombre_nino}—, pero tendrás que sujetarte. {nombre_hilo} se estiró cuanto pudo. —Sujetar no requiere nudos. Esta vez quedaré muy quieto. La costurera no discutió; dejó que el hilo comprobara por sí mismo cuánto puede durar una promesa sin lazo.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/06-segundo-intento.webp'),

        (v_story_id, 7,
        'Al mediodía llevaron el toldo a la plaza. Las olas respiraban detrás de los puestos y el cielo olía a sal. Durante un instante, la gran tela quedó suspendida sobre las sillas. {nombre_hilo} se sintió largo, recto y más elegante que nunca.',
        v_olas,
        array['olas'],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/07-toldo-sobre-plaza.webp'),

        (v_story_id, 8,
        'Entonces una brisa entró desde el muelle. El toldo aleteó una vez, dos veces, y tiró de cada costura. {nombre_hilo} quiso agarrarse sin doblarse, pero comenzó a deslizarse. Un retazo azul se soltó y cayó sobre un canasto de panecillos.',
        v_tela,
        array['aleteó'],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/08-viento-suelta-retazo.webp'),

        (v_story_id, 9,
        'Después cayó el bolsillo de un abuelo, la manga de una panadera y un trocito de falda con margaritas. Las familias corrieron a recogerlos. Nadie se enfadó con {nombre_hilo}; eso le dolió más. Había permanecido liso, sí, pero no había sostenido nada.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/09-retazos-en-la-plaza.webp'),

        (v_story_id, 10,
        'La tarde avanzaba y los narradores llegarían pronto. {nombre_nino} extendió los retazos sobre el suelo, sin esconder los agujeros. —Un nudo no siempre atrapa —dijo con suavidad—. A veces une dos cosas que quieren permanecer juntas. Luego dejó la aguja al lado del carrete.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/10-aguja-junto-carrete.webp'),

        (v_story_id, 11,
        '{nombre_hilo} miró las telas separadas. Cada una conservaba el calor de una casa distinta. Comprendió que seguir impecable sobre un estante era otra forma de no pertenecer a ninguna parte. —Haz el primero pequeño —pidió—. Quiero saber cómo se siente sostener de verdad.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/11-primer-nudo.webp'),

        (v_story_id, 12,
        '{nombre_nino} hizo un nudo diminuto. No dolió. {nombre_hilo} sintió que una punta dejaba de escapar. Después vino otro nudo, y otro. Las familias acercaron sus retazos y ayudaron a coser. La mesa crujió bajo tantos codos, dedales y manos trabajando juntas.',
        v_crujido,
        array['crujió'],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/12-familias-cosiendo.webp'),

        (v_story_id, 13,
        'Cuando alzaron nuevamente el toldo, el sol atravesó los pequeños espacios de las costuras. Sobre el suelo apareció una constelación de colores: peces, casas, flores y lunas hechas de luz. Cada nudo era apenas un punto oscuro dentro de aquel cielo compartido.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/13-constelacion-de-retazos.webp'),

        (v_story_id, 14,
        'La campanita anunció el comienzo de la fiesta. Bajo el toldo, los adultos contaron historias y los niños inventaron finales. La brisa volvió desde el mar. Esta vez la tela danzó sin desarmarse, y {nombre_hilo} descubrió que podía moverse sin dejar de estar unido.',
        v_campanita,
        array['campanita'],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/14-fiesta-bajo-toldo.webp'),

        (v_story_id, 15,
        'La costurera pasó un dedo sobre la última puntada. —Lo que nos une no tiene que borrarnos —dijo—. Mira: cada retazo conserva su dibujo y tú sigues siendo {color_hilo}. {nombre_hilo} contempló sus curvas nuevas. No eran heridas. Eran lugares donde había decidido quedarse.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/15-ultima-puntada.webp'),

        (v_story_id, 16,
        'Desde aquel día, el toldo regresó a la plaza cada vez que alguien tenía una historia para compartir. {nombre_hilo} nunca volvió a temer sus nudos. Había aprendido que un lazo no siempre encierra: a veces permite sostener, bailar con el viento y pertenecer sin dejar de ser uno mismo.',
        null,
        array[]::text[],
        '/images/el-hilo-que-aprendio-a-hacer-nudos/16-toldo-de-historias.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/el-hilo-que-aprendio-a-hacer-nudos.webp
-- Imágenes:
-- 01-carrete-junto-al-mar.webp
-- 02-hilos-con-nudos.webp
-- 03-retazos-sobre-mesa.webp
-- 04-hilo-elegido.webp
-- 05-puntadas-que-escapan.webp
-- 06-segundo-intento.webp
-- 07-toldo-sobre-plaza.webp
-- 08-viento-suelta-retazo.webp
-- 09-retazos-en-la-plaza.webp
-- 10-aguja-junto-carrete.webp
-- 11-primer-nudo.webp
-- 12-familias-cosiendo.webp
-- 13-constelacion-de-retazos.webp
-- 14-fiesta-bajo-toldo.webp
-- 15-ultima-puntada.webp
-- 16-toldo-de-historias.webp
-- Sonidos nuevos:
-- tijeras-de-costura.mp3
-- tela-al-viento.mp3
-- olas-tranquilas.mp3
