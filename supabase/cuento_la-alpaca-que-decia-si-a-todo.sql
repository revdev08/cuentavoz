-- Cuentavoz: La alpaca que decía sí a todo
do $$
declare
  v_story_id uuid;
  v_campanillas uuid;
  v_telar uuid;
  v_viento uuid;
  v_crujido uuid;
begin
  select id into v_story_id from stories where slug = 'la-alpaca-que-decia-si-a-todo' limit 1;
  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('La alpaca que decía sí a todo', 'la-alpaca-que-decia-si-a-todo', '2-7 años', true, '/images/portadas/la-alpaca-que-decia-si-a-todo.webp', 'Aventuras')
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'campanillas de alpaca') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('campanillas de alpaca', '/sounds/campanillas-de-alpaca.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'telar de lana') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('telar de lana', '/sounds/telar-de-lana.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'viento de montaña') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('viento de montaña', '/sounds/viento-de-montana.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'crujido') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('crujido', '/sounds/crujido.mp3', 'efecto');
  end if;

  select id into v_campanillas from sound_effects where nombre = 'campanillas de alpaca' limit 1;
  select id into v_telar from sound_effects where nombre = 'telar de lana' limit 1;
  select id into v_viento from sound_effects where nombre = 'viento de montaña' limit 1;
  select id into v_crujido from sound_effects where nombre = 'crujido' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_alpaca', 'texto', array['Nina', 'Luna', 'Mora', 'Canela']),
    (v_story_id, 'color_manta', 'color', array['turquesa', 'coral', 'amarilla', 'violeta']),
    (v_story_id, 'nombre_pueblo_montana', 'texto', array['Pueblo Nube Alta', 'Villa Quisquís', 'Cumbre Clara', 'Valle Campana']);

  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'En {nombre_pueblo_montana}, entre montañas y casas de adobe, vivía {nombre_alpaca}. Llevaba una manta {color_manta} y tenía gran corazón. Cuando alguien pedía un favor, ella respondía antes de pensar: —¡Sí, claro! Le encantaba ver contentas las caras de sus vecinos.', null, array[]::text[], '/images/la-alpaca-que-decia-si-a-todo/01-alpaca-pueblo-montana.webp'),
    (v_story_id, 2, 'Una mañana llegaron los preparativos de la Fiesta de los Vientos. La panadera pidió harina, el músico pidió sus flautas y la tejedora pidió ovillos. {nombre_alpaca} dijo sí a todo. Sus campanillas sonaron alegres mientras ella iba de puerta en puerta aceptando encargos.', v_campanillas, array['campanillas'], '/images/la-alpaca-que-decia-si-a-todo/02-alpaca-acepta-favores.webp'),
    (v_story_id, 3, 'En el patio de la tejedora, el telar hacía tac, tac, tac. —¿Podrías llevar estas cintas al mirador? —preguntó la mujer. {nombre_alpaca} ya cargaba harina y flautas, pero sonrió. —Sí, claro. Póngalas sobre mi manta. Todavía cabe un poquito más.', v_telar, array['telar'], '/images/la-alpaca-que-decia-si-a-todo/03-telar-y-cintas.webp'),
    (v_story_id, 4, 'Luego el jardinero pidió macetas diminutas. La niña de los globos pidió una caja de estrellas de papel. El carpintero pidió tablones para el escenario. {nombre_alpaca} dijo sí, sí y sí. Cada bulto era pequeño por separado, pero juntos hicieron una montaña sobre su lomo.', null, array[]::text[], '/images/la-alpaca-que-decia-si-a-todo/04-carga-montana-colores.webp'),
    (v_story_id, 5, 'Al comenzar la subida al mirador, el viento de montaña despeinó sus orejas y levantó las cintas como serpientes de colores. {nombre_alpaca} apretó los dientes. Quería llegar sin que nadie se preocupara. —Puedo con todo —se dijo, aunque sus patitas ya temblaban un poco.', v_viento, array['viento'], '/images/la-alpaca-que-decia-si-a-todo/05-viento-cintas-montana.webp'),
    (v_story_id, 6, 'El sendero se hizo angosto. Una flauta rodó hacia un lado, luego una maceta se inclinó y la caja de estrellas empezó a resbalar. {nombre_alpaca} trató de sostenerlo todo con el cuello, la cola y una pata. Cuanto más se apuraba, menos podía avanzar.', null, array[]::text[], '/images/la-alpaca-que-decia-si-a-todo/06-sendero-carga-inestable.webp'),
    (v_story_id, 7, 'Frente a un puentecito de madera, las tablas hicieron crujido bajo su carga. {nombre_alpaca} se detuvo justo a tiempo. Del otro lado se veía el mirador y las banderas de la fiesta. Sin embargo, cruzar así podía romper el puente y perder todos los encargos.', v_crujido, array['crujido'], '/images/la-alpaca-que-decia-si-a-todo/07-puente-cruje-alpaca.webp'),
    (v_story_id, 8, 'Por primera vez, {nombre_alpaca} no supo qué responder. Sus vecinos confiaban en ella, y no quería decepcionarlos. Miró las cintas enredadas, la harina torcida y las flautas asomando de una canasta. Entonces entendió que decir sí por miedo no era ayudar de verdad.', null, array[]::text[], '/images/la-alpaca-que-decia-si-a-todo/08-alpaca-piensa-puente.webp'),
    (v_story_id, 9, 'Respiró profundo y llamó al pueblo. —¡Necesito ayuda! No puedo llevar todo sola. Su voz bajó por la montaña y llegó a las casas. Por un momento solo contestó el viento. Después aparecieron la panadera, la tejedora, el músico y la niña de los globos.', null, array[]::text[], '/images/la-alpaca-que-decia-si-a-todo/09-vecinos-suben-sendero.webp'),
    (v_story_id, 10, 'Nadie se molestó. La panadera cargó la harina, el músico tomó sus flautas y la tejedora enrolló las cintas en su brazo. La niña abrazó su caja de estrellas. {nombre_alpaca} sintió que su lomo volvía a ser ligero. Ahora cada persona cuidaba lo que podía llevar.', null, array[]::text[], '/images/la-alpaca-que-decia-si-a-todo/10-amigos-reparten-carga.webp'),
    (v_story_id, 11, 'Juntos cruzaron el puente sin prisa. Las campanillas de {nombre_alpaca} sonaron al ritmo de los pasos, y las banderas del mirador bailaron arriba. Ya no parecía una carga pesada: parecía una procesión alegre, con manos, patas y risas que avanzaban hacia la fiesta.', v_campanillas, array['campanillas'], '/images/la-alpaca-que-decia-si-a-todo/11-procesion-cruza-puente.webp'),
    (v_story_id, 12, 'En el mirador, la tejedora puso las cintas en el telar y entre todos hicieron una manta enorme para el escenario. Cada hilo llegaba desde una mano distinta. {nombre_alpaca} ayudó a pasar los colores, sin llevarlos todos encima. Así descubrió que colaborar también era compartir el trabajo.', v_telar, array['telar'], '/images/la-alpaca-que-decia-si-a-todo/12-manta-colectiva-mirador.webp'),
    (v_story_id, 13, 'Cuando el sol se escondió, comenzó la fiesta. La panadera entregó panes, el músico tocó y niños alzaron estrellas. {nombre_alpaca} miró la manta detrás del escenario. La tejedora le guiñó un ojo. —Ayudar no es cargarlo todo. Es saber cuándo pedir compañía.', null, array[]::text[], '/images/la-alpaca-que-decia-si-a-todo/13-fiesta-vientos-escenario.webp'),
    (v_story_id, 14, 'Desde ese día, {nombre_alpaca} siguió siendo generosa, pero antes de responder preguntaba: —¿Puedo hacerlo? ¿Necesito compañía? Aprendió que decir sí con sinceridad también puede significar: sí, pero hagámoslo juntos. Sus campanillas sonaban entonces todavía más felices.', null, array[]::text[], '/images/la-alpaca-que-decia-si-a-todo/14-alpaca-manta-fiesta.webp');
end $$;
