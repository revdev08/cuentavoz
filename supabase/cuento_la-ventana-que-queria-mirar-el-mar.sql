do $$

declare

    v_story_id uuid;
    v_maquina uuid;
    v_pregon uuid;
    v_lluvia uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='la-ventana-que-queria-mirar-el-mar'
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
            es_personalizable,
            portada_url
        )

        values
        (
            'La ventana que quería mirar el mar',
            'la-ventana-que-queria-mirar-el-mar',
            '2-7 años',
            true,
            '/images/portadas/la-ventana-que-queria-mirar-el-mar.webp'
        )

        returning id
        into v_story_id;

    else

        update stories
        set titulo='La ventana que quería mirar el mar',
            edad_recomendada='2-7 años',
            es_personalizable=true,
            portada_url='/images/portadas/la-ventana-que-queria-mirar-el-mar.webp'
        where id=v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    if not exists (
        select 1 from sound_effects where nombre='maquina de coser'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('maquina de coser', '/sounds/maquina-de-coser.mp3', 'efecto');
    end if;

    if not exists (
        select 1 from sound_effects where nombre='pregon callejero'
    ) then
        insert into sound_effects (nombre, archivo_url, categoria)
        values ('pregon callejero', '/sounds/pregon-callejero.mp3', 'efecto');
    end if;

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    select id into v_maquina
    from sound_effects
    where nombre='maquina de coser'
    limit 1;

    select id into v_pregon
    from sound_effects
    where nombre='pregon callejero'
    limit 1;

    select id into v_lluvia
    from sound_effects
    where nombre='lluvia sobre ventana'
    limit 1;

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

        (v_story_id, 'nombre_ventana', 'texto', array['Clara', 'Vidia', 'Luna', 'Miranda']),
        (v_story_id, 'color_marco', 'color', array['azul añil', 'verde limón', 'rojo coral', 'amarillo mostaza']),
        (v_story_id, 'nombre_callejon', 'texto', array['Almendros', 'Carretas', 'Bugambilias', 'Canarios']),
        (v_story_id, 'nombre_nina', 'texto', array['Iris', 'Mara', 'Julián', 'Teo']);

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
        'En el taller de costura del callejón {nombre_callejon} había una ventana llamada {nombre_ventana}, con marco de color {color_marco}. Desde allí veía ropa tendida, bicicletas apoyadas y una frutera que ordenaba mangos. El traqueteo de una máquina marcaba todas sus mañanas.',
        v_maquina,
        array['traqueteo'],
        '/images/la-ventana-que-queria-mirar-el-mar/01-ventana-del-taller.webp'),

        (v_story_id, 2,
        'Una tarde llegó al taller una postal enviada desde la costa. Mostraba agua azul, barcas diminutas y una playa que parecía no terminar. La costurera dejó la postal junto al vidrio. {nombre_ventana} la contempló hasta que las sombras cubrieron el callejón.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/02-postal-junto-al-vidrio.webp'),

        (v_story_id, 3,
        'Desde ese día, su propia vista le pareció demasiado pequeña. —Si mirara el mar, todos vendrían a admirarme —pensaba. Ya no observaba al panadero equilibrando bandejas ni al perro que dormía bajo una silla. Comparaba cada rincón con aquella postal perfecta.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/03-sueno-de-vista-marina.webp'),

        (v_story_id, 4,
        'Cada mañana pasaba una vendedora de frutas. Su pregón subía entre los balcones mientras los vecinos bajaban canastas con cuerdas. Pero {nombre_ventana} mantenía los vidrios empañados. Decía que un callejón con mangos, sábanas y macetas jamás podría competir con una playa.',
        v_pregon,
        array['pregón'],
        '/images/la-ventana-que-queria-mirar-el-mar/04-callejon-de-las-canastas.webp'),

        (v_story_id, 5,
        'Entonces {nombre_nina}, aprendiz del taller, recibió un encargo especial: pintar sobre una tela enorme aquello que se veía desde su hogar. El mural cubriría la pared vacía de la plaza. —Tú me ayudarás a mirar —le dijo a {nombre_ventana}, limpiando una esquina del cristal.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/05-encargo-del-mural.webp'),

        (v_story_id, 6,
        '{nombre_ventana} temió que todos encontraran aburrida su vista. Durante la noche cubrió el vidrio con vaho y dibujó olas imaginarias. A la mañana siguiente aseguró que detrás de aquella niebla había delfines, conchas gigantes y un barco rojo navegando hacia la plaza.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/06-mar-dibujado-en-vaho.webp'),

        (v_story_id, 7,
        '{nombre_nina} intentó pintar lo que la ventana describía. Sin embargo, cada pregunta enredaba más la historia. ¿Cómo cabía una ballena entre dos tejados? ¿Por qué el faro tenía macetas? {nombre_ventana} añadió respuestas apresuradas hasta que su mar inventado dejó de parecer verdadero.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/07-boceto-imposible.webp'),

        (v_story_id, 8,
        '—No necesito una vista famosa —dijo {nombre_nina}, dejando el pincel—. Necesito la vista que solamente tú puedes mostrarme. {nombre_ventana} guardó silencio. Podía desempañar sus cristales, pero todavía le avergonzaba que aparecieran una pared descascarada y tres calcetines sin pareja.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/08-pincel-en-reposo.webp'),

        (v_story_id, 9,
        'Esa tarde comenzó la lluvia. Las gotas golpearon el vidrio y abrieron caminos transparentes sobre el vaho. Por aquellas líneas, {nombre_ventana} vio retazos del callejón: un paraguas violeta, una caja de limones y las manos del panadero protegiendo sus panes.',
        v_lluvia,
        array['lluvia'],
        '/images/la-ventana-que-queria-mirar-el-mar/09-lluvia-abre-caminos.webp'),

        (v_story_id, 10,
        'Un charco creció bajo la ropa tendida. Las sábanas azules se reflejaron como olas; los limones parecieron peces amarillos y el paraguas se convirtió en una medusa. No era el mar de la postal. Era algo que ninguna postal del mundo podía repetir.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/10-oceano-en-el-charco.webp'),

        (v_story_id, 11,
        '{nombre_ventana} dejó escapar el vaho. El vidrio se aclaró de arriba abajo. —Mira ahora —pidió. {nombre_nina} acercó la tela y comenzó otra vez: pintó las cuerdas de canastas, al perro dormido, las bicicletas y el pequeño océano que la lluvia había formado.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/11-vidrio-finalmente-claro.webp'),

        (v_story_id, 12,
        'Los vecinos descubrieron el mural secándose dentro del taller. Cada uno reconoció un detalle y añadió otro. La frutera pintó una hoja. El panadero dibujó vapor sobre sus panes. Incluso tres calcetines desparejados terminaron flotando como banderas alegres sobre el callejón.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/12-vecinos-anaden-detalles.webp'),

        (v_story_id, 13,
        'Cuando escampó, llevaron la tela hasta la plaza. No mostraba palmeras perfectas ni barcos lejanos. Mostraba personas asomadas, balcones torcidos, plantas creciendo en latas y un charco lleno de cielo. Quienes pasaban se detenían porque siempre encontraban algo nuevo y distinto.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/13-mural-en-la-plaza.webp'),

        (v_story_id, 14,
        'Desde el taller, {nombre_ventana} alcanzaba a ver una esquina del mural. Comprendió que había deseado el paisaje de otra ventana sin conocer sus propios tesoros. Su callejón no necesitaba parecer una costa. Bastaba mirarlo despacio para descubrir cuánto estaba ocurriendo.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/14-ventana-mira-el-mural.webp'),

        (v_story_id, 15,
        'La costurera apoyó la postal frente al mural y sonrió. —Una vista no vale por ser grande o lejana —dijo—. Vale por lo que aprendemos a mirar en ella. {nombre_nina} abrió ambas hojas de {nombre_ventana}, dejando entrar los colores de la tarde.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/15-postal-y-mural.webp'),

        (v_story_id, 16,
        'Desde entonces, {nombre_ventana} siguió soñando con conocer el mar, pero dejó de usar aquel sueño para empequeñecer su callejón. Cada mañana buscaba un detalle que no hubiera visto antes. Descubrió que mirar lejos inspira; mirar cerca, con cariño, también abre mundos enteros.',
        null,
        array[]::text[],
        '/images/la-ventana-que-queria-mirar-el-mar/16-nueva-mirada-cotidiana.webp');

end $$;

-- Assets
-- Portada:
-- /images/portadas/la-ventana-que-queria-mirar-el-mar.webp
-- Imágenes:
-- 01-ventana-del-taller.webp
-- 02-postal-junto-al-vidrio.webp
-- 03-sueno-de-vista-marina.webp
-- 04-callejon-de-las-canastas.webp
-- 05-encargo-del-mural.webp
-- 06-mar-dibujado-en-vaho.webp
-- 07-boceto-imposible.webp
-- 08-pincel-en-reposo.webp
-- 09-lluvia-abre-caminos.webp
-- 10-oceano-en-el-charco.webp
-- 11-vidrio-finalmente-claro.webp
-- 12-vecinos-anaden-detalles.webp
-- 13-mural-en-la-plaza.webp
-- 14-ventana-mira-el-mural.webp
-- 15-postal-y-mural.webp
-- 16-nueva-mirada-cotidiana.webp
-- Sonidos nuevos:
-- maquina-de-coser.mp3
-- pregon-callejero.mp3
