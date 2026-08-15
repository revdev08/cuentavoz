-- Cuentavoz: El ascensor que tenía vértigo
do $$
declare
  v_story_id uuid;
  v_timbre_ascensor uuid;
  v_cables_ascensor uuid;
  v_lluvia_ventana uuid;
begin
  select id into v_story_id from stories where slug = 'el-ascensor-que-tenia-vertigo' limit 1;
  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values ('El ascensor que tenía vértigo', 'el-ascensor-que-tenia-vertigo', '2-7 años', true, '/images/portadas/el-ascensor-que-tenia-vertigo.webp', 'Aventuras') returning id into v_story_id;
  end if;
  if not exists (select 1 from sound_effects where nombre = 'timbre de ascensor') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('timbre de ascensor', '/sounds/timbre-de-ascensor.mp3', 'efecto');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'cables de ascensor') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('cables de ascensor', '/sounds/cables-de-ascensor.mp3', 'ambiente');
  end if;
  if not exists (select 1 from sound_effects where nombre = 'lluvia en ventana') then
    insert into sound_effects (nombre, archivo_url, categoria) values ('lluvia en ventana', '/sounds/lluvia-en-ventana.mp3', 'ambiente');
  end if;
  select id into v_timbre_ascensor from sound_effects where nombre = 'timbre de ascensor' limit 1;
  select id into v_cables_ascensor from sound_effects where nombre = 'cables de ascensor' limit 1;
  select id into v_lluvia_ventana from sound_effects where nombre = 'lluvia en ventana' limit 1;
  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_ascensor', 'texto', array['Lolo', 'Tino', 'Milo', 'Pipo']),
    (v_story_id, 'color_cabina', 'color', array['azul', 'verde', 'amarilla', 'roja']),
    (v_story_id, 'nombre_edificio', 'texto', array['Casa Nube', 'Edificio Jacaranda', 'Torre del Patio', 'Casa de las Ventanas']),
    (v_story_id, 'nombre_nino', 'texto', array['Sofía', 'Mateo', 'Valentina', 'Samuel']);
  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id,1,'En {nombre_edificio} vivía {nombre_ascensor}, un ascensor de cabina {color_cabina} que conocía cada piso, cada maceta y cada vecino. Solo había una cosa que no contaba a nadie: al mirar hacia arriba por su hueco, sentía cosquillas enormes en las ruedas.',null,array[]::text[],'/images/el-ascensor-que-tenia-vertigo/01-ascensor-en-edificio.webp'),
    (v_story_id,2,'Por eso prefería quedarse cerca del vestíbulo. Subía al segundo piso si era necesario, pero evitaba la azotea. Allí arriba estaban las nubes, los pájaros y un jardín que parecía flotar. {nombre_ascensor} pensaba que las cosas valientes vivían lejos de las alturas.',null,array[]::text[],'/images/el-ascensor-que-tenia-vertigo/02-ascensor-mira-arriba.webp'),
    (v_story_id,3,'Una mañana, {nombre_nino} entró con una maceta pequeña entre las manos. Dentro crecía una planta de tomate con dos hojas nuevas. —Debe llegar al jardín de la azotea antes de la lluvia —dijo. El timbre sonó y {nombre_ascensor} cerró las puertas despacito.',v_timbre_ascensor,array['timbre'],'/images/el-ascensor-que-tenia-vertigo/03-nino-con-maceta.webp'),
    (v_story_id,4,'Primero subieron al segundo piso. Luego al tercero. Los cables cantaban muy bajito dentro de las paredes. {nombre_ascensor} quiso detenerse allí, donde todavía podía oír la puerta del vestíbulo. Pero {nombre_nino} miró la maceta y dijo que las plantas también necesitaban conocer el cielo.',v_cables_ascensor,array['cables'],'/images/el-ascensor-que-tenia-vertigo/04-cables-cantan.webp'),
    (v_story_id,5,'Al llegar al cuarto piso, una gota golpeó la ventana del pasillo. Después llegaron muchas más. La lluvia comenzó a hacer caminos sobre el vidrio. {nombre_ascensor} sintió que sus ruedas temblaban. Si no seguía, el tomate no encontraría tierra seca en la azotea.',v_lluvia_ventana,array['lluvia'],'/images/el-ascensor-que-tenia-vertigo/05-lluvia-en-ventana.webp'),
    (v_story_id,6,'—Podemos subir un piso a la vez —propuso {nombre_nino}, sin apurarlo. Esa idea no quitó el miedo de {nombre_ascensor}, pero lo hizo más pequeño. Respiró con sus puertas, contó hasta tres y dejó que sus ruedas buscaran el siguiente piso.',null,array[]::text[],'/images/el-ascensor-que-tenia-vertigo/06-un-piso-a-la-vez.webp'),
    (v_story_id,7,'En el quinto piso subió una vecina con un paraguas roto. En el sexto, un señor llevaba una caja de pan caliente. Cada persona saludó a {nombre_ascensor} como si el viaje fuera sencillo. Él comprendió que no estaba cruzando la altura solo.',null,array[]::text[],'/images/el-ascensor-que-tenia-vertigo/07-vecinos-acompanan.webp'),
    (v_story_id,8,'Cuando las puertas se abrieron en la azotea, el viento fresco entró sin pedir permiso. Frente a ellos había un jardín lleno de lechugas, flores y regaderas. La lluvia apenas rozaba las tejas. {nombre_ascensor} no se movió durante un instante, mirando aquel cielo enorme.',null,array[]::text[],'/images/el-ascensor-que-tenia-vertigo/08-jardin-azotea.webp'),
    (v_story_id,9,'{nombre_nino} plantó el tomate en una jardinera junto a una enredadera. Luego regó con cuidado alrededor de las raíces. {nombre_ascensor} miró las nubes por la puerta abierta y descubrió algo sorprendente: desde allí arriba el edificio no parecía pequeño, parecía lleno de hogares.',null,array[]::text[],'/images/el-ascensor-que-tenia-vertigo/09-planta-tomate.webp'),
    (v_story_id,10,'Entonces el timbre llamó otra vez. Una abuela necesitaba bajar con una cesta de ropa seca antes de que la lluvia volviera. {nombre_ascensor} sintió el vértigo regresar, pero no huyó. Cerró sus puertas y empezó a bajar, piso por piso, con el mismo cuidado.',v_timbre_ascensor,array['timbre'],'/images/el-ascensor-que-tenia-vertigo/10-abuela-con-canasta.webp'),
    (v_story_id,11,'Los cables acompañaron el descenso con su zumbido tranquilo. En cada piso, {nombre_ascensor} recordó una voz, una risa o una maceta. Ya no pensaba solo en la distancia entre el suelo y la azotea. Pensaba en todas las personas que podía acercar.',v_cables_ascensor,array['cables'],'/images/el-ascensor-que-tenia-vertigo/11-baja-con-confianza.webp'),
    (v_story_id,12,'En el vestíbulo, {nombre_nino} tocó la puerta de la cabina. —Ser valiente no es dejar de sentir cosquillas —dijo—. Es seguir cuando algo importante te necesita, aunque sea despacito. {nombre_ascensor} guardó esas palabras junto a sus botones luminosos.',null,array[]::text[],'/images/el-ascensor-que-tenia-vertigo/12-palabras-valientes.webp'),
    (v_story_id,13,'Al día siguiente, {nombre_ascensor} subió de nuevo hasta el jardín. Esta vez llevaba una niña, un paquete de semillas y una jaula vacía para una mariposa que iba a ser liberada. Sus ruedas temblaron un poco, pero siguieron adelante.',null,array[]::text[],'/images/el-ascensor-que-tenia-vertigo/13-viaje-de-semillas.webp'),
    (v_story_id,14,'Desde entonces, {nombre_ascensor} nunca presumió de no tener vértigo. Simplemente aprendió a avanzar un piso a la vez. Cada vez que llegaba a la azotea, veía crecer el tomate y sonreía: la valentía también podía subir despacito, pero llegar muy alto.',null,array[]::text[],'/images/el-ascensor-que-tenia-vertigo/14-ascensor-llega-alto.webp');
end $$;
