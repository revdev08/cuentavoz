do $$

declare
    v_story_id uuid;
    v_estornudo uuid;
    v_aleteo uuid;
    v_risas uuid;

begin

    select id into v_story_id
    from stories
    where slug='el-estornudo-que-aprendio-a-avisar'
    limit 1;

    if v_story_id is null then
        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)
        values
        (
            'El estornudo que aprendió a avisar',
            'el-estornudo-que-aprendio-a-avisar',
            '2-7 años',
            true,
            '/images/portadas/el-estornudo-que-aprendio-a-avisar.webp'
        )
        returning id into v_story_id;
    else
        update stories
        set titulo='El estornudo que aprendió a avisar',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/el-estornudo-que-aprendio-a-avisar.webp'
        where id=v_story_id;
    end if;

    if not exists (
        select 1 from sound_effects where nombre='estornudo infantil'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('estornudo infantil', '/sounds/estornudo-infantil.mp3', 'efecto');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='aleteo de mariposas'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('aleteo de mariposas', '/sounds/aleteo-de-mariposas.mp3', 'efecto');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='risas infantiles'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('risas infantiles', '/sounds/risas-infantiles.mp3', 'efecto');
    end if;

    select id into v_estornudo
    from sound_effects
    where nombre='estornudo infantil'
    limit 1;

    select id into v_aleteo
    from sound_effects
    where nombre='aleteo de mariposas'
    limit 1;

    select id into v_risas
    from sound_effects
    where nombre='risas infantiles'
    limit 1;

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)
    values
        (v_story_id, 'nombre_estornudo', 'texto', array['Chispa', 'Cosquilla', 'Puf', 'Brinco']),
        (v_story_id, 'nombre_nino', 'texto', array['Leo', 'Mila', 'Nico', 'Abril']),
        (v_story_id, 'nombre_mariposario', 'texto', array['Alas de Sol', 'Jardín Volador', 'Casa Monarca', 'Mil Colores']),
        (v_story_id, 'color_panuelo', 'color', array['amarillo limón', 'azul cielo', 'verde menta', 'rojo cereza']);

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
    values

        (v_story_id, 1,
        'Detrás de la nariz de {nombre_nino} vivía {nombre_estornudo}, una cosquilla redonda que crecía con polvo, pimienta y polen. Casi siempre dormía tranquilamente. Cuando despertaba, daba tres vueltas, inflaba sus mejillas invisibles y buscaba la salida más rápida, sin avisarle a nadie.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/01-cosquilla-detras-de-la-nariz.webp'),

        (v_story_id, 2,
        'Una mañana, {nombre_nino} visitó el mariposario {nombre_mariposario} para ayudar en el conteo semanal. Había mariposas azules sobre los helechos, amarillas junto a las frutas y una enorme mariposa blanca que todavía nadie había contado. Todos caminaban despacio y hablaban bajito.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/02-conteo-de-mariposas.webp'),

        (v_story_id, 3,
        'Al pasar bajo unas flores cargadas de polen, {nombre_estornudo} despertó de golpe. Giró, creció y salió convertido en un achís enorme. Un aleteo llenó todo el invernadero. Las mariposas abandonaron las frutas, las hojas y hasta el sombrero del cuidador.',
        v_estornudo, array['achís'],
        '/images/el-estornudo-que-aprendio-a-avisar/03-estornudo-entre-las-flores.webp'),

        (v_story_id, 4,
        '{nombre_nino} se cubrió la cara, avergonzado. Nadie lo regañó, pero varias personas habían perdido la cuenta y debían comenzar otra vez. Desde detrás de la nariz, {nombre_estornudo} escuchó el revuelo. Por primera vez no se sintió poderoso. Se sintió como una visita que había irrumpido sin llamar.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/04-conteo-interrumpido.webp'),

        (v_story_id, 5,
        '—No volveré a salir jamás —decidió. Se escondió tan profundamente que, cuando apareció otra cosquilla, apretó todas sus burbujas. Los ojos de {nombre_nino} se llenaron de lágrimas. Su nariz picaba y su respiración sonaba muy extraña. Contenerlo tampoco estaba ayudando.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/05-estornudo-escondido.webp'),

        (v_story_id, 6,
        'La cuidadora acercó un pañuelo {color_panuelo}. —Tu cuerpo no hizo nada malo —dijo—. La próxima vez puedes avisar, girarte y cubrirte con el codo. Así el estornudo sale y los demás pueden prepararse. {nombre_estornudo} oyó cada palabra, aunque todavía desconfiaba.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/06-cuidadora-ofrece-panuelo.webp'),

        (v_story_id, 7,
        'Continuaron contando alrededor de una mesa con rodajas de naranja. Una mariposa diminuta se posó sobre la manga de {nombre_nino}. Justo entonces, otro granito de polen entró por su nariz. {nombre_estornudo} comenzó a crecer, pero cerró la salida con todas sus fuerzas.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/07-mariposa-sobre-la-manga.webp'),

        (v_story_id, 8,
        'La cosquilla aumentó hasta hacerle arrugar la frente. {nombre_nino} ya no podía mirar la mariposa ni escuchar los números. {nombre_estornudo} comprendió que desaparecer no era una solución: ambos estaban atrapados, uno detrás de la nariz y el otro delante de todos.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/08-cosquilla-incontenible.webp'),

        (v_story_id, 9,
        'Entonces {nombre_nino} levantó un dedo. —Voy a estornudar —advirtió. Los demás dejaron de contar durante un momento. La mariposa levantó vuelo sin prisa. El niño giró hacia un rincón y dobló el brazo. Detrás de su nariz, {nombre_estornudo} encontró una salida preparada.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/09-nino-avisa-y-se-prepara.webp'),

        (v_story_id, 10,
        'Esta vez no irrumpió. Esperó la señal y salió dentro del codo con un achís breve y redondo. Algunas alas temblaron, pero ninguna mariposa huyó lejos. {nombre_nino} respiró aliviado. {nombre_estornudo} descubrió que podía ser escuchado sin ocupar toda la habitación.',
        v_estornudo, array['achís'],
        '/images/el-estornudo-que-aprendio-a-avisar/10-estornudo-en-el-codo.webp'),

        (v_story_id, 11,
        'El pequeño soplo alcanzó unas vainas secas de algodoncillo. Cientos de semillas sedosas se elevaron bajo el techo de cristal como paracaídas diminutos. Las mariposas cruzaron entre ellas con un suave aleteo, y por un instante el aire pareció aprender a florecer.',
        v_aleteo, array['aleteo'],
        '/images/el-estornudo-que-aprendio-a-avisar/11-semillas-como-paracaidas.webp'),

        (v_story_id, 12,
        'Todos esperaron a que las semillas descendieran. Después reanudaron el conteo desde el número correcto. La gran mariposa blanca apareció sobre el pañuelo {color_panuelo}, provocando risas muy suaves. Esta vez, {nombre_nino} también rio. El estornudo no había arruinado la mañana.',
        v_risas, array['risas'],
        '/images/el-estornudo-que-aprendio-a-avisar/12-mariposa-sobre-el-panuelo.webp'),

        (v_story_id, 13,
        '{nombre_estornudo} entendió que avisar no lo hacía menos espontáneo. Simplemente ofrecía a los demás un segundo para detenerse, apartarse o preparar un pañuelo. Tampoco necesitaba esconderse hasta lastimar la nariz. Podía escuchar al cuerpo y compartir el espacio al mismo tiempo.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/13-estornudo-comprende.webp'),

        (v_story_id, 14,
        'Más tarde, otra niña sintió cosquillas. Avisó, se cubrió y soltó un achís pequeñísimo. Nadie hizo una mueca ni perdió la cuenta. {nombre_nino} le ofreció el pañuelo limpio de repuesto. Detrás de su nariz, {nombre_estornudo} celebró dando una vuelta silenciosa.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/14-otro-estornudo-cuidadoso.webp'),

        (v_story_id, 15,
        '—Las señales del cuerpo merecen que las escuchemos —dijo la cuidadora mientras guardaba cuidadosamente las tablillas—. Ser considerados no significa desaparecer, sino aprender cómo compartimos el lugar con otros. {nombre_nino} asintió y {nombre_estornudo} se acomodó satisfecho detrás de la nariz.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/15-conversacion-al-terminar.webp'),

        (v_story_id, 16,
        'Desde aquel día, cuando despertaba, {nombre_estornudo} daba tres vueltas y tocaba suavemente la nariz. {nombre_nino} sabía entonces qué hacer: avisar, girarse y preparar el codo. El achís seguía siendo sonoro y saltarín, pero nunca volvió a sentirse vergonzoso ni secreto.',
        null, array[]::text[],
        '/images/el-estornudo-que-aprendio-a-avisar/16-estornudo-que-avisa.webp');

end $$;

-- Assets
-- Portada: /images/portadas/el-estornudo-que-aprendio-a-avisar.webp
-- Sonidos nuevos:
-- /sounds/estornudo-infantil.mp3
-- /sounds/aleteo-de-mariposas.mp3
-- /sounds/risas-infantiles.mp3
