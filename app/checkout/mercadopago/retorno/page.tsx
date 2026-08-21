import { AppHeader } from "@/components/AppHeader";
import { ConfirmacionPago } from "@/components/ConfirmacionPago";

export default function RetornoMercadoPagoPage() {
  return (
    <div className="min-h-screen bg-pergamino-50 dark:bg-tinta-950">
      <AppHeader />
      <main className="px-5 pb-20">
        <ConfirmacionPago completa />
      </main>
    </div>
  );
}
