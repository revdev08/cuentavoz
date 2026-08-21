do $$

declare
    v_story_id uuid;
    v_cremallera uuid;
    v_timbre uuid;
    v_risas uuid;

begin

    select id into v_story_id from stories
    where slug='la-mochila-de-las-dos-mananas' limit 1;

    if v_story_id is null then
        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)
        values
        ('La mochila de las dos mañanas',
         'la-mochila-de-las-dos-mananas',
         '2-7 años', true,
         '/images/portadas/la-mochila-de-las-dos-mananas.webp')
        returning id into v_story_id;
    else
        update stories
        set titulo='La mochila de las dos mañanas',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/la-mochila-de-las-dos-mananas.webp'
        where id=v_story_id;
    end if;

    if not exists (select 1 from sound_effects where nombre='cremallera') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('cremallera', '/sounds/cremallera.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='timbre escolar') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('timbre escolar', '/sounds/timbre-escolar.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='risas infantiles') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('risas infantiles', '/sounds/risas-infantiles.mp3', 'efecto');
    end if;

    select id into v_cremallera from sound_effects where nombre='cremallera' limit 1;
    select id into v_timbre from sound_effects where nombre='timbre escolar' limit 1;
    select id into v_risas from sound_effects where nombre='risas infantiles' limit 1;

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)
    values
        (v_story_id, 'nombre_nino', 'texto', array['Alma', 'Dani', 'Emilia', 'Mateo', 'Sami', 'Tomás']),
        (v_story_id, 'nombre_mochila', 'texto', array['Pipa', 'Bolsita', 'Nube', 'Menta', 'Toto', 'Luna']),
        (v_story_id, 'color_mochila', 'color', array['azul cielo', 'rojo coral', 'verde menta', 'violeta']),
        (v_story_id, 'nombre_escuela', 'texto', array['Jardín Colibrí', 'Escuela Girasol', 'Casa de las Rondas', 'Jardín Arcoíris']),
        (v_story_id, 'objeto_compania', 'texto', array['un pañuelo suave', 'una piedrita lisa', 'una foto familiar', 'un muñeco pequeño']);

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
    values

        (v_story_id, 1,
        'La primera mañana de escuela, {nombre_mochila} esperaba sobre una silla junto a la mesa del desayuno. Era una mochila {color_mochila}, recién estrenada y bastante nerviosa. {nombre_nino} guardó colores, una merienda y algo especialmente elegido para sentirse acompañado: {objeto_compania}. Después cerró cuidadosamente cada pequeño bolsillo.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/01-mochila-sobre-la-silla.webp'),

        (v_story_id, 2,
        'Antes de salir, {nombre_mochila} intentó memorizar toda la casa: el olor del desayuno, la ventana iluminada y la voz que decía «nos veremos después». Temía que, al cruzar la puerta, todo aquello desapareciera. Por eso apretó suavemente sus correas alrededor de {nombre_nino}.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/02-memorizar-la-casa.webp'),

        (v_story_id, 3,
        'Frente a {nombre_escuela}, muchas familias se despedían de maneras muy diferentes. Algunas daban tres besos; otras chocaban las manos o cantaban brevemente. {nombre_nino} abrazó fuerte a quien lo acompañaba. {nombre_mochila} sintió exactamente el mismo nudo, aunque las mochilas no tienen garganta para explicarlo.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/03-despedidas-en-la-entrada.webp'),

        (v_story_id, 4,
        'Sonó ring-ring y la gran puerta se abrió. {nombre_nino} entró mirando hacia atrás lentamente. {nombre_mochila} decidió mantener todos sus bolsillos cerrados. Imaginaba que, si dejaba salir cualquier cosa, también escaparían el desayuno, la ventana y aquella voz querida que había prometido regresar.',
        v_timbre, array['ring-ring'],
        '/images/la-mochila-de-las-dos-mananas/04-primer-timbre.webp'),

        (v_story_id, 5,
        'En el salón pidieron los colores para dibujar. {nombre_nino} tiró suavemente de la cremallera, pero {nombre_mochila} se puso rígida. Solo permitió un pequeño zzzip. Por la abertura apareció un lápiz amarillo y también salió un poquito del olor conocido de casa lentamente.',
        v_cremallera, array['zzzip'],
        '/images/la-mochila-de-las-dos-mananas/05-abertura-pequena.webp'),

        (v_story_id, 6,
        'El olor no desapareció al salir. Se quedó muy cerca de {nombre_nino}, mezclado con plastilina, jabón y madera. {nombre_mochila} aflojó una correa despacio. Quizá las cosas de casa podían acompañarlos sin permanecer encerradas. Aun así, conservó firmemente cerrado el bolsillo más pequeño.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/06-aromas-que-se-mezclan.webp'),

        (v_story_id, 7,
        'Durante la ronda, cada persona contó cómo se sentía. Hubo emoción, sueño, mucha curiosidad y un poco de miedo. Cuando llegó su turno, {nombre_nino} dijo: —Quiero estar aquí, pero también extraño mi casa. Nadie intentó borrar una emoción para dejar únicamente la otra.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/07-ronda-de-emociones.webp'),

        (v_story_id, 8,
        '{nombre_mochila} escuchó atentamente desde el perchero. Comprendió que aquel nudo no significaba que la mañana estuviera saliendo mal. Significaba que había alguien muy importante esperando al otro lado de la puerta. Con un zzzip decidido, abrió el bolsillo pequeño y mostró {objeto_compania}.',
        v_cremallera, array['zzzip'],
        '/images/la-mochila-de-las-dos-mananas/08-bolsillo-de-compania.webp'),

        (v_story_id, 9,
        'Al salir al patio, el sol brillante proyectó dos sombras: la de {nombre_nino} y la de {nombre_mochila}. Cuando caminaron, ambas se estiraron hasta tocar la sombra del portón, como un puente oscuro hacia la despedida. Luego volvieron juntas tranquilamente hasta los juegos.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/09-puente-de-sombras.webp'),

        (v_story_id, 10,
        'Primero observaron en silencio desde un banco. Después {nombre_nino} se acercó a una construcción de bloques. Una torre cayó, alguien propuso convertirla en carretera y pronto llegaron risas desde todos lados. {nombre_mochila} descubrió que disfrutar allí no traicionaba a quienes estaban en casa.',
        v_risas, array['risas'],
        '/images/la-mochila-de-las-dos-mananas/10-carretera-de-bloques.webp'),

        (v_story_id, 11,
        'A la hora de la merienda, {nombre_nino} abrió la mochila por completo. Sacó el pan, compartió una historia sobre {objeto_compania} y guardó dentro un dibujo completamente nuevo. Ahora {nombre_mochila} llevaba recuerdos de casa y recuerdos de escuela sin que ninguno expulsara al otro.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/11-dos-clases-de-recuerdos.webp'),

        (v_story_id, 12,
        'Miró las otras mochilas cuidadosamente alineadas. Una guardaba una fotografía; otra, una hoja perfumada; otra no llevaba ningún objeto, pero conocía una canción familiar. Cada cual había encontrado una forma distinta de cruzar aquella mañana. No existía una despedida perfecta.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/12-mochilas-del-perchero.webp'),

        (v_story_id, 13,
        'Cuando volvió a sonar el timbre, {nombre_nino} corrió hacia la entrada. La persona que había prometido regresar estaba allí. El abrazo fue largo, pero no borró lo vivido. Entre ambos contaron la torre, la ronda, el dibujo y también el momento difícil.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/13-reencuentro-en-el-porton.webp'),

        (v_story_id, 14,
        '—Extrañar a alguien y disfrutar un lugar completamente nuevo pueden caber juntos en la misma mañana —dijo {nombre_nino}. {nombre_mochila} abrió alegremente sus dos bolsillos como si estuviera de acuerdo. Uno olía un poco a casa; el otro, a plastilina y aventura reciente.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/14-dos-bolsillos-abiertos.webp'),

        (v_story_id, 15,
        'Al día siguiente, antes de separarse, dieron tres golpecitos suaves sobre la tela {color_mochila}: uno por el cariño, otro por el regreso y otro por todo lo que podía suceder entretanto. El nudo seguía allí, pero ya tenía espacio para respirar.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/15-tres-golpecitos.webp'),

        (v_story_id, 16,
        '{nombre_mochila} entró nuevamente a {nombre_escuela} sobre la espalda de {nombre_nino}. No necesitó encerrar la casa para conservarla. Había aprendido que el cariño siempre puede viajar con nosotros sin sujetarnos al mismo lugar, y que una mañana alcanza para sentir más de una cosa.',
        null, array[]::text[],
        '/images/la-mochila-de-las-dos-mananas/16-segunda-manana.webp');

end $$;

-- Assets
-- Portada: /images/portadas/la-mochila-de-las-dos-mananas.webp
-- Sonidos:
-- /sounds/cremallera.mp3 (nuevo)
-- /sounds/timbre-escolar.mp3 (nuevo)
-- /sounds/risas-infantiles.mp3 (ya existe)
