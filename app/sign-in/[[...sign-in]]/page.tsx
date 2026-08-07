"use client";

import { SignIn } from "@clerk/nextjs";
import { AppHeader } from "@/components/AppHeader";
import { useTemaOscuro } from "@/lib/theme/useTemaOscuro";

export default function SignInPage() {
  const oscuro = useTemaOscuro();

  return (
    <div className="relative min-h-screen overflow-hidden bg-pergamino-50 dark:bg-tinta-950">
      <div className="pointer-events-none absolute inset-0 overflow-hidden">
        <div className="absolute -left-24 -top-24 h-72 w-72 rounded-full bg-pergamino-200 opacity-60 blur-3xl dark:bg-oro-700/40" />
        <div className="absolute -right-20 bottom-0 h-64 w-64 rounded-full bg-esmeralda-500 opacity-20 blur-3xl" />
      </div>
      <div className="relative">
        <AppHeader />
        <main className="flex flex-col items-center justify-center px-6 pb-16 pt-4">
          <h1 className="mb-6 font-display text-2xl font-semibold text-tinta-900 dark:text-pergamino-50">
            Bienvenido de vuelta
          </h1>
          <SignIn
            appearance={{
              variables: {
                colorPrimary: "#D4A24C",
                colorBackground: oscuro ? "#271F42" : "#FFFFFF",
                colorText: oscuro ? "#FCF6EA" : "#1C1730",
                colorTextSecondary: oscuro ? "#FCF6EA80" : "#1C173080",
                colorInputBackground: oscuro ? "#362A57" : "#FCF6EA",
                colorInputText: oscuro ? "#FCF6EA" : "#1C1730",
                borderRadius: "1.25rem",
              },
              elements: {
                card: "shadow-xl",
                formButtonPrimary: "bg-oro-500 hover:bg-oro-700",
                footerActionLink: "text-oro-500 hover:text-oro-700",
              },
            }}
          />
        </main>
      </div>
    </div>
  );
}
