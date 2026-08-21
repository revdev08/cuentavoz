  do $$

  declare
      v_story_id uuid;
      v_chapoteo uuid;
      v_aleteo uuid;
      v_llamada uuid;

  begin

      select id into v_story_id from stories
      where slug='el-flamenco-que-contaba-las-plumas-ajenas' limit 1;

      if v_story_id is null then
          insert into stories
          (titulo, slug, edad_recomendada, es_personalizable, portada_url)
          values
          ('El flamenco que contaba las plumas ajenas',
           'el-flamenco-que-contaba-las-plumas-ajenas',
           '2-7 años', true,
           '/images/portadas/el-flamenco-que-contaba-las-plumas-ajenas.webp')
          returning id into v_story_id;
      else
          update stories
          set titulo='El flamenco que contaba las plumas ajenas',
              edad_recomendada='2-7 años',
              es_personalizable=true,
              portada_url='/images/portadas/el-flamenco-que-contaba-las-plumas-ajenas.webp'
          where id=v_story_id;
      end if;

      if not exists (select 1 from sound_effects where nombre='chapoteo') then
          insert into sound_effects (nombre, archivo_url, categoria)
          values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
      end if;

      if not exists (select 1 from sound_effects where nombre='aleteo de flamencos') then
          insert into sound_effects (nombre, archivo_url, categoria)
          values ('aleteo de flamencos', '/sounds/aleteo-de-flamencos.mp3', 'efecto');
      end if;

      if not exists (select 1 from sound_effects where nombre='llamada de flamencos') then
          insert into sound_effects (nombre, archivo_url, categoria)
          values ('llamada de flamencos', '/sounds/llamada-de-flamencos.mp3', 'efecto');
      end if;

      select id into v_chapoteo from sound_effects where nombre='chapoteo' limit 1;
      select id into v_aleteo from sound_effects where nombre='aleteo de flamencos' limit 1;
      select id into v_llamada from sound_effects where nombre='llamada de flamencos' limit 1;

      delete from story_variables where story_id=v_story_id;

      insert into story_variables
      (story_id, variable_key, tipo, opciones_sugeridas)
      values
          (v_story_id, 'nombre_flamenco', 'texto', array['Lumo', 'Coral', 'Nilo', 'Mora', 'Tilo', 'Azalea']),
          (v_story_id, 'nombre_laguna', 'texto', array['Laguna Salina', 'Laguna Espejada', 'Laguna del Alba', 'Laguna Rosada']),
          (v_story_id, 'color_plumas', 'color', array['coral', 'rosado amanecer', 'durazno', 'frambuesa']),
          (v_story_id, 'movimiento_favorito', 'texto', array['giro de luna', 'paso de ola', 'salto de junco', 'vuelta de caracol']);

      delete from story_blocks where story_id=v_story_id;

      insert into story_blocks
      (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
      values

          (v_story_id, 1,
          'En {nombre_laguna}, donde la sal dibujaba estrellas blancas sobre la orilla, vivía {nombre_flamenco}. Sus plumas eran de color {color_plumas} y sus patas parecían dos pinceles delicados. Sin embargo, cada mañana miraba atentamente a las demás aves y contaba aquello que hacían mucho mejor.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/01-flamenco-contando-aves.webp'),

          (v_story_id, 2,
          'De la espátula admiraba el pico ancho, capaz de barrer el agua como una cuchara. De la garza admiraba su perfecta quietud. De los patos, sus rápidas zambullidas. Al terminar la cuenta, {nombre_flamenco} siempre olvidaba apuntar algo hermoso sobre sí mismo.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/02-cualidades-de-las-aves.webp'),

          (v_story_id, 3,
          'Aquel día, las aves prepararían el Baile del Agua, una reunión sin jueces ni premios. Cada cual llevaría un movimiento nacido de su cuerpo. {nombre_flamenco} deseaba participar, pero pensó que su propio paso sería demasiado pequeño al lado de tantas maravillas.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/03-invitacion-al-baile-del-agua.webp'),

          (v_story_id, 4,
          'Primero intentó moverse como la espátula. Hundió el pico, lo barrió de lado a lado y levantó una corona de barro. El chapoteo salpicó hasta sus alas. Las espátulas no se burlaron; continuaron comiendo. Pero {nombre_flamenco} anotó en su pensamiento: «Yo no sé».',
          v_chapoteo, array['chapoteo'],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/04-corona-de-barro.webp'),

          (v_story_id, 5,
          'Después copió la quietud de la garza. Estiró el cuello, cerró un ojo y sostuvo una pata en el aire. Una nube pasó. Luego otra. Al tercer mosquito, perdió el equilibrio y cayó sentado. La garza le ofreció espacio, sin decirle cómo debía levantarse.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/05-equilibrio-de-garza.webp'),

          (v_story_id, 6,
          'Por último, quiso zambullirse como los patos. Tomó impulso y metió la cabeza, pero sus largas patas quedaron arriba, temblando como juncos confundidos. Al salir, respiró y escuchó un gronk de su propia garganta. Ni siquiera su voz sonaba como las otras.',
          v_llamada, array['gronk'],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/06-patas-sobre-el-agua.webp'),

          (v_story_id, 7,
          'Cuando comenzó el baile, {nombre_flamenco} se escondió detrás de una isla de sal. Desde allí vio picos que barrían, alas que temblaban y patas que remaban. Cuanto más admiraba cada figura, menos podía recordar la forma exacta de su propio cuerpo.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/07-escondido-tras-la-sal.webp'),

          (v_story_id, 8,
          'Entonces el viento se quedó quieto y la laguna se volvió un espejo. En el reflejo, las figuras de todas las aves se superpusieron: apareció una criatura imposible, con pico de cuchara, cuello de garza, patas de pato y cuatro pares de alas.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/08-criatura-en-el-reflejo.webp'),

          (v_story_id, 9,
          '{nombre_flamenco} observó maravillado. La criatura parecía tener todas las ventajas, pero cuando quiso bailar no pudo decidir qué patas usar. Sus alas chocaron, el cuello se enredó y el pico señaló tres direcciones. Ser como todos a la vez la dejaba inmóvil.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/09-reflejo-sin-movimiento.webp'),

          (v_story_id, 10,
          'Una onda separó los reflejos y, por fin, {nombre_flamenco} vio el suyo. Notó la curva de su cuello, la ligereza de sus alas y la línea larga de sus patas. No eran mejores que las demás. Tampoco eran menores. Eran posibilidades que aún no había probado.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/10-descubre-su-reflejo.webp'),

          (v_story_id, 11,
          'Apoyó una pata y trazó un círculo. Abrió las alas para sostener el equilibrio, inclinó el cuello y giró sin prisa. Después añadió su {movimiento_favorito}. El agua dibujó una espiral rosada alrededor de la isla, distinta de cualquier movimiento que hubiera contado.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/11-espiral-rosada.webp'),

          (v_story_id, 12,
          'Las otras aves hicieron silencio para mirar. {nombre_flamenco} sintió miedo de haberse equivocado, pero continuó. Sus alas hicieron flap-flap, sus patas cruzaron la espiral y su pico acompañó la curva. No estaba copiando una forma perfecta; estaba descubriendo una verdaderamente propia.',
          v_aleteo, array['flap-flap'],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/12-primer-baile-propio.webp'),

          (v_story_id, 13,
          'La espátula entró barriendo el agua. La garza agregó una pausa larga y los patos cruzaron por debajo de dos alas abiertas. Nadie intentó parecerse a otra ave. Cada movimiento dejó espacio para el siguiente, y la laguna comenzó a bailar entera.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/13-danza-de-toda-la-laguna.webp'),

          (v_story_id, 14,
          '—Admirar lo que alguien hace puede enseñarnos —dijo {nombre_flamenco}, todavía girando—. Pero si usamos esa admiración para medir cuánto valemos, dejamos de ver nuestras propias posibilidades. Las aves respondieron con un gronk alegre que recorrió el agua como una cuerda vibrante.',
          v_llamada, array['gronk'],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/14-palabras-sobre-el-agua.webp'),

          (v_story_id, 15,
          'Al caer la tarde, el cielo pintó cien flamencos bajo cada flamenco. {nombre_flamenco} ya no buscó la criatura imposible. Miró cómo cada reflejo conservaba su figura y, al mismo tiempo, compartía las mismas ondas. Aquella imagen fue el final del baile.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/15-cien-flamencos-reflejados.webp'),

          (v_story_id, 16,
          'Desde entonces, {nombre_flamenco} siguió admirando picos, patas y vuelos, pero dejó de convertirlos en una cuenta injusta contra sí mismo. Cuando olvidaba sus propias cualidades, dibujaba una espiral tranquila en {nombre_laguna}. Inspirarse en otros abría nuevos caminos; compararse hasta desaparecer los cerraba.',
          null, array[]::text[],
          '/images/el-flamenco-que-contaba-las-plumas-ajenas/16-espiral-para-recordar.webp');

  end $$;

  -- Assets
  -- Portada: /images/portadas/el-flamenco-que-contaba-las-plumas-ajenas.webp
  -- Sonidos:
  -- /sounds/chapoteo.mp3 (ya existe)
  -- /sounds/aleteo-de-flamencos.mp3 (nuevo)
  -- /sounds/llamada-de-flamencos.mp3 (nuevo)
