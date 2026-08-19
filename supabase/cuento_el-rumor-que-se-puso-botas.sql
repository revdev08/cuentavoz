do $$

declare
    v_story_id uuid;
    v_susurro uuid;
    v_papel uuid;
    v_horno uuid;

begin

    select id into v_story_id
    from stories
    where slug='el-rumor-que-se-puso-botas'
    limit 1;

    if v_story_id is null then
        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)
        values
        (
            'El rumor que se puso botas',
            'el-rumor-que-se-puso-botas',
            '2-7 años',
            true,
            '/images/portadas/el-rumor-que-se-puso-botas.webp'
        )
        returning id into v_story_id;
    else
        update stories
        set titulo='El rumor que se puso botas',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/el-rumor-que-se-puso-botas.webp'
        where id=v_story_id;
    end if;

    if not exists (
        select 1 from sound_effects where nombre='susurro de voces'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('susurro de voces', '/sounds/susurro-de-voces.mp3', 'efecto');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='papel arrugado'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('papel arrugado', '/sounds/papel-arrugado.mp3', 'efecto');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='horno crepitante'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('horno crepitante', '/sounds/horno-crepitante.mp3', 'ambiente');
    end if;

    select id into v_susurro from sound_effects where nombre='susurro de voces' limit 1;
    select id into v_papel from sound_effects where nombre='papel arrugado' limit 1;
    select id into v_horno from sound_effects where nombre='horno crepitante' limit 1;

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)
    values
        (v_story_id, 'nombre_rumor', 'texto', array['Runrún', 'Cuchicheo', 'Tilín', 'Bocadeboca']),
        (v_story_id, 'nombre_nina', 'texto', array['Inés', 'Mara', 'Zoe', 'Elena']),
        (v_story_id, 'nombre_barrio', 'texto', array['Las Buganvilias', 'La Ronda', 'Los Balcones', 'La Canela']),
        (v_story_id, 'pan_favorito', 'texto', array['pan de coco', 'pan de queso', 'pan de canela', 'pan de maíz']);

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
    values

        (v_story_id, 1,
        'En la panadería del barrio {nombre_barrio} nació {nombre_rumor}, un rumor pequeño como una cinta de papel. Su primera forma decía algo sencillo: «Hoy el horno descansará una hora». La panadera lo contó mientras amasaba, sin secretos, plumas ni botas.',
        v_horno, array['horno'],
        '/images/el-rumor-que-se-puso-botas/01-rumor-junto-al-horno.webp'),

        (v_story_id, 2,
        'Un repartidor escuchó solamente «el horno descansará». Al salir, se lo dijo al florista mediante un susurro: —Parece que el horno dejó de funcionar. {nombre_rumor} se estiró, perdió una palabra verdadera y ganó un sombrero de papel demasiado grande.',
        v_susurro, array['susurro'],
        '/images/el-rumor-que-se-puso-botas/02-sombrero-de-papel.webp'),

        (v_story_id, 3,
        'El florista repitió que la panadería estaba rota. Una ciclista entendió que cerraría toda la semana. Cuando la frase cruzó la plaza, {nombre_rumor} ya llevaba botas verdes, tres plumas violetas y un paraguas, aunque aquella mañana no caía una gota.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/03-rumor-cruza-la-plaza.webp'),

        (v_story_id, 4,
        '{nombre_nina} preparaba una canasta grande para la merienda comunitaria. Quería llevar {pan_favorito}, pero una vecina anunció: —¡No habrá pan! Dicen que una tormenta rompió el horno. {nombre_rumor} añadió nubes a su paraguas y empezó a sentirse importantísimo.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/04-canasta-sin-pan.webp'),

        (v_story_id, 5,
        'Al mediodía, las versiones eran enormes. Unos hablaban de un rayo. Otros, de una bandada que había robado la harina. Alguien aseguró que el horno caminaba hacia el río. {nombre_rumor} desfilaba convertido en una criatura de botas, alas y chimenea.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/05-rumor-gigante.webp'),

        (v_story_id, 6,
        'Muchas familias dejaron sus canastas en casa. La plaza, adornada para compartir la merienda, permaneció casi vacía. {nombre_nina} observó las mesas sin platos y preguntó quién había visto realmente el horno roto. Nadie levantó la mano. Todos conocían a alguien que conocía a alguien.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/06-plaza-casi-vacia.webp'),

        (v_story_id, 7,
        '—Busquemos la primera frase —propuso {nombre_nina}. No perseguirían al rumor por las calles; recorrerían sus pasos hacia atrás. La vecina recordó a la ciclista. La ciclista señaló al florista. Con cada nombre, {nombre_rumor} sintió que una de sus botas se aflojaba.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/07-investigacion-hacia-atras.webp'),

        (v_story_id, 8,
        'El florista admitió que nunca había visto una tormenta ni un horno roto. Solo completó lo que no escuchó. Tomó el sombrero de papel de {nombre_rumor} y lo abrió con cuidado. Dentro no había pruebas, únicamente dobleces hechos por su imaginación.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/08-sombrero-sin-pruebas.webp'),

        (v_story_id, 9,
        'Luego encontraron al repartidor. Él recordó las palabras exactas que había oído a medias. Al intentar enderezar la cinta, el papel hizo crac y soltó las plumas, las nubes y el paraguas. {nombre_rumor} quedó pequeño otra vez, todavía con una sola bota.',
        v_papel, array['crac'],
        '/images/el-rumor-que-se-puso-botas/09-rumor-pierde-disfraces.webp'),

        (v_story_id, 10,
        'Juntos llegaron a la panadería. El horno estaba entero y tibio. La panadera explicó que descansaría una hora para limpiarlo y después prepararía la merienda. Nadie había mentido a propósito; cada persona agregó aquello que creyó entender sin detenerse a preguntar.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/10-horno-entero-y-tibio.webp'),

        (v_story_id, 11,
        '{nombre_rumor} miró su última bota. Gracias a ella había cruzado rápido el barrio, pero también había pisado la verdad hasta dejarla irreconocible. Podía seguir corriendo o regresar con la frase completa. Por primera vez, eligió caminar despacio junto a {nombre_nina}.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/11-rumor-elige-caminar.webp'),

        (v_story_id, 12,
        'En cada esquina repetían juntos: —El horno descansó una hora y ya está preparando pan. Quien escuchaba podía acercarse a comprobarlo. Algunas personas rieron de alivio; otras volvieron por sus canastas. La plaza comenzó a llenarse sin carreras ni criaturas inventadas.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/12-frase-completa-regresa.webp'),

        (v_story_id, 13,
        'Pronto el horno crepitó detrás del mostrador. La panadera sacó bandejas de {pan_favorito} y las ventanas se empañaron con aromas dulces. {nombre_rumor}, convertido nuevamente en cinta, descansó junto a la receta original. Ya no necesitaba parecer enorme para que lo escucharan.',
        v_horno, array['crepitó'],
        '/images/el-rumor-que-se-puso-botas/13-bandejas-recien-horneadas.webp'),

        (v_story_id, 14,
        '—Antes de repetir algo, podemos preguntar con mucho cuidado: «¿Lo vi?, ¿lo escuché completo?, ¿puedo comprobarlo?» —dijo {nombre_nina}. No era una fórmula para saberlo todo. Era una manera de cuidar a las personas cuando una historia todavía tenía huecos.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/14-preguntas-en-la-mesa.webp'),

        (v_story_id, 15,
        'Durante la merienda, cada familia inventó a propósito el rumor más disparatado: hornos bailarines, panes con bigotes y palomas panaderas. Esta vez todos sabían que era un juego. {nombre_rumor} se puso sus botas por unos minutos y bailó sin engañar a nadie.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/15-juego-de-historias.webp'),

        (v_story_id, 16,
        'Desde aquel día, cuando una noticia llegaba incompleta a {nombre_barrio}, alguien abría espacio para una pregunta. {nombre_rumor} seguía viajando, porque las historias adoran moverse, pero aprendió a no disfrazar los huecos. Una frase cuidada camina más despacio y llega mucho más lejos.',
        null, array[]::text[],
        '/images/el-rumor-que-se-puso-botas/16-rumor-sin-disfraces.webp');

end $$;

-- Assets
-- Portada: /images/portadas/el-rumor-que-se-puso-botas.webp
-- Sonidos:
-- /sounds/susurro-de-voces.mp3
-- /sounds/papel-arrugado.mp3
-- /sounds/horno-crepitante.mp3
