-- Cuentavoz: El banquito que aprendió a sostener aplausos
do $$
declare
  v_story_id uuid;
  v_telon_teatro uuid;
  v_tambor_feria uuid;
  v_madera_cruje uuid;
  v_aplausos_suaves uuid;
begin
  select id into v_story_id from stories where slug = 'el-banquito-que-aprendio-a-sostener-aplausos' limit 1;
  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El banquito que aprendió a sostener aplausos', 'el-banquito-que-aprendio-a-sostener-aplausos', '2-7 años', true, '/images/portadas/el-banquito-que-aprendio-a-sostener-aplausos.webp', 'Valores')
    returning id into v_story_id;
  end if;
  if not exists (select 1 from sound_effects where nombre = 'telon de teatro') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('telon de teatro', '/sounds/telon-de-teatro.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'tambor de feria') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('tambor de feria', '/sounds/tambor-de-feria.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'madera cruje') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('madera cruje', '/sounds/madera-cruje.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'aplausos suaves') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('aplausos suaves', '/sounds/aplausos-suaves.mp3', 'efecto');
  end if;
  select id into v_telon_teatro from sound_effects where nombre = 'telon de teatro' limit 1;
  select id into v_tambor_feria from sound_effects where nombre = 'tambor de feria' limit 1;
  select id into v_madera_cruje from sound_effects where nombre = 'madera cruje' limit 1;
  select id into v_aplausos_suaves from sound_effects where nombre = 'aplausos suaves' limit 1;
  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_banquito', 'texto', array['Tilo', 'Pipo', 'Nuez', 'Bruno']),
    (v_story_id, 'color_banquito', 'color', array['azul', 'rojo', 'verde', 'amarillo']),
    (v_story_id, 'nombre_teatro', 'texto', array['Teatro de las Nubes', 'Teatro Luneta', 'Teatro de los Titeres', 'Teatro del Patio']),
    (v_story_id, 'nombre_nino', 'texto', array['Sofía', 'Mateo', 'Valentina', 'Samuel']);
  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'Detrás del escenario de {nombre_teatro} vivía {nombre_banquito}, un banquito {color_banquito} de patas cortas y asiento redondo. Desde allí veía bailar a los títeres, escuchaba las risas y soñaba con estar arriba, donde todos pudieran verlo y aplaudirle.', null, array[]::text[], '/images/el-banquito-que-aprendio-a-sostener-aplausos/01-banquito-tras-bambalinas.webp'),
    (v_story_id, 2, 'Su trabajo era sencillo: sostener la caja de pinturas, el pie cansado de la titiritera o una taza de agua. Pero {nombre_banquito} pensaba que aquello no contaba. Quería luces sobre su asiento y un saludo al final. Ser útil en silencio le parecía demasiado poco.', null, array[]::text[], '/images/el-banquito-que-aprendio-a-sostener-aplausos/02-banquito-suena-escenario.webp'),
    (v_story_id, 3, 'Una tarde, el tambor anunció la función de La Ballena Azul. Los niños ocuparon las primeras filas y las cortinas temblaron de emoción. {nombre_banquito} esperó detrás de una columna, mirando el escenario vacío. Esta vez decidió que no se quedaría escondido entre cajas.', v_tambor_feria, array['tambor'], '/images/el-banquito-que-aprendio-a-sostener-aplausos/03-tambor-anuncia-funcion.webp'),
    (v_story_id, 4, 'Cuando el telón comenzó a subir, {nombre_banquito} se deslizó hasta el centro del escenario. Quiso ser parte de la primera escena. Pero la titiritera necesitaba ese lugar libre para mover una gran ola de tela. La ola se enredó en una de sus patas.', v_telon_teatro, array['telón'], '/images/el-banquito-que-aprendio-a-sostener-aplausos/04-telon-y-ola.webp'),
    (v_story_id, 5, 'La ballena de títere apareció torcida y los peces de papel chocaron unos con otros. Nadie se hizo daño, pero el cuento perdió su ritmo. {nombre_banquito} sintió las mejillas de madera arder. Había querido que todos lo miraran, y ahora todos esperaban que se apartara.', null, array[]::text[], '/images/el-banquito-que-aprendio-a-sostener-aplausos/05-titeres-enredados.webp'),
    (v_story_id, 6, 'Volvió lentamente a bambalinas. Al apoyarse junto a una caja, la madera crujió bajo su peso. —Quizá soy demasiado pequeño para hacer algo importante —pensó. La titiritera no lo regañó. Solo acomodó la ola, respiró hondo y continuó la función como pudo.', v_madera_cruje, array['crujió'], '/images/el-banquito-que-aprendio-a-sostener-aplausos/06-banquito-cruje.webp'),
    (v_story_id, 7, 'Desde allí, {nombre_banquito} vio a {nombre_nino} al fondo del patio. El niño estiraba el cuello, se ponía de puntillas y volvía a sentarse. Delante había personas muy altas y apenas alcanzaba a ver la punta azul de la ballena cuando cruzaba el escenario.', null, array[]::text[], '/images/el-banquito-que-aprendio-a-sostener-aplausos/07-nino-no-alcanza-ver.webp'),
    (v_story_id, 8, 'El banquito recordó lo que había arruinado al ocupar el centro sin pensar. Esta vez no corrió. Esperó una pausa, pidió permiso con un golpecito suave y se acercó a {nombre_nino}. La titiritera entendió enseguida y señaló un rincón seguro junto a la primera fila.', null, array[]::text[], '/images/el-banquito-que-aprendio-a-sostener-aplausos/08-banquito-pide-permiso.webp'),
    (v_story_id, 9, '{nombre_nino} se sentó sobre {nombre_banquito} y sus ojos quedaron a la altura exacta del mar de tela. Vio a la ballena saltar, al pulpo hacer cosquillas y a los peces formar una rueda. El niño soltó una risa tan clara que otros niños empezaron a reír también.', null, array[]::text[], '/images/el-banquito-que-aprendio-a-sostener-aplausos/09-nino-ve-ballena.webp'),
    (v_story_id, 10, 'Entonces la función volvió a encontrar su música. La titiritera movió las olas sin tropiezos y el tambor marcó el paso de una tormenta juguetona. Desde abajo, {nombre_banquito} no veía todas las luces, pero sentía la alegría de {nombre_nino} subir por sus cuatro patas.', v_tambor_feria, array['tambor'], '/images/el-banquito-que-aprendio-a-sostener-aplausos/10-tormenta-de-titeres.webp'),
    (v_story_id, 11, 'Al final, la ballena hizo una reverencia y el público aplaudió. Las palmas sonaron suaves al principio, luego llenaron todo el patio. {nombre_banquito} vibró de sorpresa. No estaba en el centro del escenario, pero los aplausos llegaban hasta él como una lluvia calentita.', v_aplausos_suaves, array['aplausos'], '/images/el-banquito-que-aprendio-a-sostener-aplausos/11-aplausos-en-patio.webp'),
    (v_story_id, 12, 'Cuando terminó la función, {nombre_nino} abrazó el asiento redondo. —Gracias, ahora pude ver toda la historia —dijo. La titiritera sonrió mientras guardaba los peces de papel. —Hay cosas importantes que no necesitan estar delante —añadió—. A veces sostienen la alegría de otros.', null, array[]::text[], '/images/el-banquito-que-aprendio-a-sostener-aplausos/12-gracias-banquito.webp'),
    (v_story_id, 13, '{nombre_banquito} miró el escenario, las cajas y sus patas cortas. Comprendió que no quería dejar de ver las funciones; quería ayudar a que alguien pudiera verlas mejor. Aquella noche pidió quedarse junto a la primera fila, no como estrella, sino como un buen asiento.', null, array[]::text[], '/images/el-banquito-que-aprendio-a-sostener-aplausos/13-banquito-elige-lugar.webp'),
    (v_story_id, 14, 'Desde entonces, {nombre_banquito} sostenía a quien lo necesitara durante cada función. Cuando oía aplausos, ya no soñaba con que fueran solo para él. Sabía que también celebraban la historia que alguien había podido mirar gracias a sus patas cortas y su asiento firme.', v_aplausos_suaves, array['aplausos'], '/images/el-banquito-que-aprendio-a-sostener-aplausos/14-banquito-sostiene-aplausos.webp');
end $$;
