-- Cuentavoz: El cactus que aprendió a abrazar
do $$
declare
  v_story_id uuid;
  v_viento_desierto uuid;
  v_pasos_arena uuid;
  v_grillos_nocturnos uuid;
begin
  select id into v_story_id from stories where slug = 'el-cactus-que-aprendio-a-abrazar' limit 1;

  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El cactus que aprendió a abrazar', 'el-cactus-que-aprendio-a-abrazar', '2-7 años', true, '/images/portadas/el-cactus-que-aprendio-a-abrazar.webp', 'Valores')
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'viento del desierto') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('viento del desierto', '/sounds/viento-del-desierto.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'pasos sobre arena') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('pasos sobre arena', '/sounds/pasos-sobre-arena.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'grillos nocturnos') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('grillos nocturnos', '/sounds/grillos-nocturnos.mp3', 'ambiente');
  end if;

  select id into v_viento_desierto from sound_effects where nombre = 'viento del desierto' limit 1;
  select id into v_pasos_arena from sound_effects where nombre = 'pasos sobre arena' limit 1;
  select id into v_grillos_nocturnos from sound_effects where nombre = 'grillos nocturnos' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_cactus', 'texto', array['Púa', 'Nopal', 'Tito', 'Menta']),
    (v_story_id, 'color_flor', 'color', array['coral', 'amarilla', 'violeta', 'rosada']),
    (v_story_id, 'nombre_oasis', 'texto', array['Oasis de las Dunas', 'Oasis Cantarín', 'Oasis de la Luna', 'Oasis de los Susurros']),
    (v_story_id, 'nombre_lagartija', 'animal', array['Lina', 'Rulo', 'Milo', 'Senda']);

  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'En las dunas doradas de {nombre_oasis} crecía {nombre_cactus}, un cactus alto con una flor {color_flor} en la cabeza. Cada tarde veía a los viajeros despedirse con abrazos suaves. Él los miraba contento por ellos, aunque por dentro guardaba una pregunta que pinchaba.', null, array[]::text[], '/images/el-cactus-que-aprendio-a-abrazar/01-cactus-dunas.webp'),
    (v_story_id, 2, '—¿Cómo se sentirá un abrazo? —se preguntaba {nombre_cactus}. Sus brazos eran redondos, sus espinas eran puntiagudas y nadie podía acercarse demasiado. Aun así, imaginaba que un abrazo sería como guardar un pedacito de sol sin que se escapara por ninguna rendija.', null, array[]::text[], '/images/el-cactus-que-aprendio-a-abrazar/02-cactus-suena-abrazo.webp'),
    (v_story_id, 3, 'Una mañana llegó {nombre_lagartija}, una lagartija pequeña que viajaba entre las piedras calientes. Caminaba despacio porque llevaba una concha a la espalda para protegerse del sol. Sus pasos dejaban puntitos diminutos sobre la arena, como si alguien hubiera escrito una carta invisible.', v_pasos_arena, array['pasos'], '/images/el-cactus-que-aprendio-a-abrazar/03-lagartija-llega.webp'),
    (v_story_id, 4, '—¡Bienvenida! —dijo {nombre_cactus}, emocionado—. Creo que ya sé cómo saludar. Abrió sus brazos cuanto pudo y avanzó un poquito. {nombre_lagartija} dio un salto hacia atrás justo a tiempo. Una espina rozó su concha y dejó un rasguño muy fino.', null, array[]::text[], '/images/el-cactus-que-aprendio-a-abrazar/04-espinas-rasguno.webp'),
    (v_story_id, 5, 'El cactus se quedó inmóvil. No había querido lastimarla. {nombre_lagartija} no estaba enfadada, pero mantuvo una distancia prudente. —Quizá tus abrazos necesitan otra forma —dijo con amabilidad. {nombre_cactus} bajó la flor. Pensó que, si no podía abrazar como los demás, tal vez nunca sería cercano a nadie.', null, array[]::text[], '/images/el-cactus-que-aprendio-a-abrazar/05-cactus-triste.webp'),
    (v_story_id, 6, 'Durante el día, {nombre_cactus} escondió sus brazos detrás de unas rocas. Ni siquiera quiso hablar con las hormigas que pasaban. Al atardecer, el viento recorrió las dunas y las hizo cantar con un silbido largo. Pero él cerró los ojos para no escuchar aquella música.', v_viento_desierto, array['viento'], '/images/el-cactus-que-aprendio-a-abrazar/06-viento-dunas.webp'),
    (v_story_id, 7, 'Cuando cayó la noche, {nombre_lagartija} volvió al oasis. La arena seguía tibia, pero el aire se había vuelto frío. Buscó una piedra donde dormir y encontró todas ocupadas por escarabajos. Los grillos cantaban cerca del agua, mientras la pequeña lagartija temblaba bajo su concha.', v_grillos_nocturnos, array['grillos'], '/images/el-cactus-que-aprendio-a-abrazar/07-lagartija-tiene-frio.webp'),
    (v_story_id, 8, 'Desde detrás de las rocas, {nombre_cactus} la vio encogerse. Quiso correr a envolverla, pero recordó el rasguño. Entonces pensó en otra cosa: sus brazos también podían hacer sombra de noche y guardar el calor que el suelo había juntado durante el día.', null, array[]::text[], '/images/el-cactus-que-aprendio-a-abrazar/08-cactus-piensa.webp'),
    (v_story_id, 9, '—{nombre_lagartija}, ¿te gustaría descansar cerca de mí? —preguntó sin moverse—. No voy a tocarte. Puedo cuidar un espacio tibio. La lagartija observó las espinas, luego la voz temblorosa del cactus. Finalmente asintió y se acomodó a una distancia segura bajo uno de sus brazos.', null, array[]::text[], '/images/el-cactus-que-aprendio-a-abrazar/09-sombra-tibia.webp'),
    (v_story_id, 10, 'El cactus se quedó muy quieto toda la noche. Con sus brazos formó una pequeña cueva de sombra y calor. {nombre_lagartija} dejó de temblar, sacó la nariz de la concha y sonrió. Nunca nadie le había ofrecido un sitio tan cuidadoso sin pedirle que fuera distinta.', null, array[]::text[], '/images/el-cactus-que-aprendio-a-abrazar/10-cueva-de-sombra.webp'),
    (v_story_id, 11, 'Al amanecer, el viento volvió entre las dunas, esta vez suave como una canción de cuna. {nombre_cactus} abrió los ojos y descubrió que su flor {color_flor} tenía otras tres compañeras. Habían brotado durante la noche, pequeñas y valientes, alrededor de sus brazos abiertos.', v_viento_desierto, array['viento'], '/images/el-cactus-que-aprendio-a-abrazar/11-flores-al-amanecer.webp'),
    (v_story_id, 12, 'Los viajeros que pasaban por {nombre_oasis} vieron aquel refugio y se acercaron con cuidado. Un ratón descansó junto a una raíz; una mariposa se posó en una flor; dos escarabajos compartieron la sombra. Nadie tocó las espinas, pero todos sintieron que el cactus los recibía.', null, array[]::text[], '/images/el-cactus-que-aprendio-a-abrazar/12-refugio-en-oasis.webp'),
    (v_story_id, 13, '—Ahora lo entiendo —dijo {nombre_cactus} a {nombre_lagartija}—. Acercarse no siempre es apretar fuerte. A veces es preguntar primero, dejar espacio y quedarse cerca de la manera que ayuda. La lagartija rozó su concha contra la tierra y respondió: —Ese también es un abrazo.', null, array[]::text[], '/images/el-cactus-que-aprendio-a-abrazar/13-abrazo-de-sombra.webp'),
    (v_story_id, 14, 'Desde entonces, {nombre_cactus} no dejó de tener espinas ni quiso esconderlas. Solo aprendió a abrir sus brazos con cuidado. Cuando alguien necesitaba descanso, ofrecía su abrazo de sombra. Y cada visitante recordaba que querer bien era acercarse sin lastimar y hacer sitio para el otro.', null, array[]::text[], '/images/el-cactus-que-aprendio-a-abrazar/14-oasis-amigos.webp');
end $$;
