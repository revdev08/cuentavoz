-- Cuentavoz: La gaviota que peinaba las olas
-- Protagonista: una gaviota. Escenario: una playa de conchas al amanecer.
-- Emoción dominante: admiración. Enseñanza: cuidar no es dejar todo quieto;
-- es ayudar a cada cosa a ser lo que es.

do $$
declare
  v_story_id uuid;
  v_olas uuid;
  v_crujido uuid;
  v_chapoteo uuid;
  v_gaviotas uuid;
begin
  --------------------------------------------------
  -- Buscar historia
  --------------------------------------------------
  select id into v_story_id
  from stories
  where slug = 'la-gaviota-que-peinaba-las-olas'
  limit 1;

  --------------------------------------------------
  -- Crear historia
  --------------------------------------------------
  if v_story_id is null then
    insert into stories (titulo, slug, edad_recomendada, es_personalizable, portada_url, categoria)
    values (
      'La gaviota que peinaba las olas',
      'la-gaviota-que-peinaba-las-olas',
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
  if not exists (select 1 from sound_effects where nombre = 'olas tranquilas') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('olas tranquilas', '/sounds/olas-tranquilas.mp3', 'ambiente');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'crujido') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('crujido', '/sounds/crujido.mp3', 'efecto');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'chapoteo') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
  end if;

  if not exists (select 1 from sound_effects where nombre = 'gaviotas costeras') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('gaviotas costeras', '/sounds/gaviotas-costeras.mp3', 'ambiente');
  end if;

  --------------------------------------------------
  -- Obtener ids
  --------------------------------------------------
  select id into v_olas from sound_effects where nombre = 'olas tranquilas' limit 1;
  select id into v_crujido from sound_effects where nombre = 'crujido' limit 1;
  select id into v_chapoteo from sound_effects where nombre = 'chapoteo' limit 1;
  select id into v_gaviotas from sound_effects where nombre = 'gaviotas costeras' limit 1;

  --------------------------------------------------
  -- Variables
  --------------------------------------------------
  delete from story_variables where story_id = v_story_id;

  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, 'nombre_gaviota', 'texto', array['Luna', 'Brisa', 'Nube', 'Perla']),
    (v_story_id, 'nombre_playa', 'texto', array['Playa Susurro', 'Bahia Clara', 'Costa de Conchas', 'Orilla Azul']),
    (v_story_id, 'color_peine', 'color', array['coral', 'turquesa', 'amarillo', 'violeta']);

  --------------------------------------------------
  -- Bloques
  --------------------------------------------------
  delete from story_blocks where story_id = v_story_id;

  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url) values
    (v_story_id, 1,
      'En {nombre_playa}, donde la arena guardaba conchas como pequeños secretos, vivía {nombre_gaviota}. Cada amanecer, antes de que los pescadores salieran, observaba las olas correr, caer y volver. Le parecían preciosas, pero también demasiado despeinadas para una playa tan especial.',
      v_olas, array['olas'],
      '/images/la-gaviota-que-peinaba-las-olas/01-gaviota-mira-olas.webp'),

    (v_story_id, 2,
      'Una mañana encontró un peine de concha entre la espuma. Tenía dientes finos, color {color_peine}, y cabía justo bajo su ala. {nombre_gaviota} lo levantó con el pico. —Ahora sí podré arreglar esta orilla —dijo, convencida de que el mar agradecería verse ordenado.',
      null, array[]::text[],
      '/images/la-gaviota-que-peinaba-las-olas/02-peine-concha-espuma.webp'),

    (v_story_id, 3,
      'Desde ese día, {nombre_gaviota} bajaba al agua con su peine. Peinaba una ola hacia la izquierda, luego otra hacia la derecha, y alisaba la espuma hasta dejarla redonda como una almohada. Durante unos segundos, la playa parecía un dibujo perfecto y silencioso.',
      null, array[]::text[],
      '/images/la-gaviota-que-peinaba-las-olas/03-gaviota-peina-espuma.webp'),

    (v_story_id, 4,
      'Al principio, los cangrejos se asomaban curiosos desde sus cuevitas. Un pececito plateado saltó cerca de la orilla y preguntó si podía jugar entre los remolinos. —Mejor no —respondió {nombre_gaviota}—. Los remolinos arruinan mi peinado. El pececito se alejó, sin entender del todo.',
      null, array[]::text[],
      '/images/la-gaviota-que-peinaba-las-olas/04-pez-pregunta-remolinos.webp'),

    (v_story_id, 5,
      'Más tarde, el viejo muelle crujió cuando una barquita regresó de pescar. Las olas, que solían empujarla con cuidado, estaban tan lisas que apenas podían alcanzarla. La barquita quedó lejos, balanceándose sola. {nombre_gaviota} siguió peinando, aunque sintió una pequeña duda bajo las plumas.',
      v_crujido, array['crujió'],
      '/images/la-gaviota-que-peinaba-las-olas/05-barquita-muelle-cruje.webp'),

    (v_story_id, 6,
      'Esa tarde llegó una tortuguita recién nacida junto a unas piedras tibias. Miró el mar plano, miró sus aletas diminutas y dio un pasito atrás. Sin las olas que la llamaban y la sostenían, la distancia hasta el agua parecía gigantesca. {nombre_gaviota} dejó el peine sobre la arena.',
      null, array[]::text[],
      '/images/la-gaviota-que-peinaba-las-olas/06-tortuguita-frente-mar-liso.webp'),

    (v_story_id, 7,
      '—Yo solo quería que todo se viera bonito —susurró {nombre_gaviota}. Entonces vio los huequitos vacíos donde los cangrejos solían jugar, la barquita esperando ayuda y a la tortuguita sin saber avanzar. Por primera vez entendió que una playa bonita no siempre era una playa inmóvil.',
      null, array[]::text[],
      '/images/la-gaviota-que-peinaba-las-olas/07-gaviota-observa-playa-silenciosa.webp'),

    (v_story_id, 8,
      'El viento de la tarde levantó el peine de concha y lo hizo girar sobre la arena. {nombre_gaviota} pudo atraparlo enseguida, pero no lo hizo. Miró el borde del mar, respiró hondo y decidió esperar. No sabía cómo devolverle movimiento al agua, pero ya no quería impedírselo.',
      null, array[]::text[],
      '/images/la-gaviota-que-peinaba-las-olas/08-peine-gira-arena-viento.webp'),

    (v_story_id, 9,
      'Una ola pequeña llegó primero y chapoteó sobre las patas de {nombre_gaviota}. Después llegó otra, y otra más. La espuma volvió a hacer caminos torcidos, los cangrejos corrieron felices y la tortuguita siguió una ola hasta el agua. {nombre_gaviota} sintió que la playa respiraba otra vez.',
      v_chapoteo, array['chapoteó'],
      '/images/la-gaviota-que-peinaba-las-olas/09-tortuguita-sigue-ola.webp'),

    (v_story_id, 10,
      'Las olas empujaron la barquita hacia el muelle, donde pudo descansar. El pececito volvió a saltar entre dos remolinos y dejó una gota brillante en el pico de {nombre_gaviota}. Ella no peinó nada. Solo observó cómo cada curva del agua tenía una tarea que antes no había sabido mirar.',
      null, array[]::text[],
      '/images/la-gaviota-que-peinaba-las-olas/10-barquita-llega-muelle.webp'),

    (v_story_id, 11,
      'Cuando el sol bajó, el mar se llenó de colores que ningún peine habría podido inventar. La espuma llevaba naranja, rosa y azul entre sus bordes. {nombre_gaviota} comprendió que el movimiento no era desorden: era la forma que tenía el mar de cuidar a todos los que vivían cerca.',
      null, array[]::text[],
      '/images/la-gaviota-que-peinaba-las-olas/11-olas-colores-atardecer.webp'),

    (v_story_id, 12,
      'La tortuguita asomó desde una ola segura. —Cuidar no es dejar todo quieto —dijo—. Es ayudar a cada cosa a ser lo que es. {nombre_gaviota} miró el peine de concha junto a sus patas y supo que aquellas palabras cabían mejor en el corazón que bajo un ala.',
      null, array[]::text[],
      '/images/la-gaviota-que-peinaba-las-olas/12-tortuguita-habla-gaviota.webp'),

    (v_story_id, 13,
      'Esa noche, {nombre_gaviota} dejó que las olas bailaran sin corregirlas. La luna dibujó caminos de plata sobre cada remolino, y el peine de concha flotó un instante antes de volver a la arena. La gaviota entendió que no necesitaba arreglar la belleza para poder admirarla.',
      v_olas, array['olas'],
      '/images/la-gaviota-que-peinaba-las-olas/13-luna-olas-peine.webp'),

    (v_story_id, 14,
      'Al amanecer, varias gaviotas costeras llamaron desde el cielo y {nombre_gaviota} voló con ellas sobre {nombre_playa}. Abajo, las olas seguían cambiando de forma, la barquita avanzaba y la tortuguita nadaba libre. {nombre_gaviota} sonrió: cuidar era mirar con amor, dejar espacio y acompañar sin mandar.',
      v_gaviotas, array['gaviotas'],
      '/images/la-gaviota-que-peinaba-las-olas/14-gaviotas-vuelan-playa.webp');
end $$;
