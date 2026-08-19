-- Cuentavoz: La escalera que quería tocar el cielo
-- Edad: 2-7 años
-- Emoción dominante: admiración esperanzada.
-- Enseñanza: una meta alta se alcanza cuidando cada paso que la sostiene.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_madera uuid;
    v_lluvia_techo uuid;
    v_gorriones uuid;
    v_regadera uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-escalera-que-queria-tocar-el-cielo'
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
            'La escalera que quería tocar el cielo',
            'la-escalera-que-queria-tocar-el-cielo',
            '2-7 años',
            'Emociones',
            true,
            '/images/portadas/la-escalera-que-queria-tocar-el-cielo.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='La escalera que quería tocar el cielo',
        edad_recomendada='2-7 años',
        categoria='Emociones',
        es_personalizable=true,
        portada_url='/images/portadas/la-escalera-que-queria-tocar-el-cielo.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='madera cruje') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('madera cruje', '/sounds/madera-cruje.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='lluvia sobre techo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('lluvia sobre techo', '/sounds/lluvia-sobre-techo.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='gorriones urbanos') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('gorriones urbanos', '/sounds/gorriones-urbanos.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='agua de regadera') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('agua de regadera', '/sounds/agua-de-regadera.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_madera from sound_effects where nombre='madera cruje' limit 1;
    select id into v_lluvia_techo from sound_effects where nombre='lluvia sobre techo' limit 1;
    select id into v_gorriones from sound_effects where nombre='gorriones urbanos' limit 1;
    select id into v_regadera from sound_effects where nombre='agua de regadera' limit 1;

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

        (v_story_id, 'nombre_escalera', 'texto', array['Peldaña', 'Madera', 'Altura', 'Travesaño']),
        (v_story_id, 'nombre_nino', 'texto', array['Elena', 'Martín', 'Sofía', 'Nicolás']),
        (v_story_id, 'color_escalera', 'color', array['azul', 'verde', 'amarillo', 'rojo', 'morado']),
        (v_story_id, 'nombre_barrio', 'texto', array['Barrio de las Terrazas', 'Barrio Colibrí', 'Barrio del Sol', 'Barrio de los Jazmines']),
        (v_story_id, 'planta_terraza', 'texto', array['tomates', 'lavanda', 'albahaca', 'fresas', 'girasoles']);

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
        'En {nombre_barrio}, las casas subían por la colina como cajas de colores. Sobre sus techos crecían jardines, ropa tendida, antenas delgadas y pequeños depósitos de agua. Allí trabajaba {nombre_escalera}, una escalera de madera pintada de {color_escalera}, siempre apoyada entre macetas de {planta_terraza}.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/01-escalera-entre-terrazas.webp'),

        (v_story_id, 2,
        'A {nombre_escalera} le encantaba ayudar a subir regaderas y cosechas. Sin embargo, mientras todos miraban las plantas, ella miraba la torre situada en la cima del barrio. —Algún día llegaré tan alto que tocaré el cielo —decía—. Entonces cada uno de mis peldaños será importante.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/02-torre-sobre-la-colina.webp'),

        (v_story_id, 3,
        '—Tus peldaños ya importan —respondía {nombre_nino}, quien cuidaba la terraza vecina. Pero la escalera solo contaba el último. Imaginaba nubes descansando sobre su punta y estrellas enganchadas en sus bordes. Los primeros escalones le parecían demasiado cercanos al suelo para merecer atención.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/03-sueno-de-nubes.webp'),

        (v_story_id, 4,
        'Una mañana anunciaron que al atardecer pasaría sobre la torre una nube con forma de ballena. Los vecinos subirían a las terrazas para verla. {nombre_escalera} decidió alcanzar el techo más alto. Si llegaba allí, pensó, nadie volvería a fijarse en sus peldaños inferiores.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/04-anuncio-de-la-nube.webp'),

        (v_story_id, 5,
        'Comenzaron a llevarla cuesta arriba. En el primer techo, una jardinera pidió ayuda para alcanzar una rama cargada de limones. —Después —contestó la escalera—. Tengo una cima esperándome. En el segundo, unos gorriones necesitaban recuperar su cesta caída. Ella continuó sin detenerse.',
        v_gorriones,
        array['gorriones'],
        '/images/la-escalera-que-queria-tocar-el-cielo/05-ascenso-sin-detenerse.webp'),

        (v_story_id, 6,
        'Cuanto más subía, más inclinadas eran las calles. {nombre_escalera} pidió que avanzaran deprisa. Una pata golpeó un adoquín y su tercer peldaño crujió. —Conviene revisarlo —dijo {nombre_nino}. —Está muy abajo —respondió ella—. Lo importante es que mi punta siga acercándose al cielo.',
        v_madera,
        array['crujió'],
        '/images/la-escalera-que-queria-tocar-el-cielo/06-peldano-agrietado.webp'),

        (v_story_id, 7,
        'Llegaron a la terraza anterior a la torre. El muro era alto y liso. {nombre_escalera} se apoyó, estiró los largueros y ordenó sus peldaños hacia arriba. {nombre_nino} puso un pie en el primero. La madera tembló. En el tercero, la grieta se abrió un poco más.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/07-frente-al-muro-alto.webp'),

        (v_story_id, 8,
        '—Baja, por favor —pidió la escalera. Por primera vez no miró su punta, sino aquello que la sostenía. El peldaño olvidado soportaba el peso de todos los demás. Sin él, ningún paso podía llegar al último. La nube ballena empezaba a aparecer detrás de la colina.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/08-escalera-mira-hacia-abajo.webp'),

        (v_story_id, 9,
        '{nombre_escalera} pudo intentar el ascenso de todos modos. En cambio, pidió regresar a la terraza amplia. Allí se acostó sobre dos bancos para que revisaran la grieta. No alcanzaría la torre aquella tarde. La decisión dolió, aunque también hizo que dejara de temblar.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/09-reparacion-en-la-terraza.webp'),

        (v_story_id, 10,
        'Los vecinos trajeron cuerda, cola y una pieza de madera. Mientras trabajaban, comenzó una lluvia breve sobre los tejados. Colocaron bajo cada peldaño un cuenco para recogerla. {nombre_escalera} permaneció quieta, sintiendo cómo atendían uno por uno los lugares que ella había despreciado.',
        v_lluvia_techo,
        array['lluvia'],
        '/images/la-escalera-que-queria-tocar-el-cielo/10-lluvia-durante-la-reparacion.webp'),

        (v_story_id, 11,
        'La lluvia terminó justo cuando el sol descendía. En cada cuenco quedó un espejo pequeño. Uno reflejaba una nube; otro, una chimenea; otro, un gorrión. Desde el primer peldaño hasta el último, los reflejos reunían un cielo completo, partido en dieciséis ventanas de agua.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/11-cielo-en-los-peldanos.webp'),

        (v_story_id, 12,
        'Entonces apareció la nube ballena. No nadó sobre la torre, como todos esperaban, sino sobre la terraza donde descansaba {nombre_escalera}. Su enorme figura pasó por cada cuenco: primero la cola, luego el lomo y finalmente una cabeza blanca que parecía sonreír desde el peldaño reparado.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/12-ballena-en-los-reflejos.webp'),

        (v_story_id, 13,
        'Los vecinos se sentaron alrededor para mirar. {nombre_nino} chorreó agua de una regadera sobre las plantas y dijo: —Una altura grande se construye cuidando cada paso pequeño. {nombre_escalera} observó su reflejo completo. Ningún peldaño mostraba todo el cielo, pero ninguno sobraba.',
        v_regadera,
        array['chorreó'],
        '/images/la-escalera-que-queria-tocar-el-cielo/13-leccion-entre-macetas.webp'),

        (v_story_id, 14,
        'Al día siguiente regresaron por la misma cuesta. Esta vez {nombre_escalera} se detuvo en el primer techo para recoger los limones. En el segundo ayudó a colocar la cesta de los gorriones. Cada tarea parecía baja, pero dejaba el barrio un poco más preparado para subir.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/14-paradas-en-el-camino.webp'),

        (v_story_id, 15,
        'Semanas después alcanzaron la terraza de la torre. El peldaño reparado sostuvo el primer paso, y los demás continuaron el trabajo. Desde arriba, {nombre_escalera} vio todos los jardines que había ayudado a cuidar. Descubrió que la cima era hermosa porque el camino seguía visible debajo.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/15-llegada-a-la-torre.webp'),

        (v_story_id, 16,
        'Desde entonces, {nombre_escalera} conservó su deseo de acercarse al cielo. Ya no apresuraba a nadie ni contaba solamente el último peldaño. Comprendió que alcanzar algo alto no vuelve pequeños los pasos anteriores: cada uno sostiene el siguiente y merece llegar firme, cuidado y acompañado.',
        null,
        array[]::text[],
        '/images/la-escalera-que-queria-tocar-el-cielo/16-escalera-bajo-el-cielo.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/la-escalera-que-queria-tocar-el-cielo.webp
-- Imágenes:
-- 01-escalera-entre-terrazas.webp
-- 02-torre-sobre-la-colina.webp
-- 03-sueno-de-nubes.webp
-- 04-anuncio-de-la-nube.webp
-- 05-ascenso-sin-detenerse.webp
-- 06-peldano-agrietado.webp
-- 07-frente-al-muro-alto.webp
-- 08-escalera-mira-hacia-abajo.webp
-- 09-reparacion-en-la-terraza.webp
-- 10-lluvia-durante-la-reparacion.webp
-- 11-cielo-en-los-peldanos.webp
-- 12-ballena-en-los-reflejos.webp
-- 13-leccion-entre-macetas.webp
-- 14-paradas-en-el-camino.webp
-- 15-llegada-a-la-torre.webp
-- 16-escalera-bajo-el-cielo.webp
-- Sonidos nuevos:
-- gorriones-urbanos.mp3
-- agua-de-regadera.mp3
