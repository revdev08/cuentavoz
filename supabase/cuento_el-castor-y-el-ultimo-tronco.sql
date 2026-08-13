-- Décimo cuento generado con el sistema escritor-cuentavoz/.
--
-- "El castor y el último tronco"
--
-- Protagonista: un castor (vuelve a ser animal, distinto al erizo).
-- Escenario: un arroyo con una presa a medio construir (primer cuento
-- de castor/presa -- distinto a cocina, caminos, pueblo nevado, valle,
-- jardín, río de barco de papel, bosque de otoño, huerto de cosecha).
-- Conflicto: terminar algo que empezó -- no usado antes (dejó su presa
-- a medias por miedo a que el último tronco fuera imposible). Magia:
-- sonidos (un arroyo solo "canta" de verdad, con un zumbido profundo,
-- cuando una presa queda completa -- nunca resuelve el conflicto sola,
-- el castor igual tiene que cargar el último tronco). Quién inicia el
-- cambio: una nutria joven que llega buscando un hogar en el estanque
-- que todavía no existe (personaje secundario nuevo). Quién expresa la
-- enseñanza: la misma nutria, cuando el estanque por fin se llena (no
-- un animal viejo y sabio esta vez -- ya van dos cuentos seguidos con
-- ese recurso, tortuga y tejón, así que aquí se evita a propósito).
-- Emoción dominante: satisfacción (variante fresca -- las siete
-- emociones listadas en 01-identidad.md ya se usaron todas en los
-- cuentos anteriores). Regalo/cierre: una habilidad nueva -- el castor
-- termina sabiendo de verdad cómo construir una presa (no costumbre,
-- camino, canción, árbol, amistad, lugar descubierto, abrazo ni
-- promesa como cierre principal).
--
-- Escena inolvidable: el sonido delgado y triste del arroyo se
-- transforma, muy despacio, en un zumbido profundo y calmado en cuanto
-- el último tronco encaja -- como si el arroyo entero hubiera estado
-- conteniendo esa canción, esperando el tronco correcto para cantarla.
--
-- No usa: castillos, princesas, reyes, hadas madrinas, cofres, llaves
-- doradas, portales mágicos, profecías, piedras mágicas ni mapas del
-- tesoro.
--
-- Sonidos: a pedido explícito, este cuento privilegia sonidos poco
-- usados en el catálogo hasta ahora (arroyo y chapoteo tenían solo 1
-- aparición cada uno en los 9 cuentos anteriores; abejas del huerto y
-- búho sabio, muy pocas). A propósito NO usa viento ni crujido esta
-- vez -- son los dos sonidos más repetidos del catálogo hasta ahora.
-- Reutiliza 4 sonidos existentes (arroyo, chapoteo, abejas del huerto,
-- búho sabio). No necesita ningún sonido nuevo.
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
    v_arroyo uuid;
    v_chapoteo uuid;
    v_abejas uuid;
    v_buho uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='el-castor-y-el-ultimo-tronco'
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
            'El castor y el último tronco',
            'el-castor-y-el-ultimo-tronco',
            '2-7 años',
            'Naturaleza',
            true,
            null
        )

        returning id
        into v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos (ninguno -- todos ya existen en el catálogo)
    --------------------------------------------------

    if not exists (select 1 from sound_effects where nombre='arroyo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('arroyo', '/sounds/arroyo.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='chapoteo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('chapoteo', '/sounds/chapoteo.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='abejas del huerto') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('abejas del huerto', '/sounds/abejas.mp3', 'ambiente');
    end if;

    if not exists (select 1 from sound_effects where nombre='buho sabio') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('buho sabio', '/sounds/buho.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_arroyo from sound_effects where nombre='arroyo' limit 1;
    select id into v_chapoteo from sound_effects where nombre='chapoteo' limit 1;
    select id into v_abejas from sound_effects where nombre='abejas del huerto' limit 1;
    select id into v_buho from sound_effects where nombre='buho sabio' limit 1;

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

    (v_story_id, 'nombre_castor', 'texto', array['Roble','Corteza','Nogal','Palo','Tronco','Avellano']),
    (v_story_id, 'color_pelaje', 'color', array['café','marrón','dorado','gris','cobrizo','negro','canela','beige']),
    (v_story_id, 'nombre_arroyo', 'texto', array['Arroyo Claro','Río Manso','Aguasvivas','El Cristalino','Arroyo Verde','Río Tranquilo']);

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
      'Desde la primavera, {nombre_castor}, de pelaje color {color_pelaje}, había estado construyendo una presa sobre {nombre_arroyo}, tronco a tronco, con un sueño enorme en la cabeza. Pero a mitad de camino, cuando el trabajo se puso difícil de verdad, {nombre_castor} simplemente dejó de intentarlo.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/01-castor-presa-a-medias-primavera.png'),

    (v_story_id, 2,
      'Desde entonces, {nombre_arroyo} hacía un sonido delgado y triste al pasar por el hueco de la presa a medio hacer -- muy distinto al zumbido profundo que se escuchaba corriente abajo, donde otras presas ya estaban terminadas. Se decía que un arroyo solo canta de verdad cuando una presa queda completa.',
      v_arroyo, array['arroyo'],
      '/images/el-castor-y-el-ultimo-tronco/02-arroyo-sonido-triste-hueco.png'),

    (v_story_id, 3,
      '{nombre_castor} recordaba, de cuando era más pequeño, algo que le habían enseñado: cada tronco cuenta, hasta el último. En ese momento no le había parecido importante. Ahora, mirando su presa a medias, esas palabras pesaban distinto.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/03-castor-recuerda-ensenanza-troncos.png'),

    (v_story_id, 4,
      'Pasaron los meses y {nombre_castor} evitaba pasar cerca de su propia presa, avergonzado. Prefería mirar desde lejos los estanques de las demás familias, ya completos, ya tranquilos.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/04-castor-evita-presa-averguenza.png'),

    (v_story_id, 5,
      'Cerca de la orilla, las abejas zumbaban de flor en flor, ajenas por completo a la obra inconclusa. La vida en {nombre_arroyo} seguía su curso, esperara quien esperara.',
      v_abejas, array['abejas'],
      '/images/el-castor-y-el-ultimo-tronco/05-abejas-orilla-vida-continua.png'),

    (v_story_id, 6,
      'Una nutria joven llegó buscando un hogar, atraída por los rumores de un nuevo estanque en camino. Encontró, en cambio, apenas un charco pequeño donde debía haber agua profunda.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/06-nutria-joven-llega-busca-hogar.png'),

    (v_story_id, 7,
      '—¿Cuándo va a estar listo el estanque? —preguntó la nutria, sin malicia. {nombre_castor} sintió calor en las mejillas. —Pronto —mintió, sin ninguna intención real de volver a intentarlo—. Muy pronto.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/07-nutria-pregunta-castor-miente.png'),

    (v_story_id, 8,
      'Pero la nutria no se fue. Cada tarde volvía a sentarse junto al hueco de la presa, paciente, sin exigir nada, solo esperando con una confianza que {nombre_castor} no entendía de dónde sacaba.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/08-nutria-espera-paciente-cada-tarde.png'),

    (v_story_id, 9,
      'Verla ahí, día tras día, esperando algo que dependía por completo de {nombre_castor}, empezó a pesar más que el miedo al último tronco.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/09-castor-observa-nutria-siente-peso.png'),

    (v_story_id, 10,
      'Una mañana, sin decir nada, {nombre_castor} nadó corriente arriba, buscando el tronco más grande y más pesado que pudo encontrar. Era hora, por fin, de terminar lo que había empezado.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/10-castor-busca-ultimo-tronco-grande.png'),

    (v_story_id, 11,
      'Arrastrarlo hasta la presa costó todo lo que {nombre_castor} tenía. Al encajarlo en el hueco, el agua chapoteó con fuerza, empujando, resistiéndose a quedarse quieta.',
      v_chapoteo, array['chapoteó'],
      '/images/el-castor-y-el-ultimo-tronco/11-tronco-encaja-agua-chapotea.png'),

    (v_story_id, 12,
      'Por un momento, {nombre_castor} quiso soltarlo todo y rendirse, otra vez. Pero pensó en la nutria, esperando pacientemente cada tarde, y sostuvo el tronco con las últimas fuerzas que le quedaban.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/12-castor-casi-se-rinde-piensa-nutria.png'),

    (v_story_id, 13,
      'Con un último empujón, el tronco encajó en su lugar exacto. El agua, que hasta hacía un segundo chapoteaba y se escapaba por todos lados, de pronto dejó de moverse.',
      v_chapoteo, array['chapoteaba'],
      '/images/el-castor-y-el-ultimo-tronco/13-ultimo-empujon-agua-se-detiene.png'),

    (v_story_id, 14,
      'Despacio, el sonido delgado y triste del arroyo se fue transformando en un zumbido profundo y calmado, completamente distinto al de antes -- como si {nombre_arroyo} entero hubiera estado conteniendo esa canción, esperando el tronco correcto para por fin cantarla.',
      v_arroyo, array['arroyo'],
      '/images/el-castor-y-el-ultimo-tronco/14-arroyo-canta-zumbido-profundo.png'),

    (v_story_id, 15,
      'La nutria se lanzó de cabeza al agua nueva y profunda, dando vueltas de alegría. —Sabía que ibas a terminarlo —dijo, saliendo a tomar aire—. El arroyo también lo sabía. Por eso nunca dejó de esperar.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/15-nutria-nada-feliz-estanque-nuevo.png'),

    (v_story_id, 16,
      'Cayó la tarde sobre el nuevo estanque, y en algún árbol cercano un búho ululó una sola vez, tranquilo, como saludando el trabajo terminado.',
      v_buho, array['ululó'],
      '/images/el-castor-y-el-ultimo-tronco/16-atardecer-buho-ulula-estanque.png'),

    (v_story_id, 17,
      '{nombre_castor} entendió, por fin, que terminar nunca había sido cuestión de no tener miedo al último tronco. Había sido, simplemente, cuestión de cargarlo de todos modos -- tarde, cansado, pero de todos modos.',
      null, array[]::text[],
      '/images/el-castor-y-el-ultimo-tronco/17-castor-reflexion-final.png');

end $$;
