-- Sexto cuento generado con el sistema escritor-cuentavoz/.
--
-- "La semilla que aprendió a cantar"
--
-- Protagonista: una semilla (segundo elemento natural del catálogo
-- nuevo, después de la nube -- los otros tres fueron objetos).
-- Escenario: un jardín en primavera (distinto a cocina/caminos/pueblo
-- nevado/escritorio/valle de montaña). Conflicto: timidez -- no usado
-- antes. Magia: canciones (cada semilla tiene una canción secreta que
-- le da valor para florecer, pero cantarla no garantiza nada por sí
-- sola -- la protagonista igual tiene que decidir cantar en voz alta).
-- Quién inicia el cambio: una semilla más pequeña y asustada que llega
-- después (personaje secundario nuevo, no familia de animales ni niño
-- ni la propia protagonista sola). Quién expresa la enseñanza: una
-- abeja vieja del jardín (personaje nuevo, no un adulto humano ni un
-- fenómeno como el eco). Emoción dominante: curiosidad (distinta a
-- ternura/asombro/esperanza/alegría ya usadas). Regalo/cierre: una
-- nueva amistad (no costumbre, camino, canción como cierre, ni árbol --
-- aquí la canción es la MAGIA, no el cierre).
--
-- Escena inolvidable: mientras la semilla canta su canción en voz alta
-- por primera vez, diminutas grietas de luz se abren en la tierra a su
-- alrededor, como si el propio tarareo aflojara el suelo.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro.
--
-- Sonidos: reutiliza 3 del catálogo existente (pájaros del bosque,
-- lluvia mágica, abejas del huerto) y crea 1 nuevo: "tarareo de
-- semilla" (no existía ningún sonido de canto/tarareo, y es central
-- para la escena inolvidable).
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
    v_pajaros uuid;
    v_lluvia uuid;
    v_abejas uuid;
    v_tarareo uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-semilla-que-aprendio-a-cantar'
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
            'La semilla que aprendió a cantar',
            'la-semilla-que-aprendio-a-cantar',
            '2-7 años',
            'Naturaleza',
            true,
            null
        )

        returning id
        into v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='tarareo de semilla') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('tarareo de semilla', '/sounds/tarareo-de-semilla.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='pajaros del bosque') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pajaros del bosque', '/sounds/pajaros.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='lluvia magica') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('lluvia magica', '/sounds/lluvia.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='abejas del huerto') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('abejas del huerto', '/sounds/abejas.mp3', 'ambiente');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_tarareo from sound_effects where nombre='tarareo de semilla' limit 1;
    select id into v_pajaros from sound_effects where nombre='pajaros del bosque' limit 1;
    select id into v_lluvia from sound_effects where nombre='lluvia magica' limit 1;
    select id into v_abejas from sound_effects where nombre='abejas del huerto' limit 1;

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

    (v_story_id, 'nombre_semilla', 'texto', array['Brote','Espiga','Rocío','Musgo','Retoño','Avena']),
    (v_story_id, 'color_flor', 'color', array['rojo','amarillo','morado','naranja','rosado','azul','blanco','turquesa']),
    (v_story_id, 'nombre_jardin', 'texto', array['El Jardín Viejo','Huerto del Sol','El Rincón Verde','Jardín de Piedra','El Sembrado','Los Canteros']);

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
      'En {nombre_jardin} vivía {nombre_semilla}, una semilla que llevaba desde el invierno enterrada bajo la tierra. A diferencia de las demás, nunca se había atrevido a asomarse hacia la superficie. Le daba miedo no saber cómo se vería una vez que floreciera.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/01-semilla-enterrada-invierno.png'),

    (v_story_id, 2,
      'Llegó la primavera, y con ella los pájaros que cantaban desde las ramas cercanas. {nombre_semilla} los escuchaba desde abajo, con curiosidad, sin animarse todavía a subir.',
      v_pajaros, array['pájaros'],
      '/images/la-semilla-que-aprendio-a-cantar/02-pajaros-cantan-primavera.png'),

    (v_story_id, 3,
      'Entre las semillas del jardín se contaba una vieja historia: cada una guarda una canción secreta que le da valor para florecer, pero solo si se atreve a cantarla en voz alta. {nombre_semilla} conocía su canción de memoria. Nunca la había cantado más que en un susurro, para sí misma.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/03-leyenda-cancion-secreta-semillas.png'),

    (v_story_id, 4,
      'Una mañana empezó a caer una lluvia suave que ablandó la tierra entera. Una a una, las semillas vecinas empujaron hacia arriba y se abrieron en flores de todos los colores. {nombre_semilla} sintió la tierra removerse a su alrededor, pero se quedó quieta.',
      v_lluvia, array['lluvia'],
      '/images/la-semilla-que-aprendio-a-cantar/04-lluvia-suave-flores-brotan.png'),

    (v_story_id, 5,
      'Se dijo a sí misma que todavía no era el momento, que esperaría un poco más. Desde abajo, veía pasar la luz entre las raíces y escuchaba a las abejas ir de flor en flor, ocupadas y felices.',
      v_abejas, array['abejas'],
      '/images/la-semilla-que-aprendio-a-cantar/05-abejas-flor-en-flor.png'),

    (v_story_id, 6,
      'Esa misma tarde llegó, empujada por el viento, una semilla mucho más pequeña que cayó justo a su lado. Estaba sola, asustada, y no conocía a nadie en {nombre_jardin}.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/06-semilla-pequena-cae-viento.png'),

    (v_story_id, 7,
      '—¿Hace falta ser valiente para crecer? —preguntó la semilla pequeña, con un hilo de voz. {nombre_semilla} no supo qué responder. Ella tampoco había encontrado el valor para intentarlo, y no sabía cómo ayudar a alguien más a encontrar algo que ni ella misma tenía.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/07-semilla-pequena-pregunta-miedo.png'),

    (v_story_id, 8,
      'Cayó la noche sobre el jardín, oscura y silenciosa. La semilla pequeña temblaba, sola en la tierra fría, sin saber qué la esperaba al día siguiente.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/08-noche-semilla-pequena-tiembla.png'),

    (v_story_id, 9,
      '{nombre_semilla} la sintió temblar a su lado, y entendió algo de golpe: en ese momento, el miedo de la semilla pequeña le importaba más que el suyo propio.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/09-semilla-siente-temblor-vecina.png'),

    (v_story_id, 10,
      'Por primera vez, {nombre_semilla} decidió no quedarse callada. Respiró hondo, bajo toda esa tierra oscura, y empezó a cantar su canción en voz alta, de verdad, para que la semilla pequeña no se sintiera tan sola.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/10-semilla-decide-cantar-voz-alta.png'),

    (v_story_id, 11,
      'Mientras cantaba, diminutas grietas de luz se abrieron en la tierra a su alrededor, como si su propio tarareo hubiera aflojado el suelo. La semilla pequeña dejó de temblar, y escuchó.',
      v_tarareo, array['tarareo'],
      '/images/la-semilla-que-aprendio-a-cantar/11-grietas-luz-tierra-tarareo.png'),

    (v_story_id, 12,
      'Poco a poco, con la voz quebrada, la semilla pequeña empezó a tararear también, insegura al principio, un poco más firme después.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/12-semilla-pequena-tararea-tambien.png'),

    (v_story_id, 13,
      'Cantando juntas, muy despacio, las dos empujaron hacia arriba a través de la tierra suavizada, sin soltarse la una a la otra ni por un momento.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/13-dos-semillas-empujan-juntas.png'),

    (v_story_id, 14,
      'Salieron a la luz al mismo tiempo, y se abrieron en flores de color {color_flor}, una junto a la otra, como si siempre hubieran estado destinadas a florecer juntas.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/14-flores-nacen-juntas-color.png'),

    (v_story_id, 15,
      'Una abeja vieja, que llevaba años visitando ese jardín, se detuvo un momento a mirarlas. —Nunca había visto florecer a dos cantando juntas —dijo—. El secreto nunca fue dejar de tener miedo. Fue cantar de todos modos.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/15-abeja-vieja-observa-comenta.png'),

    (v_story_id, 16,
      'Desde esa primavera, {nombre_semilla} y su amiga florecieron siempre juntas, año tras año, una al lado de la otra en el mismo rincón de {nombre_jardin}.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/16-semillas-florecen-cada-primavera.png'),

    (v_story_id, 17,
      '{nombre_semilla} entendió, por fin, que ser valiente nunca había significado dejar de tener miedo. Había significado cantar de todos modos — sobre todo cuando alguien más necesitaba escucharla.',
      null, array[]::text[],
      '/images/la-semilla-que-aprendio-a-cantar/17-semilla-reflexion-final.png');

end $$;
