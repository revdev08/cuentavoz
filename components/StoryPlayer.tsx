"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { useSupabaseClient } from "@/lib/supabase/client";
import { useBlockAudio } from "@/lib/audio/useBlockAudio";
import { useNarracionAutomatica } from "@/lib/audio/useNarracionAutomatica";
import { ThemeToggle } from "@/components/ThemeToggle";
import { EsquinaDoblada, estiloDoblez } from "@/components/EsquinaDoblada";
import { articuloPara, articuloDefinidoPara } from "@/lib/texto/genero";
import type { Database } from "@/lib/supabase/database.types";

type Story = Database["public"]["Tables"]["stories"]["Row"];
type StoryVariable = Database["public"]["Tables"]["story_variables"]["Row"];
type ChildProfile = Database["public"]["Tables"]["children_profiles"]["Row"];
type SoundEffect = Database["public"]["Tables"]["sound_effects"]["Row"];
type StoryBlock = Database["public"]["Tables"]["story_blocks"]["Row"] & {
  sonido: SoundEffect | null;
};

function sustituirVariables(texto: string, valores: Record<string, string>) {
  // [^}]+ en vez de \w+: \w es solo ASCII y no matchea la "ñ" de nombre_niño.
  return texto.replace(/\{([^}]+)\}/g, (_, key) => valores[key] ?? `{${key}}`);
}

/**
 * Parte el texto del bloque en trozos, marcando cuáles son alguna de las
 * trigger_keywords -- esos se renderizan como botones subrayados con
 * puntos (igual que la demo de la landing), tocables para disparar el
 * sonido a mano en vez de solo esperar a que el micrófono la detecte.
 */
