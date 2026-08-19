# Cuentavoz — Scaffold MVP

Next.js 14 (App Router) + Clerk (auth) + Supabase (datos) + PWA, listo para
conectar Mercado Pago / Lemon Squeezy en la siguiente fase.

## 1. Instalar dependencias

Este scaffold se generó sin ejecutar `npm install` (sin acceso a red en el
entorno donde se creó). En tu máquina, con Node 18+:

```bash
cd story-app-mvp
npm install
```

Esto instalará Next.js, Clerk, Supabase, Tailwind, Howler.js y next-pwa
según lo declarado en `package.json`. También necesitas `svix` para
verificar el webhook de Clerk:

```bash
npm install svix
```

## 2. Crear el proyecto en Supabase

1. Ve a [app.supabase.com](https://app.supabase.com) y crea un proyecto nuevo.
2. En **SQL Editor**, pega y corre el contenido de `supabase/schema.sql`.
   Esto crea todas las tablas y las políticas de Row Level Security.
3. En **Project Settings -> API**, copia `Project URL` y `anon public key`
   a tu `.env.local` (ver paso 5).

## 3. Crear el proyecto en Clerk

1. Ve a [dashboard.clerk.com](https://dashboard.clerk.com) y crea una app.
2. Activa los proveedores que quieras (Google recomendado para este público).
3. Copia `Publishable key` y `Secret key` a tu `.env.local`.

## 4. Conectar Clerk con Supabase (RLS por familia)

Para que las políticas de `supabase/schema.sql` funcionen (cada familia
solo ve sus propios datos), Supabase necesita validar el JWT que emite
Clerk:

1. En Clerk Dashboard -> **JWT Templates**, crea una plantilla nueva
   llamada exactamente `supabase`. Puedes dejar el claim `sub` por defecto
   (es el `clerk_user_id` que usan las políticas RLS).
2. En Supabase -> **Authentication -> Sign In / Providers -> Third Party
   Auth**, agrega Clerk como proveedor, pegando el "Issuer URL" que te da
   Clerk en la misma pantalla de JWT Templates.

Con esto, `lib/supabase/client.ts` ya manda el JWT correcto en cada
petición del navegador.

> Si quieres arrancar más rápido y dejar esto para después, el dashboard
> (`app/dashboard/page.tsx`) ya funciona sin este paso porque usa el
> cliente de `service_role` en el servidor. Solo lo necesitas para
> queries hechas directamente desde el navegador con RLS activo.

## 5. Variables de entorno

```bash
cp .env.example .env.local
```

Completa cada valor según los pasos 2 y 3. Nunca subas `.env.local` a git
(ya está en `.gitignore`).

## 6. Webhook de Clerk -> Supabase

Para que se cree automáticamente la fila en `families` cuando alguien se
registra:

1. En local, usa [ngrok](https://ngrok.com) o `clerk dev` para exponer tu
   `localhost:3000`.
2. En Clerk Dashboard -> **Webhooks**, agrega un endpoint apuntando a
   `https://tu-url/api/webhooks/clerk`, evento `user.created`.
3. Copia el "Signing Secret" a `CLERK_WEBHOOK_SECRET` en `.env.local`.

## 7. Correr en desarrollo

```bash
npm run dev
```

Abre `http://localhost:3000`. El service worker del PWA está desactivado
en desarrollo (`disable: process.env.NODE_ENV === "development"` en
`next.config.mjs`) para no pelear con el hot reload — se activa solo en
`npm run build && npm run start`.

## 7.1 Mercado Pago: planes Premium

Los planes viven en `lib/mercadopago.ts`: mensual por $60.000 COP y
semestral por $149.000 COP. Registrarse no crea una suscripción: cada familia
permanece en `inactive` y sin acceso a los cuentos hasta que Mercado Pago
confirme el estado `authorized`.

1. Ejecuta `supabase/migracion_mercadopago.sql` en Supabase SQL Editor.
2. Configura `MELI_ACCESS_TOKEN`, `MERCADOPAGO_WEBHOOK_SECRET` y
   `NEXT_PUBLIC_APP_URL` en `.env.local`.
3. En Mercado Pago -> Tus integraciones -> Webhooks, registra
   `https://www.cuentavoz.com/api/webhooks/mercadopago`.
4. Activa el evento `subscription_preapproval`. Mercado Pago también
   recomienda activar `payments` para seguir los cobros recurrentes.

El checkout usa `/api/checkout/mercadopago?plan=mensual` o
`?plan=semestral`. El webhook valida la firma, vuelve a consultar la
preaprobación en Mercado Pago y solo después cambia `families.plan`.

### Suscripción privada de desarrollo

Existe un plan oculto de $2.000 COP mensuales para probar el flujo completo.
No aparece en la landing ni en `/planes`. Configura uno o varios correos
principales de Clerk, separados por comas, exclusivamente en el servidor:

```env
MERCADOPAGO_DEV_EMAILS=dev1@cuentavoz.com,dev2@cuentavoz.com
```

Después de iniciar sesión con uno de esos correos, abre directamente:

```text
https://www.cuentavoz.com/api/checkout/mercadopago?plan=desarrollador
```

Un correo no autorizado recibe `404`, aunque conozca la URL. Esta variable
nunca debe llevar el prefijo `NEXT_PUBLIC_`.

## 8. Íconos del PWA

Agrega tus íconos reales en `public/icons/icon-192.png` y
`public/icons/icon-512.png` (referenciados en `public/manifest.json`).

## Qué falta para completar el MVP (próximos pasos)

- [ ] Cargar el primer cuento real en la tabla `stories` / `story_blocks`
      (siguiente paso que planeamos: "escribir el primer cuento MVP").
- [ ] Componente de reproductor de cuento con Howler.js (capas de audio +
      modo zona / modo escucha con Web Speech API).
- [ ] Formulario de personalización pre-cuento (nombre, color, animal).
- [x] Checkout y webhook de suscripciones de Mercado Pago.
- [ ] Integración internacional con Lemon Squeezy.
- [x] Control de acceso: usuarios `inactive` solo pueden elegir y pagar un
      plan; dashboard y cuentos requieren `families.plan = premium`.

## Estructura del proyecto

```
app/
  layout.tsx              ClerkProvider + metadata PWA
  page.tsx                Landing pública
  sign-in/[[...sign-in]]/ Login (componente de Clerk)
  sign-up/[[...sign-up]]/ Registro (componente de Clerk)
  dashboard/               Área protegida (requiere sesión)
  api/webhooks/clerk/      Sincroniza usuarios nuevos -> tabla families
lib/supabase/
  client.ts                Cliente para el navegador (JWT de Clerk)
  server.ts                Cliente service_role (solo servidor)
  database.types.ts        Tipos (regenerar con supabase gen types)
supabase/
  schema.sql                Tablas + Row Level Security
middleware.ts               Protege rutas privadas con Clerk
```
