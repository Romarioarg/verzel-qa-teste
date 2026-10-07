// @ts-check
import { test, expect } from '@playwright/test';

// Os endereços usam o baseURL do playwright.config.js
const CALCULAR = '/api/carrinho/calcular';

test.describe('API - cálculo do carrinho', () => {
  test('CT17 - calcula subtotal, desconto, frete e total com cupom válido (CA01, CA06, CA09)', async ({ request }) => {
    // Exemplo da própria documentação: 1 Calça (P002) + 2 Bonés (P004) com BEMVINDO10
    const resposta = await request.post(CALCULAR, {
      data: {
        itens: [
          { produtoId: 'P002', quantidade: 1 },
          { produtoId: 'P004', quantidade: 2 },
        ],
        cupom: 'BEMVINDO10',
      },
    });

    expect(resposta.status()).toBe(200);
    const corpo = await resposta.json();

    expect(corpo).toMatchObject({
      subtotal: 239.7,
      desconto: 23.97,
      frete: 0,
      freteGratis: true,
      total: 215.73,
      cupom: { codigo: 'BEMVINDO10', aplicado: true },
    });
  });

  test('CT19-a - aceita a quantidade máxima de 5 unidades (CA10)', async ({ request }) => {
    const resposta = await request.post(CALCULAR, {
      data: { itens: [{ produtoId: 'P006', quantidade: 5 }] },
    });

    expect(resposta.status()).toBe(200);
    const corpo = await resposta.json();
    expect(corpo.subtotal).toBe(149.5);
  });

  test(
    'CT19-b - recusa 6 unidades do mesmo produto com QUANTIDADE_MAXIMA_EXCEDIDA (CA10)',
    {
      annotation: {
        type: 'bug',
        description: 'BUG-02: a API aceita e cria pedidos com mais de 5 unidades. Ver docs/bugs.md',
      },
    },
    async ({ request }) => {
      // Falha esperada enquanto o BUG-02 não for corrigido.
      test.fail();

      const resposta = await request.post(CALCULAR, {
        data: { itens: [{ produtoId: 'P006', quantidade: 6 }] },
      });

      expect(resposta.status()).toBe(422);
      const corpo = await resposta.json();
      expect(corpo.erro.codigo).toBe('QUANTIDADE_MAXIMA_EXCEDIDA');
    }
  );
});