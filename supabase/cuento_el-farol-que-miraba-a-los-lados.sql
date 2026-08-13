-- Cuentavoz: El farol que miraba a los lados
-- Protagonista: un farol de estación. Escenario: una estación diminuta entre colinas.
-- Emoción dominante: curiosidad. Enseñanza: mirar a los lados también ayuda a encontrar el camino.

do $$
declare
  v_story_id uuid;
  v_tren uuid;
  v_silbato uuid;
  v_lluvia uuid;
  v_ruedas uuid;
  v_grillos uuid;
begin
  --------------------------------------------------
  -- Buscar historia
  --------------------------------------------------
  select id into v_story_id from stories where slug = 'el-farol-que-miraba-a-los-lados' limit 1;

  --------------------------------------------------
  -- Crear historia
  --------------------------------------------------
  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El farol que miraba a los lados', 'el-farol-que-miraba-a-los-lados', '2-7 años', true, null, 'Valores')
    returning id into v_story_id;
  end if;

  --------------------------------------------------
  -- Sonidos nuevos
  --------------------------------------------------
  if not exists (select 1 from sound_effects where nombre = 'tren lejano') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('tren lejano', '/sounds/tren-lejano.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'silbato de estacion') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('silbato de estacion', '/sounds/silbato-de-estacion.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'lluvia magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('lluvia magica', '/sounds/lluvia.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'ruedas de tren') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('ruedas de tren', '/sounds/ruedas-de-tren.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'grillos nocturnos') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
  end if;

  --------------------------------------------------
  -- Obtener ids
  --------------------------------------------------
  select id into v_tren from sound_effects where nombre = 'tren lejano' limit 1;
  select id into v_silbato from sound_effects where nombre = 'silbato de estacion' limit 1;
  select id into v_lluvia from sound_effects where nombre = 'lluvia magica' limit 1;
  select id into v_ruedas from sound_effects where nombre = 'ruedas de tren' limit 1;
  select id into v_grillos from sound_effects where nombre = 'grillos nocturnos' limit 1;

  --------------------------------------------------
  -- Variables
  --------------------------------------------------
  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_farol', 'texto', array['Lumen', 'Brillo', 'Pipo', 'Luci']),
    (v_story_id, 'nombre_estacion', 'texto', array['Estacion Nube', 'Estacion Roble', 'Estacion Suspiro', 'Estacion Lucero']),
    (v_story_id, 'color_luz', 'color', array['amarilla', 'azul', 'violeta', 'verde']);

  --------------------------------------------------
  -- Bloques
  --------------------------------------------------
  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1,
      'En {nombre_estacion}, una estación diminuta entre colinas, vivía {nombre_farol}, un farol alto de luz {color_luz}. Su trabajo era sencillo: alumbrar las vías cuando llegaba el tren y cuidar la plataforma hasta el último viajero. Y {nombre_farol} lo hacía mirando siempre, siempre, hacia adelante.',
      null, array[]::text[],
      '/images/el-farol-que-miraba-a-los-lados/01-farol-estacion-colinas.webp'),

    (v_story_id, 2,
      'Cada tarde, el tren lejano anunciaba su llegada desde detrás de la montaña. Entonces {nombre_farol} encendía su luz, recta como una flecha, sobre los rieles plateados. —Un buen farol mira el camino —decía con orgullo—. Lo demás puede esperar.',
      v_tren, array['tren'],
      '/images/el-farol-que-miraba-a-los-lados/02-tren-llega-atardecer.webp'),

    (v_story_id, 3,
      'A su alrededor ocurrían muchas cosas. Un caracol cruzaba las baldosas con una hoja a modo de sombrilla. Dos ardillas jugaban a esconder bellotas bajo el banco. Pero {nombre_farol} apenas las veía. Su luz apuntaba a las vías, y sus ojos de vidrio tampoco miraban a otro sitio.',
      null, array[]::text[],
      '/images/el-farol-que-miraba-a-los-lados/03-caracol-ardillas-estacion.webp'),

    (v_story_id, 4,
      'Una noche llegó una niña con una maleta pequeña y un sombrero enorme. Esperaba a su abuela, que venía en el último tren. La niña se sentó bajo {nombre_farol}, abrazó la maleta y preguntó: —¿Sabes por dónde aparece el tren? {nombre_farol} señaló las vías sin bajar la mirada.',
      null, array[]::text[],
      '/images/el-farol-que-miraba-a-los-lados/04-nina-espera-abuela.webp'),

    (v_story_id, 5,
      'De pronto, el silbato sonó entre las colinas. La niña saltó de alegría, y {nombre_farol} iluminó más fuerte que nunca. Sin embargo, el tren no apareció. El silbato volvió a sonar, pero esta vez venía de una curva escondida, hacia el lado que {nombre_farol} nunca miraba.',
      v_silbato, array['silbato'],
      '/images/el-farol-que-miraba-a-los-lados/05-silbato-curva-escondida.webp'),

    (v_story_id, 6,
      'La lluvia cayó suave sobre la estación. Desde la curva lateral llegó un brillo: el tren se había detenido junto a un árbol caído. Nadie veía la rama mojada ni a los pajaritos bajo ella. {nombre_farol} quiso ayudar, pero toda su luz seguía apuntando al frente.',
      v_lluvia, array['lluvia'],
      '/images/el-farol-que-miraba-a-los-lados/06-lluvia-tren-arbol-caido.webp'),

    (v_story_id, 7,
      '—Tal vez debes mirar donde hace falta —dijo la niña, sin ordenarle nada. {nombre_farol} sintió calor detrás de su vidrio. Mirar a los lados le parecía perder el rumbo. Pero el tren esperaba, la abuela esperaba, y la lluvia seguía creciendo sobre la rama.',
      null, array[]::text[],
      '/images/el-farol-que-miraba-a-los-lados/07-nina-sugiere-farol.webp'),

    (v_story_id, 8,
      'Con un pequeño chirrido de hierro, {nombre_farol} giró por primera vez. Su luz {color_luz} cruzó la plataforma, rozó las hojas mojadas y llegó hasta la curva. Allí encontró el árbol caído, una bandada de pajaritos empapados y la locomotora esperando pacientemente detrás.',
      null, array[]::text[],
      '/images/el-farol-que-miraba-a-los-lados/08-farol-gira-curva.webp'),

    (v_story_id, 9,
      'La luz mostró a los pasajeros dónde bajar con cuidado. Entre todos apartaron las ramas pequeñas, mientras el conductor movía las ruedas despacito, solo cuando las vías quedaron libres. {nombre_farol} descubrió que su luz no se hacía menor al mirar de lado; alcanzaba rincones que antes ni conocía.',
      v_ruedas, array['ruedas'],
      '/images/el-farol-que-miraba-a-los-lados/09-pasajeros-liberan-vias.webp'),

    (v_story_id, 10,
      'Cuando la última rama se apartó, el tren avanzó hasta {nombre_estacion}. La abuela bajó con un paraguas de lunares y abrazó a la niña. {nombre_farol} vio la sonrisa de las dos, los charcos redondos y los caracoles refugiados bajo el banco. ¡Cuántas cosas hermosas cabían a los lados!',
      null, array[]::text[],
      '/images/el-farol-que-miraba-a-los-lados/10-abuela-abraza-nina.webp'),

    (v_story_id, 11,
      'La niña levantó la mano hacia {nombre_farol}. —Mirar el camino es importante —dijo—, pero mirar alrededor ayuda a saber a quién acompañamos. {nombre_farol} guardó esas palabras como una chispa nueva. Comprendió que alumbrar no era escoger un solo lugar para siempre.',
      null, array[]::text[],
      '/images/el-farol-que-miraba-a-los-lados/11-nina-agradece-farol.webp'),

    (v_story_id, 12,
      'Más tarde, cuando la estación quedó tranquila, los grillos cantaron entre la hierba brillante. {nombre_farol} giró su luz despacio: primero a las vías, luego al banco, después al camino de piedras y finalmente a los nidos bajo el alero. Cada rincón recibió un poquito de claridad.',
      v_grillos, array['grillos'],
      '/images/el-farol-que-miraba-a-los-lados/12-farol-cuida-estacion-noche.webp'),

    (v_story_id, 13,
      'Al día siguiente, el caracol encontró iluminado su paso de baldosas. Las ardillas descubrieron sus bellotas bajo una luz amable. Y cuando el tren volvió a llegar, {nombre_farol} miró adelante con gusto, pero también dejó que su resplandor abrazara todo lo que vivía alrededor.',
      v_tren, array['tren'],
      '/images/el-farol-que-miraba-a-los-lados/13-caracol-ardillas-luz.webp'),

    (v_story_id, 14,
      'Desde entonces, {nombre_farol} siguió siendo el mejor farol de {nombre_estacion}, no porque alumbrara más fuerte, sino porque sabía mirar. Había aprendido que un camino se vuelve más seguro y bonito cuando también vemos a quienes caminan, esperan y sueñan junto a él.',
      null, array[]::text[],
      '/images/el-farol-que-miraba-a-los-lados/14-farol-amanecer-estacion.webp');
end $$;
