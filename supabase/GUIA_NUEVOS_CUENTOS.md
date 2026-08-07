# Guía para generar cuentos nuevos en Cuentavoz

Catálogo reiniciado desde cero. Flujo: copia el prompt de la sección 1,
pégalo en una IA con el tema que quieras, y te devuelve **el archivo
`.sql` completo listo para ejecutar** en Supabase, más la lista de
imágenes y sonidos que hay que conseguir. Sin paso intermedio.

## 0. Qué es un cuento aquí

Un padre o una madre le lee el cuento en voz alta a su hijo desde el
celular. El objetivo no es solo entretener — es crear un recuerdo
bonito entre quien lee y quien escucha. Cada cuento tiene bloques
(pantalla = imagen + párrafo corto), variables que personalizan el
texto, y algunos bloques tienen un sonido que se activa al leer o tocar
su palabra clave. Cada cuento vive en un solo archivo
`supabase/cuento_<slug>.sql`.

## 1. El prompt

Copia todo el bloque de abajo, reemplaza `[TEMA DEL CUENTO]` (o deja
"sorpréndeme"), y pega también la tabla de la sección 4 (recursos ya
usados) al final antes de enviarlo.

````
Vas a escribir un cuento infantil interactivo para la app Cuentavoz.
Lo va a leer en voz alta un padre o una madre desde el celular, para un
niño de entre 2 y 7 años. El objetivo NO es solo entretener: es crear
un recuerdo bonito entre quien lee y quien escucha.

Escribe con la sensibilidad de los grandes cuentos clásicos (Hermanos
Grimm, Andersen, Beatrix Potter, Kenneth Grahame), pero sin copiar
personajes, argumentos, escenarios ni estructuras -- el cuento debe
sentirse completamente original, como si perteneciera a un libro
distinto a los anteriores. Antes de escribir, revisa la tabla de
"recursos ya usados" que pego al final y evita repetirlos sin querer.

TEMA: [TEMA DEL CUENTO -- o "sorpréndeme, que no se parezca a los anteriores"]

## Reglas narrativas

- El protagonista puede ser cualquier cosa capaz de sentir: no siempre
  un niño o un animal. Una nube, una piedra, una campana, un farol, una
  hoja, un reloj, una semilla, un zapato -- lo que sirva a esta historia.
- Varía deliberadamente respecto al cuento anterior: protagonista,
  escenario, conflicto, emoción principal, tipo de magia, y quién
  transmite la enseñanza. No reutilices la misma estructura narrativa.
- El conflicto no siempre es "encontrar algo perdido". Puede ser miedo,
  orgullo, impaciencia, timidez, egoísmo, exceso de confianza,
  dificultad para pedir ayuda o para perdonar, no escuchar, olvidar
  agradecer, miedo al cambio, creer que uno no sirve, prometer algo
  difícil.
- La magia nunca resuelve el conflicto por sí sola -- el protagonista
  tiene que decidir. Puede aparecer mediante canciones, viento, lluvia,
  reflejos, estrellas, ecos, sombras, aromas, estaciones, estelas de
  luz -- evita que sea "una luz brillante que arregla todo".
- La moraleja se siembra al principio, se pone a prueba a mitad, y
  algún personaje (o el propio protagonista) la dice en voz alta cerca
  del final, de forma natural -- nunca escribas "la moraleja es...".
  El protagonista la repite con sus propias palabras en el cierre.
- El cuento provoca UNA emoción principal (ternura, curiosidad,
  esperanza, calma, admiración, asombro, alegría) -- no todas a la vez.
- Incluye al menos una escena verdaderamente memorable, una imagen que
  se quede en la cabeza del niño. Invéntala, no copies ejemplos de otro
  cuento.
- El final no siempre entrega un objeto para guardar. Puede ser un
  nuevo amigo, una tradición, una canción, un lugar descubierto, una
  habilidad nueva, un abrazo.
- Escribe para ser leído en voz alta: alterna frases cortas y largas,
  imágenes poéticas simples, sin abusar de adjetivos. Muestra más de lo
  que explicas. El adulto que lo lee también debe disfrutarlo.

## Reglas técnicas

- 14-22 bloques, 40-50 palabras cada uno.
- Define solo las variables que la historia necesite (no estás limitado
  a nombre/color/animal -- pueden ser otras, y pueden ser más o menos
  de tres). Cada variable es SIEMPRE texto libre además de tener
  opciones sugeridas, sin artículo incluido en las opciones ("llave",
  no "una llave").
- Si una variable representa un sustantivo al que el texto le pone
  artículo, escribe `{un_variable} {variable}` o `{el_variable}
  {variable}` -- nunca un artículo fijo.
