-- Cuentavoz: El paraguas que quería atrapar una nube
do $$
declare
  v_story_id uuid;
  v_lluvia uuid;
  v_chapoteo uuid;
  v_viento uuid;
  v_trueno uuid;
  v_papel uuid;
begin
  select id into v_story_id from stories where slug = 'el-paraguas-que-queria-atrapar-una-nube' limit 1;
  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El paraguas que quería atrapar una nube', 'el-paraguas-que-queria-atrapar-una-nube', '2-7 años', true, null, 'Aventuras')
    returning id into v_story_id;
  end if;

  if not exists (select 1 from sound_effects where nombre = 'lluvia magica') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('lluvia magica', '/sounds/lluvia.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'chapoteo') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'viento entre arboles') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('viento entre arboles', '/sounds/viento.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'trueno suave') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('trueno suave', '/sounds/trueno-suave.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'papel arrugado') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('papel arrugado', '/sounds/papel-arrugado.mp3', 'efecto');
  end if;

  select id into v_lluvia from sound_effects where nombre = 'lluvia magica' limit 1;
  select id into v_chapoteo from sound_effects where nombre = 'chapoteo' limit 1;
  select id into v_viento from sound_effects where nombre = 'viento entre arboles' limit 1;
  select id into v_trueno from sound_effects where nombre = 'trueno suave' limit 1;
  select id into v_papel from sound_effects where nombre = 'papel arrugado' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_paraguas', 'texto', array['Pompom', 'Gota', 'Rizo', 'Lluvin']),
    (v_story_id, 'color_paraguas', 'color', array['amarillo', 'azul', 'rojo', 'violeta']),
    (v_story_id, 'nombre_pueblo', 'texto', array['Pueblo Charco', 'Villa Lluvia', 'Barrio Arcoiris', 'Calle Nube']);

  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1, 'En {nombre_pueblo} vivía {nombre_paraguas}, un paraguas {color_paraguas} con un mango curvo y una gran idea: atrapar una nube. No una nube cualquiera, sino una que pudiera llevar sobre su tela como un sombrero esponjoso, para que todos la admiraran.', null, array[]::text[], '/images/el-paraguas-que-queria-atrapar-una-nube/01-paraguas-mira-nube.webp'),
    (v_story_id, 2, 'Cada vez que el cielo se llenaba de nubes, {nombre_paraguas} abría sus varillas y saltaba junto a la ventana. Pero las nubes pasaban muy arriba. —Algún día bajarás —les gritaba. Su dueña sonreía y decía que un paraguas tenía trabajos más importantes.', null, array[]::text[], '/images/el-paraguas-que-queria-atrapar-una-nube/02-paraguas-salta-ventana.webp'),
    (v_story_id, 3, 'Una tarde, una nube pequeña y redonda se quedó atrapada entre los tejados. Soltó una lluvia finita sobre los balcones y luego se movió despacio hacia la plaza. {nombre_paraguas} sintió que aquella era su oportunidad. ¡Por fin una nube estaba lo bastante baja!', v_lluvia, array['lluvia'], '/images/el-paraguas-que-queria-atrapar-una-nube/03-nube-baja-lluvia.webp'),
    (v_story_id, 4, 'Apenas su dueña salió a comprar pan, {nombre_paraguas} se abrió con un ¡flap! y escapó de su mano. Rodó por la acera, giró junto a una fuente y persiguió a la nube por la calle. Detrás de él, el panadero dejó caer una cuchara de sorpresa.', null, array[]::text[], '/images/el-paraguas-que-queria-atrapar-una-nube/04-paraguas-escapa-calle.webp'),
    (v_story_id, 5, 'La nube dobló frente a una heladería. {nombre_paraguas} quiso alcanzarla, pero cayó de punta en un charco y provocó un enorme chapoteo. Tres patitos de goma salieron disparados como barquitos. El paraguas se sacudió, orgulloso de que la persecución fuera tan emocionante.', v_chapoteo, array['chapoteo'], '/images/el-paraguas-que-queria-atrapar-una-nube/05-paraguas-charco-patitos.webp'),
    (v_story_id, 6, 'Luego el viento empujó a {nombre_paraguas} por una cuesta. Voló sobre una bicicleta, pasó entre puestos de frutas y aterrizó en el sombrero de una estatua. La nube seguía adelante, dejando gotitas en el aire. —¡Espera! —gritó él—. ¡Necesito atraparte!', v_viento, array['viento'], '/images/el-paraguas-que-queria-atrapar-una-nube/06-paraguas-vuela-mercado.webp'),
    (v_story_id, 7, 'En la plaza, la nube se detuvo sobre una feria de papel. Unos niños habían construido casitas, molinos y barcos diminutos. {nombre_paraguas} levantó sus varillas para saltar encima de ella, pero una ráfaga hizo bailar los papeles y los barcos comenzaron a moverse hacia los charcos.', null, array[]::text[], '/images/el-paraguas-que-queria-atrapar-una-nube/07-feria-papel-nube.webp'),
    (v_story_id, 8, 'Un trueno suave retumbó detrás de los tejados. La nube dejó de ser redonda y se hizo grande, gris y pesada. Los niños miraron sus casitas de papel. {nombre_paraguas} podía seguir persiguiendo su nube, o abrirse sobre la feria. Nunca había tenido que elegir entre una aventura y ayudar.', v_trueno, array['trueno'], '/images/el-paraguas-que-queria-atrapar-una-nube/08-trueno-feria-papel.webp'),
    (v_story_id, 9, 'Por un instante, {nombre_paraguas} quiso correr. Luego vio una casita con una puerta pintada y un molino que giraba nervioso. Se abrió sobre ellos tan ancho como pudo. La lluvia golpeó su tela, pero debajo quedaron secos los niños, los barcos y las pequeñas calles de papel.', v_lluvia, array['lluvia'], '/images/el-paraguas-que-queria-atrapar-una-nube/09-paraguas-protege-feria.webp'),
    (v_story_id, 10, 'El agua hizo un sonido de papel arrugado en una esquina que quedó fuera de su sombra. {nombre_paraguas} se inclinó un poquito más. Un niño llevó un cartón, una niña acercó una bandeja y todos construyeron un techo largo junto al paraguas. La feria sobrevivió a la tormenta.', v_papel, array['arrugado'], '/images/el-paraguas-que-queria-atrapar-una-nube/10-ninos-salvan-feria.webp'),
    (v_story_id, 11, 'Cuando la lluvia terminó, la nube volvió a ser pequeña y blanca. Bajó hasta quedar justo encima de {nombre_paraguas}. Él se preparó para atraparla, pero la nube dejó caer una última gota sobre su punta y siguió flotando. Esta vez, el paraguas no corrió detrás.', null, array[]::text[], '/images/el-paraguas-que-queria-atrapar-una-nube/11-nube-gota-paraguas.webp'),
    (v_story_id, 12, 'Los niños aplaudieron y levantaron sus barquitos de papel. —No atrapaste la nube —dijo uno—, pero nos ayudaste a guardar nuestro pueblo. {nombre_paraguas} miró las casitas completas y sintió algo mejor que tener un sombrero de nube: sentirse útil en medio de la aventura.', null, array[]::text[], '/images/el-paraguas-que-queria-atrapar-una-nube/12-ninos-aplauden-paraguas.webp'),
    (v_story_id, 13, 'La nube se alejó sobre {nombre_pueblo}, dejando un arco iris delgadito detrás. {nombre_paraguas} volvió junto a su dueña, que lo encontró frente a la panadería. Ella lo abrió, vio las gotas en su tela y sonrió. —Un paraguas sirve para cuidar —dijo con cariño.', null, array[]::text[], '/images/el-paraguas-que-queria-atrapar-una-nube/13-arcoiris-paraguas-panaderia.webp'),
    (v_story_id, 14, 'Desde ese día, {nombre_paraguas} todavía saludaba a las nubes, pero ya no quería atraparlas. Había aprendido que una aventura es mucho más divertida cuando al final alguien queda protegido, acompañado o contento. Y cuando llovía, abría sus varillas con una sonrisa enorme.', null, array[]::text[], '/images/el-paraguas-que-queria-atrapar-una-nube/14-paraguas-sonrie-lluvia.webp');
end $$;
