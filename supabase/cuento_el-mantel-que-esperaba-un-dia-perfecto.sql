-- Cuentavoz: El mantel que esperaba un día perfecto
-- Edad: 2-7 años
-- Emoción dominante: calidez.
-- Enseñanza: un momento no necesita ser perfecto para merecer que lo vivamos juntos.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_crujido uuid;
    v_vajilla uuid;
    v_ronroneo uuid;
    v_risas uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-mantel-que-esperaba-un-dia-perfecto'
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
            'El mantel que esperaba un día perfecto',
            'el-mantel-que-esperaba-un-dia-perfecto',
            '2-7 años',
            'Familia',
            true,
            '/images/portadas/el-mantel-que-esperaba-un-dia-perfecto.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='El mantel que esperaba un día perfecto',
        edad_recomendada='2-7 años',
        categoria='Familia',
        es_personalizable=true,
        portada_url='/images/portadas/el-mantel-que-esperaba-un-dia-perfecto.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos requeridos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='crujido') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('crujido', '/sounds/crujido.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='vajilla tintineando') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('vajilla tintineando', '/sounds/vajilla-tintineando.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='ronroneo de gato') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('ronroneo de gato', '/sounds/ronroneo-de-gato.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='risas familiares') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('risas familiares', '/sounds/risas-familiares.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_crujido from sound_effects where nombre='crujido' limit 1;
    select id into v_vajilla from sound_effects where nombre='vajilla tintineando' limit 1;
    select id into v_ronroneo from sound_effects where nombre='ronroneo de gato' limit 1;
    select id into v_risas from sound_effects where nombre='risas familiares' limit 1;

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

        (v_story_id, 'nombre_mantel', 'texto', array['Lino', 'Domingo', 'Puntada', 'Mantelín']),
        (v_story_id, 'color_mantel', 'color', array['azul cielo', 'rojo cereza', 'verde menta', 'amarillo miel']),
        (v_story_id, 'nombre_nino', 'texto', array['Alma', 'Simón', 'Lucía', 'Teo']),
        (v_story_id, 'comida_favorita', 'texto', array['arepas', 'panqueques', 'empanadas', 'galletas']);

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
        'En el cajón más alto de una casa con patio vivía {nombre_mantel}, un mantel de color {color_mantel} bordado con hojas pequeñas. Olía a madera y a jabón. La familia lo extendía solamente en cumpleaños, visitas importantes y cenas que habían sido planeadas durante semanas.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/01-mantel-en-el-cajon.webp'),

        (v_story_id, 2,
        '{nombre_mantel} estaba orgulloso de no tener manchas, dobleces torcidos ni hilos sueltos. Mientras los manteles cotidianos conocían desayunos apurados y vasos tambaleantes, él esperaba el día perfecto: una mesa silenciosa, platos impecables y ninguna miga capaz de caer sobre sus bordados.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/02-mantel-imagina-perfeccion.webp'),

        (v_story_id, 3,
        'Desde el cajón escuchaba a {nombre_nino} contar historias durante la comida. A veces alguien se equivocaba de palabra; otras veces la abuela servía una arepa con forma extraña. —Los mejores momentos no siempre llegan bien peinados —decía ella. {nombre_mantel} prefería seguir cuidadosamente doblado.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/03-historias-desde-el-cajon.webp'),

        (v_story_id, 4,
        'Una tarde de martes se apagó la electricidad. La cocina quedó quieta, el ventilador dejó de girar y la familia llevó velas al patio. No había celebración ni invitados. Solo quedaban {comida_favorita}, frutas, queso y una jarra de jugo todavía fresco.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/04-casa-sin-electricidad.webp'),

        (v_story_id, 5,
        '—Comamos bajo las estrellas —propuso {nombre_nino}. Buscaron una tela para cubrir la mesa del patio, pero las demás estaban lavándose. El cajón alto se abrió con un crujido. {nombre_mantel} vio manos pequeñas acercándose y apretó todos sus dobleces, esperando que escogieran otra cosa.',
        v_crujido,
        array['crujido'],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/05-cajon-abierto.webp'),

        (v_story_id, 6,
        '—Hoy no es especial —protestó el mantel—. Hay platos distintos y nadie preparó flores. {nombre_nino} miró el patio oscuro. —Tal vez todavía no sabemos qué clase de día es —respondió. No prometió evitar migas ni accidentes. Solamente esperó, sosteniendo una esquina con cuidado.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/06-invitacion-al-patio.webp'),

        (v_story_id, 7,
        '{nombre_mantel} podía quedarse limpio dentro del cajón. En cambio, aflojó los dobleces. La familia lo extendió sobre una mesa un poco pequeña, así que dos puntas quedaron desiguales. Encima pusieron platos de varios colores, que tintinearon mientras todos buscaban un lugar.',
        v_vajilla,
        array['tintinearon'],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/07-mesa-desigual.webp'),

        (v_story_id, 8,
        'Al principio, {nombre_mantel} vigiló cada tenedor. Una miga aterrizó cerca de una hoja bordada. Luego cayó otra. El gato saltó a una silla y ronroneó contra el borde. Nadie parecía preocupado. Hablaban de sombras en la pared y repartían {comida_favorita} sin contar los pedazos.',
        v_ronroneo,
        array['ronroneó'],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/08-gato-y-migas.webp'),

        (v_story_id, 9,
        'Cuando la abuela levantó la jarra, el gato movió la cola. Un poco de jugo rojo cayó en el centro del mantel. Todos se quedaron quietos. {nombre_mantel} sintió que su día perfecto se alejaba para siempre, dejando una mancha redonda donde antes todo era impecable.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/09-mancha-de-jugo.webp'),

        (v_story_id, 10,
        '{nombre_nino} trajo un paño húmedo y secó el jugo sin frotar. La marca se volvió rosada, parecida a una isla. Una miga grande quedó al norte; tres semillas formaron un camino. —Miren —dijo la abuela—, nuestra cena acaba de dibujar un mapa.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/10-mapa-sobre-la-tela.webp'),

        (v_story_id, 11,
        'Cada persona añadió un recuerdo al mapa. La isla era el lugar donde el gato había estornudado. Las semillas señalaban el viaje de la jarra. Las migas marcaban pueblos con nombres inventados. Pronto llegaron risas tan grandes que las velas parecieron inclinarse para escucharlas.',
        v_risas,
        array['risas'],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/11-mapa-de-recuerdos.webp'),

        (v_story_id, 12,
        '{nombre_mantel} observó sus bordados. Seguían allí. La mancha no había borrado las hojas ni roto sus puntadas. Ahora, además, guardaba el martes en que la casa se quedó oscura y la familia encontró una isla sobre la mesa. Ya no parecía menos valioso.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/12-mantel-mira-sus-marcas.webp'),

        (v_story_id, 13,
        'La electricidad regresó antes del postre. Las lámparas iluminaron platos distintos, puntas desiguales y la marca rosada. Nadie corrió a guardar el mantel. Apagaron otra vez una lámpara para conservar la luz de las velas y terminaron la cena sin apresurarla.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/13-regresa-la-luz.webp'),

        (v_story_id, 14,
        'Mientras recogían, la abuela dobló a {nombre_mantel} con suavidad. —Un momento no necesita ser perfecto para merecer que lo vivamos —dijo—. Las cosas cuidadas también pueden usarse. El mantel comprendió que protegerse de cada marca lo había apartado de muchas historias.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/14-leccion-al-recoger.webp'),

        (v_story_id, 15,
        'A la mañana siguiente, {nombre_mantel} pidió bajar otra vez. Sobre él desayunaron fruta y {comida_favorita}. Nadie derramó nada, pero eso ya no era lo más importante. Escuchó planes, preguntas y una canción incompleta. Cuando terminaron, ayudó a envolver las migas para sacudirlas en el patio.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/15-desayuno-del-dia-siguiente.webp'),

        (v_story_id, 16,
        'Desde entonces, {nombre_mantel} siguió siendo lavado, secado y doblado con cariño, pero dejó de esperar una ocasión impecable. Había descubierto que cualquier día podía guardar algo especial. Bastaba una mesa compartida, tiempo para escucharse y la valentía de vivir el momento antes de saber cómo terminaría.',
        null,
        array[]::text[],
        '/images/el-mantel-que-esperaba-un-dia-perfecto/16-mantel-lleno-de-historias.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/el-mantel-que-esperaba-un-dia-perfecto.webp
-- Imágenes:
-- 01-mantel-en-el-cajon.webp
-- 02-mantel-imagina-perfeccion.webp
-- 03-historias-desde-el-cajon.webp
-- 04-casa-sin-electricidad.webp
-- 05-cajon-abierto.webp
-- 06-invitacion-al-patio.webp
-- 07-mesa-desigual.webp
-- 08-gato-y-migas.webp
-- 09-mancha-de-jugo.webp
-- 10-mapa-sobre-la-tela.webp
-- 11-mapa-de-recuerdos.webp
-- 12-mantel-mira-sus-marcas.webp
-- 13-regresa-la-luz.webp
-- 14-leccion-al-recoger.webp
-- 15-desayuno-del-dia-siguiente.webp
-- 16-mantel-lleno-de-historias.webp
-- Sonidos requeridos:
-- crujido.mp3
-- vajilla-tintineando.mp3
-- ronroneo-de-gato.mp3
-- risas-familiares.mp3
