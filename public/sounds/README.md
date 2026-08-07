# Sonidos requeridos — lista maestra

Coloca aquí estos 12 archivos (nombres exactos). Son todos los que
necesitan los 3 cuentos actuales del catálogo (Bosque Encantado, Huerto
Encantado, La Capa Roja) — ningún cuento usa un archivo que no esté
aquí.

| Archivo | Sonido | Categoría | Se usa en |
|---|---|---|---|
| `pasos-hojas.mp3` | Pasos sobre hojas secas | efecto | El Bosque Encantado |
| `viento.mp3` | Viento entre árboles | ambiente (loop) | El Bosque Encantado |
| `lluvia.mp3` | Lluvia mágica | ambiente (loop) | El Bosque Encantado |
| `pajaros.mp3` | Pájaros del bosque | ambiente (loop) | El Bosque Encantado, El Huerto Encantado |
| `campanita.mp3` | Campanita mágica | efecto | El Bosque Encantado, El Huerto Encantado |
| `buho.mp3` | Búho sabio (ulular) | efecto | El Bosque Encantado |
| `arroyo.mp3` | Arroyo / agua corriendo | ambiente (loop) | El Bosque Encantado |
| `chapoteo.mp3` | Splash al pisar el agua | efecto | El Bosque Encantado |
| `crujido.mp3` | Crujido de ramas/arbustos | efecto | El Bosque Encantado, La Capa Roja |
| `destello.mp3` | Chispazo / brillo mágico | efecto | El Bosque Encantado, El Huerto Encantado, La Capa Roja |
| `grillos.mp3` | Grillos nocturnos | ambiente (loop) | El Bosque Encantado, El Huerto Encantado, La Capa Roja |
| `abejas.mp3` | Abejas zumbando | ambiente (loop) | El Huerto Encantado |

Fuentes gratuitas con licencia clara para uso comercial (revisa la
licencia de cada archivo individual antes de publicar):

- https://pixabay.com/sound-effects/
- https://mixkit.co/free-sound-effects/
- https://freesound.org/ (filtra por licencia CC0)

Formato sugerido: mp3, mono, 128kbps — livianos para no pesar el PWA.

## Cómo se elige qué palabra dispara cada sonido

Cada bloque del cuento tiene como máximo **una** `trigger_keyword`, y
tiene que ser una palabra que aparezca tal cual en el texto de ese
bloque y que honestamente sea "el sonido" (ej. "campanita", "lluvia",
"grillos") — nunca una palabra auxiliar de la frase (ej. "camino",
"nariz", "puerta") aunque esté cerca. Esa misma palabra es la que se
subraya y se puede tocar en el lector, así que si no tiene sentido que
"suene" al tocarla, no debería estar marcada. Si un bloque no tiene
ninguna palabra así de honesta, mejor que se quede sin sonido a que se
le fuerce una palabra que no pega.
