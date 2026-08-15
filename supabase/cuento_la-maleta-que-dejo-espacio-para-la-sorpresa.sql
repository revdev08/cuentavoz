-- Cuentavoz: La maleta que dejó espacio para la sorpresa
do $$
declare
  v_story_id uuid;
  v_silbato_estacion uuid;
  v_cremallera_maleta uuid;
  v_traqueteo_tren uuid;
  v_lluvia_vagon uuid;
begin
  select id into v_story_id from stories where slug = 'la-maleta-que-dejo-espacio-para-la-sorpresa' limit 1;

  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('La maleta que dejó espacio para la sorpresa', 'la-maleta-que-dejo-espacio-para-la-sorpresa', '2-7 años', true, '/images/portadas/la-maleta-que-dejo-espacio-para-la-sorpresa.webp', 'Aventuras')
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'silbato de estacion') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('silbato de estacion', '/sounds/silbato-de-estacion.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'cremallera de maleta') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('cremallera de maleta', '/sounds/cremallera-de-maleta.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'traqueteo de tren') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('traqueteo de tren', '/sounds/traqueteo-de-tren.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'lluvia sobre vagon') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('lluvia sobre vagon', '/sounds/lluvia-sobre-vagon.mp3', 'ambiente');
  end if;

  select id into v_silbato_estacion from sound_effects where nombre = 'silbato de estacion' limit 1;
  select id into v_cremallera_maleta from sound_effects where nombre = 'cremallera de maleta' limit 1;
  select id into v_traqueteo_tren from sound_effects where nombre = 'traqueteo de tren' limit 1;
  select id into v_lluvia_vagon from sound_effects where nombre = 'lluvia sobre vagon' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_maleta', 'texto', array['Mora', 'Pipa', 'Lola', 'Tina']),
    (v_story_id, 'color_maleta', 'color', array['roja', 'turquesa', 'amarilla', 'violeta']),
    (v_story_id, 'nombre_tren', 'texto', array['Tren de los Álamos', 'Tren Luciérnaga', 'Tren del Norte', 'Tren de las Colinas']),
    (v_story_id, 'nombre_nino', 'texto', array['Sofía', 'Mateo', 'Valentina', 'Samuel']),
    (v_story_id, 'pueblo_destino', 'texto', array['Pueblo de las Ventanas', 'Villa Azafrán', 'Puerto de Nubes', 'Pueblo del Puente']);

  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'En la estación pequeña donde dormía {nombre_tren} vivía {nombre_maleta}, una maleta {color_maleta} que adoraba ir llena. Guardaba una bufanda, un farol, tres botones y una taza, por si acaso. Pensaba que viajar preparado era no dejar ni un rincón vacío.', null, array[]::text[], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/01-maleta-en-estacion.webp'),
    (v_story_id, 2, 'Sus bolsillos estaban tan apretados que una pluma asomaba por la cremallera y una galleta dormía junto a un calcetín. {nombre_maleta} se sentía importante con tanto equipaje. No sabía que algunas cosas viajan mejor cuando tienen aire para moverse y sitio para sorprender.', null, array[]::text[], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/02-maleta-repleta.webp'),
    (v_story_id, 3, 'Una mañana, {nombre_nino} la eligió para viajar hasta {pueblo_destino}. Dentro puso una muda de ropa, un cuaderno de dibujo y una pequeña caja de lápices. {nombre_maleta} quiso hacer sitio, pero sus recuerdos y sus por-si-acaso formaban una montaña imposible de ordenar.', null, array[]::text[], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/03-nino-elige-maleta.webp'),
    (v_story_id, 4, 'En el andén, el silbato anunció la salida. {nombre_nino} apretó la tapa de la maleta con ambas manos. {nombre_maleta} hizo fuerza desde dentro, pero nada. La bufanda empujaba el farol, la taza empujaba los botones y el cuaderno quedó atrapado bajo todo aquello.', v_silbato_estacion, array['silbato'], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/04-silbato-salida.webp'),
    (v_story_id, 5, 'Entonces la cremallera protestó con un sonido largo: ¡crrrr! Se cerró apenas un dedo y volvió a abrirse. {nombre_maleta} sintió mucha vergüenza. El tren esperaba, la gente subía y ella parecía una ballena con demasiadas cosas en la panza. ¿Para qué servía guardar tanto?', v_cremallera_maleta, array['cremallera'], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/05-cremallera-protesta.webp'),
    (v_story_id, 6, '{nombre_nino} no se enfadó. Sacó la bufanda y se la puso al cuello. Sacó la taza y la compartió con una señora que llevaba té caliente. Luego miró el farol. —No todo tiene que ir escondido —dijo—. Algunas cosas pueden acompañarnos de otra manera.', null, array[]::text[], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/06-objetos-acompanan.webp'),
    (v_story_id, 7, 'Por fin, la tapa cerró sin pelear. Desde la repisa, {nombre_maleta} sintió el traqueteo de las ruedas al cruzar campos verdes y puentes de hierro. Tenía menos cosas dentro, pero el viaje parecía más grande. Por primera vez, un bolsillo respiraba tranquilo junto al cuaderno.', v_traqueteo_tren, array['traqueteo'], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/07-tren-por-campos.webp'),
    (v_story_id, 8, 'Al entrar en un túnel, el vagón quedó oscuro. {nombre_nino} encendió el farol y su luz dibujó círculos suaves sobre los asientos. Una niña mostró una figura de papel que había hecho con su boleto. Parecía un pájaro, aunque todavía no sabía cómo abrir las alas.', null, array[]::text[], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/08-farol-en-tunel.webp'),
    (v_story_id, 9, 'Cuando salieron del túnel, una lluvia fina empezó a golpear las ventanas. La niña protegió su pájaro de papel bajo las manos, pero el agua entraba por una rendija. {nombre_maleta} recordó su bolsillo vacío. Quiso ayudar enseguida, aunque aún no sabía exactamente cómo.', v_lluvia_vagon, array['lluvia'], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/09-lluvia-en-vagon.webp'),
    (v_story_id, 10, '—Aquí cabe —dijo {nombre_nino}, abriendo el bolsillo libre de {nombre_maleta}. La niña guardó su pájaro de papel junto al cuaderno y los lápices. Todos lo miraron con cuidado, como si aquel rincón fuera un nido. La maleta descubrió que un espacio vacío podía proteger algo querido.', null, array[]::text[], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/10-bolsillo-nido.webp'),
    (v_story_id, 11, 'Durante el resto del viaje, el pájaro quedó quieto y seco. {nombre_nino} dibujó para él unas alas enormes y la niña añadió plumas con los lápices. Cuando el traqueteo del tren volvió sobre un puente, el papel se levantó un poquito y pareció ensayar su primer vuelo.', v_traqueteo_tren, array['traqueteo'], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/11-pajaro-ensaya-vuelo.webp'),
    (v_story_id, 12, 'Al llegar a {pueblo_destino}, la lluvia había parado. La niña abrió el bolsillo y sacó su pájaro. Lo lanzó hacia una corriente de aire y las alas de papel dieron dos vueltas alegres sobre el andén. {nombre_maleta} sintió algo nuevo: orgullo por no estar completamente llena.', null, array[]::text[], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/12-pajaro-en-anden.webp'),
    (v_story_id, 13, 'Antes de despedirse, la señora del té sonrió a {nombre_maleta}. —Prepararse es bueno —dijo—, pero dejar lugar también lo es. Así las sorpresas tienen dónde sentarse. {nombre_maleta} miró su bolsillo libre y comprendió que no era un hueco: era una bienvenida.', null, array[]::text[], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/13-sorpresa-tiene-sitio.webp'),
    (v_story_id, 14, 'Desde aquel viaje, {nombre_maleta} seguía llevando lo necesario, pero reservaba un rincón para lo que nadie podía planear. A veces guardaba un dibujo, otras una flor o un pájaro de papel. Había aprendido que dejar espacio no era olvidar algo: era estar lista para recibirlo.', null, array[]::text[], '/images/la-maleta-que-dejo-espacio-para-la-sorpresa/14-maleta-lista-para-viajar.webp');
end $$;
