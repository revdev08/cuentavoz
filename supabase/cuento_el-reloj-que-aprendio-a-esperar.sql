-- Cuentavoz: El reloj que aprendió a esperar
-- Protagonista: un reloj de pared. Escenario: una panadería al amanecer.
-- Emoción dominante: calma. Enseñanza: cada cosa buena tiene su tiempo.
-- Las imágenes se agregarán posteriormente; todas las rutas ya apuntan a WebP.

do $$
declare
  v_story_id uuid;
  v_tictac uuid;
  v_amasado uuid;
  v_horno uuid;
  v_campanada uuid;
  v_crujido uuid;
  v_pajaros uuid;
begin
  select id into v_story_id
  from stories
  where slug = 'el-reloj-que-aprendio-a-esperar'
  limit 1;

  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El reloj que aprendió a esperar', 'el-reloj-que-aprendio-a-esperar', '2-7 años', true, null, 'Valores')
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'tictac de reloj') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('tictac de reloj', '/sounds/tictac-de-reloj.mp3', 'ambiente');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'amasado de masa') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('amasado de masa', '/sounds/amasado-de-masa.mp3', 'efecto');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'horno crepitante') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('horno crepitante', '/sounds/horno-crepitante.mp3', 'ambiente');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'campanada de reloj') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('campanada de reloj', '/sounds/campanada-de-reloj.mp3', 'efecto');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'crujido') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('crujido', '/sounds/crujido.mp3', 'efecto');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'pajaros del bosque') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
  end if;

  select id into v_tictac from sound_effects where nombre = 'tictac de reloj' limit 1;
  select id into v_amasado from sound_effects where nombre = 'amasado de masa' limit 1;
  select id into v_horno from sound_effects where nombre = 'horno crepitante' limit 1;
  select id into v_campanada from sound_effects where nombre = 'campanada de reloj' limit 1;
  select id into v_crujido from sound_effects where nombre = 'crujido' limit 1;
  select id into v_pajaros from sound_effects where nombre = 'pajaros del bosque' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_reloj', 'texto', array['Tic', 'Toto', 'Minuto', 'Relojín']),
    (v_story_id, 'nombre_panaderia', 'texto', array['La Espiga', 'El Horno Azul', 'Pan de Luna', 'La Miga Feliz']),
    (v_story_id, 'pan_favorito', 'texto', array['pan redondo', 'pan de canela', 'pan de queso', 'pan de miel']);

  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1,
      'En la pared más alta de {nombre_panaderia} vivía {nombre_reloj}, un reloj de madera que conocía los secretos de la mañana. Antes de que saliera el sol, ya había contado los bostezos de la panadera, el agua que hervía, las primeras migas y los pasos que se acercaban por la calle.',
      null, array[]::text[],
      '/images/el-reloj-que-aprendio-a-esperar/01-reloj-pared-panaderia.webp'),

    (v_story_id, 2,
      'Lo que más le gustaba era esperar el pan favorito de la casa: {pan_favorito}. Sabía que, cuando estuviera listo, todo el barrio olería a desayuno. Los vecinos aparecerían con sueño en los ojos y bolsas en las manos. Pero a {nombre_reloj} aquella espera le parecía siempre demasiado larga.',
      null, array[]::text[],
      '/images/el-reloj-que-aprendio-a-esperar/02-reloj-espera-pan-favorito.webp'),

    (v_story_id, 3,
      'Cada mañana hacía su tictac paciente mientras la panadera mezclaba harina, agua y levadura. —Las cosas buenas saben llegar a su hora —decía ella sin mirar arriba. {nombre_reloj} asentía con sus manecillas, pero por dentro deseaba que la masa subiera, el pan se dorara y la mañana corriera más rápido.',
      v_tictac, array['tictac'],
      '/images/el-reloj-que-aprendio-a-esperar/03-panadera-mezcla-masa-tictac.webp'),

    (v_story_id, 4,
      'Un lunes de lluvia, la masa subía tan lentamente que parecía estar soñando en su tazón. {nombre_reloj} miró el mostrador vacío, miró las gotas resbalar detrás de la ventana y escuchó a la panadera tararear sin ninguna prisa. Entonces decidió que no podía soportar ni un minuto más.',
      null, array[]::text[],
      '/images/el-reloj-que-aprendio-a-esperar/04-masa-lenta-lluvia-ventana.webp'),

    (v_story_id, 5,
      'Sin que nadie lo notara, empujó su manecilla larga un poquito hacia adelante. Luego otro poquito. El tiempo dio un saltito dentro de la panadería. —¡Ya es hora de hornear! —dijo la panadera, sorprendida, al oír la marca que le indicaba empezar. El reloj sintió un orgullo pequeño y secreto.',
      null, array[]::text[],
      '/images/el-reloj-que-aprendio-a-esperar/05-reloj-empuja-manecilla-adelante.webp'),

    (v_story_id, 6,
      'La panadera sacó la masa del tazón y comenzó el amasado sobre la mesa de madera. La masa todavía estaba pegajosa y torpe, como si no quisiera separarse de las manos que la sostenían. Pero {nombre_reloj} se dijo que, si todos se daban prisa, seguro quedaría igual de bien.',
      v_amasado, array['amasado'],
      '/images/el-reloj-que-aprendio-a-esperar/06-amasado-masa-mesa-madera.webp'),

    (v_story_id, 7,
      'El pan entró al horno demasiado pronto. Durante un rato, el fuego crepitaba detrás de la puertecita de hierro y el reloj esperó orgulloso. Imaginaba a los vecinos haciendo fila, felices por recibir el desayuno antes que nunca. Nunca se preguntó si el pan también necesitaba tener su propio tiempo.',
      v_horno, array['crepitaba'],
      '/images/el-reloj-que-aprendio-a-esperar/07-pan-temprano-horno-crepitante.webp'),

    (v_story_id, 8,
      'Pero al abrir el horno, la panadera guardó silencio. El pan estaba pálido por dentro y duro por fuera. No olía a canela ni a miel; olía a algo que todavía no estaba listo. {nombre_reloj} bajó sus manecillas despacito. De pronto, todos los minutos que había empujado parecieron pesarle mucho.',
      null, array[]::text[],
      '/images/el-reloj-que-aprendio-a-esperar/08-pan-palida-panadera-silenciosa.webp'),

    (v_story_id, 9,
      'La puerta de la panadería crujió y entró una niña con una bufanda amarilla. —¿Ya está mi {pan_favorito}? —preguntó. La panadera explicó lo ocurrido y ofreció otro pan. La niña sonrió con educación, pero sus ojos buscaron la bandeja vacía, y el reloj no pudo olvidar aquella esperanza.',
      v_crujido, array['crujió'],
      '/images/el-reloj-que-aprendio-a-esperar/09-nina-pregunta-pan-panaderia.webp'),

    (v_story_id, 10,
      'Entonces {nombre_reloj} comprendió que su prisa no había acortado la espera: la había hecho más larga para todos. Quiso deshacer sus minutos, pero las manecillas no sabían caminar hacia atrás. Solo podían seguir hacia adelante. Por primera vez, el reloj se preguntó qué significaba cuidar bien el próximo instante.',
      null, array[]::text[],
      '/images/el-reloj-que-aprendio-a-esperar/10-reloj-comprende-prisa.webp'),

    (v_story_id, 11,
      'Afuera, los pájaros comenzaron a cantar sobre el tejado mojado. {nombre_reloj} los escuchó uno por uno: ninguno apuraba al otro, ninguno llegaba antes de saber su canción. Cada trino aparecía cuando tenía que aparecer y, juntos, hacían una mañana más bonita que el silencio o la prisa.',
      v_pajaros, array['pájaros'],
      '/images/el-reloj-que-aprendio-a-esperar/11-pajaros-tejado-lluvia.webp'),

    (v_story_id, 12,
      'Por primera vez, {nombre_reloj} dejó quieta su manecilla larga. Observó cómo la panadera preparaba una masa nueva, con calma y con cuidado. Esta vez no quiso mandar ni adelantar nada. Solo quiso acompañar el trabajo con un tictac sereno, como los pájaros acompañaban aquella mañana lluviosa desde el tejado.',
      v_tictac, array['tictac'],
      '/images/el-reloj-que-aprendio-a-esperar/12-reloj-tictac-sereno-masa-nueva.webp'),

    (v_story_id, 13,
      'La masa creció despacio, como una almohada que aprende a respirar. Cuando la panadera la tocó, sonrió. —Ahora sí —susurró—. Ya nos contó que está preparada. {nombre_reloj} sintió que aquella frase también era para él. Prepararse no era correr: era llegar de verdad al momento indicado.',
      null, array[]::text[],
      '/images/el-reloj-que-aprendio-a-esperar/13-masa-crece-panadera-sonrie.webp'),

    (v_story_id, 14,
      'El nuevo pan entró al horno. Esta vez el fuego crepitaba sin apuro y el aroma empezó a llenar cada rincón de {nombre_panaderia}. {nombre_reloj} no empujó ningún minuto. Se limitó a contar, con atención y cariño, el tiempo que el pan necesitaba. Cada vuelta de sus manecillas se sintió importante.',
      v_horno, array['crepitaba'],
      '/images/el-reloj-que-aprendio-a-esperar/14-pan-horno-aroma-panaderia.webp'),

    (v_story_id, 15,
      'Cuando por fin llegó la hora, {nombre_reloj} dejó caer una campanada clara. La niña de la bufanda amarilla seguía allí, sentada junto a la ventana, mirando la lluvia. La panadera puso en sus manos un pan tibio, redondo y perfumado. Esta vez, el olor llenó la habitación como una bienvenida.',
      v_campanada, array['campanada'],
      '/images/el-reloj-que-aprendio-a-esperar/15-campanada-nina-recibe-pan.webp'),

    (v_story_id, 16,
      'La niña partió el pan por la mitad y ofreció una parte a la panadera. —Esperar no es quedarse sin hacer nada —dijo—. Es cuidar que algo tenga el tiempo que necesita. La panadera miró al reloj y le guiñó un ojo. {nombre_reloj} entendió que la paciencia también podía compartirse.',
      null, array[]::text[],
      '/images/el-reloj-que-aprendio-a-esperar/16-nina-comparte-pan-ensena.webp'),

    (v_story_id, 17,
      'Desde aquel día, {nombre_reloj} siguió contando las mañanas en {nombre_panaderia}. Ya no deseaba empujar las horas ni ganarle al sol. Había aprendido que esperar con cariño también era una forma de ayudar, porque las cosas que llegan a su tiempo pueden ser las más deliciosas y las más recordadas.',
      null, array[]::text[],
      '/images/el-reloj-que-aprendio-a-esperar/17-reloj-amanecer-panaderia.webp');
end $$;
