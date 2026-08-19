import Link from "next/link";
import { SignedIn, SignedOut } from "@clerk/nextjs";
import { AppHeader } from "@/components/AppHeader";
import { LibroSimple } from "@/components/LibroSimple";
import { TiraPalabrasMagicas } from "@/components/TiraPalabrasMagicas";
import { DemoInteractivo } from "@/components/DemoInteractivo";
import { SeccionPreocupaciones } from "@/components/SeccionPreocupaciones";
import { SeccionComoFunciona } from "@/components/SeccionComoFunciona";
import { SeccionComparacion } from "@/components/SeccionComparacion";
import { SeccionVistaPrevia } from "@/components/SeccionVistaPrevia";
import { SeccionPrecios } from "@/components/SeccionPrecios";
import { SeccionPreguntas } from "@/components/SeccionPreguntas";
import { SeccionMomentos } from "@/components/SeccionMomentos";

const ESTRELLAS = [
  { left: "6%", top: "18%", size: 2, retraso: "0s" },
  { left: "14%", top: "42%", size: 1.6, retraso: "0.8s" },
  { left: "22%", top: "12%", size: 2.2, retraso: "1.6s" },
  { left: "30%", top: "55%", size: 1.4, retraso: "2.4s" },
  { left: "40%", top: "8%", size: 1.8, retraso: "0.4s" },
  { left: "58%", top: "15%", size: 2, retraso: "1.2s" },
  { left: "68%", top: "48%", size: 1.6, retraso: "2s" },
  { left: "76%", top: "10%", size: 2.4, retraso: "0.6s" },
  { left: "84%", top: "40%", size: 1.8, retraso: "1.8s" },
  { left: "92%", top: "20%", size: 2, retraso: "0.2s" },
  { left: "50%", top: "30%", size: 1.4, retraso: "2.8s" },
  { left: "10%", top: "62%", size: 1.6, retraso: "1s" },
];

