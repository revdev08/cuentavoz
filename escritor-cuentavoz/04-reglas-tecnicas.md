# Cuentavoz
# 04 - Reglas Técnicas Oficiales

Versión 2.0

---

# Objetivo

Este documento define todas las reglas técnicas que debe seguir la IA al generar un cuento para Cuentavoz.

El objetivo es que el resultado pueda ejecutarse directamente en Supabase sin modificaciones manuales.

Un cuento técnicamente correcto debe:

- Generar un SQL válido.
- Poder ejecutarse varias veces sin errores.
- Mantener consistencia con la base de datos.
- Utilizar correctamente variables, sonidos e imágenes.
- Cumplir todas las reglas narrativas.

La prioridad siempre será:

1. Integridad del SQL.
2. Consistencia de los datos.
3. Calidad narrativa.

---

# Formato de entrega

La IA únicamente debe devolver dos elementos.

## 1. Archivo SQL completo

Debe estar listo para copiar y ejecutar.

Nunca debe contener pseudocódigo.

Nunca debe contener fragmentos incompletos.

Nunca debe omitir sentencias.

Debe incluir absolutamente todo lo necesario.

---

## 2. Lista de assets

Después del SQL entregar únicamente:

### Imágenes

Lista de archivos.

### Sonidos nuevos

Solo si el cuento creó alguno.

No generar imágenes.

No generar sonidos.

Únicamente sus nombres.

---

# SQL

Todo el cuento debe vivir dentro de un único archivo SQL.

Debe utilizar un bloque:

```sql
do $$
declare

...

begin

...

end $$;
```

Nunca entregar varios archivos.

Nunca dividir el cuento.

---

# Idempotencia

El SQL debe poder ejecutarse todas las veces que sea necesario.

Ejecutarlo dos veces debe dejar exactamente el mismo resultado.

Nunca debe producir duplicados.

Para lograrlo siempre debe seguir este orden.

1.

Buscar la historia.

2.

Crearla si no existe.

3.

Buscar o crear sonidos.

4.

Eliminar variables existentes.

5.

Insertar variables.

6.

Eliminar bloques.

7.

Insertar bloques.

---

# Stories

Las historias SIEMPRE se identifican mediante el campo:

slug

Nunca mediante el título.

El título puede modificarse en el futuro.

El slug nunca.

Siempre utilizar:

```sql
select id
into v_story_id
from stories
where slug='la-campana-agradecida'
limit 1;
```

Si no existe:

```sql
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
    'La Campana Agradecida',
    'la-campana-agradecida',
    '2-7 años',
    true,
    null
)

returning id
into v_story_id;
```

Nunca buscar historias mediante el título.

---

# Slug

Todo cuento debe generar automáticamente un slug.

Reglas:

- minúsculas
- sin tildes
- sin eñes
- sin caracteres especiales
- palabras separadas por guiones
- sin espacios
- nunca comenzar con guiones
- nunca terminar con guiones

Ejemplos

La Campana Agradecida

↓

la-campana-agradecida

El Río que Aprendió a Escuchar

↓

el-rio-que-aprendio-a-escuchar

La Montaña de los Ecos

↓

la-montana-de-los-ecos

El slug será el identificador oficial del cuento.

Nunca debe cambiar.

---

# Variables

Crear únicamente las variables necesarias.

No utilizar variables por costumbre.

Cada historia debe decidir qué necesita.

Ejemplos:

nombre_nino

objeto_especial

lugar_favorito

mascota

nombre_barco

fruta_preferida

instrumento

color_magico

---

# Tipos permitidos

Actualmente existen:

texto

animal

color

No utilizar otros tipos.

---

# Opciones sugeridas

Todas las variables deben incluir opciones.

Ejemplo:

```sql
array[
'campana',
'farol',
'vela',
'brujula'
]
```

Las opciones:

- no llevan artículos
- no llevan comillas dobles
- son palabras simples cuando sea posible

Correcto

campana

Incorrecto

una campana

---

# Uso de artículos

Nunca escribir artículos manualmente.

Incorrecto

```
una {objeto}
```

Correcto

```
{un_objeto} {objeto}
```

Incorrecto

```
el {animal}
```

Correcto

```
{el_animal} {animal}
```

El sistema calculará automáticamente el artículo correcto.

---

# Bloques

Cada cuento tendrá entre:

14 y 22 bloques.

Nunca menos.

Nunca más.

---

# Longitud

Cada bloque tendrá aproximadamente entre:

40 y 50 palabras.

No sacrifiques la naturalidad por cumplir exactamente el número.

Lo importante es mantener un ritmo homogéneo.

---

# Orden

Siempre consecutivo.

1

2

3

4

5

...

Nunca repetir.

Nunca omitir números.

---

# Texto

Cada bloque representa una pantalla.

Debe funcionar de manera independiente.

Pero también conectar naturalmente con el siguiente.

Nunca cortar una frase entre bloques.

---

# Imágenes

Todos los bloques tienen imagen.

Formato obligatorio:

```
/images/[slug]/01-nombre-escena.webp
```

Ejemplos

```
/images/la-campana-agradecida/01-campana-olvidada.webp

/images/la-campana-agradecida/02-pueblo-neblina.webp

/images/la-campana-agradecida/03-primer-gracias.webp
```

Reglas

Siempre:

- minúsculas
- sin tildes
- descriptivo
- separado por guiones

Nunca utilizar:

```
escena1.webp

imagen.webp

foto.webp
```

## Conversión obligatoria a WebP

La IA puede entregar las ilustraciones en PNG, JPG, SVG u otro formato, pero dentro de la carpeta final de cada cuento deben quedar **solo archivos `.webp`**.