- Si defines una variable de color y la vas a usar como adjetivo de
  algo, escribe siempre `de color {variable}` (nunca pegada
  directamente a un sustantivo, ej. NO "luz {color}") -- así el
  adjetivo nunca necesita concordar en género con nada, porque "color"
  siempre es masculino sin importar la palabra que sigue.

## Sonidos -- regla estricta

Usa un sonido por bloque solo cuando de verdad aporte, y la palabra
clave que subrayas tiene que ser algo que un niño reconocería como un
SONIDO REAL, no un verbo o sustantivo visual. Esto es importante:
"brilló", "brillaba", "parpadeó", "resplandecía" NO valen como palabra
clave, aunque el bloque tenga un efecto de "destello mágico" -- brillar
no suena, y un niño no espera que tocar esa palabra haga ruido. Usa
"destello mágico" solo si el texto describe algo con sonido propio (un
chisporroteo, un chasquido), nunca solo por acompañar un brillo.

Palabras clave válidas son sonidos inequívocos: gotas de lluvia, pasos,
un animal, el viento, una campana, algo que se rompe o cruje, un
chapoteo, algo que canta o zumba. Si ningún momento del bloque tiene
una palabra así, el bloque se queda sin sonido.

Reutiliza uno de estos si aplica: pasos sobre hojas, viento entre
árboles, lluvia mágica, pájaros del bosque, campanita mágica, búho
sabio, arroyo, chapoteo, crujido, grillos nocturnos, abejas del huerto.
Si ninguno sirve y el cuento realmente necesita uno nuevo, inclúyelo en
el SQL con su bloque `if not exists` y anótalo en la lista de assets.

La palabra clave debe además: (1) aparecer tal cual en el texto de ESE
mismo bloque, (2) no aparecer antes por accidente en el mismo texto.

## Qué debes entregar

### 1. El archivo SQL completo, listo para pegar y ejecutar

Usa EXACTAMENTE esta plantilla. Reemplaza los `[...]`, agrega una línea
de variable/select por cada sonido que uses, y una fila de
`story_blocks` por cada bloque:

```sql
do $$
declare
  v_story_id uuid;
  v_[sonido1] uuid;
  v_[sonido2] uuid;
begin
  select id into v_story_id from stories where titulo = '[Título del cuento]' limit 1;

  if v_story_id is null then
    insert into stories (titulo, edad_recomendada, es_personalizable, portada_url)
    values ('[Título del cuento]', '2-7 años', true, null)
    returning id into v_story_id;
  end if;

  -- Solo si necesitas un sonido que NO está en el catálogo reutilizable.
  -- archivo_url SIEMPRE es "/sounds/" + el nombre con espacios
  -- cambiados por guiones + ".mp3" -- nunca un nombre de archivo
  -- distinto al "nombre" (ej. nombre='lluvia fuerte' -> archivo_url=
  -- '/sounds/lluvia-fuerte.mp3'):
  if not exists (select 1 from sound_effects where nombre = '[nombre sonido nuevo]') then
    insert into sound_effects (nombre, archivo_url, categoria)
    values ('[nombre sonido nuevo]', '/sounds/[nombre-sonido-nuevo-con-guiones].mp3', '[efecto o ambiente]');
  end if;

  -- Un select por cada sonido que el cuento usa (nuevo o reutilizado):
  select id into v_[sonido1] from sound_effects where nombre = '[nombre exacto en el catálogo]' limit 1;
  select id into v_[sonido2] from sound_effects where nombre = '[nombre exacto en el catálogo]' limit 1;

  delete from story_variables where story_id = v_story_id;
  insert into story_variables (story_id, variable_key, tipo, opciones_sugeridas) values
    (v_story_id, '[variable_key]', '[texto|color|animal]', array['[opcion1]','[opcion2]','[opcion3]','[opcion4]']),
    (v_story_id, '[variable_key_2]', '[texto|color|animal]', array['[opcion1]','[opcion2]']);

  delete from story_blocks where story_id = v_story_id;
  insert into story_blocks (story_id, orden, texto_bloque, sound_effect_id, trigger_keywords, imagen_url)
  values
    (v_story_id, 1,
      '[texto del bloque 1, con {variables} donde corresponda]',
      v_[sonido1], array['[palabra clave]'],
      '/images/[slug-del-cuento]/01-[nombre-escena-corto-y-descriptivo].svg'),
    (v_story_id, 2,
      '[texto del bloque 2]',
      null, array[]::text[],
      '/images/[slug-del-cuento]/02-[nombre-escena-corto-y-descriptivo].svg'),
    -- ... una fila más por cada bloque restante, "orden" consecutivo,
    -- ";" solo al final de la ÚLTIMA fila:
    (v_story_id, N,
      '[texto del último bloque]',
      null, array[]::text[],
      '/images/[slug-del-cuento]/NN-[nombre-escena-corto-y-descriptivo].svg');
end $$;
```

