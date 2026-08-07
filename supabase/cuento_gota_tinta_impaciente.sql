-- Primer cuento del catálogo reiniciado: "La gota de tinta impaciente".
-- Enseñanza: lo que se hace con calma, casi siempre se hace bien -- la
-- paciencia no es perder el tiempo, es la manera de llegar a ser algo
-- hermoso.
--
-- Protagonista: una gota de tinta (no un niño ni un animal). Escenario:
-- un escritorio junto a una ventana, de noche (interior, no bosque/mar,
-- distinto a todo lo anterior). Conflicto: impaciencia / aprender a
-- esperar. Magia: tinta (la gota se convierte en un dibujo real, pero
-- solo porque decide esperar, no por arte de magia sola). Quien
-- transmite la enseñanza: un reloj de péndulo (objeto, no un animal
-- sabio ni un adulto). Emoción principal: ternura. Cierre: una
-- costumbre nueva (esperar el momento justo antes de empezar cualquier
-- historia), no un objeto para guardar.
--
-- Escena memorable: la gota salta antes de tiempo y se convierte en un
-- borrón torpe sobre el papel -- y en vez de desecharlo, alguien lo
-- convierte con calma, línea a línea, en un dibujo hermoso.
--
-- trigger_keywords: nunca un verbo visual (ver la nota sobre "destello
-- mágico" en la guía) -- todas las palabras clave de este cuento son
-- sonidos reales: un tictac, el viento, un crujido, la lluvia.
--
-- Necesita UN sonido nuevo: "tictac de reloj" (no existía nada de
-- reloj/tictac en el catálogo). El resto reutiliza sonidos existentes.
--
-- Requiere haber corrido antes supabase/schema.sql (y, si aplica,
-- supabase/borrar_todos_los_cuentos.sql para partir de un catálogo
-- limpio).
-- Seguro de correr varias veces: los sonidos solo se insertan si no
-- existen todavía, y las variables/bloques del cuento se borran y se
-- vuelven a crear desde cero cada vez.
--
-- PENDIENTE: las 16 ilustraciones todavía no existen -- imagen_url
-- queda con la ruta asignada pero el archivo se agrega después (otra
-- IA las genera a partir del nombre de cada escena). Lista completa de
-- assets a agregar al final de este comentario:
--
-- Imágenes (public/images/gota-tinta-impaciente/):
-- /images/gota-tinta-impaciente/01-tintero-viejo-escritorio.svg
-- /images/gota-tinta-impaciente/02-ventana-lampara-noche.svg
-- /images/gota-tinta-impaciente/03-reloj-pendulo-tictac.svg
-- /images/gota-tinta-impaciente/04-pluma-entra-sale-tintero.svg
-- /images/gota-tinta-impaciente/05-viento-cortinas-ventana.svg
-- /images/gota-tinta-impaciente/06-gota-salta-tintero.svg
-- /images/gota-tinta-impaciente/07-mancha-torpe-en-papel.svg
-- /images/gota-tinta-impaciente/08-ventana-cruje-tormenta.svg
-- /images/gota-tinta-impaciente/09-lluvia-contra-cristal.svg
-- /images/gota-tinta-impaciente/10-reloj-consuela-gota.svg
-- /images/gota-tinta-impaciente/11-gota-quieta-esperando.svg
-- /images/gota-tinta-impaciente/12-persona-mira-mancha.svg
-- /images/gota-tinta-impaciente/13-dibujo-favorito-aparece.svg
-- /images/gota-tinta-impaciente/14-reloj-sonrie-sabiduria.svg
-- /images/gota-tinta-impaciente/15-gota-brilla-tinta-color.svg
-- /images/gota-tinta-impaciente/16-costumbre-escribir-ventana.svg
--
-- Sonidos nuevos (public/sounds/):
-- /sounds/tictac-de-reloj.mp3
--
-- Ejecutar en Supabase -> SQL Editor.

do $$
declare
  v_story_id uuid;
  v_tictac uuid;
  v_viento uuid;
  v_crujido uuid;
  v_lluvia uuid;
begin
  select id into v_story_id from stories where titulo = 'La gota de tinta impaciente' limit 1;

  if v_story_id is null then
    insert into stories (titulo, edad_recomendada, es_personalizable, portada_url)
    values ('La gota de tinta impaciente', '2-7 años', true, null)
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'tictac de reloj') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('tictac de reloj', '/sounds/tictac-de-reloj.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'viento entre arboles') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('viento entre arboles', '/sounds/viento.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'crujido') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('crujido', '/sounds/crujido.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'lluvia magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('lluvia magica', '/sounds/lluvia.mp3', 'ambiente');
  end if;

  select id into v_tictac from sound_effects where nombre = 'tictac de reloj' limit 1;
  select id into v_viento from sound_effects where nombre = 'viento entre arboles' limit 1;
  select id into v_crujido from sound_effects where nombre = 'crujido' limit 1;
  select id into v_lluvia from sound_effects where nombre = 'lluvia magica' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_gota', 'texto', array['Manchita','Garabato','Puntito','Chispa','Tilde','Borrón']),
    (v_story_id, 'color_tinta', 'color', array['azul','negro','dorado','violeta','verde esmeralda','rojo carmín','plateado','arcoíris']),
    (v_story_id, 'dibujo_favorito', 'animal', array['gato','estrella','barco','flor','dragón pequeño','nube']);

  delete from story_blocks where story_id = v_story_id;

  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
  values
    (v_story_id, 1,
      'En un escritorio junto a la ventana vivía {nombre_gota}, una gota de tinta de color {color_tinta}, dentro de un tintero viejo y redondo. Mientras las demás gotas esperaban su turno en silencio, {nombre_gota} solo pensaba en una cosa: saltar a la página cuanto antes, sin esperar a nadie.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/01-tintero-viejo-escritorio.svg'),

    (v_story_id, 2,
      'Esa habitación guardaba historias enteras: cada noche, alguien encendía una lámpara pequeña y se sentaba a escribir junto a la ventana. {nombre_gota} miraba la página en blanco desde el fondo del tintero, impaciente, deseando ser ya un dibujo, una palabra, cualquier cosa menos una simple gota quieta.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/02-ventana-lampara-noche.svg'),

    (v_story_id, 3,
      'En la esquina del cuarto, un viejo reloj de péndulo llevaba años midiendo el tiempo con un tictac constante. —Las mejores historias —le dijo una noche a {nombre_gota}— esperan el momento justo para empezar. {nombre_gota} lo escuchó, pero no entendía cómo algo tan quieto podía saber tanto de historias.',
      v_tictac, array['tictac'],
      '/images/gota-tinta-impaciente/03-reloj-pendulo-tictac.svg'),

    (v_story_id, 4,
      'Cada noche, la pluma se hundía en el tintero y volvía a salir, una y otra vez, sin elegir nunca a {nombre_gota}. Ella se estiraba, se acercaba al borde, ansiosa por ser la próxima. —¡Ya casi es mi turno! —pensaba, aunque nadie la había llamado todavía.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/04-pluma-entra-sale-tintero.svg'),

    (v_story_id, 5,
      'Una noche, el viento empezó a soplar fuerte afuera, moviendo las cortinas de la ventana entreabierta. La persona que escribía esa noche se detuvo un momento, pensando qué dibujar. Fue entonces cuando {nombre_gota}, sin poder esperar ni un segundo más, decidió que ese era su momento.',
      v_viento, array['viento'],
      '/images/gota-tinta-impaciente/05-viento-cortinas-ventana.svg'),

    (v_story_id, 6,
      'Sin que nadie la llamara, {nombre_gota} saltó fuera del tintero directo a la página en blanco. No esperó a que la pluma la guiara, ni a que alguien decidiera qué forma tomar. Solo quería, por fin, dejar de ser una gota quieta esperando su turno.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/06-gota-salta-tintero.svg'),

    (v_story_id, 7,
      'Cayó de golpe sobre el papel y se abrió en todas direcciones, sin forma ni sentido: un borrón grande y torpe, muy distinto a cualquier dibujo. La persona que escribía suspiró al verlo. {nombre_gota} se quedó inmóvil sobre la página, deshecha, sin saber qué había hecho mal.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/07-mancha-torpe-en-papel.svg'),

    (v_story_id, 8,
      'Afuera, la ventana crujió con una nueva ráfaga de viento, como si la noche entera compartiera su vergüenza. {nombre_gota} miró su propia forma torcida sobre el papel y pensó que lo había arruinado todo. Ya no había manera de deshacer lo que había hecho.',
      v_crujido, array['crujió'],
      '/images/gota-tinta-impaciente/08-ventana-cruje-tormenta.svg'),

    (v_story_id, 9,
      'Empezó a llover contra el cristal, como si el cielo también estuviera triste por ella. {nombre_gota} sintió que las gotas de lluvia y su propia vergüenza se parecían: las dos habían caído sin que nadie las esperara todavía. Deseó, por primera vez, haber tenido paciencia.',
      v_lluvia, array['lluvia'],
      '/images/gota-tinta-impaciente/09-lluvia-contra-cristal.svg'),

    (v_story_id, 10,
      'El viejo reloj, desde su esquina, la miró con ternura. —No todo lo que cae torcido se queda torcido para siempre —le dijo—. Pero eso ya no depende de saltar rápido. Depende de quedarte quieta el tiempo suficiente para que alguien pueda ayudarte a encontrar tu forma.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/10-reloj-consuela-gota.svg'),

    (v_story_id, 11,
      '{nombre_gota} quiso removerse, arrastrarse, intentar arreglar sola su forma torcida. Pero por primera vez en su vida, decidió quedarse quieta y esperar, aunque cada segundo se sintiera eterno. No sabía si serviría de algo. Solo sabía que ya había intentado hacerlo todo a su manera, y no había funcionado.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/11-gota-quieta-esperando.svg'),

    (v_story_id, 12,
      'A la mañana siguiente, la persona que escribía volvió al escritorio y encontró el borrón todavía ahí, ya seco. En vez de arrugar la página, se quedó mirándolo un largo rato. Después, con mucho cuidado, tomó la pluma y empezó a dibujar unas líneas suaves alrededor de la mancha.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/12-persona-mira-mancha.svg'),

    (v_story_id, 13,
      'Línea a línea, muy despacio, la mancha torpe de {nombre_gota} se fue convirtiendo en algo distinto: primero una curva, después una forma conocida, hasta que sobre la página apareció {un_dibujo_favorito} {dibujo_favorito}, tan bonito que la propia {nombre_gota} no podía creer que hubiera sido ella.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/13-dibujo-favorito-aparece.svg'),

    (v_story_id, 14,
      'El viejo reloj, sin dejar de medir el tiempo, sonrió a su manera. —Lo que se hace con calma —dijo suavemente— casi siempre se hace bien. {nombre_gota} entendió, por fin, que esperar no había sido perder el tiempo: había sido la única manera de llegar a ser algo hermoso.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/14-reloj-sonrie-sabiduria.svg'),

    (v_story_id, 15,
      'Desde esa noche, {nombre_gota} nunca más volvió a saltar antes de tiempo. Cada vez que la pluma se acercaba, esperaba su turno con calma, sabiendo que su momento llegaría. Y cuando por fin llegaba, su tinta de color {color_tinta} siempre encontraba la forma correcta para brillar en la página.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/15-gota-brilla-tinta-color.svg'),

    (v_story_id, 16,
      'Con el tiempo, en esa casa se volvió costumbre esperar el momento justo antes de empezar cualquier historia nueva. Y cada vez que alguien se sentaba a escribir junto a la ventana, {nombre_gota} recordaba lo que había aprendido: lo que vale la pena, casi siempre, vale la pena esperar.',
      null, array[]::text[],
      '/images/gota-tinta-impaciente/16-costumbre-escribir-ventana.svg');
end $$;
