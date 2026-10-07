// @ts-check
import { test, expect } from '@playwright/test';
import { adicionarAoCarrinho, abrirCarrinho, valorDoResumo } from './helpers/carrinho.js';

test.describe('Frete grátis', () => {
  test('CT08 - cobra frete de R$ 19,90 e informa quanto falta com subtotal de R$ 199,80 (CA07)', async ({ page }) => {
    // Valor logo abaixo do limite de R$ 200,00
    await adicionarAoCarrinho(page, 'Calça Jeans Slim'); // R$ 139,90
    await adicionarAoCarrinho(page, 'Camiseta Essencial'); // R$ 59,90
    await abrirCarrinho(page);

    await expect(valorDoResumo(page, 'subtotal')).toHaveText('R$ 199,80');
    await expect(valorDoResumo(page, 'frete')).toHaveText('R$ 19,90');
    await expect(page.locator('.aviso-frete')).toHaveText('Faltam R$ 0,20 para o frete grátis.');
    await expect(valorDoResumo(page, 'total')).toHaveText('R$ 219,70');
  });

  test(
    'CT07 - concede frete grátis com subtotal de exatamente R$ 200,00 (CA06)',
    {
      annotation: {
        type: 'bug',
        description: 'BUG-01: com subtotal exatamente R$ 200,00 o frete de R$ 19,90 é cobrado. Ver docs/bugs.md',
      },
    },
    async ({ page }) => {
      // Falha esperada enquanto o BUG-01 não for corrigido.
      // Quando o bug for corrigido, este teste passará e o Playwright avisará para remover o test.fail().
      test.fail();

      // Valor exatamente no limite: 2 x Mochila Urbana 20L (R$ 100,00)
      await adicionarAoCarrinho(page, 'Mochila Urbana 20L', 2);
      await abrirCarrinho(page);

      await expect(valorDoResumo(page, 'subtotal')).toHaveText('R$ 200,00');
      await expect(valorDoResumo(page, 'frete')).toHaveText('Grátis');
      await expect(valorDoResumo(page, 'total')).toHaveText('R$ 200,00');
    }
  );
});