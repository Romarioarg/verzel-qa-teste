// @ts-check
import { test, expect } from '@playwright/test';

/**
 * Adiciona um produto ao carrinho pela vitrine e abre o carrinho.
 * Cada teste começa com um navegador novo, então o carrinho sempre começa vazio.
 */
async function adicionarAoCarrinhoEAbrir(page, nomeDoProduto) {
  await page.goto('/');
  await page
    .getByRole('article', { name: nomeDoProduto })
    .getByRole('button', { name: 'Adicionar ao carrinho' })
    .click();
  await page.getByRole('link', { name: /^Carrinho/ }).click();
  await expect(page.getByRole('heading', { name: 'Carrinho', level: 1 })).toBeVisible();
}

async function aplicarCupom(page, cupom) {
  await page.getByLabel('Cupom de desconto').fill(cupom);
  await page.getByRole('button', { name: 'Aplicar cupom' }).click();
}

test.describe('Cupom de desconto', () => {
  test.beforeEach(async ({ page }) => {
    // Pré-condição comum: 1 Mochila Urbana 20L (R$ 100,00) no carrinho
    await adicionarAoCarrinhoEAbrir(page, 'Mochila Urbana 20L');
  });

  test('CT01 - aplica 10% de desconto com o cupom BEMVINDO10 (CA01)', async ({ page }) => {
    await aplicarCupom(page, 'BEMVINDO10');

    await expect(page.locator('[data-valor="subtotal"]')).toHaveText('R$ 100,00');
    await expect(page.locator('[data-valor="desconto"]')).toHaveText('- R$ 10,00');
    await expect(page.locator('[data-valor="frete"]')).toHaveText('R$ 19,90');
    await expect(page.locator('[data-valor="total"]')).toHaveText('R$ 109,90');
  });

  // Mesmo teste com dados diferentes: cupom inexistente (CA03) e expirado (CA04)
  const cuponsRecusados = [
    { ct: 'CT03', cupom: 'NAOEXISTE', mensagem: 'Cupom inválido.', ca: 'CA03' },
    { ct: 'CT04', cupom: 'VERAO2026', mensagem: 'Cupom expirado.', ca: 'CA04' },
  ];

  for (const { ct, cupom, mensagem, ca } of cuponsRecusados) {
    test(`${ct} - recusa o cupom ${cupom} com a mensagem "${mensagem}" (${ca})`, async ({ page }) => {
      await aplicarCupom(page, cupom);

      await expect(page.locator('#mensagem-cupom')).toHaveText(mensagem);
      await expect(page.locator('[data-valor="desconto"]')).toHaveText('R$ 0,00');
      await expect(page.locator('[data-valor="total"]')).toHaveText('R$ 119,90');
    });
  }
});