-- Cuentavoz: El lápiz que aprendió a equivocarse
do $$
declare
  v_story_id uuid;
  v_lapiz uuid;
  v_papel uuid;
  v_tijeras uuid;
  v_pajaros uuid;
begin
  select id into v_story_id from stories where slug = 'el-lapiz-que-aprendio-a-equivocarse' limit 1;

  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El lápiz que aprendió a equivocarse', 'el-lapiz-que-aprendio-a-equivocarse', '2-7 años', true, null, 'Valores')
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'lapiz sobre papel') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('lapiz sobre papel', '/sounds/lapiz-sobre-papel.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'papel arrugado') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('papel arrugado', '/sounds/papel-arrugado.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'tijeras de papel') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('tijeras de papel', '/sounds/tijeras-de-papel.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'pajaros del bosque') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
  end if;

  select id into v_lapiz from sound_effects where nombre = 'lapiz sobre papel' limit 1;
  select id into v_papel from sound_effects where nombre = 'papel arrugado' limit 1;
  select id into v_tijeras from sound_effects where nombre = 'tijeras de papel' limit 1;
  select id into v_pajaros from sound_effects where nombre = 'pajaros del bosque' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_lapiz', 'texto', array['Tito', 'Nube', 'Trazo', 'Puntita']),
    (v_story_id, 'color_lapiz', 'color', array['azul', 'rojo', 'verde', 'violeta']),
    (v_story_id, 'nombre_taller', 'texto', array['Taller Manzana', 'Casa de Tintas', 'Mesa de Sol', 'Rincon de Papel']);

  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'En {nombre_taller} vivía {nombre_lapiz}, un lápiz {color_lapiz} que deseaba hacer dibujos perfectos. Cada mañana esperaba dentro de un vaso junto a pinceles y reglas, imaginando castillos rectos, nubes redondas y árboles con todas las hojas en su sitio.', null, array[]::text[], '/images/el-lapiz-que-aprendio-a-equivocarse/01-lapiz-taller-manana.webp'),
    (v_story_id, 2, 'Cuando una niña abría su cuaderno, {nombre_lapiz} se alegraba, pero también temblaba un poco. Le gustaba oír el lápiz rozar el papel, aunque miraba cada línea con cuidado. Si un trazo quedaba torcido, pensaba que todo el dibujo estaba perdido.', v_lapiz, array['lápiz'], '/images/el-lapiz-que-aprendio-a-equivocarse/02-lapiz-dibuja-cuaderno.webp'),
    (v_story_id, 3, 'La niña preparaba una exposición para el taller: quería dibujar el parque que veía desde su ventana. {nombre_lapiz} prometió hacer el árbol más bonito. Empezó un tronco, luego una rama y después otra. Todo iba bien hasta que su punta resbaló hacia un lado.', null, array[]::text[], '/images/el-lapiz-que-aprendio-a-equivocarse/03-punta-resbala-arbol.webp'),
    (v_story_id, 4, 'La raya atravesó el cielo del dibujo y terminó junto a una nube. {nombre_lapiz} se quedó quietísimo. —Lo arruiné —murmuró. La niña miró el papel sin enfadarse, pero él no quiso seguir. Deseaba esconderse bajo la mesa antes de hacer otra equivocación.', null, array[]::text[], '/images/el-lapiz-que-aprendio-a-equivocarse/04-raya-atraviesa-cielo.webp'),
    (v_story_id, 5, 'La niña tomó una hoja nueva y la primera hizo un ruido de papel arrugado al caer en el cesto. {nombre_lapiz} sintió tristeza al escucharla. Cada hoja arrugada le parecía una puerta cerrada. Entonces la niña recogió el dibujo anterior y lo extendió otra vez.', v_papel, array['arrugado'], '/images/el-lapiz-que-aprendio-a-equivocarse/05-hoja-arrugada-cesto.webp'),
    (v_story_id, 6, '—Esta raya se parece a un camino —dijo la niña—. ¿Y si el parque tuviera un camino secreto? {nombre_lapiz} no entendió. Un error no podía ser un camino. Sin embargo, la niña dibujó pequeñas piedras a cada lado y la línea dejó de parecer una intrusa.', null, array[]::text[], '/images/el-lapiz-que-aprendio-a-equivocarse/06-raya-se-vuelve-camino.webp'),
    (v_story_id, 7, 'Animado, {nombre_lapiz} dibujó una puerta diminuta al final del camino. Pero al intentar hacer una ardilla, una oreja quedó enorme y la otra muy pequeña. Esta vez cerró los ojos de grafito. Esperó que la niña pidiera otra hoja.', null, array[]::text[], '/images/el-lapiz-que-aprendio-a-equivocarse/07-ardilla-orejas-distintas.webp'),
    (v_story_id, 8, 'La niña soltó una risita. —Parece que está escuchando dos cosas a la vez. Eso puede ser útil en un parque secreto. {nombre_lapiz} volvió a mirar la ardilla. De pronto, su oreja grande parecía una vela y la pequeña, una pregunta curiosa.', null, array[]::text[], '/images/el-lapiz-que-aprendio-a-equivocarse/08-ardilla-escucha-parque.webp'),
    (v_story_id, 9, 'Poco a poco, los demás materiales quisieron participar. Las tijeras hicieron un suave chasquido al recortar hojas de colores; los pinceles pintaron charcos azules; una goma dejó montañitas de polvo blanco. El dibujo dejó de ser solo del lápiz y se volvió una aventura compartida.', v_tijeras, array['chasquido'], '/images/el-lapiz-que-aprendio-a-equivocarse/09-materiales-crean-parque.webp'),
    (v_story_id, 10, 'Entonces {nombre_lapiz} cometió otro error: dibujó una mancha redonda sobre el sendero. Sintió el viejo miedo, pero respiró y esperó. La niña añadió patas, alas y un pico. La mancha se convirtió en un pájaro gordito que cuidaba la puerta del parque secreto.', null, array[]::text[], '/images/el-lapiz-que-aprendio-a-equivocarse/10-mancha-se-vuelve-pajaro.webp'),
    (v_story_id, 11, 'Cuando terminaron, el dibujo tenía caminos, ardillas curiosas, pájaros que cantaban y árboles inclinados por la brisa. Nada era igual al plan primero. Aun así, parecía un lugar donde cualquiera querría entrar. {nombre_lapiz} comprendió que no todo lo inesperado tenía que borrarse.', v_pajaros, array['pájaros'], '/images/el-lapiz-que-aprendio-a-equivocarse/11-parque-secreto-terminado.webp'),
    (v_story_id, 12, 'En la exposición, una niña pequeña señaló la raya convertida en camino. —Me gusta porque no sabes adónde va —dijo. {nombre_lapiz} escuchó orgulloso. La dueña del cuaderno sonrió y respondió: —A veces una equivocación nos muestra algo que no habíamos imaginado.', null, array[]::text[], '/images/el-lapiz-que-aprendio-a-equivocarse/12-exposicion-ninos-dibujo.webp'),
    (v_story_id, 13, 'Al volver a {nombre_taller}, {nombre_lapiz} ya no miró su punta con miedo. Sabía que podía equivocarse otra vez. Pero también sabía detenerse, observar y preguntar qué nueva idea estaba escondida allí. Su línea ya no buscaba ser perfecta: buscaba estar viva.', null, array[]::text[], '/images/el-lapiz-que-aprendio-a-equivocarse/13-lapiz-vuelve-vaso.webp'),
    (v_story_id, 14, 'Desde ese día, cada vez que una línea salía distinta, {nombre_lapiz} no se escondía. La seguía con curiosidad. Había aprendido que equivocarse no era romper una historia: era abrir una puerta para que apareciera otra, quizá más divertida, más sorprendente y muy suya.', null, array[]::text[], '/images/el-lapiz-que-aprendio-a-equivocarse/14-lapiz-nuevo-dibujo.webp');
end $$;
