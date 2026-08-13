-- Duodécimo cuento generado con el sistema escritor-cuentavoz/.
--
-- "La estrella que aprendió a pedir ayuda"
--
-- Protagonista: una estrella (elemento natural, distinto a nube/semilla
-- -- primer cuento de cielo nocturno como escenario propio, no solo de
-- paso). Escenario: el cielo, entre constelaciones. Conflicto:
-- dificultad para pedir ayuda -- no usado antes en el catálogo nuevo.
-- Magia: viento (el viento nocturno lleva cualquier mensaje que se le
-- confíe, de estrella a estrella, de cielo a tierra -- pero nunca
-- puede inventar un llamado que nadie hizo; la decisión de pedir ayuda
-- sigue siendo de la estrella). Nota: NO se reutiliza "estrellas" como
-- tipo de magia aunque el protagonista sea una estrella -- ese tipo ya
-- se usó en "La brújula...".  Quién inicia el cambio: un grupito de
-- estrellas más jóvenes que se acercan sin que nadie se lo pida
-- (personaje/grupo secundario nuevo). Quién expresa la enseñanza: las
-- mismas estrellas jóvenes, en coro, todas a la vez (no un personaje
-- viejo y sabio -- se evita a propósito para no repetir ese patrón por
-- cuarta vez). Emoción dominante: alivio (variante fresca). Regalo/
-- cierre: un recuerdo -- un brillo cálido que vuelve a aparecer cada
-- vez que otra estrella se acerca sin que nadie se lo pida (no
-- costumbre, camino, canción, árbol, amistad, lugar descubierto,
-- abrazo, promesa, habilidad nueva ni nueva forma de mirar el mundo).
--
-- Escena inolvidable: la estrella por fin susurra "ya no puedo sola"
-- hacia el viento, y en segundos cada estrella de su constelación se da
-- la vuelta a la vez, y su luz llega junta como una ola cálida.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro.
--
-- Sonidos: a pedido explícito, crea 2 sonidos nuevos esta vez (no solo
-- reutiliza el catálogo): "viento susurrante" (un viento nocturno suave
-- y susurrante, distinto de "viento entre árboles" -- que el catálogo
-- reserva para bosques/montañas/campos, nunca dentro del cielo puro) y
-- "tintineo de estrellas" (el sonido que hacen las estrellas al brillar
-- con cariño unas hacia otras -- una traducción sensorial honesta del
-- "titilar" de las estrellas, no un capricho: se establece una sola vez
-- como concepto y se usa de forma consistente). Cada uno se usa dos
-- veces, como motivo. También reutiliza grillos nocturnos.
--
-- Requiere: supabase/schema.sql, supabase/migracion_agregar_slug.sql y
-- supabase/migracion_progreso_y_favoritos.sql ya corridos.
--
-- Idempotente: seguro de correr varias veces. Identifica el cuento por
-- slug, sigue el orden oficial de escritor-cuentavoz/05-plantilla-sql.md.
--
-- Ejecutar en Supabase -> SQL Editor.

do $$

