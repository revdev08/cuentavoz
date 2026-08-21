import { clerkMiddleware, createRouteMatcher } from "@clerk/nextjs/server";

// Rutas públicas: landing, sign-in/up, y assets del PWA.
// Todo lo demás (dashboard, story/*) requiere sesión activa.
const isPublicRoute = createRouteMatcher([
  "/",
  "/sign-in(.*)",
  "/sign-up(.*)",
  "/api/webhooks/clerk",
  "/api/webhooks/mercadopago",
  "/manifest.json",
  "/sw.js",
]);

export default clerkMiddleware((auth, req) => {
  if (!isPublicRoute(req)) {
    auth().protect();
  }
});

export const config = {
  matcher: [
    // Los recursos de `public` no deben pasar por Clerk. En particular, las
    // portadas nuevas se sirven como WebP; si se omite esa extensión Clerk
    // responde con una redirección de autenticación y el navegador no puede
    // dibujarlas dentro de un <img>.
    "/((?!_next|.*\\.(?:ico|png|jpg|jpeg|gif|webp|avif|svg|css|js|mp3|wav|ogg|json|webmanifest|woff2?)$).*)",
    "/(api|trpc)(.*)",
  ],
};
