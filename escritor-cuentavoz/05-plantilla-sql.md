# Cuentavoz
# 05 - Plantilla SQL Oficial

Versión 1.0

---

# Objetivo

Todos los cuentos de Cuentavoz deben generarse utilizando exactamente la misma estructura SQL.

Esto garantiza:

- Compatibilidad con Supabase.
- Consistencia entre cuentos.
- Facilidad de mantenimiento.
- Idempotencia.
- Menor probabilidad de errores.

La IA nunca debe inventar una estructura diferente.

---

# Estructura obligatoria

Todo archivo SQL seguirá exactamente este orden.

```
1. DECLARE

2. Buscar la historia

3. Crear la historia (si no existe)

4. Crear sonidos nuevos (si aplica)

5. Obtener IDs de sonidos

6. Eliminar variables

7. Insertar variables

8. Eliminar bloques

9. Insertar bloques

10. END
```

Nunca alterar este orden.

---

# Plantilla oficial

```sql
do $$

declare

    v_story_id uuid;

begin

    --------------------------------------------------
    -- Buscar historia
    --------------------------------------------------

    select id
    into v_story_id
    from stories
    where slug='[slug]'
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
            '[Título]',
            '[slug]',
            '2-7 años',
            true,
            null
        )

        returning id
        into v_story_id;

    end if;

    --------------------------------------------------
    -- Sonidos nuevos
    --------------------------------------------------

    ...

    --------------------------------------------------
    -- Obtener ids
    --------------------------------------------------

    ...

    --------------------------------------------------
    -- Variables
    --------------------------------------------------

    delete
    from story_variables
    where story_id=v_story_id;

    insert into story_variables (...)

    --------------------------------------------------
    -- Bloques
    --------------------------------------------------

    delete
    from story_blocks
    where story_id=v_story_id;

    insert into story_blocks (...)

end $$;
```

---

# Declaración de variables

Siempre declarar:

```sql
v_story_id uuid;
```

Después una variable UUID por cada sonido utilizado.

Ejemplo

```sql
v_viento uuid;

v_lluvia uuid;

v_campanita uuid;
```

No declarar sonidos que no se utilizan.

---

# Historia

Siempre buscar por slug.

Nunca por título.

Correcto

```sql
where slug='la-campana-agradecida'
```

Incorrecto

```sql
where titulo='La Campana Agradecida'
```

---

# Creación de sonidos

Solo si hacen falta.

Siempre:

```sql
if not exists
```

Nunca insertar sonidos duplicados.

---

# Obtener IDs

Después de crear los sonidos.

Siempre:

```sql
select id
into v_lluvia
from sound_effects
where nombre='lluvia magica'
limit 1;
```

Nunca utilizar ids escritos manualmente.

---

# Variables

Siempre eliminar antes de insertar.

```sql
delete
from story_variables
where story_id=v_story_id;
```

Nunca hacer UPDATE.

Nunca insertar encima de las existentes.

---

# Insert de variables

Siempre un único INSERT.

Ejemplo

```sql
insert into story_variables
(
story_id,
variable_key,
tipo,
opciones_sugeridas
)

values

(...),

(...),

(...);
```

No utilizar múltiples INSERT.

---

# Story Blocks

Siempre eliminar primero.

```sql
delete
from story_blocks
where story_id=v_story_id;
```

Después insertar todos los bloques en un único INSERT.

---

# Orden de bloques

Siempre consecutivo.

```
1

2

3

...

18
```

Nunca repetir.

Nunca saltar números.

---

# Texto

Todo el texto pertenece a:

```
texto_bloque
```

Nunca dividir un bloque.

Nunca dejar bloques vacíos.

---

# Sonidos

Cada bloque utiliza únicamente:

- un sonido

o

- ninguno

Nunca dos sonidos.

---

# Trigger Keywords

Siempre:

```sql
array['campanita']
```

Nunca:

```sql
array[
'campanita',
'árbol',
'niño'
]
```

Solo una palabra.

---

# Bloques sin sonido

Siempre:

```sql
null,
array[]::text[]
```

Nunca utilizar NULL de otra forma.

---

# Imagen

Todos los bloques deben tener imagen.

Formato obligatorio.

```text
/images/[slug]/01-nombre-escena.webp
```

Nunca reutilizar imágenes.

Cada bloque representa una ilustración distinta.

---

# Assets

Después del SQL.

## Imágenes

```
01-campana-olvidada.webp

02-primer-dia.webp

03-viento-suave.webp

...
```

## Sonidos nuevos

Solo si existen.

---

# Comillas

Siempre utilizar:

```
'
```

Nunca:

```
"
```

Las comillas internas deben duplicarse.

Ejemplo

```sql
'La campana respondió: ''Gracias por escucharme.'''
```

---

# Nombres

Utilizar nombres claros.

Correcto

```
v_lluvia

v_campanita

v_arroyo
```

Incorrecto

```
v1

v2

v3
```

---

# SQL limpio

El SQL debe ser fácil de leer.

Separar cada sección.

Mantener la misma indentación.

Utilizar nombres descriptivos.

---

# Errores que nunca deben aparecer

❌ Dos INSERT de bloques.

❌ Variables sin declarar.

❌ Variables no utilizadas.

❌ Sonidos sin obtener su id.

❌ Bloques sin imagen.

❌ Orden incorrecto.

❌ Slug distinto al de la carpeta de imágenes.

❌ Trigger keyword inexistente.

❌ Comillas mal escapadas.

❌ SQL que requiera edición manual.

---

# Validación final

Antes de entregar el SQL verificar.

✓ Ejecuta en PostgreSQL.

✓ Ejecuta en Supabase.

✓ Es idempotente.

✓ Busca la historia por slug.

✓ Inserta una única historia.

✓ Declara correctamente los sonidos.

✓ Inserta todas las variables.

✓ Inserta todos los bloques.

✓ Cada bloque tiene imagen.

✓ Los assets coinciden con el SQL.

✓ El usuario puede copiar y ejecutar el archivo completo sin modificar una sola línea.

---

# Regla definitiva

Todos los cuentos publicados por Cuentavoz deben utilizar exactamente esta plantilla.

No se permiten variaciones estructurales.

La única diferencia entre cuentos debe ser:

- la historia
- las variables
- los sonidos
- las imágenes

La estructura SQL siempre será la misma.