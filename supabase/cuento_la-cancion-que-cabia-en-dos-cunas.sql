do $$

declare
    v_story_id uuid;
    v_lluvia uuid;
    v_caja uuid;
    v_hipo uuid;

begin

    select id into v_story_id
    from stories
    where slug='la-cancion-que-cabia-en-dos-cunas'
    limit 1;

    if v_story_id is null then
        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)
        values
        (
            'La canción que cabía en dos cunas',
            'la-cancion-que-cabia-en-dos-cunas',
            '2-7 años',
            true,
            '/images/portadas/la-cancion-que-cabia-en-dos-cunas.webp'
        )
        returning id into v_story_id;
    else
        update stories
        set titulo='La canción que cabía en dos cunas',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/la-cancion-que-cabia-en-dos-cunas.webp'
        where id=v_story_id;
    end if;

    if not exists (
        select 1 from sound_effects where nombre='lluvia sobre techo'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('lluvia sobre techo', '/sounds/lluvia-sobre-techo.mp3', 'ambiente');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='caja musical'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('caja musical', '/sounds/caja-musical.mp3', 'efecto');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='hipo de bebe'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('hipo de bebe', '/sounds/hipo-de-bebe.mp3', 'efecto');
    end if;

    select id into v_lluvia from sound_effects where nombre='lluvia sobre techo' limit 1;
    select id into v_caja from sound_effects where nombre='caja musical' limit 1;
    select id into v_hipo from sound_effects where nombre='hipo de bebe' limit 1;

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)
    values
        (v_story_id, 'nombre_mayor', 'texto', array['Teo', 'Mila', 'Simón', 'Vera']),
        (v_story_id, 'nombre_bebe', 'texto', array['Lía', 'Noa', 'Sol', 'Gael']),
        (v_story_id, 'peluche_favorito', 'texto', array['conejo de orejas largas', 'ballena azul', 'oso de bolsillo', 'zorro dormilón']),
        (v_story_id, 'color_manta', 'color', array['verde menta', 'amarillo miel', 'azul noche', 'rosa coral']),
        (v_story_id, 'palabra_cancion', 'texto', array['lunita', 'barquito', 'lucero', 'caracol']);

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
    values

        (v_story_id, 1,
        'Cada noche, {nombre_mayor} se acomodaba con su {peluche_favorito} bajo una manta {color_manta}. Mamá se sentaba junto a la cama y cantaba una melodía que empezaba con «duerme, {palabra_cancion}». Aquella canción había pertenecido a sus noches desde que podía recordarlas.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/01-cancion-junto-a-la-cama.webp'),

        (v_story_id, 2,
        'Entonces llegó {nombre_bebe}, con manos diminutas, bostezos enormes y una cuna junto a la ventana. Durante el día, {nombre_mayor} mostraba orgulloso cada juguete. Pero al caer la noche descubrió algo inesperado: mamá cantaba la misma melodía junto a la nueva cuna.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/02-bebe-en-la-nueva-cuna.webp'),

        (v_story_id, 3,
        '{nombre_mayor} escuchó desde el pasillo. Las palabras eran iguales, pero ahora llevaban el nombre de {nombre_bebe}. Sintió un nudo pequeño detrás del pecho. Si la canción podía marcharse a otra cuna, quizá también podían marcharse los abrazos, los cuentos y su lugar favorito.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/03-nino-escucha-desde-el-pasillo.webp'),

        (v_story_id, 4,
        'La noche siguiente guardó la caja musical dentro del armario. Sin su habitual trin-trin, pensó, nadie recordaría cómo comenzaba la canción. Después se acostó muy tieso y fingió dormir. Mamá buscó la caja, pero terminó tarareando la melodía conocida suavemente.',
        v_caja, array['trin-trin'],
        '/images/la-cancion-que-cabia-en-dos-cunas/04-caja-musical-escondida.webp'),

        (v_story_id, 5,
        'La canción atravesó la pared de todos modos. {nombre_mayor} apretó su {peluche_favorito}. No quería que {nombre_bebe} llorara, pero tampoco quería compartir aquello que sentía suyo. Ambas cosas cabían en su corazón y chocaban como dos almohadas durante una pelea silenciosa.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/05-dos-sentimientos-en-la-cama.webp'),

        (v_story_id, 6,
        'Esa madrugada comenzó la lluvia sobre el techo. {nombre_bebe} despertó sobresaltado y mamá intentó calmarlo, pero estaba tan cansada que olvidó la segunda estrofa. Desde su habitación, {nombre_mayor} conocía cada palabra. Se cubrió hasta la nariz y permaneció callado.',
        v_lluvia, array['lluvia'],
        '/images/la-cancion-que-cabia-en-dos-cunas/06-lluvia-y-llanto-nocturno.webp'),

        (v_story_id, 7,
        'El llanto continuó. Entre un sollozo y otro apareció un sonido diminuto: hip. Luego otro: hip. {nombre_bebe} tenía hipo. {nombre_mayor} descubrió con mucha sorpresa que aquellos saltitos caían exactamente en los espacios donde la canción hacía una pausa.',
        v_hipo, array['hip'],
        '/images/la-cancion-que-cabia-en-dos-cunas/07-hipo-entre-las-pausas.webp'),

        (v_story_id, 8,
        'Sin quitarse la manta, {nombre_mayor} caminó hasta la puerta. Podía volver a su cama o completar la estrofa. Miró a mamá meciendo la cuna y a {nombre_bebe} buscando aire entre hipidos. Entonces cantó la siguiente línea desde el pasillo.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/08-cancion-desde-la-puerta.webp'),

        (v_story_id, 9,
        'Mamá no dijo nada; simplemente dejó un espacio para su voz. {nombre_mayor} se acercó. Cada vez que el bebé hacía hip, ambos esperaban y continuaban después. La vieja melodía adquirió un ritmo nuevo, extraño al principio y pronto imposible de olvidar.',
        v_hipo, array['hip'],
        '/images/la-cancion-que-cabia-en-dos-cunas/09-cancion-con-hipidos.webp'),

        (v_story_id, 10,
        'Sobre la cuna giraba un móvil de estrellas de papel. Con cada pausa, las sombras cambiaban de pared: una estrella caía sobre la cama grande y otra sobre la cuna. Parecía una constelación cosida entre ambos lugares por las voces de la familia.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/10-constelacion-entre-dos-camas.webp'),

        (v_story_id, 11,
        'Cuando {nombre_bebe} cerró los ojos, {nombre_mayor} confesó dónde estaba la caja musical y por qué la había escondido. Esperaba un regaño. Mamá, en cambio, se sentó en el suelo. —Temías que compartir nuestra canción significara perderla —dijo. Él asintió.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/11-confesion-junto-a-la-cuna.webp'),

        (v_story_id, 12,
        '—Cuando una familia cambia, algunas costumbres también cambian —explicó mamá—. Eso puede doler aunque amemos a quien llegó. Pero el cariño nunca abandona una cama para entrar en otra. Podemos buscar juntos una forma donde todos tengamos nuestro propio lugar.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/12-familia-habla-en-el-suelo.webp'),

        (v_story_id, 13,
        'Al día siguiente recuperaron la caja. {nombre_mayor} giró la llave y volvió el trin-trin. Después inventó una estrofa exclusiva para las noches de dos voces. Incluía a {palabra_cancion}, al {peluche_favorito} y hasta un hipo que siempre llegaba tarde.',
        v_caja, array['trin-trin'],
        '/images/la-cancion-que-cabia-en-dos-cunas/13-nueva-estrofa-en-familia.webp'),

        (v_story_id, 14,
        'Algunas noches mamá cantaba primero junto a la cuna. Otras comenzaba en la cama grande. Cuando {nombre_mayor} necesitaba tiempo solamente con ella, aprendió a pedirlo sin esconder melodías. Y cuando el bebé lloraba, podía elegir acercarse o seguir descansando.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/14-momentos-para-cada-uno.webp'),

        (v_story_id, 15,
        '—El amor no se parte como una galleta —dijo {nombre_mayor} una noche—. Cambia de forma para hacernos sitio. Mamá sonrió. Él había comprendido que querer a {nombre_bebe} no exigía dejar de extrañar las noches anteriores ni fingir alegría siempre.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/15-amor-que-hace-sitio.webp'),

        (v_story_id, 16,
        'Desde entonces, la canción siguió creciendo. Conservaba su comienzo antiguo, tenía una estrofa nueva y dejaba pausas para cualquier hip inesperado. {nombre_mayor} ya no temía que otra voz borrara la suya: había descubierto que una familia puede cambiar de ritmo sin perder su melodía.',
        null, array[]::text[],
        '/images/la-cancion-que-cabia-en-dos-cunas/16-cancion-bajo-las-estrellas.webp');

end $$;

-- Assets
-- Portada: /images/portadas/la-cancion-que-cabia-en-dos-cunas.webp
-- Sonidos:
-- /sounds/lluvia-sobre-techo.mp3
-- /sounds/caja-musical.mp3
-- /sounds/hipo-de-bebe.mp3
