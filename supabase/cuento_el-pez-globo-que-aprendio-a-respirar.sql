-- Cuentavoz: El pez globo que aprendió a respirar
do $$
declare
  v_story_id uuid;
  v_burbujas uuid;
  v_corriente uuid;
  v_chapoteo uuid;
begin
  select id into v_story_id from stories where slug = 'el-pez-globo-que-aprendio-a-respirar' limit 1;
  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El pez globo que aprendió a respirar', 'el-pez-globo-que-aprendio-a-respirar', '2-7 años', true, '/images/portadas/el-pez-globo-que-aprendio-a-respirar.webp', 'Emociones') returning id into v_story_id;
  end if;
  if not exists (select 1 from sound_effects where nombre = 'burbujas marinas') then insert into sound_effects (nombre, archivo_url, categoria) values ('burbujas marinas', '/sounds/burbujas-marinas.mp3', 'efecto'); end if;
  if not exists (select 1 from sound_effects where nombre = 'corriente marina') then insert into sound_effects (nombre, archivo_url, categoria) values ('corriente marina', '/sounds/corriente-marina.mp3', 'ambiente'); end if;
  if not exists (select 1 from sound_effects where nombre = 'chapoteo') then insert into sound_effects (nombre, archivo_url, categoria) values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto'); end if;
  select id into v_burbujas from sound_effects where nombre = 'burbujas marinas' limit 1;
  select id into v_corriente from sound_effects where nombre = 'corriente marina' limit 1;
  select id into v_chapoteo from sound_effects where nombre = 'chapoteo' limit 1;
  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_pez', 'texto', array['Pipo', 'Bombo', 'Nilo', 'Lumi']),
    (v_story_id, 'color_pez', 'color', array['amarillo', 'turquesa', 'violeta', 'coral']),
    (v_story_id, 'nombre_arrecife', 'texto', array['Arrecife Susurro', 'Coral Azul', 'Bahía Brillante', 'Jardín de Olas']);
  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'En {nombre_arrecife} vivía {nombre_pez}, un pez globo {color_pez} con ocho aletas pequeñas y una costumbre enorme: se inflaba por cualquier cosa. Si una sombra cruzaba el coral, ¡puf! Si una concha rodaba, ¡puf! Quería sentirse preparado para todo.', null, array[]::text[], '/images/el-pez-globo-que-aprendio-a-respirar/01-pez-globo-arrecife.webp'),
    (v_story_id, 2, 'Sus amigos lo querían mucho, aunque a veces debían apartarse cuando él crecía como una pelota. {nombre_pez} no lo hacía para molestar. Pensaba que inflarse era la única manera de ser valiente. Nadie le había mostrado que la calma también puede cuidar.', null, array[]::text[], '/images/el-pez-globo-que-aprendio-a-respirar/02-pez-globo-amigos.webp'),
    (v_story_id, 3, 'Una mañana, cientos de burbujas subieron desde una grieta del fondo. {nombre_pez} dio un salto y se infló tanto que quedó atrapado entre dos abanicos de coral. Los pececitos rieron con cariño, pero él no podía moverse ni mirar a dónde iba.', v_burbujas, array['burbujas'], '/images/el-pez-globo-que-aprendio-a-respirar/03-burbujas-coral.webp'),
    (v_story_id, 4, '—Solo quería estar listo —dijo {nombre_pez} cuando por fin se desinfló. La tortuga de la limpieza no respondió con consejos; siguió mordisqueando algas cerca de una roca. Entonces el pez notó su ritmo: una mordida, una pausa, otra mordida, otra pausa.', null, array[]::text[], '/images/el-pez-globo-que-aprendio-a-respirar/04-tortuga-ritmo-algas.webp'),
    (v_story_id, 5, 'Al día siguiente, una corriente movió las algas como largas cintas verdes. {nombre_pez} quiso inflarse, pero recordó las pausas. Contó una, dos, tres respiraciones y dejó salir aire despacio. La corriente pasó sobre sus escamas sin empujarlo ni asustarlo.', v_corriente, array['corriente'], '/images/el-pez-globo-que-aprendio-a-respirar/05-corriente-algas-verdes.webp'),
    (v_story_id, 6, 'Aquella tarde llegó la noticia de que habría una carrera de caracoles marinos. {nombre_pez} quiso ayudar a decorar la salida con conchas. Mientras llevaba una estrella de mar de papel, una anguila salió de una cueva. ¡Puf! El pez se infló de nuevo.', null, array[]::text[], '/images/el-pez-globo-que-aprendio-a-respirar/06-anguila-sorpresa.webp'),
    (v_story_id, 7, 'La estrella de papel quedó flotando sobre su cabeza y los caracoles se escondieron bajo sus caparazones. {nombre_pez} cerró los ojos. Esta vez no intentó fingir que nada pasaba. Dejó salir una burbuja, luego otra, hasta recuperar su tamaño de siempre.', v_burbujas, array['burbuja'], '/images/el-pez-globo-que-aprendio-a-respirar/07-estrella-papel-burbujas.webp'),
    (v_story_id, 8, '—No sabía que se podía ser valiente sin hacerse gigante —dijo. Los caracoles asomaron sus antenas. {nombre_pez} recogió la estrella y pidió perdón. Después la colocó junto a las conchas, con mucho cuidado. Ya no quería que el miedo decidiera por él.', null, array[]::text[], '/images/el-pez-globo-que-aprendio-a-respirar/08-pez-pide-perdon.webp'),
    (v_story_id, 9, 'La carrera comenzó lentamente. Todos animaban a los caracoles, que avanzaban dejando hilos brillantes sobre la arena. De pronto una ola pequeña levantó el cartel de salida. {nombre_pez} sintió cosquillas de miedo en la barriga, pero no se infló enseguida.', null, array[]::text[], '/images/el-pez-globo-que-aprendio-a-respirar/09-carrera-caracoles.webp'),
    (v_story_id, 10, 'Primero miró. Luego respiró. Al ver que el cartel caería sobre una caracola, nadó rápido y lo sostuvo con la cola. El agua hizo chapoteo alrededor, pero todos siguieron seguros. {nombre_pez} descubrió que una aleta tranquila podía ayudar mejor que un cuerpo enorme.', v_chapoteo, array['chapoteo'], '/images/el-pez-globo-que-aprendio-a-respirar/10-pez-sostiene-cartel.webp'),
    (v_story_id, 11, 'Los amigos aplaudieron con sus aletas. La tortuga se acercó, sonriendo. —Ser valiente no es no sentir susto —dijo—. Es darse un momento para respirar antes de decidir. {nombre_pez} repitió la frase bajito, como si fuera una canción para sus escamas.', null, array[]::text[], '/images/el-pez-globo-que-aprendio-a-respirar/11-amigos-aplauden-arrecife.webp'),
    (v_story_id, 12, 'Al caer la tarde, la carrera terminó en un empate perfecto. Los caracoles celebraron con una corona de algas y compartieron su merienda. {nombre_pez} no necesitó ser el más grande del arrecife. Se sentía ligero, atento y orgulloso de su nueva pausa.', null, array[]::text[], '/images/el-pez-globo-que-aprendio-a-respirar/12-caracoles-celebran.webp'),
    (v_story_id, 13, 'Desde entonces, cada vez que una sombra aparecía o una concha rodaba, {nombre_pez} hacía tres respiraciones antes de elegir. Algunas veces todavía se inflaba un poquito, porque aprender toma tiempo. Pero ahora sus amigos sabían cómo acompañarlo y él sabía cómo volver a calmarse.', null, array[]::text[], '/images/el-pez-globo-que-aprendio-a-respirar/13-tres-respiraciones.webp'),
    (v_story_id, 14, 'En {nombre_arrecife}, los niños peces empezaron a jugar a las burbujas lentas: una para mirar, otra para respirar y otra para decidir. {nombre_pez} guiaba el juego con una sonrisa. Había aprendido que la calma no apaga el valor: le enseña por dónde nadar.', v_burbujas, array['burbujas'], '/images/el-pez-globo-que-aprendio-a-respirar/14-juego-burbujas-lentas.webp');
end $$;