Reglas del SQL: comillas simples, escapa las que aparezcan dentro del
texto duplicándolas (`''`). El nombre del sonido en el `select` debe
coincidir EXACTO con el catálogo (minúsculas, tal cual está escrito
abajo). Bloque sin sonido: `null` y `array[]::text[]`.

No se generan imágenes ni archivos de audio -- eso lo agrega el usuario
después (las imágenes las hace otra IA a partir del nombre de archivo,
por eso cada `[nombre-escena]` debe ser corto, descriptivo y único, ej.
`01-campana-olvidada.svg`, `02-pueblo-neblina.svg`,
`03-primer-agradecimiento.svg` -- nunca genérico como `01-escena.svg`).

### 2. Lista de assets a agregar

Solo la lista de rutas, sin tabla ni descripciones (el nombre del
archivo ya es descriptivo):

```
Imágenes (public/images/[slug-del-cuento]/):
/images/[slug]/01-[nombre-escena].svg
/images/[slug]/02-[nombre-escena].svg
... una línea por bloque, en el mismo orden ...

Sonidos nuevos (public/sounds/) -- omite esta lista si no creaste ninguno:
/sounds/[nombre-sonido-nuevo].mp3
```

## Recursos ya usados (pega esta tabla al final del prompt)

[Pega aquí la tabla de la sección 4 de esta guía -- está vacía, este es el primer cuento del catálogo nuevo]
````

## 2. Antes de correr el SQL que te devuelva la IA

- Revisa cada palabra clave contra el texto de su propio bloque, y
  pregúntate: ¿un niño esperaría que ESTO suene al tocarlo? Si la
  palabra es un verbo o adjetivo visual (brillar, ver, mirar, aparecer),
  no vale aunque parezca "mágica".
- Revisa que cada `select ... from sound_effects where nombre = '...'`
  use un nombre que sí existe en el catálogo o que el cuento lo esté
  creando primero con `if not exists`.
- Corre el archivo en Supabase -> SQL Editor. Es seguro correrlo varias
  veces.
- Agrega las imágenes y sonidos nuevos a sus carpetas en `public/`.
- Si el cuento usó una variable nueva, agrégale su pregunta a
  `ETIQUETAS` en `components/StoryPlayer.tsx` (opcional -- si no lo
  haces, se muestra una pregunta genérica automática).
- Actualiza la tabla de la sección 4 con el cuento nuevo.

## 3. Catálogo de sonidos reutilizables

| Sonido (nombre exacto en la BD) | Categoría | Qué es |
|---|---|---|
| pasos sobre hojas | efecto | Pasos crujiendo sobre hojas secas |
| viento entre arboles | ambiente | Viento soplando |
| lluvia magica | ambiente | Lluvia suave |
| pajaros del bosque | ambiente | Canto de pájaros |
| campanita magica | efecto | Campanita/cascabel |
| buho sabio | efecto | Ulular de búho |
| arroyo | ambiente | Agua de arroyo corriendo |
| chapoteo | efecto | Splash de agua |
| crujido | efecto | Ramas/hojas crujiendo |
| grillos nocturnos | ambiente | Grillos de noche |
| abejas del huerto | ambiente | Abejas zumbando |

`destello magico` (chispazo/brillo) se sacó de esta lista a propósito:
fue la causa de que varios cuentos anteriores subrayaran palabras
puramente visuales ("brilló", "parpadeó") como si sonaran. Si un cuento
nuevo de verdad necesita un efecto de chispazo, créalo explícitamente
con `if not exists` y solo úsalo con una palabra que describa un sonido
real (ej. "chisporroteó"), nunca con un verbo de brillar.

## 4. Recursos narrativos ya usados

| Cuento | Protagonista | Variables propias | Conflicto | Tipo de magia | Emoción principal | Cierre final |
|---|---|---|---|---|---|---|
| La gota de tinta impaciente | Una gota de tinta | nombre_gota, color_tinta, dibujo_favorito | Impaciencia / aprender a esperar | Tinta (un borrón se convierte en dibujo, con ayuda y paciencia, no solo). Quien enseña: un reloj de péndulo (objeto) | Ternura | Una costumbre nueva (esperar el momento justo) |
