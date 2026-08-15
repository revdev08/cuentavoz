-- Cuentavoz: El violín que quería hacer reír
do $$
declare
  v_story_id uuid;
  v_violin uuid;
  v_tambor uuid;
  v_risas uuid;
  v_aplausos uuid;
  v_campanita uuid;
begin
  select id into v_story_id from stories where slug = 'el-violin-que-queria-hacer-reir' limit 1;
  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El violín que quería hacer reír', 'el-violin-que-queria-hacer-reir', '2-7 años', true, null, 'Música')
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'violin travieso') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('violin travieso', '/sounds/violin-travieso.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'tambor de feria') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('tambor de feria', '/sounds/tambor-de-feria.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'risas infantiles') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('risas infantiles', '/sounds/risas-infantiles.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'aplausos suaves') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('aplausos suaves', '/sounds/aplausos-suaves.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'campanita magica') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('campanita magica', '/sounds/campanita.mp3', 'efecto');
  end if;

  select id into v_violin from sound_effects where nombre = 'violin travieso' limit 1;
  select id into v_tambor from sound_effects where nombre = 'tambor de feria' limit 1;
  select id into v_risas from sound_effects where nombre = 'risas infantiles' limit 1;
  select id into v_aplausos from sound_effects where nombre = 'aplausos suaves' limit 1;
  select id into v_campanita from sound_effects where nombre = 'campanita magica' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_violin', 'texto', array['Arco', 'Mimo', 'Bruno', 'Violeta']),
    (v_story_id, 'color_violin', 'color', array['miel', 'azul', 'rojo', 'violeta']),
    (v_story_id, 'nombre_feria', 'texto', array['Feria Lucero', 'Noche de Sombreros', 'Fiesta del Farol', 'Plaza Brincante']);

  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'En la {nombre_feria}, cuando el cielo se volvía azul oscuro, cada instrumento ocupaba un rincón. Allí vivía {nombre_violin}, un violín color {color_violin}. Sus cuerdas contaban secretos dulces, pero él soñaba con algo distinto: quería hacer reír a todo el mundo.', null, array[]::text[], '/images/el-violin-que-queria-hacer-reir/01-violin-feria-noche.webp'),
    (v_story_id, 2, 'Antes del gran Baile de Sombreros, el tambor marcaba pum, pum, pum; el acordeón respiraba largo y la flauta ensayaba escalitas. {nombre_violin} los miraba de reojo. —Mi música es demasiado seria —pensó—. Si sonara como ellos, quizá los niños se reirían conmigo.', v_tambor, array['pum'], '/images/el-violin-que-queria-hacer-reir/02-banda-prepara-baile.webp'),
    (v_story_id, 3, 'Así que {nombre_violin} dejó de escuchar sus cuerdas. Imitó al tambor golpeando su caja con el arco. Luego quiso inflarse como acordeón y acabó con una clavija torcida. Los músicos no se burlaron, pero se quedaron muy quietos. Aquello no parecía música ni chiste.', null, array[]::text[], '/images/el-violin-que-queria-hacer-reir/03-violin-imita-tambor.webp'),
    (v_story_id, 4, '—Probaré algo más gracioso —dijo {nombre_violin}. Rozó una cuerda, luego otra, y produjo un ñiiic inesperado que hizo saltar el sombrero del director. Dos niños soltaron pequeñas risas. El violín se emocionó y repitió el ñiiic cada vez más fuerte.', v_violin, array['ñiiic'], '/images/el-violin-que-queria-hacer-reir/04-sombrero-salta-escenario.webp'),
    (v_story_id, 5, 'Cuando comenzó el baile, {nombre_violin} tocó ñiiic, ñiiic, ñiiic sin parar. Los sombreros de plumas giraron, los zapatos buscaron el paso y hasta el tambor perdió su pum. Nadie cayó, pero todos quedaron congelados con caras confundidas. La música había olvidado escuchar a los bailarines.', null, array[]::text[], '/images/el-violin-que-queria-hacer-reir/05-baile-confundido-sombreros.webp'),
    (v_story_id, 6, 'Con las mejillas calientes, {nombre_violin} se escondió detrás de una cortina. Afuera, la feria seguía encendida, pero él no quería tocar. —Quise hacerlos felices y arruiné el baile —susurró. Por primera vez entendió que copiar sonidos no le daba una voz propia.', null, array[]::text[], '/images/el-violin-que-queria-hacer-reir/06-violin-tras-cortina.webp'),
    (v_story_id, 7, 'Junto a la cortina, una niña esperaba a que su padre terminara. Para entretenerse, golpeaba despacito sus rodillas: tap, tap, pausa, tap. Después hacía una cara graciosa y volvía a empezar. Sin darse cuenta, {nombre_violin} acompañó aquel ritmo con una nota pequeña.', null, array[]::text[], '/images/el-violin-que-queria-hacer-reir/07-nina-marca-ritmo.webp'),
    (v_story_id, 8, 'La niña abrió los ojos. {nombre_violin} tocó otra nota, esta vez dejando un silencio para que ella hiciera tap con las rodillas. Los dos sonrieron. No era un chiste ruidoso. Era una conversación de sonidos: una nota, un tap y una pausa que parecía hacer cosquillas.', null, array[]::text[], '/images/el-violin-que-queria-hacer-reir/08-violin-descubre-pausa.webp'),
    (v_story_id, 9, 'El director asomó la cabeza por la cortina. {nombre_violin} respiró hondo y le contó su idea: una canción con espacios para que todos participaran. El tambor escuchó el ritmo de las rodillas y respondió suave. La flauta añadió aire. Nadie tuvo que sonar igual para tocar juntos.', null, array[]::text[], '/images/el-violin-que-queria-hacer-reir/09-banda-ensaya-juntos.webp'),
    (v_story_id, 10, 'Volvieron al escenario. {nombre_violin} tocó una melodía saltarina y dejó una pausa enorme. Los niños hicieron caras chistosas dentro de ese silencio. Entonces llegaron las risas, redondas y contagiosas, sin tapar a nadie. El violín comprendió que una canción podía invitar, no mandar.', v_risas, array['risas'], '/images/el-violin-que-queria-hacer-reir/10-risas-frente-escenario.webp'),
    (v_story_id, 11, 'En cada pausa, los sombreros respondían con un giro, las manos con una palmada y las botas con un salto. Las campanitas de la feria tintineaban desde los puestos, como si quisieran jugar también. {nombre_violin} no imitó instrumentos: escuchó y añadió la nota que faltaba.', v_campanita, array['campanitas'], '/images/el-violin-que-queria-hacer-reir/11-campanitas-y-sombreros.webp'),
    (v_story_id, 12, 'La canción terminó con un último silencio. La plaza quedó quieta. Después llegaron los aplausos suaves, grandes como una ola que no mojaba. {nombre_violin} no necesitó hacer ñiiic para reír: bastó ver a niños, músicos y sombreros celebrando la misma melodía.', v_aplausos, array['aplausos'], '/images/el-violin-que-queria-hacer-reir/12-aplausos-feria-noche.webp'),
    (v_story_id, 13, 'La niña se acercó al escenario y dijo: —Me gustó porque pude poner mi parte. El director acomodó su sombrero y sonrió. —Eso es hacer música juntos: cada voz tiene su sitio cuando también sabe escuchar. {nombre_violin} guardó la frase entre sus cuerdas.', null, array[]::text[], '/images/el-violin-que-queria-hacer-reir/13-nina-habla-violin.webp'),
    (v_story_id, 14, 'Desde aquella noche, {nombre_violin} siguió tocando notas dulces, alegres y, de vez en cuando, un ñiiic pequeñito. Ya no quería parecerse a nadie. Había descubierto que la alegría crece cuando cada quien ofrece su sonido y deja espacio para escuchar a los demás.', null, array[]::text[], '/images/el-violin-que-queria-hacer-reir/14-violin-sonido-propio.webp');
end $$;
