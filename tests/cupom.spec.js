// @ts-check
import { test, expect } from '@playwright/test';
import { adicionarAoCarrinho, abrirCarrinho, aplicarCupom, valorDoResumo } from './helpers/carrinho.js';

test.describe('Cupom de desconto', () => {
  test.beforeEach(async ({ page }) => {
    // Pré-condição comum: 1 Mochila Urbana 20L (R$ 100,00) no carrinho
    await adicionarAoCarrinho(page, 'Mochila Urbana 20L');
    await abrirCarrinho(page);
  });

  test('CT01 - aplica 10% de desconto com o cupom BEMVINDO10 (CA01)', async ({ page }) => {
    await aplicarCupom(page, 'BEMVINDO10');

    await expect(valorDoResumo(page, 'subtotal')).toHaveText('R$ 100,00');
    await expect(valorDoResumo(page, 'desconto')).toHaveText('- R$ 10,00');
    await expect(valorDoResumo(page, 'frete')).toHaveText('R$ 19,90');
    await expect(valorDoResumo(page, 'total')).toHaveText('R$ 109,90');
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
      await expect(valorDoResumo(page, 'desconto')).toHaveText('R$ 0,00');
      await expect(valorDoResumo(page, 'total')).toHaveText('R$ 119,90');
    });
  }
});