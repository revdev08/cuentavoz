-- Cuentavoz: La cometa que aprendió a soltar la cola
-- Protagonista: una cometa. Escenario: colinas de verano y un festival de vuelo.
-- Emoción dominante: libertad. Enseñanza: soltar un poquito no es perder;
-- a veces es dejar espacio para avanzar.

do $$
declare
  v_story_id uuid;
  v_viento uuid;
  v_tela uuid;
  v_campanita uuid;
  v_pajaros uuid;
begin
  --------------------------------------------------
  -- Buscar historia
  --------------------------------------------------
  select id into v_story_id
  from stories
  where slug = 'la-cometa-que-aprendio-a-soltar-la-cola'
  limit 1;

  --------------------------------------------------
  -- Crear historia
  --------------------------------------------------
  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values (
      'La cometa que aprendió a soltar la cola',
      'la-cometa-que-aprendio-a-soltar-la-cola',
      '2-7 años',
      true,
      null,
      'Valores'
    )
    returning id into v_story_id;
  end if;

  --------------------------------------------------
  -- Sonidos nuevos
  --------------------------------------------------
  if not exists (select 1 from sound_effects where nombre = 'viento entre arboles') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('viento entre arboles', '/sounds/viento.mp3', 'ambiente');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'tela al viento') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('tela al viento', '/sounds/tela-al-viento.mp3', 'efecto');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'campanita magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('campanita magica', '/sounds/campanita.mp3', 'efecto');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'pajaros del bosque') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
  end if;

  --------------------------------------------------
  -- Obtener ids
  --------------------------------------------------
  select id into v_viento from sound_effects where nombre = 'viento entre arboles' limit 1;
  select id into v_tela from sound_effects where nombre = 'tela al viento' limit 1;
  select id into v_campanita from sound_effects where nombre = 'campanita magica' limit 1;
  select id into v_pajaros from sound_effects where nombre = 'pajaros del bosque' limit 1;

  --------------------------------------------------
  -- Variables
  --------------------------------------------------
  delete from story_variables where story_id = v_story_id;

  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_cometa', 'texto', array['Aire', 'Mila', 'Vuela', 'Papelina']),
    (v_story_id, 'color_cometa', 'color', array['roja', 'azul', 'amarilla', 'violeta']),
    (v_story_id, 'nombre_colina', 'texto', array['Colina Brisa', 'Loma Clara', 'Monte Nube', 'Prado Volador']);

  --------------------------------------------------
  -- Bloques
  --------------------------------------------------
  delete from story_blocks where story_id = v_story_id;

  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1,
      'En {nombre_colina} vivía {nombre_cometa}, una cometa de papel {color_cometa} con una cola larguísima de cintas. Cada cinta guardaba un recuerdo: una pluma, una hoja brillante, un lazo de cumpleaños. {nombre_cometa} las cuidaba porque creía que perder una sería olvidar para siempre.',
      null, array[]::text[],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/01-cometa-colina-verano.webp'),

    (v_story_id, 2,
      'Cuando el viento pasaba por las hierbas altas, todas las cometas del valle salían a jugar. {nombre_cometa} también quería volar, pero primero revisaba su cola una y otra vez. —No puedo soltar ninguna cinta —decía—. Son demasiado importantes para mí.',
      v_viento, array['viento'],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/02-cometas-juegan-viento.webp'),

    (v_story_id, 3,
      'Llegó el día del Festival de las Cometas. Los niños extendieron mantas sobre la colina, y las familias llevaron pan, frutas y sombreros. A lo lejos, pequeñas campanitas marcaban el inicio de la fiesta. {nombre_cometa} sintió cosquillas de emoción dentro de su papel.',
      v_campanita, array['campanitas'],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/03-festival-cometas-colina.webp'),

    (v_story_id, 4,
      'Una niña sostuvo el hilo de {nombre_cometa} y corrió cuesta abajo. La cometa subió un poco, pero su cola pesaba tanto que arrastraba las cintas entre los dientes de la hierba. Las otras cometas ya dibujaban círculos arriba, ligeras como risas de colores.',
      null, array[]::text[],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/04-cometa-cola-pesada.webp'),

    (v_story_id, 5,
      '—¡Más alto! —pidió la niña. {nombre_cometa} juntó todas sus fuerzas y la tela aleteó con un sonido suave. Por un instante alcanzó a ver el pueblo entero, los tejados, el arroyo y los caminos. Luego una cinta se enredó en un arbusto y la cometa volvió a bajar.',
      v_tela, array['aleteó'],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/05-cometa-ve-pueblo-arriba.webp'),

    (v_story_id, 6,
      'Mientras la niña soltaba el nudo con cuidado, una cometa amarilla aterrizó cerca. No tenía cola, solo un pequeño pompón en la punta. —¿No extrañas cosas para guardar? —preguntó {nombre_cometa}. La amarilla miró el cielo. —Guardo los recuerdos en los lugares donde los viví.',
      null, array[]::text[],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/06-cometa-amarilla-conversa.webp'),

    (v_story_id, 7,
      'Aquella respuesta dejó a {nombre_cometa} pensativa. Miró su cola: la pluma venía del primer día de viento, la hoja del otoño y el lazo de una merienda feliz. De pronto comprendió que ninguno de esos días vivía dentro de las cintas. Vivían todavía en su memoria.',
      null, array[]::text[],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/07-cometa-recuerda-cintas.webp'),

    (v_story_id, 8,
      'El viento cambió y llegó una nube grande desde el otro lado de la colina. Las cometas bajaron antes de que lloviera. Pero la cola de {nombre_cometa} quedó atrapada. La niña tiró con cuidado, y el papel se tensó. Soltar parecía mucho más difícil que guardar.',
      v_viento, array['viento'],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/08-nube-cola-atrapada.webp'),

    (v_story_id, 9,
      'Entonces {nombre_cometa} eligió la cinta más vieja: la pluma del primer vuelo. —Gracias por recordármelo —susurró—, pero ya lo llevo conmigo. La niña desató el nudo y la cinta salió volando hacia un árbol, donde quedó colgada como una banderita pequeña y libre.',
      null, array[]::text[],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/09-pluma-vuela-arbol.webp'),

    (v_story_id, 10,
      'Después soltaron una hoja, luego el lazo y una cinta azul. Cada una encontró un sitio bonito: una rama, una cerca, el sombrero de un espantapájaros. {nombre_cometa} no olvidó nada. Al contrario, sus recuerdos parecieron hacerse más grandes cuando dejaron de pesarle en la cola.',
      null, array[]::text[],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/10-cintas-viajan-colina.webp'),

    (v_story_id, 11,
      'Con apenas tres cintas suaves, {nombre_cometa} volvió a levantar el vuelo. Esta vez la tela aleteó más alto y el viento la llevó por encima de la nube gris. Desde allí vio cómo la lluvia caía lejos, sin alcanzar el festival, como una cortina plateada sobre las montañas.',
      v_tela, array['aleteó'],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/11-cometa-sobre-nube.webp'),

    (v_story_id, 12,
      'Las cometas del valle se reunieron a su alrededor y volaron juntas en una rueda enorme. Abajo, la niña levantó los brazos. {nombre_cometa} entendió que soltar un poquito no era perder: era abrir espacio para sentir el aire, mirar lejos y seguir adelante sin miedo.',
      null, array[]::text[],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/12-cometas-rueda-cielo.webp'),

    (v_story_id, 13,
      'Al atardecer, los pájaros cantaron sobre las cercas donde descansaban algunas cintas. Cada una parecía contar una parte del día sin pedir que la cometa la cargara. {nombre_cometa} sonrió al verlas bailar desde arriba. Los recuerdos podían acompañar también desde lejos.',
      v_pajaros, array['pájaros'],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/13-pajaros-cintas-atardecer.webp'),

    (v_story_id, 14,
      'Desde aquel festival, {nombre_cometa} siguió volando en {nombre_colina} con una cola corta y ligera. Cuando encontraba algo hermoso, lo miraba con atención antes de dejarlo seguir su camino. Había aprendido que conservar un recuerdo no siempre significa cargarlo: a veces significa agradecerlo y soltarlo.',
      null, array[]::text[],
      '/images/la-cometa-que-aprendio-a-soltar-la-cola/14-cometa-vuela-atardecer.webp');
end $$;
