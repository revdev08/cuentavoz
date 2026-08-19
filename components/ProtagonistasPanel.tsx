"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useSupabaseClient } from "@/lib/supabase/client";
import type { Database } from "@/lib/supabase/database.types";

type Perfil = Database["public"]["Tables"]["children_profiles"]["Row"];

const AVATARES = ["🦊", "🐻", "🐰", "🐯", "🐙", "🦕", "🦄", "🚀"];
const COLORES = [
  { nombre: "dorado", hex: "#F0C078" },
  { nombre: "verde", hex: "#8FB4A0" },
  { nombre: "azul", hex: "#82ADD0" },
  { nombre: "morado", hex: "#A98AC4" },
  { nombre: "rosado", hex: "#D98A96" },
  { nombre: "rojo", hex: "#C96161" },
];

type Formulario = {
  nombre: string;
  edad: string;
  avatar: string;
  color_favorito: string;
};

const FORMULARIO_VACIO: Formulario = {
  nombre: "",
  edad: "",
  avatar: AVATARES[0],
  color_favorito: COLORES[0].nombre,
};

export function ProtagonistasPanel({ perfilesIniciales, familyId }: {
  perfilesIniciales: Perfil[];
  familyId: string;
}) {
  const supabase = useSupabaseClient();
  const router = useRouter();
  const [perfiles, setPerfiles] = useState(perfilesIniciales);
  const [formulario, setFormulario] = useState<Formulario>(FORMULARIO_VACIO);
  const [modalAbierto, setModalAbierto] = useState(false);
  const [perfilEditando, setPerfilEditando] = useState<Perfil | null>(null);
  const [perfilEliminando, setPerfilEliminando] = useState<Perfil | null>(null);
  const [guardando, setGuardando] = useState(false);
  const [error, setError] = useState("");

  function abrirNuevo() {
    setPerfilEditando(null);
    setFormulario(FORMULARIO_VACIO);
    setError("");
    setModalAbierto(true);
  }

  function abrirEdicion(perfil: Perfil) {
    setPerfilEditando(perfil);
    setFormulario({
      nombre: perfil.nombre,
      edad: perfil.edad?.toString() ?? "",
      avatar: perfil.avatar || AVATARES[0],
      color_favorito: perfil.color_favorito || COLORES[0].nombre,
    });
    setError("");
    setModalAbierto(true);
  }

  function cerrarModal() {
    if (guardando) return;
    setModalAbierto(false);
    setPerfilEditando(null);
    setError("");
  }

  async function guardar(event: React.FormEvent) {
    event.preventDefault();
    const nombre = formulario.nombre.trim();
    const edad = Number(formulario.edad);
    if (nombre.length < 2) {
      setError("Escribe un nombre de al menos dos letras.");
      return;
    }
    if (!Number.isInteger(edad) || edad < 2 || edad > 7) {
      setError("La edad debe estar entre 2 y 7 años.");
      return;
    }

    setGuardando(true);
    setError("");
    const datos = {
      nombre,
      edad,
      avatar: formulario.avatar,
      color_favorito: formulario.color_favorito,
    };

    if (perfilEditando) {
      const { data, error: errorSupabase } = await supabase
        .from("children_profiles")
        .update(datos)
        .eq("id", perfilEditando.id)
        .eq("family_id", familyId)
        .select()
        .single();
      if (errorSupabase || !data) {
        setError("No se pudo guardar el perfil. Inténtalo otra vez.");
        setGuardando(false);
        return;
      }
      setPerfiles((actuales) => actuales.map((p) => p.id === data.id ? data : p));
    } else {
      const { data, error: errorSupabase } = await supabase
        .from("children_profiles")
        .insert({ ...datos, family_id: familyId })
        .select()
        .single();
      if (errorSupabase || !data) {
        setError("No se pudo crear el protagonista. Inténtalo otra vez.");
        setGuardando(false);
        return;
      }
      setPerfiles((actuales) => [...actuales, data]);
    }

    setGuardando(false);
    setModalAbierto(false);
    setPerfilEditando(null);
    router.refresh();
  }

  async function eliminar() {
    if (!perfilEliminando) return;
    setGuardando(true);
    const { error: errorSupabase } = await supabase
      .from("children_profiles")
      .delete()
      .eq("id", perfilEliminando.id)
      .eq("family_id", familyId);

    if (errorSupabase) {
      setError("No se pudo eliminar el perfil. Inténtalo otra vez.");
      setGuardando(false);
      setPerfilEliminando(null);
      return;
    }
    setPerfiles((actuales) => actuales.filter((p) => p.id !== perfilEliminando.id));
    setPerfilEliminando(null);
    setGuardando(false);
    router.refresh();
  }

  return (
    <>
      <div className="relative flex flex-wrap gap-4">
        {perfiles.map((perfil) => {
          const color = COLORES.find((c) => c.nombre === perfil.color_favorito)?.hex || COLORES[0].hex;
          return (
            <article key={perfil.id} className="group relative flex w-[150px] flex-col items-center gap-2 rounded-[24px] border border-white/15 bg-white/10 px-4 py-5 text-center backdrop-blur transition hover:-translate-y-1 hover:bg-white/15">
              <button type="button" onClick={() => abrirEdicion(perfil)} className="absolute right-2.5 top-2.5 flex h-7 w-7 items-center justify-center rounded-full bg-white/10 text-xs text-white/55 opacity-0 transition hover:bg-white/20 hover:text-white group-hover:opacity-100 focus:opacity-100" aria-label={`Editar perfil de ${perfil.nombre}`}>✎</button>
              <span className="flex h-16 w-16 items-center justify-center rounded-full border-2 border-white/30 text-3xl shadow-[0_0_0_5px_rgba(255,255,255,0.06)]" style={{ backgroundColor: color }} aria-hidden>{perfil.avatar || perfil.nombre.charAt(0).toUpperCase()}</span>
              <p className="mt-1 w-full truncate font-display text-lg italic text-white">{perfil.nombre}</p>
              <span className="font-mono text-[9px] uppercase tracking-wide text-white/45">{perfil.edad ? `${perfil.edad} años` : "Edad pendiente"}</span>
              <button type="button" onClick={() => abrirEdicion(perfil)} className="mt-2 text-[10px] font-bold text-oro-200/75 underline decoration-white/20 underline-offset-4 transition hover:text-oro-200">Personalizar</button>
            </article>
          );
        })}

        <button type="button" onClick={abrirNuevo} className="group flex min-h-[190px] w-[150px] flex-col items-center justify-center gap-3 rounded-[24px] border border-dashed border-white/25 bg-white/[0.04] px-4 text-center transition hover:-translate-y-1 hover:border-oro-300/60 hover:bg-white/10 focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-oro-300/25">
          <span className="flex h-12 w-12 items-center justify-center rounded-full border border-oro-300/40 bg-oro-300/10 text-2xl text-oro-200 transition group-hover:scale-110">+</span>
          <span className="text-xs font-bold text-white/70">Agregar protagonista</span>
        </button>
      </div>

      {perfiles.length === 0 && <p className="relative mt-5 text-sm text-white/55">Crea el primer perfil para guardar su progreso y personalizar los cuentos.</p>}

      {modalAbierto && (
        <div className="fixed inset-0 z-50 flex items-end justify-center bg-tinta-950/75 p-0 backdrop-blur-sm sm:items-center sm:p-6" role="dialog" aria-modal="true" aria-labelledby="titulo-protagonista" onMouseDown={(e) => { if (e.target === e.currentTarget) cerrarModal(); }}>
          <form onSubmit={guardar} className="max-h-[92dvh] w-full max-w-lg overflow-y-auto rounded-t-[32px] bg-[#FBF4E4] p-6 shadow-2xl sm:rounded-[32px] sm:p-8 dark:bg-tinta-900">
            <div className="flex items-start justify-between gap-4">
              <div><p className="font-mono text-[9px] font-bold uppercase tracking-[0.18em] text-oro-700 dark:text-oro-300">Perfil de lectura</p><h3 id="titulo-protagonista" className="mt-1 font-display text-3xl italic text-tinta-900 dark:text-pergamino-50">{perfilEditando ? "Editar protagonista" : "Nuevo protagonista"}</h3></div>
              <button type="button" onClick={cerrarModal} className="flex h-9 w-9 items-center justify-center rounded-full bg-pergamino-200 text-xl text-tinta-900/50 hover:text-tinta-900 dark:bg-white/10 dark:text-white/60" aria-label="Cerrar">×</button>
            </div>

            <label className="mt-7 block"><span className="mb-2 block text-xs font-bold text-tinta-900/65 dark:text-pergamino-50/65">Nombre</span><input autoFocus value={formulario.nombre} onChange={(e) => setFormulario({ ...formulario, nombre: e.target.value })} maxLength={30} placeholder="¿Cómo se llama?" className="w-full rounded-2xl border border-pergamino-300 bg-white px-4 py-3 text-tinta-900 outline-none transition focus:border-oro-500 focus:ring-4 focus:ring-oro-300/20 dark:border-white/10 dark:bg-white/5 dark:text-white" /></label>
            <label className="mt-4 block"><span className="mb-2 block text-xs font-bold text-tinta-900/65 dark:text-pergamino-50/65">Edad</span><select value={formulario.edad} onChange={(e) => setFormulario({ ...formulario, edad: e.target.value })} className="w-full rounded-2xl border border-pergamino-300 bg-white px-4 py-3 text-tinta-900 outline-none focus:border-oro-500 focus:ring-4 focus:ring-oro-300/20 dark:border-white/10 dark:bg-tinta-800 dark:text-white"><option value="">Elige una edad</option>{[2,3,4,5,6,7].map((edad) => <option key={edad} value={edad}>{edad} años</option>)}</select></label>

            <fieldset className="mt-5"><legend className="mb-3 text-xs font-bold text-tinta-900/65 dark:text-pergamino-50/65">Compañero del perfil</legend><div className="flex flex-wrap gap-2">{AVATARES.map((avatar) => <button key={avatar} type="button" onClick={() => setFormulario({ ...formulario, avatar })} aria-pressed={formulario.avatar === avatar} className={`flex h-12 w-12 items-center justify-center rounded-2xl text-2xl transition ${formulario.avatar === avatar ? "bg-tinta-950 shadow-[0_0_0_3px_#F0C078] dark:bg-oro-400" : "bg-white hover:-translate-y-1 dark:bg-white/5"}`}>{avatar}</button>)}</div></fieldset>
            <fieldset className="mt-5"><legend className="mb-3 text-xs font-bold text-tinta-900/65 dark:text-pergamino-50/65">Color favorito</legend><div className="flex flex-wrap gap-3">{COLORES.map((color) => <button key={color.nombre} type="button" onClick={() => setFormulario({ ...formulario, color_favorito: color.nombre })} aria-label={color.nombre} aria-pressed={formulario.color_favorito === color.nombre} className={`h-9 w-9 rounded-full border-2 border-white shadow transition hover:scale-110 ${formulario.color_favorito === color.nombre ? "ring-2 ring-tinta-950 ring-offset-2 dark:ring-oro-300" : ""}`} style={{ backgroundColor: color.hex }} />)}</div></fieldset>

            {error && <p role="alert" className="mt-5 rounded-xl bg-baya-100 px-4 py-3 text-sm font-semibold text-baya-700 dark:bg-baya-500/15 dark:text-baya-200">{error}</p>}
            <div className="mt-7 flex items-center gap-3">
              {perfilEditando && <button type="button" onClick={() => { setModalAbierto(false); setPerfilEliminando(perfilEditando); }} className="mr-auto text-xs font-bold text-baya-600 underline underline-offset-4 dark:text-baya-200">Eliminar perfil</button>}
              <button type="button" onClick={cerrarModal} className="rounded-full px-5 py-3 text-xs font-bold text-tinta-900/50 dark:text-white/50">Cancelar</button>
              <button type="submit" disabled={guardando} className="rounded-full bg-tinta-950 px-6 py-3 text-xs font-bold text-white shadow-lg transition hover:-translate-y-0.5 disabled:cursor-wait disabled:opacity-60 dark:bg-oro-400 dark:text-tinta-950">{guardando ? "Guardando…" : perfilEditando ? "Guardar cambios" : "Crear protagonista"}</button>
            </div>
          </form>
        </div>
      )}

      {perfilEliminando && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-tinta-950/75 p-6 backdrop-blur-sm" role="alertdialog" aria-modal="true" aria-labelledby="titulo-eliminar">
          <div className="w-full max-w-sm rounded-[28px] bg-pergamino-50 p-7 text-center shadow-2xl dark:bg-tinta-900">
            <span className="text-4xl" aria-hidden>{perfilEliminando.avatar || "📖"}</span>
            <h3 id="titulo-eliminar" className="mt-3 font-display text-2xl italic text-tinta-900 dark:text-white">¿Eliminar a {perfilEliminando.nombre}?</h3>
            <p className="mt-2 text-sm leading-relaxed text-tinta-900/55 dark:text-white/55">También se eliminará su progreso de lectura. Esta acción no se puede deshacer.</p>
            <div className="mt-6 flex justify-center gap-3"><button type="button" onClick={() => setPerfilEliminando(null)} disabled={guardando} className="rounded-full px-5 py-3 text-xs font-bold text-tinta-900/55 dark:text-white/55">Conservar perfil</button><button type="button" onClick={eliminar} disabled={guardando} className="rounded-full bg-baya-600 px-5 py-3 text-xs font-bold text-white disabled:opacity-60">{guardando ? "Eliminando…" : "Sí, eliminar"}</button></div>
          </div>
        </div>
      )}
    </>
  );
}