Cuando estén todas las imágenes de un cuento en `public/images/[slug]/`, ejecutar:

```bash
npm run images:webp -- [slug-del-cuento]
```

Ejemplo:

```bash
npm run images:webp -- el-pez-globo-que-aprendio-a-respirar
```

El comando convierte las imágenes de esa carpeta a WebP, valida que cada archivo generado se pueda leer y únicamente después elimina el original. Si una conversión falla, conserva el archivo fuente para que pueda corregirse. No modifica otros cuentos.

Antes de ejecutar el SQL, comprobar que las rutas `imagen_url` terminan en `.webp` y que la carpeta contiene únicamente los WebP finales.

---

# Nombre de escenas

Cada escena debe describir claramente la ilustración.

Correcto

```
07-campana-sonando.webp

09-rio-con-estrellas.webp

14-arbol-florecido.webp
```

Incorrecto

```
07-final.webp

09-imagen.webp

14-escena.webp
```

---

# Sonidos

Los sonidos son opcionales.

Solo utilizar cuando mejoren la experiencia.

Nunca añadir sonidos porque sí.

---

# Sonidos existentes

Si el sonido ya existe:

```sql
select id
into v_campanita
from sound_effects
where nombre='campanita magica'
limit 1;
```

Nunca volver a insertarlo.

---

# Sonidos nuevos

Si realmente hace falta uno nuevo.

Primero comprobar:

```sql
if not exists (
select 1
from sound_effects
where nombre='campana antigua'
)
then

insert into sound_effects
(
nombre,
archivo_url,
categoria
)

values
(
'campana antigua',
'/sounds/campana-antigua.mp3',
'efecto'
);

end if;
```

Después obtener su id.

---

# Archivo del sonido

Siempre:

```
/sounds/nombre-del-sonido.mp3
```

Ejemplos

```
/sounds/campana-antigua.mp3

/sounds/viento-suave.mp3

/sounds/olas-tranquilas.mp3
```

---

# Categorías

Solo existen dos categorías.

efecto

ambiente

Elegir siempre la más adecuada.

---

# Trigger Keywords

Cada sonido tiene exactamente UNA palabra clave.

Debe cumplir:

✓ aparece exactamente dentro del bloque

✓ representa el sonido

✓ una sola palabra

Ejemplos

```
campanita

chapoteó

crujió

llovía

silbó
```

Nunca utilizar palabras que no aparecen en el texto.

## Prueba de sonido obligatoria

Antes de asignar una palabra clave, comprobar dos cosas:

1. La palabra aparece literalmente en el texto del mismo bloque.
2. El adulto o el niño pueden imaginar de inmediato el sonido al leerla.

Una palabra visual o de contexto no basta. Por ejemplo, `brilló`,
`camino`, `puerta` o `dorado` no deben disparar audio por sí solas.
En cambio, `tictac`, `campanada`, `amasado`, `crujió`, `chapoteó` o
`pájaros` sí pueden hacerlo cuando coinciden con el audio asignado.

Si la escena no ofrece una palabra sonora honesta, el bloque debe quedar
sin sonido (`null`, `array[]::text[]`).

---

# Bloques sin sonido

Cuando un bloque no tenga sonido utilizar exactamente:

```sql
null,
array[]::text[]
```

No utilizar otras variantes.

---

# Comillas

Todo el SQL utiliza comillas simples.

```
'
```

Si el texto contiene una comilla.

Debe escaparse duplicándola.

Ejemplo

```
'El árbol respondió: ''Todavía no es el momento.'''
```

Nunca utilizar comillas dobles para textos SQL.

---

# Assets

Después del SQL entregar únicamente:

## Imágenes

```
01-campana-olvidada.webp

02-pueblo-neblina.webp

03-primer-gracias.webp

...

18-celebracion-final.webp
```

## Sonidos nuevos

Solo si existen.

Ejemplo

```
campana-antigua.mp3

olas-tranquilas.mp3
```

No describir cómo deben verse.

No generar prompts.

Solo listar los archivos.

---

# Recursos reutilizables

Siempre reutilizar antes de crear.

Especialmente:

- sonidos

No crear dos sonidos iguales con nombres distintos.

---

# Errores comunes

Evitar:

❌ Variables no declaradas.

❌ Variables declaradas pero nunca usadas.

❌ Slugs con espacios.

❌ Imágenes repetidas.

❌ Dos bloques con el mismo orden.

❌ Trigger keyword inexistente.

❌ Sonidos sin crear.

❌ Comillas mal escapadas.

❌ SQL incompleto.

❌ Insertar historias duplicadas.

---

# Validación técnica

Antes de entregar el resultado verificar:

✓ SQL válido para PostgreSQL.

✓ Compatible con Supabase.

✓ Puede ejecutarse varias veces.

✓ Historia identificada por slug.

✓ Slug correcto.

✓ Variables declaradas.

✓ Variables utilizadas.

✓ Opciones sugeridas válidas.

✓ Imágenes para todos los bloques.

✓ Ruta correcta de imágenes.

✓ Sonidos existentes o creados.

✓ Trigger keyword correcta.

✓ Orden consecutivo.

✓ Número correcto de bloques.

✓ SQL listo para copiar y ejecutar.

---

# Regla final

El usuario nunca debería tener que editar el SQL.

Si existe cualquier duda técnica, elegir siempre la opción más compatible con PostgreSQL y Supabase.

El resultado final debe poder copiarse directamente en el editor SQL de Supabase y ejecutarse correctamente sin modificaciones.