declare

    v_story_id uuid;
    v_viento_susurrante uuid;
    v_tintineo uuid;
    v_grillos uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-estrella-que-aprendio-a-pedir-ayuda'
    limit 1;

    --------------------------------------------------
    -- Crear historia
    --------------------------------------------------

    if v_story_id is null then

        insert into stories
        (
            titulo,
            slug,
            edad_recomendada,
            categoria,
            es_personalizable,
            portada_url
        )

        values
        (
            'La estrella que aprendió a pedir ayuda',
            'la-estrella-que-aprendio-a-pedir-ayuda',
            '2-7 años',
            'Sueños',
            true,
            null
        )

        returning id
        into v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='viento susurrante') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('viento susurrante', '/sounds/viento-susurrante.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='tintineo de estrellas') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('tintineo de estrellas', '/sounds/tintineo-de-estrellas.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='grillos nocturnos') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('grillos nocturnos', '/sounds/grillos.mp3', 'ambiente');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_viento_susurrante from sound_effects where nombre='viento susurrante' limit 1;
    select id into v_tintineo from sound_effects where nombre='tintineo de estrellas' limit 1;
    select id into v_grillos from sound_effects where nombre='grillos nocturnos' limit 1;

    --------------------------------------------------
    -- Variables
    --------------------------------------------------

    delete
    from story_variables
    where story_id=v_story_id;

    insert into story_variables
    (
        story_id,
        variable_key,
        tipo,
        opciones_sugeridas
    )

    values

    (v_story_id, 'nombre_estrella', 'texto', array['Lucera','Destello','Polar','Centella','Nova','Brillante']),
    (v_story_id, 'color_estrella', 'color', array['dorado','plateado','azulado','blanco','violeta','rosado','turquesa','ambar']),
    (v_story_id, 'nombre_constelacion', 'texto', array['El Cazador Dormido','La Cuchara de Plata','El Río Celeste','La Corona Chica','Los Siete Faroles','El Pez Volador']);

    --------------------------------------------------
    -- Bloques
    --------------------------------------------------

    delete
    from story_blocks
    where story_id=v_story_id;

    insert into story_blocks
    (
        story_id,
        orden,
        texto_bloque,
        sound_effect_id,
        trigger_keywords,
        imagen_url
    )

    values

    (v_story_id, 1,
      'En {nombre_constelacion} brillaba {nombre_estrella}, orgullosa de no necesitar ayuda de nadie para alumbrar cada noche. Mientras las demás estrellas se apoyaban unas a otras cuando se cansaban, {nombre_estrella} siempre había brillado sola, y le encantaba que fuera así.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/01-estrella-brilla-sola-constelacion.webp'),

    (v_story_id, 2,
      'Se decía, entre las estrellas, que a veces una luz se cansa de brillar en soledad, y empieza a temblar un poco. Nada grave, decían -- siempre y cuando se pidiera ayuda a tiempo. {nombre_estrella} nunca había tenido que comprobarlo.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/02-leyenda-estrellas-se-apoyan.webp'),

    (v_story_id, 3,
      'Una leyenda muy vieja contaba que el viento nocturno lleva cualquier mensaje que se le confíe, de estrella a estrella, de cielo a tierra. Pero el viento nunca puede inventar un llamado que nadie hizo. {nombre_estrella} la conocía, aunque nunca había pensado que fuera a necesitarla.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/03-leyenda-viento-lleva-mensajes.webp'),

    (v_story_id, 4,
      'Una noche, sin ningún motivo claro, la luz de {nombre_estrella} empezó a parpadear. Al principio fue apenas un temblor pequeño. {nombre_estrella} decidió que no era nada, y que se le pasaría sola.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/04-luz-estrella-empieza-parpadear.webp'),

    (v_story_id, 5,
      'El viento nocturno pasó cerca, susurrando suavemente, como ofreciéndose a llevar un mensaje si hacía falta. {nombre_estrella}, con todo su orgullo, no dijo una sola palabra.',
      v_viento_susurrante, array['susurrando'],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/05-viento-nocturno-susurra-ofrece.webp'),

    (v_story_id, 6,
      'Intentó de todo para detener el temblor: contener la luz, concentrarse con todas sus fuerzas, brillar más fuerte a propósito. Nada funcionó. El parpadeo, en cambio, se hizo un poco más notorio cada noche.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/06-estrella-intenta-todo-sola.webp'),

    (v_story_id, 7,
      'Muy abajo, en un campo tranquilo, los grillos cantaban sin saber que, muy arriba, una pequeña crisis apenas comenzaba.',
      v_grillos, array['grillos'],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/07-grillos-campo-cielo-crisis.webp'),

    (v_story_id, 8,
      'Cerca de ahí, un grupito de estrellas más jóvenes llevaba varias noches observando el parpadeo de {nombre_estrella}, preocupadas, susurrando entre ellas sin saber si debían acercarse.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/08-estrellas-jovenes-observan-preocupadas.webp'),

    (v_story_id, 9,
      'Sin que nadie se los pidiera, decidieron acercarse de todos modos, aunque no sabían si {nombre_estrella} las quería cerca o si preferiría, como siempre, resolverlo sola.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/09-estrellas-jovenes-deciden-acercarse.webp'),

    (v_story_id, 10,
      'Al acercarse, un suave tintineo llenó el espacio entre ellas -- el sonido que hacen las estrellas cuando brillan con cariño unas hacia otras.',
      v_tintineo, array['tintineo'],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/10-tintineo-estrellas-se-acercan.webp'),

    (v_story_id, 11,
      '—Estoy bien —dijo {nombre_estrella}, débilmente, todavía luchando contra el orgullo—. No hace falta que se queden.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/11-estrella-dice-estoy-bien-orgullo.webp'),

    (v_story_id, 12,
      'Pero el parpadeo empeoró. Y esa vez, muy despacio, muy bajito, {nombre_estrella} susurró hacia el viento nocturno lo único que llevaba días sin poder decir: —Ya no puedo sola.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/12-estrella-susurra-ya-no-puedo-sola.webp'),

    (v_story_id, 13,
      'El viento atrapó el susurro y lo llevó tan rápido y tan lejos que, en cuestión de segundos, cada estrella de {nombre_constelacion} se dio la vuelta a la vez.',
      v_viento_susurrante, array['susurro'],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/13-viento-lleva-susurro-constelacion-entera.webp'),

    (v_story_id, 14,
      'Su luz llegó junta, como una ola cálida, tintineando suavemente sobre {nombre_estrella}. El parpadeo se calmó, despacio, hasta volver a brillar entero y firme, de color {color_estrella}.',
      v_tintineo, array['tintineando'],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/14-luz-conjunta-llega-tintineando.webp'),

    (v_story_id, 15,
      '—Nunca tuviste que brillar sola —dijeron todas juntas, casi al mismo tiempo—. Solo tenías que decirlo.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/15-estrellas-jovenes-hablan-coro.webp'),

    (v_story_id, 16,
      'Desde esa noche, {nombre_estrella} guardó un pequeño recuerdo de ese momento: un brillo cálido, apenas perceptible, que aparecía cada vez que alguna otra estrella se acercaba a acompañarla sin que nadie se lo pidiera.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/16-estrella-guarda-recuerdo-brillo.webp'),

    (v_story_id, 17,
      '{nombre_estrella} entendió, por fin, que brillar sola nunca había sido una virtud. La verdadera fuerza había estado, todo ese tiempo, en atreverse a decir, en voz baja si hacía falta: ya no puedo sola.',
      null, array[]::text[],
      '/images/la-estrella-que-aprendio-a-pedir-ayuda/17-estrella-reflexion-final.webp');

end $$;