export default function HomePage() {
  return (
    <div className="relative">
      {/* Portada: pantalla completa, siempre oscura -- como abrir un
          grimorio real, sin importar el tema del sitio. */}
      <section className="relative flex min-h-[100dvh] flex-col overflow-hidden bg-gradient-to-b from-tinta-900 via-tinta-800 to-tinta-900">
        <AppHeader sobreOscuro absoluto>
          <nav className="hidden items-center gap-1 text-sm font-medium text-pergamino-50/70 md:flex">
            <a
              href="#como-funciona"
              className="rounded-full px-3 py-1.5 transition hover:bg-pergamino-50/10 hover:text-pergamino-50"
            >
              Cómo funciona
            </a>
            <a
              href="#precios"
              className="rounded-full px-3 py-1.5 transition hover:bg-pergamino-50/10 hover:text-pergamino-50"
            >
              Precios
            </a>
            <a
              href="#preguntas"
              className="rounded-full px-3 py-1.5 transition hover:bg-pergamino-50/10 hover:text-pergamino-50"
            >
              Preguntas
            </a>
          </nav>
          <SignedIn>
            <Link
              href="/dashboard"
              className="hidden rounded-full px-4 py-1.5 text-sm font-semibold text-pergamino-50 transition hover:bg-pergamino-50/10 sm:inline-block"
            >
              Mis cuentos
            </Link>
          </SignedIn>
        </AppHeader>

        <div className="pointer-events-none absolute inset-0" aria-hidden>
          {ESTRELLAS.map((e, i) => (
            <span
              key={i}
              className="estrella absolute rounded-full bg-pergamino-50"
              style={{
                left: e.left,
                top: e.top,
                width: e.size,
                height: e.size,
                animationDelay: e.retraso,
              }}
            />
          ))}
        </div>

        <LibroSimple
          size={70}
          colorIzq="#E7A23D"
          colorDer="#B4485A"
          className="libro-flotante absolute left-[8%] top-[22%] opacity-90"
          style={{
            ["--duracion-vuelo" as string]: "11s",
            ["--deriva-x" as string]: "16px",
            ["--deriva-y" as string]: "-14px",
          }}
        />
        <LibroSimple
          size={46}
          colorIzq="#4C7A63"
          colorDer="#E7A23D"
          className="libro-flotante absolute right-[10%] top-[66%] opacity-80"
          style={{
            ["--duracion-vuelo" as string]: "8s",
            ["--retraso-vuelo" as string]: "0.6s",
            ["--deriva-x" as string]: "-14px",
            ["--deriva-y" as string]: "12px",
          }}
        />

        <div className="relative z-10 flex flex-1 flex-col items-center justify-center px-6 py-24 text-center">
          <span className="mb-7 flex items-center gap-3 font-mono text-xs uppercase tracking-[0.14em] text-oro-300">
            <span className="h-px w-7 bg-oro-300/40" />
            Para leer en voz alta, juntos
            <span className="h-px w-7 bg-oro-300/40" />
          </span>

          <h1 className="max-w-3xl font-display text-4xl italic leading-[1.1] text-pergamino-50 sm:text-6xl">
            Un cuento que <span className="not-italic font-semibold text-oro-300">escucha</span>
            <br />
            cuando lo lees.
          </h1>

          <p className="mt-6 max-w-lg text-lg leading-relaxed text-pergamino-50/70">
            Tu hijo elige quién es el héroe. Tu voz decide qué pasa después.
            Toca una palabra y mira cómo reacciona el cuento:
          </p>

          <div className="mt-9">
            <TiraPalabrasMagicas />
          </div>

          <div className="mt-10 flex flex-col gap-3 sm:flex-row">
            <SignedOut>
              <Link
                href="/sign-up"
                className="rounded-full bg-oro-500 px-9 py-4 text-base font-extrabold text-tinta-950 shadow-[0_14px_30px_-10px_rgba(231,162,61,0.55)] transition hover:bg-oro-300"
              >
                Crear cuenta
              </Link>
              <Link
                href="#demo"
                className="rounded-full border border-pergamino-50/25 px-9 py-4 text-base font-bold text-pergamino-50 transition hover:bg-pergamino-50/10"
              >
                Ver cómo funciona
              </Link>
            </SignedOut>
            <SignedIn>
              <Link
                href="/dashboard"
                className="rounded-full bg-oro-500 px-9 py-4 text-base font-extrabold text-tinta-950 shadow-[0_14px_30px_-10px_rgba(231,162,61,0.55)] transition hover:bg-oro-300"
              >
                Ir a mis cuentos
              </Link>
            </SignedIn>
          </div>
          <p className="mt-4 text-sm text-pergamino-50/45">
            Elige entre el plan mensual o semestral después de registrarte.
          </p>
        </div>

        <div className="relative z-10 flex flex-col items-center gap-2 pb-8 font-mono text-[11px] uppercase tracking-[0.16em] text-pergamino-50/40">
          <span>Desliza para abrir el libro</span>
          <span className="animate-bounce text-base">↓</span>
        </div>
      </section>

      <div className="relative bg-pergamino-50 dark:bg-tinta-950">
        {/* ================= DEMO EN VIVO ================= */}
        <section id="demo" className="bg-tinta-900 py-24">
          <div className="mx-auto max-w-xl px-6 text-center sm:px-8">
            <span className="font-mono text-xs uppercase tracking-[0.14em] text-oro-300">
              Míralo con tus propios ojos
            </span>
            <h2 className="mt-4 font-display text-3xl italic text-pergamino-50 sm:text-4xl">
              No es un audiolibro. Es un cuento con el que se conversa.
            </h2>
            <p className="mt-4 text-[15px] leading-relaxed text-pergamino-50/70">
              Tu hijo elige el nombre del héroe y su compañero de aventura. El
              texto cambia al instante. Y cuando lees en voz alta —o tocas la
              palabra— ciertas frases cobran vida.
            </p>
          </div>

          <div className="mt-14">
            <DemoInteractivo />
          </div>
        </section>

        <SeccionComoFunciona />

        <SeccionPreocupaciones />

        <SeccionComparacion />

        {/* ================= CITA ================= */}
        <section className="px-6 py-4 sm:px-8">
          <div className="mx-auto max-w-xl border-l-2 border-baya-500 pl-6 text-left">
            <p className="texto-iluminado font-display text-lg italic leading-relaxed text-tinta-900/80 dark:text-pergamino-50/80">
              Cada cuento refuerza el vínculo afectivo y el desarrollo
              cognitivo en la primera infancia. No es otra pantalla más: es
              un momento que padres e hijos construyen con su propia voz.
            </p>
          </div>
        </section>

        <SeccionMomentos />

        <SeccionVistaPrevia />

        <SeccionPrecios />

        <SeccionPreguntas />

        {/* ================= CIERRE ================= */}
        <section className="relative overflow-hidden bg-gradient-to-b from-tinta-900 to-tinta-950 px-6 py-28 text-center">
          <LibroSimple
            size={56}
            colorIzq="#E7A23D"
            colorDer="#B4485A"
            className="absolute left-[12%] top-[22%] opacity-50"
          />
          <span className="mb-4 flex items-center justify-center gap-3 font-mono text-xs uppercase tracking-[0.14em] text-oro-300">
            <span className="h-px w-7 bg-oro-300/40" />
            Última página
            <span className="h-px w-7 bg-oro-300/40" />
          </span>
          <h2 className="font-display text-4xl italic text-pergamino-50 sm:text-5xl">
            El siguiente cuento los está esperando.
          </h2>
          <div className="mt-9 flex flex-col items-center gap-3 sm:flex-row sm:justify-center">
            <SignedOut>
              <Link
                href="/sign-up"
                className="rounded-full bg-oro-500 px-9 py-4 text-base font-extrabold text-tinta-950 shadow-[0_14px_30px_-10px_rgba(231,162,61,0.55)] transition hover:bg-oro-300"
              >
                Crear cuenta
              </Link>
              <Link
                href="/sign-in"
                className="rounded-full border border-pergamino-50/25 px-9 py-4 text-base font-bold text-pergamino-50 transition hover:bg-pergamino-50/10"
              >
                Ya tengo cuenta
              </Link>
            </SignedOut>
            <SignedIn>
              <Link
                href="/dashboard"
                className="rounded-full bg-oro-500 px-9 py-4 text-base font-extrabold text-tinta-950 shadow-[0_14px_30px_-10px_rgba(231,162,61,0.55)] transition hover:bg-oro-300"
              >
                Ir a mis cuentos
              </Link>
            </SignedIn>
          </div>
          <p className="mt-4 text-sm text-pergamino-50/45">
            Elige un plan mensual o semestral para abrir la biblioteca.
          </p>
        </section>

        <footer className="border-t border-pergamino-200 bg-pergamino-50 px-6 py-8 text-center text-sm text-tinta-900/50 dark:border-tinta-700 dark:bg-tinta-950 dark:text-pergamino-50/40">
          <p>🔒 Modo escucha sin grabar ni guardar audio, nunca.</p>
          <p className="mt-2">Cuentavoz · hecho para familias en Colombia y LATAM</p>
        </footer>
      </div>
    </div>
  );
}
