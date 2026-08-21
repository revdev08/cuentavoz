import type { Metadata, Viewport } from "next";
import { Fraunces, Nunito, IBM_Plex_Mono } from "next/font/google";
import { ClerkProvider } from "@clerk/nextjs";
import { esMX } from "@clerk/localizations";
import "./globals.css";

const fraunces = Fraunces({
  subsets: ["latin"],
  weight: ["400", "500", "600"],
  style: ["italic", "normal"],
  variable: "--font-display",
});

const nunito = Nunito({
  subsets: ["latin"],
  weight: ["400", "600", "700", "800"],
  variable: "--font-body",
});

const plexMono = IBM_Plex_Mono({
  subsets: ["latin"],
  weight: ["400", "500"],
  variable: "--font-mono",
});

export const metadata: Metadata = {
  title: "Cuentavoz",
  description:
    "Cuentos para leer en voz alta con tu hijo, con sonidos que cobran vida y personajes que ustedes crean juntos.",
  icons: {
    icon: "/icon.svg",
    shortcut: "/icon.svg",
    apple: "/icon.svg",
  },
  manifest: "/manifest.json",
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: "Cuentavoz",
  },
};

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#E7A23D" },
    { media: "(prefers-color-scheme: dark)", color: "#141224" },
  ],
  width: "device-width",
  initialScale: 1,
};

// Evita el "flash" de tema incorrecto: aplica la clase "dark" antes del
// primer paint, según lo guardado en localStorage o, si no hay nada
// guardado, la preferencia del sistema.
const SCRIPT_TEMA = `
(function () {
  try {
    var guardado = localStorage.getItem("tema");
    var oscuro = guardado ? guardado === "oscuro" : window.matchMedia("(prefers-color-scheme: dark)").matches;
    document.documentElement.classList.toggle("dark", oscuro);
  } catch (e) {}
})();
`;

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    // @clerk/localizations 4.13.6 y @clerk/types 4.26.0 tienen un desfase de
    // tipos conocido en campos con parámetros (ej. socialButtonsBlockButton);
    // en runtime esMX es un LocalizationResource válido.
    <ClerkProvider localization={esMX as Parameters<typeof ClerkProvider>[0]["localization"]}>
      <html
        lang="es"
        className={`${fraunces.variable} ${nunito.variable} ${plexMono.variable}`}
        suppressHydrationWarning
      >
        <head>
          <script dangerouslySetInnerHTML={{ __html: SCRIPT_TEMA }} />
        </head>
        <body className="min-h-screen bg-pergamino-50 font-body text-tinta-900 antialiased transition-colors dark:bg-tinta-950 dark:text-pergamino-50">
          {children}
        </body>
      </html>
    </ClerkProvider>
  );
}
