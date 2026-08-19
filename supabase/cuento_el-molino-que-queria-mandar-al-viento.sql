-- Cuentavoz: El molino que quería mandar al viento
-- Edad: 2-7 años
-- Emoción dominante: serenidad.
-- Enseñanza: adaptarse es cambiar la forma de avanzar sin olvidar el propósito.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_olas uuid;
    v_madera uuid;
    v_aspas uuid;
    v_gaviotas uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-molino-que-queria-mandar-al-viento'
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
            'El molino que quería mandar al viento',
            'el-molino-que-queria-mandar-al-viento',
            '2-7 años',
            'Naturaleza',
            true,
            '/images/portadas/el-molino-que-queria-mandar-al-viento.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='El molino que quería mandar al viento',
        edad_recomendada='2-7 años',
        categoria='Naturaleza',
        es_personalizable=true,
        portada_url='/images/portadas/el-molino-que-queria-mandar-al-viento.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos requeridos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='olas tranquilas') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('olas tranquilas', '/sounds/olas-tranquilas.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='madera cruje') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('madera cruje', '/sounds/madera-cruje.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='aspas de molino') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('aspas de molino', '/sounds/aspas-de-molino.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='gaviotas costeras') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('gaviotas costeras', '/sounds/gaviotas-costeras.mp3', 'ambiente');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_olas from sound_effects where nombre='olas tranquilas' limit 1;
    select id into v_madera from sound_effects where nombre='madera cruje' limit 1;
    select id into v_aspas from sound_effects where nombre='aspas de molino' limit 1;
    select id into v_gaviotas from sound_effects where nombre='gaviotas costeras' limit 1;

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

        (v_story_id, 'nombre_molino', 'texto', array['Brisón', 'Aspavelo', 'Remolino', 'Norte']),
        (v_story_id, 'color_aspas', 'color', array['rojo coral', 'azul marino', 'verde junco', 'amarillo sol']),
        (v_story_id, 'nombre_salina', 'texto', array['Espejomar', 'Salblanca', 'Brisaclara', 'Cielobajo']),
        (v_story_id, 'nombre_nino', 'texto', array['Vera', 'Tomás', 'Lina', 'Gael']);

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
        'Junto al mar estaba {nombre_salina}, una llanura de estanques cuadrados donde el cielo parecía descansar. Allí vivía {nombre_molino}, un molino blanco con aspas de color {color_aspas}. Su trabajo era elevar agua salada por canales estrechos para que el sol dejara pequeños cristales.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/01-molino-junto-a-las-salinas.webp'),

        (v_story_id, 2,
        '{nombre_molino} trabajaba contento cuando la brisa llegaba desde el este, pareja y obediente. Entonces sus aspas giraban a la velocidad exacta. Si el aire venía del norte, del sur o daba vueltas, cerraba sus lonas y esperaba que aprendiera la dirección correcta.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/02-brisa-favorita-del-este.webp'),

        (v_story_id, 3,
        'La salinera decía mientras revisaba los canales: —El viento cambia de camino, pero nosotros podemos cambiar la vela. {nombre_molino} pensaba que aquello servía para barcas pequeñas, no para un edificio tan firme. Un molino respetable debía conseguir que el aire lo obedeciera.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/03-consejo-de-la-salinera.webp'),

        (v_story_id, 4,
        'Una mañana llegó {nombre_nino} para ayudar a llenar los últimos estanques antes de los días calurosos. Las olas respiraban detrás de las dunas y el agua esperaba en el canal bajo. Todo estaba preparado, excepto la brisa, que apareció juguetona desde el oeste.',
        v_olas,
        array['olas'],
        '/images/el-molino-que-queria-mandar-al-viento/04-viento-llega-del-oeste.webp'),

        (v_story_id, 5,
        '—Estás al lado equivocado —le dijo {nombre_molino} al aire. Aseguró su techo giratorio y mantuvo cerradas las lonas. La brisa rodeó la torre, levantó un sombrero cercano y dibujó ondas sobre los estanques, pero no logró mover las aspas inmóviles.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/05-aspas-cerradas.webp'),

        (v_story_id, 6,
        'Pasó la mañana. El sol bebió de los estanques más bajos, mientras los últimos seguían secos. {nombre_nino} giró una pequeña veleta y mostró que podían orientar el techo hacia el oeste. —No fui construido para perseguir vientos caprichosos —respondió el molino.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/06-estanques-sin-agua.webp'),

        (v_story_id, 7,
        'La salinera propuso abrir solo media lona para probar. {nombre_molino} se negó: sus aspas siempre habían trabajado completamente vestidas. Quería el viento conocido, la velocidad conocida y el mismo sonido de cada día. Cambiar una cosa le parecía dejar de ser él.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/07-molino-rechaza-el-cambio.webp'),

        (v_story_id, 8,
        'De pronto llegó una ráfaga más fuerte. Encontró una esquina de lona suelta y tiró de ella. La torre crujió; {nombre_nino} sujetó la cuerda antes de que se desgarrara. {nombre_molino} comprendió que permanecer rígido no había detenido al viento: solo lo había dejado desprevenido.',
        v_madera,
        array['crujió'],
        '/images/el-molino-que-queria-mandar-al-viento/08-rafaga-y-lona-suelta.webp'),

        (v_story_id, 9,
        'Sobre la playa cercana, las gaviotas inclinaban una ala y luego la otra. No ordenaban al aire; ajustaban el cuerpo y continuaban hacia donde querían ir. {nombre_molino} observó también las hierbas largas, capaces de doblarse sin abandonar sus raíces.',
        v_gaviotas,
        array['gaviotas'],
        '/images/el-molino-que-queria-mandar-al-viento/09-gaviotas-sobre-la-playa.webp'),

        (v_story_id, 10,
        '—¿Quieres mandar sobre el viento o llevar agua a los estanques? —preguntó {nombre_nino}. El molino miró los cuadros secos. Su propósito no era girar de una sola manera. Era ayudar al mar a entrar, poco a poco, en aquella llanura de sal.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/10-pregunta-frente-a-los-estanques.webp'),

        (v_story_id, 11,
        '{nombre_molino} soltó el seguro del techo. Con ayuda de {nombre_nino}, giró lentamente hacia el oeste. Abrieron media lona, revisaron cada nudo y dejaron libre una cuerda para recogerla si aumentaba la fuerza. Nada se parecía a su costumbre, pero seguía siendo molino.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/11-techo-gira-al-oeste.webp'),

        (v_story_id, 12,
        'Las aspas dieron una vuelta cautelosa. Después otra. Pronto se oyó clac-clac sobre la torre y la bomba comenzó a subir agua por el canal. {nombre_molino} no giraba con su velocidad favorita, pero cada vuelta llenaba un poco los estanques.',
        v_aspas,
        array['clac-clac'],
        '/images/el-molino-que-queria-mandar-al-viento/12-primer-giro-diferente.webp'),

        (v_story_id, 13,
        'Durante la tarde, el viento cambió dos veces. Al principio {nombre_molino} protestó. Luego recogió una lona, orientó su techo y volvió a extenderla cuando el aire se calmó. Cada ajuste era pequeño. Ninguno borraba su torre, sus vigas ni su tarea.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/13-ajustes-durante-la-tarde.webp'),

        (v_story_id, 14,
        'Al ponerse el sol, el agua alcanzó el último estanque. Los cuadros reflejaron pedazos distintos del cielo: naranja, violeta, azul y una nube blanca. Vistos desde las aspas altas, parecían una manta cosida con todos los vientos de aquel día.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/14-cielo-cosido-en-sal.webp'),

        (v_story_id, 15,
        'La salinera apoyó una mano sobre la torre. —Adaptarte no significa que el viento decida quién eres —dijo—. Significa cambiar la forma de avanzar sin olvidar para qué avanzas. {nombre_molino} miró el agua nueva y supo que seguía cumpliendo su propósito.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/15-leccion-al-atardecer.webp'),

        (v_story_id, 16,
        'Desde entonces, {nombre_molino} continuó prefiriendo la brisa del este, pero dejó de exigirla. Aprendió a abrir, recoger, girar y esperar cuando era necesario. Comprendió que ser firme no era quedarse inmóvil: era conservar su propósito mientras encontraba nuevas maneras de alcanzarlo.',
        null,
        array[]::text[],
        '/images/el-molino-que-queria-mandar-al-viento/16-molino-bajo-vientos-distintos.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/el-molino-que-queria-mandar-al-viento.webp
-- Imágenes:
-- 01-molino-junto-a-las-salinas.webp
-- 02-brisa-favorita-del-este.webp
-- 03-consejo-de-la-salinera.webp
-- 04-viento-llega-del-oeste.webp
-- 05-aspas-cerradas.webp
-- 06-estanques-sin-agua.webp
-- 07-molino-rechaza-el-cambio.webp
-- 08-rafaga-y-lona-suelta.webp
-- 09-gaviotas-sobre-la-playa.webp
-- 10-pregunta-frente-a-los-estanques.webp
-- 11-techo-gira-al-oeste.webp
-- 12-primer-giro-diferente.webp
-- 13-ajustes-durante-la-tarde.webp
-- 14-cielo-cosido-en-sal.webp
-- 15-leccion-al-atardecer.webp
-- 16-molino-bajo-vientos-distintos.webp
-- Sonidos requeridos:
-- olas-tranquilas.mp3
-- madera-cruje.mp3
-- aspas-de-molino.mp3
-- gaviotas-costeras.mp3
