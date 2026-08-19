-- Cuentavoz: La sombra que no sabía descansar
-- Edad: 2-7 años
-- Emoción dominante: alivio juguetón.
-- Enseñanza: descansar no es abandonar lo que amamos; es recuperar fuerzas para volver presentes.
-- Idempotente: identifica el cuento por slug y reemplaza variables/bloques.

do $$

declare

    v_story_id uuid;
    v_pasos_adoquines uuid;
    v_fuente uuid;
    v_murmullo uuid;
    v_risas uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-sombra-que-no-sabia-descansar'
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
            'La sombra que no sabía descansar',
            'la-sombra-que-no-sabia-descansar',
            '2-7 años',
            'Emociones',
            true,
            '/images/portadas/la-sombra-que-no-sabia-descansar.webp'
        )

        returning id
        into v_story_id;

    end if;

    update stories
    set
        titulo='La sombra que no sabía descansar',
        edad_recomendada='2-7 años',
        categoria='Emociones',
        es_personalizable=true,
        portada_url='/images/portadas/la-sombra-que-no-sabia-descansar.webp'
    where id=v_story_id;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='pasos sobre adoquines') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pasos sobre adoquines', '/sounds/pasos-sobre-adoquines.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='fuente de plaza') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('fuente de plaza', '/sounds/fuente-de-plaza.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='murmullo de mercado') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('murmullo de mercado', '/sounds/murmullo-de-mercado.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='risas infantiles') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('risas infantiles', '/sounds/risas-infantiles.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_pasos_adoquines from sound_effects where nombre='pasos sobre adoquines' limit 1;
    select id into v_fuente from sound_effects where nombre='fuente de plaza' limit 1;
    select id into v_murmullo from sound_effects where nombre='murmullo de mercado' limit 1;
    select id into v_risas from sound_effects where nombre='risas infantiles' limit 1;

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

        (v_story_id, 'nombre_sombra', 'texto', array['Tinta', 'Silueta', 'Noche', 'Trapo']),
        (v_story_id, 'nombre_nino', 'texto', array['Amalia', 'Julián', 'Vera', 'Tomás']),
        (v_story_id, 'nombre_plaza', 'texto', array['Plaza del Sol', 'Plaza de los Mangos', 'Plaza Redonda', 'Plaza de las Flores']),
        (v_story_id, 'color_sombrilla', 'color', array['amarillo', 'rojo', 'verde', 'azul', 'morado']);

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
        'Cada mañana, cuando el sol tocaba la ventana, {nombre_sombra} aparecía junto a los pies de {nombre_nino}. Era una sombra ágil, delgada y muy cumplida. Si el niño saltaba, ella saltaba. Si giraba, ella giraba. Jamás llegaba tarde a un movimiento.',
        null,
        array[]::text[],
        '/images/la-sombra-que-no-sabia-descansar/01-sombra-junto-ventana.webp'),

        (v_story_id, 2,
        '{nombre_sombra} estaba orgullosa de acompañarlo. —Una buena sombra nunca se separa —decía. {nombre_nino} le recordaba que hasta los pies se detienen para dormir. Ella se estiraba por la pared y respondía: —Yo descansaré cuando el sol aprenda a quedarse quieto.',
        null,
        array[]::text[],
        '/images/la-sombra-que-no-sabia-descansar/02-promesa-en-la-pared.webp'),

        (v_story_id, 3,
        'El sábado caminaron hasta {nombre_plaza}, donde comenzaba el mercado. Los pasos repicaban sobre los adoquines. {nombre_sombra} esquivó canastos, imitó saludos y se alargó para alcanzar cada puesto antes que {nombre_nino}. Quería demostrar que podía acompañarlo sin perder ni un segundo.',
        v_pasos_adoquines,
        array['pasos'],
        '/images/la-sombra-que-no-sabia-descansar/03-llegada-al-mercado.webp'),

        (v_story_id, 4,
        'El murmullo del mercado llenaba el aire: frutas rodando, vendedores conversando, bolsas de papel abriéndose. {nombre_nino} se detuvo a probar una guayaba. Su sombra, en cambio, siguió ensayando reverencias detrás de un puesto, por si más tarde alguien necesitaba una.',
        v_murmullo,
        array['murmullo'],
        '/images/la-sombra-que-no-sabia-descansar/04-sombra-entre-puestos.webp'),

        (v_story_id, 5,
        'Al mediodía, el sol quedó justo encima de la plaza. {nombre_sombra} se encogió hasta parecer una mancha bajo los zapatos. Cerca de la fuente había una sombrilla de color {color_sombrilla}. —Ven a la sombra fresca —propuso {nombre_nino}. Ella fingió no escucharlo.',
        v_fuente,
        array['fuente'],
        '/images/la-sombra-que-no-sabia-descansar/05-mediodia-en-la-fuente.webp'),

        (v_story_id, 6,
        'Siguieron hasta una ronda de baile. {nombre_nino} levantó un brazo; {nombre_sombra} tardó en levantar el suyo. Dio una vuelta y ella quedó mirando hacia otro lado. Sus bordes, antes nítidos, temblaban como tinta sobre papel mojado. Aun así, insistió: —Puedo continuar.',
        null,
        array[]::text[],
        '/images/la-sombra-que-no-sabia-descansar/06-sombra-retrasada.webp'),

        (v_story_id, 7,
        'La música aceleró. {nombre_nino} dio tres saltos pequeños. {nombre_sombra} consiguió el primero, tropezó con el segundo y en el tercero se dividió en tres siluetas cansadas. Ninguna sabía cuál movimiento seguir. El niño dejó de bailar y se arrodilló junto a ellas.',
        null,
        array[]::text[],
        '/images/la-sombra-que-no-sabia-descansar/07-tres-siluetas-cansadas.webp'),

        (v_story_id, 8,
        '—No necesito que copies cada paso para saber que estás conmigo —dijo {nombre_nino}. Las tres siluetas se juntaron despacio. {nombre_sombra} temía que, si se detenía, dejara de ser importante. Pero ya no tenía fuerzas ni para dibujar correctamente la punta de un zapato.',
        null,
        array[]::text[],
        '/images/la-sombra-que-no-sabia-descansar/08-conversacion-en-adoquines.webp'),

        (v_story_id, 9,
        'Entonces tomó una decisión extraña para una sombra: se deslizó bajo la sombrilla {color_sombrilla}, se desprendió suavemente de los pies de {nombre_nino} y se plegó sobre sí misma. Quedó pequeña y tranquila, como un pañuelo oscuro guardado en un bolsillo de frescura.',
        null,
        array[]::text[],
        '/images/la-sombra-que-no-sabia-descansar/09-sombra-como-panuelo.webp'),

        (v_story_id, 10,
        'Desde allí escuchó la fuente y observó el mercado sin imitarlo. {nombre_nino} comió otra tajada de guayaba, conversó con una vendedora y volvió al baile. Nada malo ocurrió porque su sombra descansara. Por primera vez, {nombre_sombra} acompañó sin perseguir cada movimiento.',
        null,
        array[]::text[],
        '/images/la-sombra-que-no-sabia-descansar/10-descanso-bajo-sombrilla.webp'),

        (v_story_id, 11,
        'La tarde refrescó. {nombre_sombra} salió de debajo de la sombrilla y volvió a unirse a los zapatos. Ya no temblaba. Se extendió larga sobre la plaza y, cuando {nombre_nino} giró, ella giró también. Esta vez añadió una pequeña reverencia solo porque le dio gusto.',
        null,
        array[]::text[],
        '/images/la-sombra-que-no-sabia-descansar/11-regreso-al-atardecer.webp'),

        (v_story_id, 12,
        'Los niños soltaron risas al ver que la sombra convertía sus brazos en alas, orejas de conejo y una enorme cola de pez. Antes solo copiaba. Ahora también jugaba. Haber descansado no la volvió menos atenta; le devolvió espacio para inventar movimientos propios.',
        v_risas,
        array['risas'],
        '/images/la-sombra-que-no-sabia-descansar/12-animales-de-sombra.webp'),

        (v_story_id, 13,
        'Camino a casa, {nombre_nino} miró la silueta larga que avanzaba a su lado. —Descansar no fue dejarme solo —dijo—. Fue cuidarte para regresar completa. {nombre_sombra} apretó su mano oscura contra la del niño, y ambas formas caminaron al mismo ritmo.',
        null,
        array[]::text[],
        '/images/la-sombra-que-no-sabia-descansar/13-camino-a-casa.webp'),

        (v_story_id, 14,
        'Desde entonces, al mediodía buscaban juntos un rincón fresco. {nombre_sombra} se plegaba un rato; {nombre_nino} mordía una fruta o escuchaba la plaza. Después regresaban sin prisa. La sombra comprendió que detenerse no rompe una compañía: a veces es la manera más amable de poder continuarla.',
        null,
        array[]::text[],
        '/images/la-sombra-que-no-sabia-descansar/14-pausa-compartida.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/la-sombra-que-no-sabia-descansar.webp
-- Imágenes:
-- 01-sombra-junto-ventana.webp
-- 02-promesa-en-la-pared.webp
-- 03-llegada-al-mercado.webp
-- 04-sombra-entre-puestos.webp
-- 05-mediodia-en-la-fuente.webp
-- 06-sombra-retrasada.webp
-- 07-tres-siluetas-cansadas.webp
-- 08-conversacion-en-adoquines.webp
-- 09-sombra-como-panuelo.webp
-- 10-descanso-bajo-sombrilla.webp
-- 11-regreso-al-atardecer.webp
-- 12-animales-de-sombra.webp
-- 13-camino-a-casa.webp
-- 14-pausa-compartida.webp
-- Sonidos nuevos:
-- pasos-sobre-adoquines.mp3
-- fuente-de-plaza.mp3
-- murmullo-de-mercado.mp3
-- risas-infantiles.mp3
