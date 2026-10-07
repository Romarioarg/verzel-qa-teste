// @ts-check
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  // Pasta onde ficam os testes automatizados
  testDir: './tests',

  // Tempo máximo de cada teste (30 segundos)
  timeout: 30_000,

  // Roda os arquivos de teste em paralelo para ganhar tempo
  fullyParallel: true,

  // No CI (GitHub Actions), impede subir um teste marcado com .only por engano
  forbidOnly: !!process.env.CI,

  // Sem novas tentativas: se falhar, queremos ver a falha real
  retries: 0,

  // Relatórios: lista no terminal + relatório HTML navegável
  reporter: [['list'], ['html', { open: 'never' }]],

  use: {
    // Endereço da loja: nos testes usamos só o caminho, ex.: page.goto('/carrinho')
    baseURL: 'https://verzel-store.qa-test-verzel-store.workers.dev',

    // Evidências automáticas quando um teste falhar
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'retain-on-failure',
  },

  // Só o Chrome (Chromium), o mesmo navegador usado nos testes manuais
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});