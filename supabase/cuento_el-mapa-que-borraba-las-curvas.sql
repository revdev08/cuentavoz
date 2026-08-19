do $$

declare
    v_story_id uuid;
    v_viento uuid;
    v_sal uuid;
    v_lapiz uuid;

begin

    select id into v_story_id
    from stories
    where slug='el-mapa-que-borraba-las-curvas'
    limit 1;

    if v_story_id is null then
        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)
        values
        (
            'El mapa que borraba las curvas',
            'el-mapa-que-borraba-las-curvas',
            '2-7 años',
            true,
            '/images/portadas/el-mapa-que-borraba-las-curvas.webp'
        )
        returning id into v_story_id;
    else
        update stories
        set titulo='El mapa que borraba las curvas',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/el-mapa-que-borraba-las-curvas.webp'
        where id=v_story_id;
    end if;

    if not exists (
        select 1 from sound_effects where nombre='sal quebrándose'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('sal quebrándose', '/sounds/sal-quebrandose.mp3', 'efecto');
    end if;

    select id into v_viento
    from sound_effects
    where nombre='viento del desierto'
    limit 1;

    select id into v_sal
    from sound_effects
    where nombre='sal quebrándose'
    limit 1;

    select id into v_lapiz
    from sound_effects
    where nombre='lapiz sobre papel'
    limit 1;

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)
    values
        (v_story_id, 'nombre_mapa', 'texto', array['Pliegue', 'Rumbo', 'Trazos', 'Norte']),
        (v_story_id, 'nombre_nino', 'texto', array['Iara', 'Tomás', 'Luna', 'Simón']),
        (v_story_id, 'nombre_salar', 'texto', array['Luna Blanca', 'Los Espejos', 'Cielo Bajo', 'Sal Serena']),
        (v_story_id, 'color_tinta', 'color', array['azul añil', 'rojo granada', 'verde jade', 'violeta ciruela']);

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
    values

        (v_story_id, 1,
        'En una tienda de cartógrafos, junto al salar {nombre_salar}, vivía {nombre_mapa} desde hacía muchos años. Estaba dibujado con tinta {color_tinta} sobre papel resistente. Conocía pozos, refugios y montículos de sal, pero detestaba sus caminos curvos. Le parecían largos, desordenados y poco elegantes.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/01-mapa-entre-cartografos.webp'),

        (v_story_id, 2,
        'Cada vez que los cartógrafos dormían, {nombre_mapa} estiraba una esquina y borraba alguna vuelta. «Por aquí llegarán antes», pensaba satisfecho. Nadie notó que también desaparecían pequeñas señales: una roca con sombra, un suelo firme y un canal donde todavía crecía hierba.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/02-curvas-borradas.webp'),

        (v_story_id, 3,
        'Una mañana llegó {nombre_nino} con una caravana de familias. Querían cruzar el salar para asistir al Encuentro de Cometas, celebrado junto a los pozos de cristal. Los mayores desplegaron a {nombre_mapa}. Su nueva línea recta parecía sencilla, veloz y casi imposible de confundir.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/03-caravana-despliega-mapa.webp'),

        (v_story_id, 4,
        'Partieron cuando el cielo apenas clareaba. Al principio, todo funcionó. Las ruedas avanzaron deprisa y {nombre_mapa} se sintió importante sobre las rodillas de {nombre_nino}. A un lado quedó una curva antigua que conducía entre dos paredes de piedra. Nadie tomó aquel desvío.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/04-desvio-entre-piedras.webp'),

        (v_story_id, 5,
        'Al mediodía, el viento barrió el salar sin encontrar obstáculos. Levantó polvo blanco, sacudió sombreros y empujó las cometas guardadas dentro del carro. La ruta recta no ofrecía refugio. {nombre_nino} cubrió el mapa con ambos brazos para impedir que saliera volando.',
        v_viento, array['viento'],
        '/images/el-mapa-que-borraba-las-curvas/05-viento-sobre-el-salar.webp'),

        (v_story_id, 6,
        '—La curva antigua pasaba protegida entre rocas —recordó una viajera. {nombre_mapa} fingió que sus pliegues no temblaban. Todavía creía que llegar primero era lo más importante. Cuando el aire se calmó, señaló su línea recta con orgullo, y la caravana continuó.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/06-mapa-insiste-en-recto.webp'),

        (v_story_id, 7,
        'Poco después, el suelo cambió de blanco brillante a gris azulado. {nombre_nino} vio pequeñas burbujas atrapadas bajo la costra. Antes de poder avisar, sonó crac bajo una rueda. El carro se inclinó y todos bajaron despacio, procurando no quebrar más aquella superficie delgada.',
        v_sal, array['crac'],
        '/images/el-mapa-que-borraba-las-curvas/07-costra-de-sal-quebrada.webp'),

        (v_story_id, 8,
        'La línea borrada había rodeado ese terreno frágil durante generaciones. Sin aquella curva, la caravana no sabía dónde terminaba la costra segura. Nadie regañó al mapa, pues nadie conocía su secreto. Eso hizo que {nombre_mapa} se sintiera todavía peor dentro de sus propios dobleces.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/08-caravana-detenida.webp'),

        (v_story_id, 9,
        '{nombre_nino} lo extendió sobre una caja y observó unas marcas casi borradas. Había puntos para aves, líneas de agua y pequeños triángulos de piedra. —Los caminos daban vueltas por alguna razón —murmuró. {nombre_mapa} comprendió que había confundido una ruta corta con una ruta cuidadosa.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/09-senales-casi-borradas.webp'),

        (v_story_id, 10,
        'Por primera vez, el mapa dejó de querer tener todas las respuestas. Aflojó sus pliegues hasta quedar completamente abierto. Entonces permitió que {nombre_nino} comparara el papel con el paisaje: flamencos sobre suelo firme, juncos junto al agua y piedras oscuras donde comenzaba un paso seguro.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/10-mapa-escucha-el-paisaje.webp'),

        (v_story_id, 11,
        '{nombre_nino} sacó un lápiz. El mapa pudo haberse enrollado, avergonzado por sus errores, pero permaneció quieto. ras-ras, regresó una curva alrededor del suelo azul. ras-ras, apareció otra hacia las rocas protectoras. Esta vez, cada vuelta nació de una señal verdadera.',
        v_lapiz, array['ras-ras'],
        '/images/el-mapa-que-borraba-las-curvas/11-curvas-redibujadas.webp'),

        (v_story_id, 12,
        'La caravana retrocedió con paciencia y siguió la ruta corregida. Rodearon la costra frágil, descansaron entre paredes frescas y llenaron sus cantimploras junto a los juncos. El recorrido resultó más largo, aunque nadie volvió a perder un sombrero ni a sentir hundirse una rueda.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/12-caravana-por-ruta-segura.webp'),

        (v_story_id, 13,
        'Al caer la tarde, extendieron el mapa bajo el cielo. Las curvas nuevas parecieron continuar fuera del papel: una se unió al vuelo de los flamencos, otra al borde de las montañas y otra a la Vía Láctea. Ninguna era igual, pero juntas contaban el viaje completo.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/13-curvas-bajo-las-estrellas.webp'),

        (v_story_id, 14,
        'Llegaron al Encuentro cuando las primeras cometas ya danzaban. No fueron los primeros. Sin embargo, traían agua, historias del salar y a todos sus viajeros a salvo. {nombre_mapa} dejó de medir el éxito con minutos. Empezó a medirlo con aquello que el camino había cuidado.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/14-llegada-a-las-cometas.webp'),

        (v_story_id, 15,
        '—Un buen camino no siempre es el más corto —dijo {nombre_nino}, alisando una esquina—. Es el que nos ayuda a llegar sin dejar de mirar, aprender y cuidarnos. {nombre_mapa} conservó cada curva nueva, incluso las que parecían torpes, porque ahora conocía su propósito.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/15-conversacion-junto-al-mapa.webp'),

        (v_story_id, 16,
        'Desde entonces, {nombre_mapa} nunca volvió a borrar un giro solamente para ahorrar distancia. Invitaba a cada viajero a añadir señales y recuerdos útiles. Comprendió que avanzar bien no consiste en atravesar el mundo deprisa, sino en escoger un rumbo que también proteja el viaje.',
        null, array[]::text[],
        '/images/el-mapa-que-borraba-las-curvas/16-mapa-lleno-de-senales.webp');

end $$;

-- Assets
-- Portada: /images/portadas/el-mapa-que-borraba-las-curvas.webp
-- Sonido nuevo: /sounds/sal-quebrandose.mp3
