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
    "/((?!_next|.*\\.(?:ico|png|jpg|jpeg|svg|css|js|mp3|json)$).*)",
    "/(api|trpc)(.*)",
  ],
};
