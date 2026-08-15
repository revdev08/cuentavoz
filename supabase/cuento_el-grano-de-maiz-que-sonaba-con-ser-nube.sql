-- Cuentavoz: El grano de maíz que soñaba con ser nube
do $$
declare
  v_story_id uuid;
  v_maiz_crepitando uuid;
  v_proyector_cine uuid;
  v_palomitas_saltando uuid;
  v_grillos uuid;
begin
  select id into v_story_id from stories where slug = 'el-grano-de-maiz-que-sonaba-con-ser-nube' limit 1;

  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El grano de maíz que soñaba con ser nube', 'el-grano-de-maiz-que-sonaba-con-ser-nube', '2-7 años', true, '/images/portadas/el-grano-de-maiz-que-sonaba-con-ser-nube.webp', 'Aventuras')
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'maiz crepitando') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('maiz crepitando', '/sounds/maiz-crepitando.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'proyector de cine') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('proyector de cine', '/sounds/proyector-de-cine.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'palomitas saltando') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('palomitas saltando', '/sounds/palomitas-saltando.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'grillos nocturnos') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('grillos nocturnos', '/sounds/grillos-nocturnos.mp3', 'ambiente');
  end if;

  select id into v_maiz_crepitando from sound_effects where nombre = 'maiz crepitando' limit 1;
  select id into v_proyector_cine from sound_effects where nombre = 'proyector de cine' limit 1;
  select id into v_palomitas_saltando from sound_effects where nombre = 'palomitas saltando' limit 1;
  select id into v_grillos from sound_effects where nombre = 'grillos nocturnos' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_grano', 'texto', array['Milo', 'Chispa', 'Toto', 'Luna']),
    (v_story_id, 'color_maiz', 'color', array['amarillo', 'azul', 'rojo', 'morado']),
    (v_story_id, 'nombre_cine', 'texto', array['Cine de la Luna', 'Cine Luciérnaga', 'Cine de las Estrellas', 'Cine del Campo']),
    (v_story_id, 'nombre_nino', 'texto', array['Sofía', 'Mateo', 'Valentina', 'Samuel']);

  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'En un maizal dorado vivía {nombre_grano}, un grano de maíz {color_maiz} que pasaba las tardes mirando el cielo desde la tierra. Le gustaban sobre todo las nubes redondas, porque imaginaba que eran montañas suaves donde nadie tenía que elegir qué sería mañana.', null, array[]::text[], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/01-grano-mira-nubes.webp'),
    (v_story_id, 2, 'Cada otoño llegaba la noche de {nombre_cine}. Familias enteras extendían mantas entre los surcos y encendían una pantalla blanca bajo las estrellas. Los granos de la cosecha viajaban hasta una olla de barro, saltaban convertidos en palomitas y acompañaban la película.', null, array[]::text[], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/02-cine-en-maizal.webp'),
    (v_story_id, 3, 'Los amigos de {nombre_grano} hablaban emocionados de la olla. —Yo quiero ser una nube con sabor a sal —decía uno. —Yo, una nube con canela —decía otra. {nombre_grano} sonreía, pero por dentro se encogía. ¿Y si al cambiar dejaba de reconocerse?', null, array[]::text[], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/03-granos-suenan-palomitas.webp'),
    (v_story_id, 4, 'Cuando cayó la tarde, {nombre_nino} recogió la mazorca para llevarla al cine. Los granos se apretaron unos contra otros, felices y nerviosos. {nombre_grano}, en cambio, se deslizó por una esquina y cayó sobre una hoja. Prefería quedarse duro y pequeño antes que descubrir algo desconocido.', null, array[]::text[], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/04-grano-escapa-mazorca.webp'),
    (v_story_id, 5, 'La hoja donde cayó navegó por el aire hasta la cerca. Desde allí, {nombre_grano} vio cómo la gente encendía faroles y acomodaba almohadas sobre la hierba. El proyector empezó a girar con un ruido suave. Aun lejos de la olla, sentía curiosidad por aquella noche.', v_proyector_cine, array['proyector'], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/05-proyector-en-campo.webp'),
    (v_story_id, 6, 'En la cocina de campaña, el aceite tibio abrazó a sus amigos. Primero se oyó un pequeño crepitó. Después otro. {nombre_grano} cerró los ojos desde la cerca, convencido de que cada sonido era una despedida. Quiso taparse, pero no tenía manos ni hojas suficientes.', v_maiz_crepitando, array['crepitó'], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/06-olla-maiz-crepita.webp'),
    (v_story_id, 7, 'Entonces una palomita saltó tan alto que quedó un instante frente a la luna. Era blanca, redonda y ligera, como una nube diminuta. —¡Sigo siendo yo! —rió antes de caer en un cucurucho. {nombre_grano} sintió que la duda se movía dentro de él, despacito.', v_palomitas_saltando, array['palomita'], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/07-palomita-frente-luna.webp'),
    (v_story_id, 8, 'Un soplo llevó a {nombre_grano} hasta la manta de {nombre_nino}. El niño lo encontró junto a una taza y lo sostuvo en la palma. —No tienes que hacer nada que no quieras —murmuró—. Pero algunas cosas bonitas solo aparecen cuando uno se atreve a probar.', null, array[]::text[], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/08-nino-sostiene-grano.webp'),
    (v_story_id, 9, 'Los grillos cantaban entre las matas. En la pantalla, una niña de la película cruzaba un puente de papel. {nombre_grano} pensó en las nubes que miraba cada tarde. Tal vez no eran montañas quietas. Tal vez también habían aprendido a cambiar de forma sin perder el cielo.', v_grillos, array['grillos'], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/09-grillos-y-pantalla.webp'),
    (v_story_id, 10, 'Con mucho cuidado, {nombre_nino} acercó a {nombre_grano} a la olla. El grano tembló. Podía quedarse en la palma, pero miró a sus amigos saltando y eligió entrar. No porque alguien lo empujara, sino porque quería conocer aquella parte de sí mismo que aún no existía.', null, array[]::text[], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/10-grano-elige-olla.webp'),
    (v_story_id, 11, 'El calor subió. {nombre_grano} sintió un cosquilleo, luego un gran ¡paf! Su cascarita se abrió y apareció una palomita suave, más grande de lo que había imaginado. Saltó con las demás, riendo entre pequeñas nubes de vapor. Había cambiado, sí, pero su risa seguía siendo suya.', v_palomitas_saltando, array['paf'], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/11-grano-se-vuelve-palomita.webp'),
    (v_story_id, 12, 'La nueva palomita llegó a un cucurucho justo cuando comenzó la parte más divertida de la película. El proyector dibujaba luces en las caras de las familias. {nombre_grano} miró a {nombre_nino} compartir palomitas con quien estaba al lado y comprendió que cambiar también podía acercarlo a otros.', v_proyector_cine, array['proyector'], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/12-palomitas-comparten-cine.webp'),
    (v_story_id, 13, 'Al terminar, la abuela de {nombre_nino} recogió un grano que había quedado junto a la olla. —Cambiar no borra lo que eres —dijo mientras lo guardaba para sembrarlo—. A veces te ayuda a descubrir cuánto de ti cabía todavía por abrir. {nombre_grano} escuchó orgulloso desde el cucurucho.', null, array[]::text[], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/13-abuela-guarda-semilla.webp'),
    (v_story_id, 14, 'Desde aquella noche, {nombre_grano} siguió mirando las nubes, pero ya no para esconderse en ellas. Las veía cambiar de forma sobre el maizal y sonreía. Había aprendido que atreverse a cambiar no era dejar de ser uno mismo: era dejar que apareciera una nueva manera de brillar.', null, array[]::text[], '/images/el-grano-de-maiz-que-sonaba-con-ser-nube/14-palomita-mira-nubes.webp');
end $$;
