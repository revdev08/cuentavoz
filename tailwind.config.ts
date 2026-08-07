import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Pergamino: papel cálido. Fondo de página y tarjetas en modo día.
        pergamino: {
          50: "#FBF4E4",
          100: "#F3E8D0",
          200: "#EADFC4",
        },
        // Oro: pan de oro de manuscrito iluminado. Acento principal, CTAs.
        oro: {
          300: "#F0C078",
          500: "#E7A23D",
          700: "#C97E22",
        },
        // Esmeralda: verde musgo -- el brillo de "la magia del sonido".
        // Acento vivo, estados activos, motas flotantes.
        esmeralda: {
          200: "#B9D1C4",
          300: "#8FB4A0",
          500: "#4C7A63",
          700: "#3A5F4C",
        },
        // Baya: acento berry, para eyebrows/citas/comparativas -- variar
        // del dorado y el musgo sin salir de la paleta cálida.
        baya: {
          300: "#D98A96",
          500: "#B4485A",
          700: "#8A3444",
        },
        // Ciruela: profundidad secundaria para degradados y sombras.
        ciruela: {
          400: "#8A6BAE",
          600: "#6A4C8C",
        },
        // Tinta: violeta-noche. Fondo en modo noche y texto principal en
        // modo día (en vez de negro puro).
        tinta: {
          950: "#141224",
          900: "#1B1A2E",
          800: "#241F3D",
          700: "#2E2850",
          600: "#3D3760",
        },
      },
      fontFamily: {
        // Fraunces en itálica: la voz "manuscrito mágico" de la marca.
        display: ["var(--font-display)", "'Fraunces'", "serif"],
        body: ["var(--font-body)", "'Nunito'", "sans-serif"],
        // IBM Plex Mono: eyebrows, folios, etiquetas -- el contrapunto
        // "editorial/técnico" a la calidez del Fraunces itálico.
        mono: ["var(--font-mono)", "'IBM Plex Mono'", "monospace"],
      },
      backgroundImage: {
        "brillo-oro": "radial-gradient(circle, rgba(231,162,61,0.35) 0%, rgba(231,162,61,0) 70%)",
        "brillo-esmeralda": "radial-gradient(circle, rgba(76,122,99,0.4) 0%, rgba(76,122,99,0) 70%)",
      },
    },
  },
  plugins: [],
};

export default config;
