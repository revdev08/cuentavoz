-- Cuentavoz: El libro que no quería llegar al final
do $$
declare
  v_story_id uuid;
  v_paginas uuid;
  v_reloj uuid;
  v_lluvia uuid;
begin
  select id into v_story_id from stories where slug = 'el-libro-que-no-queria-llegar-al-final' limit 1;
  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El libro que no quería llegar al final', 'el-libro-que-no-queria-llegar-al-final', '2-7 años', true, '/images/portadas/el-libro-que-no-queria-llegar-al-final.webp', 'Emociones') returning id into v_story_id;
  end if;
  if not exists (select 1 from sound_effects where nombre = 'paginas pasando') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('paginas pasando', '/sounds/paginas-pasando.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'tictac de reloj') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('tictac de reloj', '/sounds/tictac-de-reloj.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'lluvia magica') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('lluvia magica', '/sounds/lluvia-magica.mp3', 'ambiente');
  end if;
  select id into v_paginas from sound_effects where nombre = 'paginas pasando' limit 1;
  select id into v_reloj from sound_effects where nombre = 'tictac de reloj' limit 1;
  select id into v_lluvia from sound_effects where nombre = 'lluvia magica' limit 1;
  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_libro', 'texto', array['Tilo', 'Nube', 'Punto', 'Mimo']),
    (v_story_id, 'color_portada', 'color', array['azul', 'roja', 'verde', 'violeta']),
    (v_story_id, 'nombre_biblioteca', 'texto', array['Biblioteca del Parque', 'Casa de los Cuentos', 'Biblioteca Arcoíris', 'Rincón de Papel']),
    (v_story_id, 'nombre_nino', 'texto', array['Sofía', 'Mateo', 'Valentina', 'Samuel']);
  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'En {nombre_biblioteca} vivía {nombre_libro}, un libro de portada {color_portada} que adoraba cuando alguien lo abría. Sus páginas se estiraban felices, sus personajes saludaban y cada aventura volvía a despertar. Solo había una cosa que le daba un pequeño cosquilleo de miedo: la última página.', null, array[]::text[], '/images/el-libro-que-no-queria-llegar-al-final/01-libro-en-biblioteca.webp'),
    (v_story_id, 2, 'Cada vez que una historia avanzaba, {nombre_libro} dejaba pasar las páginas con un suave roce. Pero cuando el lector se acercaba al final, intentaba hacerse pesado, esconder una esquina o pegar sus hojas con un bostezo. Pensaba que si nadie terminaba, nadie tendría que despedirse.', v_paginas, array['páginas'], '/images/el-libro-que-no-queria-llegar-al-final/02-paginas-felices.webp'),
    (v_story_id, 3, 'Una tarde lluviosa, {nombre_nino} escogió a {nombre_libro} y se sentó junto a la ventana. Leyó sobre un zorro que encontraba su casa y una luna que volvía a salir. El libro disfrutó cada palabra, aunque su marcador temblaba cada vez más cerca de la última página.', v_lluvia, array['lluviosa'], '/images/el-libro-que-no-queria-llegar-al-final/03-nino-lee-lluvia.webp'),
    (v_story_id, 4, 'Cuando faltaban solo dos hojas, {nombre_libro} cerró sus tapas de golpe. —Todavía no —susurró. {nombre_nino} intentó abrirlo con cuidado, pero el libro se hizo duro como una tabla. Afuera, la lluvia siguió cayendo y adentro quedó suspendida una aventura que quería abrazar su final.', null, array[]::text[], '/images/el-libro-que-no-queria-llegar-al-final/04-libro-se-cierra.webp'),
    (v_story_id, 5, 'En el silencio de la biblioteca, el viejo reloj hizo tictac junto al mostrador. {nombre_libro} escuchó que cada sonido avanzaba sin pedir permiso. —¿Y si el final me deja vacío? —pensó. El reloj no respondió, pero siguió marcando minutos, como quien sabe que el tiempo también guarda regresos.', v_reloj, array['tictac'], '/images/el-libro-que-no-queria-llegar-al-final/05-reloj-y-libro.webp'),
    (v_story_id, 6, 'Entonces apareció una niña pequeña buscando un cuento para dormir. Miró a {nombre_libro}, pero al ver sus tapas apretadas eligió otro. El libro sintió una puntita de tristeza. No quería que la última página llegara, pero tampoco quería quedarse cerrado cuando alguien necesitaba una historia.', null, array[]::text[], '/images/el-libro-que-no-queria-llegar-al-final/06-nina-elige-otro-libro.webp'),
    (v_story_id, 7, 'Esa noche, cuando la biblioteca quedó vacía, los personajes de {nombre_libro} salieron hasta el borde de sus dibujos. El zorro preguntó: —¿Por qué no nos dejas llegar a casa? La luna añadió: —Un final no nos borra. Nos deja descansar para que mañana alguien nos encuentre otra vez.', null, array[]::text[], '/images/el-libro-que-no-queria-llegar-al-final/07-personajes-en-paginas.webp'),
    (v_story_id, 8, 'El libro miró su última página. Allí no había un agujero ni un adiós oscuro. Había un zorro dormido, una luna redonda y una ventana encendida. Por primera vez entendió que terminar aquella noche era una forma de cuidar a sus personajes, no de perderlos.', null, array[]::text[], '/images/el-libro-que-no-queria-llegar-al-final/08-ultima-pagina-calida.webp'),
    (v_story_id, 9, 'A la mañana siguiente, {nombre_nino} regresó. {nombre_libro} abrió sus tapas antes de que nadie las tocara. Dejó que las páginas pasaran despacio, una tras otra, y cuando llegó el final no se escondió. La historia cerró con el zorro en casa y la luna velando afuera.', v_paginas, array['páginas'], '/images/el-libro-que-no-queria-llegar-al-final/09-libro-llega-final.webp'),
    (v_story_id, 10, '{nombre_nino} abrazó el libro contra el pecho. —Qué bonito —dijo—. ¿Mañana lo leemos otra vez? {nombre_libro} sintió que sus letras daban un pequeño salto. El final no había cerrado la puerta. Había dejado una llave invisible para que aquella misma aventura pudiera empezar de nuevo.', null, array[]::text[], '/images/el-libro-que-no-queria-llegar-al-final/10-nino-abraza-libro.webp'),
    (v_story_id, 11, 'Desde entonces, {nombre_libro} no escondió ninguna última página. A veces un niño leía hasta el final; otras veces se dormía a la mitad. El libro aprendió a esperar cada regreso sin apretar sus tapas. Sus historias no vivían solo en las hojas, sino también en quien las recordaba.', null, array[]::text[], '/images/el-libro-que-no-queria-llegar-al-final/11-libro-espera-lectores.webp'),
    (v_story_id, 12, 'Al caer otra tarde, el reloj volvió a hacer tictac y la biblioteca se llenó de luz dorada. {nombre_libro} vio a la niña pequeña tomarlo del estante. Esta vez abrió sus páginas sin temor. Sabía que la niña podía llegar al final, sonreír y volver cuando quisiera.', v_reloj, array['tictac'], '/images/el-libro-que-no-queria-llegar-al-final/12-nina-abre-libro.webp'),
    (v_story_id, 13, 'La niña terminó la historia y cerró el libro con dos manos suaves. —Los finales también cuidan los cuentos —dijo, como si hubiera entendido el secreto del zorro. {nombre_libro} se quedó muy quieto, feliz. Ya no quería detener el tiempo: quería compartirlo página por página.', null, array[]::text[], '/images/el-libro-que-no-queria-llegar-al-final/13-nina-termina-cuento.webp'),
    (v_story_id, 14, 'Y así, en {nombre_biblioteca}, {nombre_libro} siguió esperando nuevas manos y nuevas voces. Había aprendido que una historia no se acaba cuando llega al final. Se vuelve un recuerdo, una pregunta o una invitación para comenzar otra vez, con el corazón un poquito más grande.', null, array[]::text[], '/images/el-libro-que-no-queria-llegar-al-final/14-libro-espera-nueva-historia.webp');
end $$;
