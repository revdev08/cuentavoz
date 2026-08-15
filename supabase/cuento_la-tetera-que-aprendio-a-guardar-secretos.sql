-- Cuentavoz: La tetera que aprendió a guardar secretos
do $$
declare
  v_story_id uuid;
  v_silbido_tetera uuid;
  v_cucharitas_porcelana uuid;
  v_hervor_tetera uuid;
  v_lluvia_techo uuid;
  v_campanita uuid;
begin
  select id into v_story_id from stories where slug = 'la-tetera-que-aprendio-a-guardar-secretos' limit 1;

  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('La tetera que aprendió a guardar secretos', 'la-tetera-que-aprendio-a-guardar-secretos', '2-7 años', true, '/images/portadas/la-tetera-que-aprendio-a-guardar-secretos.webp', 'Valores')
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'silbido de tetera') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('silbido de tetera', '/sounds/silbido-de-tetera.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'cucharitas de porcelana') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('cucharitas de porcelana', '/sounds/cucharitas-de-porcelana.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'hervor de tetera') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('hervor de tetera', '/sounds/hervor-de-tetera.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'lluvia sobre techo') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('lluvia sobre techo', '/sounds/lluvia-sobre-techo.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'campanita magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('campanita magica', '/sounds/campanita-magica.mp3', 'efecto');
  end if;

  select id into v_silbido_tetera from sound_effects where nombre = 'silbido de tetera' limit 1;
  select id into v_cucharitas_porcelana from sound_effects where nombre = 'cucharitas de porcelana' limit 1;
  select id into v_hervor_tetera from sound_effects where nombre = 'hervor de tetera' limit 1;
  select id into v_lluvia_techo from sound_effects where nombre = 'lluvia sobre techo' limit 1;
  select id into v_campanita from sound_effects where nombre = 'campanita magica' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_tetera', 'texto', array['Lola', 'Pipa', 'Menta', 'Chispa']),
    (v_story_id, 'color_tetera', 'color', array['turquesa', 'coral', 'violeta', 'amarilla']),
    (v_story_id, 'nombre_plaza', 'texto', array['Plaza de las Tazas', 'Plaza Manzanilla', 'Plaza del Vapor', 'Plaza Canela']),
    (v_story_id, 'nombre_nino', 'texto', array['Sofía', 'Mateo', 'Valentina', 'Samuel']);

  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'En una cocina diminuta de {nombre_plaza} vivía {nombre_tetera}, una tetera {color_tetera} con una tapa redonda y un gran deseo de ser escuchada. Cuando estaba contenta soltaba un silbido tan largo que las palomas levantaban vuelo y las ventanas parecían sonreír.', v_silbido_tetera, array['silbido'], '/images/la-tetera-que-aprendio-a-guardar-secretos/01-tetera-en-plaza.webp'),
    (v_story_id, 2, 'Cada tarde, la panadera llenaba a {nombre_tetera} con agua, hojas de té y una rodaja de naranja. Las cucharitas bailaban dentro de las tazas mientras los vecinos conversaban. La tetera oía recetas, deseos, planes de cumpleaños y pequeños secretos, todos tibios como la infusión.', v_cucharitas_porcelana, array['cucharitas'], '/images/la-tetera-que-aprendio-a-guardar-secretos/02-tazas-y-cucharitas.webp'),
    (v_story_id, 3, 'Una víspera de feria, {nombre_nino} llegó muy temprano con una caja atada por una cinta. Se acercó a la tetera y susurró: —Mañana vuelve mi abuela. Prepararé una sorpresa en la plaza. Por favor, no se lo cuentes a nadie. {nombre_tetera} hizo vibrar su tapita, orgullosa de aquella confianza.', null, array[]::text[], '/images/la-tetera-que-aprendio-a-guardar-secretos/03-nino-confia-secreto.webp'),
    (v_story_id, 4, 'Al calentarse el agua, el hervor le hizo cosquillas por dentro. {nombre_tetera} recordó la sorpresa y quiso sentirse importante. Sin pensarlo, lanzó un silbido que dibujó en el vapor una frase enorme: «¡Mañana hay una fiesta para la abuela!». La frase trepó sobre los tejados.', v_hervor_tetera, array['hervor'], '/images/la-tetera-que-aprendio-a-guardar-secretos/04-vapor-revela-sorpresa.webp'),
    (v_story_id, 5, 'Las palomas llevaron la noticia hasta el mercado. Antes del mediodía, toda {nombre_plaza} hablaba de cintas, pastel y canciones. {nombre_nino} volvió con la caja entre los brazos y miró el vapor que aún escapaba por la boquilla. No gritó. Solo bajó la vista y la cinta dejó de bailar.', null, array[]::text[], '/images/la-tetera-que-aprendio-a-guardar-secretos/05-sorpresa-descubierta.webp'),
    (v_story_id, 6, 'Entonces {nombre_tetera} comprendió algo que nunca había sentido. Su silbido, que tanto le gustaba, podía pesar como una taza demasiado llena. Quiso esconderse bajo la mesa, pero no cabía. Permaneció quieta junto al fogón, viendo a {nombre_nino} llevar la caja de vuelta a casa.', null, array[]::text[], '/images/la-tetera-que-aprendio-a-guardar-secretos/06-tetera-arrepentida-fogon.webp'),
    (v_story_id, 7, 'Al anochecer, la lluvia comenzó a repiquetear sobre el techo de lata. La feria tendría que esperar. La panadera cerró las contraventanas y dejó a {nombre_tetera} junto al fuego apagado. Afuera, cada gota parecía preguntar: «¿Qué harás cuando alguien vuelva a confiar en ti?»', v_lluvia_techo, array['lluvia'], '/images/la-tetera-que-aprendio-a-guardar-secretos/07-lluvia-en-techo.webp'),
    (v_story_id, 8, 'A la mañana siguiente, una niña de botas amarillas entró temblando. Se inclinó hacia la tetera y dijo que quería cantar en la feria, pero tenía miedo de equivocarse. {nombre_tetera} sintió otra vez las cosquillas del silbido. Esta vez cerró bien su tapa y guardó las palabras en calorcito.', null, array[]::text[], '/images/la-tetera-que-aprendio-a-guardar-secretos/08-nina-canta-confianza.webp'),
    (v_story_id, 9, 'La lluvia cedió justo antes de abrir la plaza. Sobre el fogón, el hervor volvió a subir y el vapor llenó la cocina. Pero {nombre_tetera} no soltó ninguna palabra. Dentro de su tapa, cada secreto se convirtió en una burbuja plateada que flotaba sin romperse, esperando a su dueño.', v_hervor_tetera, array['hervor'], '/images/la-tetera-que-aprendio-a-guardar-secretos/09-burbujas-secretas-tetera.webp'),
    (v_story_id, 10, 'En la feria, algunos niños preguntaron a {nombre_tetera} qué había dicho la niña de botas amarillas. La tetera solo dejó salir un vapor suave con aroma a naranja. —Si alguien quiere contar algo, debe hacerlo con su propia voz —pensó. Guardar un secreto no era quedarse callada por miedo.', null, array[]::text[], '/images/la-tetera-que-aprendio-a-guardar-secretos/10-tetera-guarda-confianza.webp'),
    (v_story_id, 11, 'Cuando llegó su turno, la niña de botas amarillas subió al pequeño escenario. Miró a la gente, respiró y empezó a cantar. Su canción fue breve, pero hizo callar hasta a las palomas. {nombre_tetera} sintió alegría, porque aquel sonido era de la niña, no un secreto suyo.', null, array[]::text[], '/images/la-tetera-que-aprendio-a-guardar-secretos/11-nina-canta-feria.webp'),
    (v_story_id, 12, 'Al caer la tarde, una campanita sonó en la entrada de la plaza. {nombre_nino} apareció con la caja y, detrás, venía su abuela bajo un paraguas azul. Nadie había olvidado la sorpresa: ahora era más grande. Había panes, dibujos y una mesa reservada para recibirla con abrazos.', v_campanita, array['campanita'], '/images/la-tetera-que-aprendio-a-guardar-secretos/12-abuela-llega-plaza.webp'),
    (v_story_id, 13, 'Antes de servir la infusión, {nombre_tetera} llamó a {nombre_nino} con un silbido pequeño, apenas una curva en el aire. —Perdón por contar lo que cuidabas —dijo. {nombre_nino} tocó su asa tibia. —Una palabra confiada se guarda con cuidado, como una taza caliente entre dos manos.', v_silbido_tetera, array['silbido'], '/images/la-tetera-que-aprendio-a-guardar-secretos/13-perdon-tetera-y-nino.webp'),
    (v_story_id, 14, 'Desde entonces, cuando alguien le confiaba algo, {nombre_tetera} lo guardaba hasta que esa persona decidía compartirlo. Y cuando silbaba, solo anunciaba té listo y abrazos cercanos. Había aprendido que ser escuchada no significaba repetirlo todo: significaba cuidar las palabras que llegaban a ella.', v_silbido_tetera, array['silbaba'], '/images/la-tetera-que-aprendio-a-guardar-secretos/14-tetera-te-y-abrazos.webp');
end $$;