function partirConPalabraClave(texto: string, keywords: string[]) {
  if (keywords.length === 0) return [{ texto, esClave: false }];
  const escapadas = keywords.map((k) => k.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"));
  const patron = new RegExp(`(${escapadas.join("|")})`, "gi");
  return texto.split(patron).map((trozo, i) => ({ texto: trozo, esClave: i % 2 === 1 }));
}

const NUMERALES: [number, string][] = [
  [1000, "M"], [900, "CM"], [500, "D"], [400, "CD"],
  [100, "C"], [90, "XC"], [50, "L"], [40, "XL"],
  [10, "X"], [9, "IX"], [5, "V"], [4, "IV"], [1, "I"],
];

function romanizar(numero: number) {
  let resto = numero;
  let resultado = "";
  for (const [valor, simbolo] of NUMERALES) {
    while (resto >= valor) {
      resultado += simbolo;
      resto -= valor;
    }
  }
  return resultado;
}

const ETIQUETAS: Record<string, string> = {
  nombre_niño: "¿Cómo se llama el protagonista?",
  color_favorito: "¿Cuál es su color favorito?",
  animal_amigo: "¿Qué animal quiere de amigo?",
  nombre_gota: "¿Cómo quieres llamar a la gota de tinta?",
  color_tinta: "¿De qué color es la tinta?",
  dibujo_favorito: "¿En qué se convirtió la gota al final?",
  nombre_copo: "¿Cómo quieres llamar al pequeño copo de nieve?",
  color_bufanda: "¿De qué color es la bufanda?",
  nombre_invernadero: "¿Cómo se llama el invernadero del tejado?",
  nombre_cuchara: "¿Cómo se llama la cuchara de madera?",
  nombre_cuchara_nueva: "¿Cómo se llama la cuchara nueva?",
  color_cuchara_nueva: "¿De qué color es la cuchara nueva?",
  nombre_brujula: "¿Cómo se llama la brújula?",
  color_brujula: "¿De qué color es la brújula?",
  pueblo_destino: "¿A qué pueblo deben llegar?",
  nombre_vela: "¿Cómo se llama la vela más delgada?",
  color_vela: "¿De qué color es la vela?",
  nombre_nube: "¿Cómo se llama la nube?",
  color_nube: "¿De qué color se pone la nube al atardecer?",
  nombre_valle: "¿Cómo se llama el valle?",
  nombre_semilla: "¿Cómo se llama la semilla?",
  color_flor: "¿De qué color florece?",
  nombre_jardin: "¿Cómo se llama el jardín?",
  nombre_barco: "¿Cómo se llama el barco de papel?",
  color_barco: "¿De qué color es el papel del barco?",
  nombre_rio: "¿Cómo se llama el río?",
  nombre_erizo: "¿Cómo se llama el erizo?",
  color_puas: "¿De qué color son sus púas?",
  nombre_bosque: "¿Cómo se llama el bosque?",
  nombre_amigo: "¿Cómo se llama su amigo o amiga?",
  nombre_huerto: "¿Cómo se llama el huerto de la familia?",
  nombre_castor: "¿Cómo se llama el castor?",
  color_pelaje: "¿De qué color es su pelaje?",
  nombre_arroyo: "¿Cómo se llama el arroyo?",
  nombre_campana: "¿Cómo se llama la campana?",
  color_campana: "¿De qué color es la campana?",
  nombre_pueblo: "¿Cómo se llama el pueblo?",
  nombre_estrella: "¿Cómo se llama la estrella?",
  color_estrella: "¿De qué color brilla?",
  nombre_constelacion: "¿Cómo se llama su constelación?",
  nombre_reloj: "¿Cómo se llama el reloj?",
  nombre_panaderia: "¿Cómo se llama la panadería?",
  pan_favorito: "¿Cuál es el pan favorito de la casa?",
  nombre_gaviota: "¿Cómo se llama la gaviota?",
  nombre_playa: "¿Cómo se llama la playa?",
  color_peine: "¿De qué color es el peine de concha?",
  nombre_farol: "¿Cómo se llama el farol?",
  nombre_estacion: "¿Cómo se llama la estación?",
  color_luz: "¿De qué color es su luz?",
  nombre_cometa: "¿Cómo se llama la cometa?",
  color_cometa: "¿De qué color es la cometa?",
  nombre_colina: "¿Cómo se llama la colina?",
  nombre_lapiz: "¿Cómo se llama el lápiz?",
  color_lapiz: "¿De qué color es el lápiz?",
  nombre_taller: "¿Cómo se llama el taller?",
  nombre_paraguas: "¿Cómo se llama el paraguas?",
  color_paraguas: "¿De qué color es el paraguas?",
  nombre_violin: "¿Cómo se llama el violín?",
  color_violin: "¿De qué color es el violín?",
  nombre_feria: "¿Cómo se llama la feria?",
  nombre_alpaca: "¿Cómo se llama la alpaca?",
  color_manta: "¿De qué color es su manta?",
  nombre_pueblo_montana: "¿Cómo se llama el pueblo de la montaña?",
};

// Red de seguridad para variable_key que no tengan pregunta propia en
// ETIQUETAS -- cada cuento puede inventar las variables que necesite, no
// solo las tres de arriba, así que esto nunca debería mostrarse "crudo".
function etiquetaPara(variableKey: string) {
  const conocida = ETIQUETAS[variableKey];
  if (conocida) return conocida;
  const texto = variableKey.replace(/_/g, " ");
  return `¿Cuál es ${texto}?`;
}

function FondoDecorativo() {
  return (
    <div className="pointer-events-none absolute inset-0 overflow-hidden">
      <div className="absolute -left-24 -top-24 h-72 w-72 rounded-full bg-pergamino-200 opacity-60 blur-3xl dark:bg-oro-700/40" />
      <div className="absolute -right-20 top-1/3 h-64 w-64 rounded-full bg-esmeralda-500 opacity-20 blur-3xl" />
      <div className="absolute bottom-0 left-1/3 h-56 w-56 rounded-full bg-pergamino-200 opacity-40 blur-3xl dark:bg-tinta-700/60" />
    </div>
  );
}

function BarraSuperior() {
  return (
    <div className="mb-3 flex items-center justify-between">
      <Link
        href="/dashboard"
        className="flex items-center gap-1.5 text-sm font-medium text-tinta-900/60 transition hover:text-tinta-900 dark:text-pergamino-50/60 dark:hover:text-pergamino-50"
      >
        ← Mis cuentos
      </Link>
      <ThemeToggle />
    </div>
  );
}

export function StoryPlayer({
  story,
  bloques,
  variables,
  hijos,
  sesionExistente,
}: {
  story: Story;
  bloques: StoryBlock[];
  variables: StoryVariable[];
  hijos: ChildProfile[];
  /** Para "continuar donde quedó" desde el dashboard -- la última fila de
   * story_sessions para ese (niño, cuento), si existe. Si viene, se salta
   * la personalización (ya se hizo antes) y arranca directo en su bloque. */
  sesionExistente?: {
    hijoId: string;
    ultimoBloque: number;
    variablesUsadas: Record<string, string>;
  };
}) {
  const supabase = useSupabaseClient();
  const requierePersonalizacion =
    story.es_personalizable && variables.length > 0 && !sesionExistente;

  const [fase, setFase] = useState<"personalizar" | "leyendo" | "completado">(
    requierePersonalizacion ? "personalizar" : "leyendo"
  );
  const [hijoId, setHijoId] = useState(sesionExistente?.hijoId ?? hijos[0]?.id ?? "");
  const [valores, setValores] = useState<Record<string, string>>(() => {
    if (sesionExistente) return sesionExistente.variablesUsadas;
    const iniciales: Record<string, string> = {};
    for (const v of variables) {
      if ((v.variable_key === "nombre_niño" || v.variable_key === "nombre_nino") && hijos[0]) {
        iniciales[v.variable_key] = hijos[0].nombre;
      } else if (v.variable_key === "color_favorito" && hijos[0]?.color_favorito) {
        iniciales[v.variable_key] = hijos[0].color_favorito;
      }
    }
    return iniciales;
  });
  const [indice, setIndice] = useState(() =>
    Math.min(sesionExistente?.ultimoBloque ?? 0, Math.max(bloques.length - 1, 0))
  );
  // Por defecto el disparador es la voz: el padre lee la palabra en voz
  // alta y ahí suena, en vez de sonar apenas aparece el bloque.
  const [modoEscucha, setModoEscucha] = useState(true);
  const [modoReproduccion, setModoReproduccion] = useState<"acompanada" | "automatica">("acompanada");
  const [guardando, setGuardando] = useState(false);
  const [errorGuardado, setErrorGuardado] = useState(false);

  const bloqueActual = bloques[indice];
  const esUltimo = indice === bloques.length - 1;
  const faltanVariables = variables.some((v) => !valores[v.variable_key]?.trim());

  const { detectado: sonidoActivo, dispararManual } = useBlockAudio(
    fase === "leyendo" ? bloqueActual?.sonido ?? null : null,
    {
      modoEscucha: modoReproduccion === "acompanada" && modoEscucha,
      keywords: bloqueActual?.trigger_keywords ?? [],
    }
  );

  // El niño puede escribir cualquier palabra en cualquier variable (no
  // solo las sugeridas), así que para TODAS calculamos "un/una" y "el/la"
  // según el género inferido -- así el texto nunca impone un artículo fijo
  // que choque con lo que escribió (ej. "un ardilla", o "un torre mágica"
  // si la variable fuera un objeto en vez de un animal).
  const valoresConArticulos = useMemo(() => {
    const extendido = { ...valores };
    for (const v of variables) {
      if (valores[v.variable_key]) {
        extendido[`un_${v.variable_key}`] = articuloPara(valores[v.variable_key]);
        extendido[`el_${v.variable_key}`] = articuloDefinidoPara(valores[v.variable_key]);
      }
    }
    return extendido;
  }, [valores, variables]);

  const textoActual = useMemo(
    () => (bloqueActual ? sustituirVariables(bloqueActual.texto_bloque, valoresConArticulos) : ""),
    [bloqueActual, valoresConArticulos]
  );

  const narracion = useNarracionAutomatica({
    habilitada: fase === "leyendo" && modoReproduccion === "automatica",
    texto: textoActual,
    palabraConSonido: bloqueActual?.trigger_keywords?.[0] ?? null,
    alLlegarAlSonido: dispararManual,
    alTerminar: () => avanzar(),
  });

  function seleccionarProtagonista(id: string) {
    setHijoId(id);
    const perfil = hijos.find((h) => h.id === id);
    if (!perfil) return;
    setValores((actuales) => {
      const siguientes = { ...actuales };
      // Los cuentos nuevos usan nombre_nino (sin tilde) y algunos cuentos
      // anteriores nombre_niño. Solo completamos esas claves explícitas:
      // nombre_objeto/nombre_animal pertenecen a personajes del cuento.
      if (variables.some((v) => v.variable_key === "nombre_nino")) {
        siguientes.nombre_nino = perfil.nombre;
      }
      if (variables.some((v) => v.variable_key === "nombre_niño")) {
        siguientes.nombre_niño = perfil.nombre;
      }
      if (perfil.color_favorito && variables.some((v) => v.variable_key === "color_favorito")) {
        siguientes.color_favorito = perfil.color_favorito;
      }
      return siguientes;
    });
  }

  // Guarda en qué bloque va cada vez que avanza (o retrocede), para que
  // "Últimos escuchados" en el dashboard pueda mostrar progreso real y
  // ofrecer "continuar donde quedó". Una sola fila por (niño, cuento):
  // se actualiza en su lugar en vez de crear una fila nueva cada vez.
  useEffect(() => {
    if (fase !== "leyendo" || !hijoId) return;
    supabase
      .from("story_sessions")
      .upsert(
        {
          child_profile_id: hijoId,
          story_id: story.id,
          variables_usadas: valores,
          ultimo_bloque: indice,
          updated_at: new Date().toISOString(),
        },
        { onConflict: "child_profile_id,story_id" }
      )
      .then(() => {});
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [indice, fase, hijoId]);

  async function avanzar() {
    if (!esUltimo) {
      setIndice((i) => i + 1);
      return;
    }

    setFase("completado");
    if (!hijoId) return;

    setGuardando(true);
    setErrorGuardado(false);
    const { error } = await supabase.from("story_sessions").upsert(
      {
        child_profile_id: hijoId,
        story_id: story.id,
        variables_usadas: valores,
        ultimo_bloque: indice,
        completado: true,
        updated_at: new Date().toISOString(),
      },
      { onConflict: "child_profile_id,story_id" }
    );
    setGuardando(false);
    if (error) setErrorGuardado(true);
  }

  function retroceder() {
    setIndice((i) => Math.max(0, i - 1));
  }

  function activarModoAutomatico() {
    setModoEscucha(false);
    setModoReproduccion("automatica");
  }

  function activarModoAcompanado() {
    narracion.pausar();
    setModoReproduccion("acompanada");
  }

  if (bloques.length === 0) {
    return (
      <main className="mx-auto max-w-2xl px-6 py-16 text-center">
        <p className="text-tinta-900/70 dark:text-pergamino-50/70">
          Este cuento todavía no tiene contenido cargado.
        </p>
        <Link
          href="/dashboard"
          className="mt-4 inline-block text-oro-700 underline dark:text-pergamino-200"
        >
          Volver a mis cuentos
        </Link>
      </main>
    );
  }

  if (fase === "personalizar") {
    return (
      <main className="relative min-h-screen overflow-hidden bg-pergamino-50 dark:bg-tinta-950">
        <FondoDecorativo />
        <div className="relative mx-auto max-w-xl px-6 py-6 sm:py-12">
          <BarraSuperior />

          <h1 className="font-display text-2xl italic text-tinta-900 dark:text-pergamino-50">
            Antes de empezar: {story.titulo}
          </h1>
          <p className="mt-2 text-tinta-900/70 dark:text-pergamino-50/70">
            Ayúdanos a personalizar el cuento para que sienta que fue parte de crearlo.
          </p>

          {hijos.length > 1 && (
            <label className="mt-6 block">
              <span className="mb-1 block text-sm font-medium text-tinta-900 dark:text-pergamino-50">
                ¿Para cuál niño o niña es?
              </span>
              <select
                value={hijoId}
                onChange={(e) => seleccionarProtagonista(e.target.value)}
                className="w-full rounded-xl border border-pergamino-100 bg-white px-4 py-2 dark:border-tinta-600 dark:bg-tinta-800 dark:text-pergamino-50"
              >
                {hijos.map((h) => (
                  <option key={h.id} value={h.id}>
                    {h.nombre}
                  </option>
                ))}
              </select>
            </label>
          )}

          <div className="mt-6 space-y-6 rounded-3xl border border-pergamino-100 bg-white/80 p-6 shadow-sm backdrop-blur dark:border-tinta-600 dark:bg-tinta-800/80">
            {variables.map((v) => (
              <div key={v.id}>
                <label className="mb-2 block text-sm font-medium text-tinta-900 dark:text-pergamino-50">
                  {etiquetaPara(v.variable_key)}
                </label>
                <input
                  type="text"
                  value={valores[v.variable_key] ?? ""}
                  onChange={(e) =>
                    setValores((prev) => ({ ...prev, [v.variable_key]: e.target.value }))
                  }
                  className="w-full rounded-xl border border-pergamino-100 bg-white px-4 py-2 dark:border-tinta-600 dark:bg-tinta-700 dark:text-pergamino-50"
                  placeholder="Escribe lo que quieras..."
                />
                {v.opciones_sugeridas.length > 0 && (
                  <div className="mt-2 flex flex-wrap items-center gap-1.5">
                    <span className="mr-1 text-xs text-tinta-900/50 dark:text-pergamino-50/50">
                      Ideas:
                    </span>
                    {v.opciones_sugeridas.map((opcion) => (
                      <button
                        key={opcion}
                        type="button"
                        onClick={() =>
                          setValores((prev) => ({ ...prev, [v.variable_key]: opcion }))
                        }
                        className="rounded-full border border-pergamino-100 bg-white px-3 py-1 text-xs capitalize text-tinta-900/80 transition hover:border-oro-400 hover:text-oro-700 dark:border-tinta-600 dark:bg-tinta-700 dark:text-pergamino-50/80 dark:hover:border-oro-300 dark:hover:text-oro-300"
                      >
                        {opcion}
                      </button>
                    ))}
                    <button
                      type="button"
                      title="Sorpréndeme"
                      onClick={() =>
                        setValores((prev) => ({
                          ...prev,
                          [v.variable_key]:
                            v.opciones_sugeridas[
                              Math.floor(Math.random() * v.opciones_sugeridas.length)
                            ],
                        }))
                      }
                      className="rounded-full border border-esmeralda-500/40 bg-esmeralda-500/10 px-3 py-1 text-xs text-esmeralda-700 transition hover:bg-esmeralda-500/20 dark:text-esmeralda-300"
                    >
                      🎲 Sorpréndeme
                    </button>
                  </div>
                )}
              </div>
            ))}
          </div>

          <button
            type="button"
            disabled={faltanVariables}
            onClick={() => setFase("leyendo")}
            className="mt-8 w-full rounded-full bg-oro-500 px-8 py-3 font-semibold text-white shadow-sm transition hover:bg-oro-700 disabled:cursor-not-allowed disabled:opacity-40"
          >
            Comenzar el cuento
          </button>
        </div>
      </main>
    );
  }

  if (fase === "completado") {
    return (
      <main className="relative min-h-screen overflow-hidden bg-pergamino-50 dark:bg-tinta-950">
        <FondoDecorativo />
        <div className="relative mx-auto max-w-xl px-6 py-6">
          <BarraSuperior />
        </div>
        <div className="relative mx-auto flex max-w-xl flex-col items-center justify-center px-6 py-16 text-center">
          <span className="text-6xl">🎉</span>
          <h1 className="mt-4 font-display text-3xl italic text-tinta-900 dark:text-pergamino-50">
            ¡Fin del cuento!
          </h1>
          <p className="mt-3 text-tinta-900/70 dark:text-pergamino-50/70">
            {valores["nombre_niño"]
              ? `${valores["nombre_niño"]} ayudó a crear esta aventura.`
              : "Gracias por leer juntos."}
          </p>
          {guardando && (
            <p className="mt-2 text-sm text-tinta-900/50 dark:text-pergamino-50/50">
              Guardando progreso...
            </p>
          )}
          {errorGuardado && (
            <p className="mt-2 text-sm text-oro-500 dark:text-oro-300">
              No pudimos guardar el progreso, pero el cuento se leyó completo.
            </p>
          )}
          <Link
            href="/dashboard"
            className="mt-8 rounded-full bg-oro-500 px-8 py-3 font-semibold text-white shadow-sm transition hover:bg-oro-700"
          >
            Volver a mis cuentos
          </Link>
        </div>
      </main>
    );
  }

  return (
    <main
      onClick={modoReproduccion === "acompanada" ? avanzar : undefined}
      className="relative h-[100dvh] w-full overflow-hidden bg-tinta-950 transition-shadow duration-700"
      style={{
        boxShadow: sonidoActivo
          ? "inset 0 0 0 5px rgba(46,184,148,0.55), inset 0 0 90px 12px rgba(46,184,148,0.3)"
          : "inset 0 0 0 0px rgba(46,184,148,0)",
      }}
    >
      {bloqueActual?.imagen_url && (
        // eslint-disable-next-line @next/next/no-img-element
        <img
          key={bloqueActual.id}
          src={bloqueActual.imagen_url}
          alt=""
          className="imagen-reproductor-movil absolute inset-x-0 top-0 w-full object-cover sm:inset-0 sm:h-full"
        />
      )}
      <div className="absolute inset-0 bg-gradient-to-t from-tinta-950 via-tinta-950/35 to-tinta-950/15" />

      {/* Barra fina de progreso: apenas se nota, no compite con la página. */}
      <div
        className="absolute left-0 top-0 z-20 h-1 bg-oro-400 transition-all duration-500"
        style={{ width: `${((indice + 1) / bloques.length) * 100}%` }}
      />

      <Link
        href="/dashboard"
        onClick={(e) => e.stopPropagation()}
        aria-label="Volver a mis cuentos"
        className="absolute left-4 top-5 z-20 flex h-11 w-11 items-center justify-center rounded-full border border-pergamino-50/25 bg-tinta-950/50 text-lg text-pergamino-50 backdrop-blur transition hover:bg-tinta-950/75"
      >
        ←
      </Link>

      <div className="absolute right-4 top-5 z-20 flex items-center rounded-full border border-pergamino-50/20 bg-tinta-950/60 p-1 shadow-lg backdrop-blur">
        <button
          type="button"
          onClick={(e) => {
            e.stopPropagation();
            activarModoAcompanado();
          }}
          aria-pressed={modoReproduccion === "acompanada"}
          title="Lectura acompañada"
          className={`flex h-9 items-center gap-1.5 rounded-full px-3 text-xs font-semibold transition ${
            modoReproduccion === "acompanada" ? "bg-esmeralda-500/30 text-esmeralda-100" : "text-pergamino-50/65 hover:text-pergamino-50"
          }`}
        >
          <span className={modoEscucha && !sonidoActivo ? "animar-pulso" : ""}>🎙️</span>
          <span className="hidden sm:inline">Leer</span>
        </button>
        <button
          type="button"
          onClick={(e) => {
            e.stopPropagation();
            activarModoAutomatico();
            narracion.iniciar();
          }}
          aria-pressed={modoReproduccion === "automatica"}
          title="Narración automática"
          className={`flex h-9 items-center gap-1.5 rounded-full px-3 text-xs font-semibold transition ${
            modoReproduccion === "automatica" ? "bg-oro-400 text-tinta-950" : "text-pergamino-50/65 hover:text-pergamino-50"
          }`}
        >
          <span>🔊</span><span className="hidden sm:inline">Escuchar</span>
        </button>
      </div>

      <span className="pointer-events-none absolute right-5 top-20 z-20 font-display text-xs italic tracking-wide text-pergamino-50/70">
        {romanizar(indice + 1)} de {romanizar(bloques.length)}
      </span>
      {modoReproduccion === "acompanada" && modoEscucha && bloqueActual?.sonido && !sonidoActivo && (
        <span className="pointer-events-none absolute right-5 top-[86px] z-20 text-[11px] font-medium text-esmeralda-300/80">
          escuchando...
        </span>
      )}

      <div key={indice} className="pagina-voltea absolute inset-x-0 bottom-0 z-10">
        <div className="relative mx-auto max-w-2xl px-5 pb-8 pt-8 sm:px-10 sm:pb-10">
          <div
            className="relative rounded-t-[1.75rem] bg-tinta-950/75 p-6 shadow-[0_-24px_60px_-24px_rgba(0,0,0,0.65)] backdrop-blur-md sm:p-9"
            style={estiloDoblez(26)}
          >
            <EsquinaDoblada size={26} />
            <p className="texto-iluminado font-display text-lg leading-relaxed text-pergamino-50 sm:text-xl">
              {partirConPalabraClave(textoActual, bloqueActual?.trigger_keywords ?? []).map(
                (trozo, i) =>
                  trozo.esClave ? (
                    <button
                      key={i}
                      type="button"
                      onClick={(e) => {
                        e.stopPropagation();
                        dispararManual();
                      }}
                      className={`rounded border-b-2 border-dotted px-0.5 font-semibold transition ${
                        sonidoActivo
                          ? "border-esmeralda-400 text-esmeralda-300"
                          : "border-oro-400 text-oro-300 hover:text-oro-200"
                      }`}
                    >
                      {trozo.texto}
                    </button>
                  ) : (
                    <span key={i}>{trozo.texto}</span>
                  )
              )}
            </p>
            <div className="mt-3 flex items-center justify-between text-xs italic text-oro-300/80 cursor-pointer">
              {indice > 0 ? (
                <button
                  type="button"
                  onClick={(e) => {
                    e.stopPropagation();
                    retroceder();
                  }}
                  className="rounded px-1 py-0.5 transition hover:text-oro-200"
                >
                  ‹ página anterior
                </button>
              ) : (
                <span />
              )}
              {modoReproduccion === "automatica" ? (
                narracion.soportada ? (
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      narracion.reproduciendo ? narracion.pausar() : narracion.iniciar();
                    }}
                    className="rounded px-1 py-0.5 font-sans not-italic font-semibold text-oro-300 transition hover:text-oro-200"
                  >
                    {narracion.reproduciendo ? "❚❚ Pausar" : "▶ Escuchar esta página"}
                  </button>
                ) : (
                  <span className="font-sans not-italic text-pergamino-50/60">La narración no está disponible en este navegador.</span>
                )
              ) : (
                <p>toca para continuar ›</p>
              )}
            </div>
          </div>
        </div>
      </div>
    </main>
  );
}
