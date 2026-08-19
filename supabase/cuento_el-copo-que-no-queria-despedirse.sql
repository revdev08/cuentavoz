-- Cuentavoz: El copo que no quería despedirse
-- Edad: 2-7 años
-- Emoción dominante: nostalgia serena que se transforma en esperanza.
-- Enseñanza: algo no necesita durar para siempre para dejar cuidado y belleza.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_viento uuid;
    v_nieve uuid;
    v_gotas uuid;
    v_arroyo uuid;
    v_pajaros uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-copo-que-no-queria-despedirse'
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
            'El copo que no quería despedirse',
            'el-copo-que-no-queria-despedirse',
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

    if not exists (
        select 1
        from sound_effects
        where nombre='nieve crujiendo'
    ) then

        insert into sound_effects
        (
            nombre,
            archivo_url,
            categoria
        )

        values
        (
            'nieve crujiendo',
            '/sounds/nieve-crujiendo.mp3',
            'efecto'
        );

    end if;

    if not exists (
        select 1
        from sound_effects
        where nombre='gotas sobre cristal'
    ) then

        insert into sound_effects
        (
            nombre,
            archivo_url,
            categoria
        )

        values
        (
            'gotas sobre cristal',
            '/sounds/gotas-sobre-cristal.mp3',
            'ambiente'
        );

    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_viento from sound_effects where nombre='viento entre arboles' limit 1;
    select id into v_nieve from sound_effects where nombre='nieve crujiendo' limit 1;
    select id into v_gotas from sound_effects where nombre='gotas sobre cristal' limit 1;
    select id into v_arroyo from sound_effects where nombre='arroyo' limit 1;
    select id into v_pajaros from sound_effects where nombre='pajaros del bosque' limit 1;

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

        (v_story_id, 'nombre_copo', 'texto', array['Nilo', 'Brinco', 'Copito', 'Luma']),
        (v_story_id, 'nombre_nino', 'texto', array['Sofía', 'Mateo', 'Luna', 'Samuel']),
        (v_story_id, 'color_bufanda', 'color', array['rojo', 'azul', 'verde', 'morado', 'dorado']),
        (v_story_id, 'nombre_invernadero', 'texto', array['Casa de Vidrio', 'Jardín del Tejado', 'Invernadero Aurora', 'Huerto de las Alturas']);

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
        'En lo alto de una montaña vivía {nombre_copo}, un copo de nieve con seis puntas desiguales. Le gustaba descansar sobre los pinos y mirar el pueblo. Pero aquel invierno había oído algo inquietante: pronto llegaría la primavera, y la nieve tendría que marcharse.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/01-copo-sobre-pino.webp'),

        (v_story_id, 2,
        '—Yo no pienso irme —decidió {nombre_copo}. El viento pasó entre los árboles y levantó remolinos blancos alrededor de sus puntas. Los demás copos bailaron cuesta abajo. Él, en cambio, se escondió bajo una rama, convencido de que quedarse para siempre era la única manera de importar.',
        v_viento,
        array['viento'],
        '/images/el-copo-que-no-queria-despedirse/02-copo-bajo-rama.webp'),

        (v_story_id, 3,
        'Al amanecer, una gota cayó desde la rama. Después cayó otra. {nombre_copo} buscó un rincón más frío y vio, sobre el tejado del pueblo, un invernadero cubierto de escarcha. En la puerta se leía {nombre_invernadero}. Sus cristales parecían guardar un pedacito del invierno.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/03-invernadero-en-tejado.webp'),

        (v_story_id, 4,
        'Entonces apareció {nombre_nino}, con una bufanda de color {color_bufanda} y unas botas enormes. La nieve crujió bajo cada paso. Al descubrir a {nombre_copo} temblando en la rama, acercó una manopla y susurró: —Ven. Quizá dentro del invernadero podamos salvarte del sol.',
        v_nieve,
        array['crujió'],
        '/images/el-copo-que-no-queria-despedirse/04-encuentro-en-la-nieve.webp'),

        (v_story_id, 5,
        '{nombre_copo} aterrizó sobre la manopla. Juntos entraron en {nombre_invernadero}, donde dormían macetas vacías y semillas bajo la tierra. {nombre_nino} colocó el copo en un platito azul, detrás de una regadera. Allí no llegaba el sol. Por un momento, ambos creyeron haber vencido a la primavera.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/05-copo-en-platito-azul.webp'),

        (v_story_id, 6,
        'Pasaron las horas. Afuera, los tejados dejaron ver sus tejas. Adentro, el aire se volvió tibio y olía a tierra. {nombre_copo} encogió una de sus puntas. —No mires —pidió. {nombre_nino} cubrió el platito con su bufanda, aunque sabía que una tela no podía detener una estación.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/06-bufanda-sobre-platito.webp'),

        (v_story_id, 7,
        'Sobre el techo, la nieve derretida formó gotas que golpeaban el cristal: tip, tap, tip. {nombre_copo} escuchó aquel ritmo desde debajo de la bufanda. Cada sonido era una despedida pequeña. Quiso taparse también los oídos, pero los copos no tienen manos para hacer ciertas cosas.',
        v_gotas,
        array['gotas'],
        '/images/el-copo-que-no-queria-despedirse/07-gotas-en-el-cristal.webp'),

        (v_story_id, 8,
        'Al retirar la tela, {nombre_nino} encontró el platito húmedo. Cinco puntas seguían enteras; la sexta se había vuelto agua. {nombre_copo} apretó cuanto pudo sus bordes. —Si cambio, nadie recordará mi forma —dijo. Cerca de ellos, una maceta mostraba la tierra seca y agrietada.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/08-primera-punta-derretida.webp'),

        (v_story_id, 9,
        '{nombre_nino} quiso llevarlo al congelador de la cocina. Ya estaba tomando el platito cuando {nombre_copo} vio una semilla diminuta asomada entre las grietas de la maceta. Su tallo pálido estaba doblado. Podía esconderse del calor unas horas más, o acercarse a aquella tierra sedienta.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/09-semilla-en-tierra-seca.webp'),

        (v_story_id, 10,
        '—Ponme junto a la semilla —pidió al fin. {nombre_nino} lo miró sin moverse. —Allí te derretirás. {nombre_copo} observó su reflejo, cada vez más pequeño, en el platito azul. Luego respiró como respiran los copos: dejando que el aire atraviese sus seis puntas.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/10-decision-junto-semilla.webp'),

        (v_story_id, 11,
        '{nombre_nino} inclinó el platito sobre la maceta. {nombre_copo} resbaló hasta la tierra y sintió cómo sus puntas se volvían redondas. No ocurrió de golpe. Primero dejó de pesar. Después dejó de tener bordes. Por último, se convirtió en una gota clara junto a la semilla.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/11-copo-se-vuelve-gota.webp'),

        (v_story_id, 12,
        'La gota bajó entre granitos de tierra, encontró una raíz delgada y siguió su camino. Bajo el invernadero corría un arroyo pequeño, alimentado por toda la nieve de la montaña. {nombre_copo} comprendió entonces que ninguno de los copos se había perdido: viajaban juntos, aunque ya no tuvieran puntas.',
        v_arroyo,
        array['arroyo'],
        '/images/el-copo-que-no-queria-despedirse/12-viaje-bajo-la-tierra.webp'),

        (v_story_id, 13,
        'A la mañana siguiente, {nombre_nino} regresó a {nombre_invernadero}. En la maceta había nacido un brote curvado, verde y pequeño. En su primera hoja descansaba una gotita. Por un instante tuvo seis reflejos, como seis puntas desiguales saludando desde una forma completamente nueva.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/13-brote-con-seis-reflejos.webp'),

        (v_story_id, 14,
        '—Ya entiendo —dijo {nombre_nino}, tocando la tierra con cuidado—. Quedarse no siempre significa seguir igual. A veces significa ayudar a que algo continúe. La gotita tembló sobre la hoja. Si {nombre_copo} todavía podía sonreír, seguramente lo hizo en aquel momento.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/14-nino-descubre-el-brote.webp'),

        (v_story_id, 15,
        'Durante la primavera, {nombre_nino} cuidó la maceta cada tarde. El brote se volvió una flor blanca con seis pétalos desiguales. Nadie la llamó recuerdo ni premio. Era simplemente una flor, pero al verla, {nombre_nino} pensaba en aquella decisión valiente tomada sobre un platito azul.',
        null,
        array[]::text[],
        '/images/el-copo-que-no-queria-despedirse/15-flor-de-seis-petalos.webp'),

        (v_story_id, 16,
        'Cuando los pájaros cantaron sobre el tejado, una gota de rocío bajó por el pétalo y regó otra semilla. {nombre_copo} ya no temía despedirse. Había aprendido que no hacía falta durar para siempre: bastaba con cuidar algo durante el tiempo que tuviera y dejarlo listo para continuar.',
        v_pajaros,
        array['pájaros'],
        '/images/el-copo-que-no-queria-despedirse/16-flor-bajo-el-amanecer.webp');

end $$;

-- Assets
-- Imágenes:
-- 01-copo-sobre-pino.webp
-- 02-copo-bajo-rama.webp
-- 03-invernadero-en-tejado.webp
-- 04-encuentro-en-la-nieve.webp
-- 05-copo-en-platito-azul.webp
-- 06-bufanda-sobre-platito.webp
-- 07-gotas-en-el-cristal.webp
-- 08-primera-punta-derretida.webp
-- 09-semilla-en-tierra-seca.webp
-- 10-decision-junto-semilla.webp
-- 11-copo-se-vuelve-gota.webp
-- 12-viaje-bajo-la-tierra.webp
-- 13-brote-con-seis-reflejos.webp
-- 14-nino-descubre-el-brote.webp
-- 15-flor-de-seis-petalos.webp
-- 16-flor-bajo-el-amanecer.webp
-- Sonidos nuevos:
-- nieve-crujiendo.mp3
-- gotas-sobre-cristal.mp3
