do $$

declare
    v_story_id uuid;
    v_portazo uuid;
    v_tambor uuid;
    v_papel uuid;

begin

    select id into v_story_id from stories
    where slug='el-portazo-que-queria-la-ultima-palabra' limit 1;

    if v_story_id is null then
        insert into stories
        (titulo, slug, edad_recomendada, es_personalizable, portada_url)
        values
        ('El portazo que quería la última palabra',
         'el-portazo-que-queria-la-ultima-palabra',
         '2-7 años', true,
         '/images/portadas/el-portazo-que-queria-la-ultima-palabra.webp')
        returning id into v_story_id;
    else
        update stories
        set titulo='El portazo que quería la última palabra',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/el-portazo-que-queria-la-ultima-palabra.webp'
        where id=v_story_id;
    end if;

    if not exists (select 1 from sound_effects where nombre='portazo') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('portazo', '/sounds/portazo.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='tambor de feria') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('tambor de feria', '/sounds/tambor-de-feria.mp3', 'efecto');
    end if;

    if not exists (select 1 from sound_effects where nombre='papel revoloteando') then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('papel revoloteando', '/sounds/papel-revoloteando.mp3', 'efecto');
    end if;

    select id into v_portazo from sound_effects where nombre='portazo' limit 1;
    select id into v_tambor from sound_effects where nombre='tambor de feria' limit 1;
    select id into v_papel from sound_effects where nombre='papel revoloteando' limit 1;

    delete from story_variables where story_id=v_story_id;

    insert into story_variables
    (story_id, variable_key, tipo, opciones_sugeridas)
    values
        (v_story_id, 'nombre_portazo', 'texto', array['Bum', 'Trueno', 'Pum', 'Sacudón']),
        (v_story_id, 'nombre_nino', 'texto', array['Dani', 'Iker', 'Alma', 'Renata']),
        (v_story_id, 'nombre_amiga', 'texto', array['Nora', 'Sami', 'Julia', 'Benjamín']),
        (v_story_id, 'nombre_teatro', 'texto', array['Teatro Candileja', 'Teatro del Sol', 'Teatro Colibrí', 'Teatro Bambalina']),
        (v_story_id, 'color_telon', 'color', array['rojo granada', 'azul profundo', 'verde jade', 'violeta ciruela']);

    delete from story_blocks where story_id=v_story_id;

    insert into story_blocks
    (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
    values

        (v_story_id, 1,
        'En el {nombre_teatro}, {nombre_nino} preparaba el tambor para una obra de pájaros de papel. Había inventado el ritmo inicial y esperaba tocarlo bajo el telón {color_telon}. Cada golpe debía despertar una gran bandada suspendida sobre el escenario.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/01-ensayo-bajo-pajaros-de-papel.webp'),

        (v_story_id, 2,
        'Antes del ensayo, {nombre_amiga} movió el tambor hacia un costado y acortó la entrada musical. —La bandada necesita más espacio —explicó rápidamente. Pero las demás personas comenzaron a trabajar antes de que {nombre_nino} pudiera responder. Sintió calor en las orejas.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/02-tambor-movido-sin-preguntar.webp'),

        (v_story_id, 3,
        '{nombre_nino} intentó tocar desde el nuevo lugar. Las cuerdas del decorado tapaban su vista y nadie siguió el ritmo. Detuvo las baquetas. —Da igual —murmuró, aunque no daba igual. Caminó hasta el cuarto de utilería y cerró la puerta con un BAM.',
        v_portazo, array['BAM'],
        '/images/el-portazo-que-queria-la-ultima-palabra/03-portazo-en-la-utileria.webp'),

        (v_story_id, 4,
        'Del golpe nació {nombre_portazo}, una sacudida roja con forma de zigzag. No tenía cara ni manos, pero sabía empujar puertas. —¡Por fin alguien habló fuerte! —parecía decir con cada rebote. {nombre_nino} sintió por un instante que aquella explosión lo defendía.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/04-zigzag-rojo-despierta.webp'),

        (v_story_id, 5,
        '{nombre_portazo} escapó por el pasillo. Cerró el camerino, sacudió la taquilla y golpeó la puerta del escenario. Cada BAM era más grande que el anterior. Los actores dejaron de ensayar y las sombras de papel temblaron sobre las paredes.',
        v_portazo, array['BAM'],
        '/images/el-portazo-que-queria-la-ultima-palabra/05-portazos-por-el-pasillo.webp'),

        (v_story_id, 6,
        'Al llegar a las bambalinas, el zigzag empujó dos puertas al mismo tiempo. El aire subió con fuerza hasta la bandada suspendida. Cien pájaros hicieron flap-flap, soltaron sus hilos y revolotearon por el teatro como una tormenta de alas blancas.',
        v_papel, array['flap-flap'],
        '/images/el-portazo-que-queria-la-ultima-palabra/06-tormenta-de-pajaros-de-papel.webp'),

        (v_story_id, 7,
        'Una actriz pequeña se cubrió los oídos. El encargado de luces casi dejó caer una lámpara. {nombre_amiga} protegió el decorado mientras varios pájaros aterrizaban en su cabello. {nombre_nino} seguía enojado, pero ya no se sentía defendido. Se sentía responsable.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/07-ensayo-interrumpido.webp'),

        (v_story_id, 8,
        'Primero intentó atrapar a {nombre_portazo} empujándolo dentro de un baúl. El zigzag salió por la cerradura todavía más afilado. Luego fingió que no estaba enojado. La sacudida se escondió bajo el escenario y comenzó a hacer vibrar todas las tablas.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/08-enojo-dentro-del-baul.webp'),

        (v_story_id, 9,
        '{nombre_nino} dejó las baquetas en el suelo y puso ambos pies muy firmes. No persiguió al portazo. Dijo en voz clara: —Estoy enojado. Cambiaron mi parte sin escucharme. Necesito explicar por qué desde ese rincón no puedo tocar bien.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/09-nino-nombra-su-enojo.webp'),

        (v_story_id, 10,
        'El zigzag rojo se detuvo. Seguía siendo intenso, pero ya no necesitaba golpear para hacerse notar. Se dobló sobre sí mismo hasta quedar del tamaño de una cinta. {nombre_amiga} se acercó muy despacio y pidió escuchar la explicación completa.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/10-zigzag-se-vuelve-cinta.webp'),

        (v_story_id, 11,
        '{nombre_nino} mostró las cuerdas que bloqueaban su vista. {nombre_amiga} explicó que había movido el tambor para proteger a los pájaros, pero reconoció que decidió sin preguntar. Juntos probaron tres lugares hasta encontrar uno visible, seguro y cercano al escenario.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/11-tres-lugares-para-el-tambor.webp'),

        (v_story_id, 12,
        'Después repararon lo ocurrido. {nombre_nino} pidió disculpas por asustar al grupo y ayudó a desenredar cada pájaro. Nadie le exigió disculparse por sentir rabia. La emoción era válida; lo que necesitaba reparación era la manera en que había salido.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/12-reparar-la-bandada.webp'),

        (v_story_id, 13,
        'Al reiniciar cuidadosamente el ensayo, el tambor marcó tum-tum desde su nueva posición completamente segura. {nombre_amiga} levantó el telón {color_telon} y los pájaros descendieron en círculos. La pequeña cinta roja acompañó el ritmo sin cerrar una sola puerta.',
        v_tambor, array['tum-tum'],
        '/images/el-portazo-que-queria-la-ultima-palabra/13-ritmo-y-bandada-reparada.webp'),

        (v_story_id, 14,
        '—El enojo puede avisarnos que algo importa o que necesitamos un límite —dijo {nombre_nino}—. Merece palabras y atención, pero no permiso para asustar o lastimar. {nombre_portazo} se acomodó alrededor de una baqueta, satisfecho de seguir siendo fuerte sin mandar sobre todos.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/14-conversacion-tras-el-ensayo.webp'),

        (v_story_id, 15,
        'La función terminó sin premio para nadie. En el saludo final, cada actor sostuvo un pájaro reparado y {nombre_nino} tocó su ritmo completo. El público vio una bandada; quienes habían ensayado vieron también las pequeñas arrugas donde el papel fue cuidado.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/15-funcion-con-pajaros-reparados.webp'),

        (v_story_id, 16,
        'Desde entonces, cuando el calor volvía a sus orejas, {nombre_nino} apoyaba los pies y nombraba lo ocurrido antes de cerrar una puerta. {nombre_portazo} no desapareció: se convirtió en energía para hablar, proponer y reparar. Tener la última palabra dejó de ser lo importante.',
        null, array[]::text[],
        '/images/el-portazo-que-queria-la-ultima-palabra/16-enojo-convertido-en-voz.webp');

end $$;

-- Assets
-- Portada: /images/portadas/el-portazo-que-queria-la-ultima-palabra.webp
-- Sonidos:
-- /sounds/portazo.mp3
-- /sounds/tambor-de-feria.mp3
-- /sounds/papel-revoloteando.mp3
