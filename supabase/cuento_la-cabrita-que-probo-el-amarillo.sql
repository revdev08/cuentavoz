do $$

declare
    v_story_id uuid;
    v_mercado uuid;
    v_balido uuid;
    v_crujido uuid;

begin

    select id into v_story_id from stories
    where slug='la-cabrita-que-probo-el-amarillo' limit 1;

    if v_story_id is null then
        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)
        values
        ('La cabrita que probó el amarillo',
         'la-cabrita-que-probo-el-amarillo',
         '2-7 años', true,
         '/images/portadas/la-cabrita-que-probo-el-amarillo.webp')
        returning id into v_story_id;
    else
        update stories
        set titulo='La cabrita que probó el amarillo',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/la-cabrita-que-probo-el-amarillo.webp'
        where id=v_story_id;
    end if;

    if not exists (select 1 from sound_effects where nombre='mercado de plaza') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('mercado de plaza', '/sounds/mercado-de-plaza.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='balido de cabrita') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('balido de cabrita', '/sounds/balido-de-cabrita.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='crujido') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('crujido', '/sounds/crujido.mp3', 'efecto');
    end if;

    select id into v_mercado from sound_effects where nombre='mercado de plaza' limit 1;
    select id into v_balido from sound_effects where nombre='balido de cabrita' limit 1;
    select id into v_crujido from sound_effects where nombre='crujido' limit 1;

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)
    values
        (v_story_id, 'nombre_cabrita', 'texto', array['Miga', 'Lola', 'Pepa', 'Nube', 'Tita', 'Cora']),
        (v_story_id, 'nombre_mercado', 'texto', array['Mercado del Sol', 'Plaza Canela', 'Mercado de las Palmas', 'Plaza del Río']),
        (v_story_id, 'alimento_amarillo', 'texto', array['mango', 'maíz', 'piña', 'plátano', 'papaya amarilla']),
        (v_story_id, 'color_canasta', 'color', array['turquesa', 'rojo coral', 'verde hoja', 'violeta']);

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
    values

        (v_story_id, 1,
        '{nombre_cabrita} conocía exactamente seis sabores y los quería siempre en el mismo orden. Desayunaba avena, mordisqueaba hojas tiernas y guardaba pan suave en su canasta {color_canasta}. Cuando algo completamente nuevo aparecía en el plato, cerraba la boca como una puerta con cerrojo.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/01-desayuno-de-seis-sabores.webp'),

        (v_story_id, 2,
        'Los sábados visitaba {nombre_mercado}, una plaza bulliciosa llena de montañas comestibles. Le gustaban mucho los puestos verdes, blancos y morados. Pero evitaba siempre el corredor amarillo. Decía que aquel color olía demasiado fuerte, brillaba demasiado y parecía gritarle desde cada mesa.',
        v_mercado, array['mercado'],
        '/images/la-cabrita-que-probo-el-amarillo/02-corredor-amarillo.webp'),

        (v_story_id, 3,
        'Esa mañana, una vendedora colocó cerca de la entrada una bandeja pequeña con {alimento_amarillo}. —Puedes mirar sin comer —dijo tranquilamente, atendiendo después a otra persona. {nombre_cabrita} se sorprendió muchísimo. Nadie había convertido aquella bandeja en examen, promesa ni desafío difícil o inesperado.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/03-bandeja-sin-desafio.webp'),

        (v_story_id, 4,
        '{nombre_cabrita} se acercó un paso cuidadoso. Miró la forma, pero mantuvo sus labios bien apretados. Entonces una carretilla veloz pasó rozando el puesto. Tres piñas, cuatro mazorcas y cinco mangos saltaron de sus montones y comenzaron a rodar alegremente bajo los toldos.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/04-frutas-comienzan-a-rodar.webp'),

        (v_story_id, 5,
        'Las frutas amarillas cruzaron la plaza como un río redondo. Los limones rodearon una balanza, los plátanos patinaron sobre hojas y un mango aterrizó suavemente dentro de la canasta {color_canasta}. {nombre_cabrita} soltó un beee tan largo que hizo reír a dos gallinas.',
        v_balido, array['beee'],
        '/images/la-cabrita-que-probo-el-amarillo/05-rio-de-frutas.webp'),

        (v_story_id, 6,
        'Quiso devolver el mango sin tocarlo. Inclinó la canasta, pero la fruta rodó hacia un pan recién horneado. Para salvar el desayuno, {nombre_cabrita} apoyó una pezuña sobre el mango. Esperaba algo realmente terrible. Solo sintió una piel lisa, tibia y firme.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/06-pezuña-sobre-el-mango.webp'),

        (v_story_id, 7,
        'Ayudó a recoger el resto sin acercarlo a su boca. Clasificó curvas, coronas, granos y cáscaras. El corredor que antes parecía un solo grito empezó a llenarse de diferencias. Algunas cosas pinchaban, otras pesaban y muchas olían completamente distinto allí.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/07-formas-del-color-amarillo.webp'),

        (v_story_id, 8,
        'La vendedora cortó {alimento_amarillo} para una familia y dejó un trocito apartado cuidadosamente. No se lo acercó ni preguntó si sería valiente. {nombre_cabrita} decidió primero olerlo desde muy lejos. Después desde bastante cerca. Su nariz encontró un aroma que no conocía todavía.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/08-primer-aroma.webp'),

        (v_story_id, 9,
        'Podía marcharse. También podía seguir investigando. Tocó el trocito con la punta de la lengua y esperó. El sabor llegó dulce, ácido y extraño, todo junto. {nombre_cabrita} frunció el hocico. Aún no sabía si quería otro bocado, y eso estaba bien.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/09-prueba-con-la-punta.webp'),

        (v_story_id, 10,
        'En el puesto vecino, un cabrito mordió una mazorca con fuerte crujido y pidió más. Una oveja probó la misma mazorca y prefirió devolverla. Nadie tenía la respuesta correcta para todas las bocas. Cada lengua estaba contando una experiencia diferente.',
        v_crujido, array['crujido'],
        '/images/la-cabrita-que-probo-el-amarillo/10-dos-gustos-distintos.webp'),

        (v_story_id, 11,
        '{nombre_cabrita} quiso comprobar una cosa. Probó un segundo pedacito de {alimento_amarillo}, esta vez junto con su pan conocido. El sabor cambió. No se volvió su favorito de inmediato, pero dejó de parecer una alarma. Ahora era simplemente algo nuevo que estaba conociendo.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/11-sabor-con-pan.webp'),

        (v_story_id, 12,
        'Después eligió una mazorca únicamente para escuchar sus granos, olió una piña sin tocarla y decidió no probar un limón. Había descubierto que acercarse no era una sola acción. Podía mirar, preguntar, oler, tocar, lamer, morder o decir: «Hoy no».',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/12-siete-formas-de-acercarse.webp'),

        (v_story_id, 13,
        'La plaza volvió a ordenarse. Sobre cada mesa regresaron pequeñas montañas amarillas, pero {nombre_cabrita} ya no vio un corredor que gritaba. Vio muchas invitaciones diferentes y recordó que podía responder a cada una con curiosidad, tiempo y sus propios límites claros.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/13-mercado-visto-de-nuevo.webp'),

        (v_story_id, 14,
        '—Probar algo nuevo no significa que deba gustarme —dijo {nombre_cabrita}—. Tampoco tengo que hacerlo todo de una vez. Puedo acercarme por pasos y escuchar lo que siento. La vendedora asintió mientras acomodaba el último mango, sin entregar medallas ni felicitaciones exageradas.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/14-palabras-junto-al-puesto.webp'),

        (v_story_id, 15,
        'Antes de volver a casa, {nombre_cabrita} guardó un pedacito de {alimento_amarillo} junto al pan. Quizá lo comería durante el camino o quizá no. Lo importante era que la decisión ya no pertenecía al miedo ni a las miradas ajenas. Pertenecía a ella.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/15-canasta-con-una-posibilidad.webp'),

        (v_story_id, 16,
        'El sábado siguiente, {nombre_cabrita} regresó feliz a {nombre_mercado}. Conservaba sus seis sabores queridos, pero dejó un pequeño espacio para investigar otro. Comprendió que la curiosidad puede avanzar muy despacio: conocer no obliga a querer, y decir «todavía no» también permite seguir descubriendo.',
        null, array[]::text[],
        '/images/la-cabrita-que-probo-el-amarillo/16-regreso-con-curiosidad.webp');

end $$;

-- Assets
-- Portada: /images/portadas/la-cabrita-que-probo-el-amarillo.webp
-- Sonidos:
-- /sounds/mercado-de-plaza.mp3 (nuevo)
-- /sounds/balido-de-cabrita.mp3 (nuevo)
-- /sounds/crujido.mp3 (ya existe)
