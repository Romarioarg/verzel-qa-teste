// @ts-check
import { expect } from '@playwright/test';

/** @typedef {import('@playwright/test').Page} Page */

/**
 * Adiciona um produto ao carrinho pela vitrine, quantas vezes for pedido.
 * Cada teste usa um navegador novo, então o carrinho sempre começa vazio.
 * @param {Page} page
 * @param {string} nomeDoProduto nome exatamente como aparece na vitrine
 * @param {number} [quantidade=1]
 */
export async function adicionarAoCarrinho(page, nomeDoProduto, quantidade = 1) {
  await page.goto('/');
  const botao = page
    .getByRole('article', { name: nomeDoProduto })
    .getByRole('button', { name: 'Adicionar ao carrinho' });

  for (let i = 0; i < quantidade; i++) {
    await botao.click();
  }
}

/**
 * Abre a página do carrinho pelo link do topo.
 * @param {Page} page
 */
export async function abrirCarrinho(page) {
  await page.getByRole('link', { name: /^Carrinho/ }).click();
  await expect(page.getByRole('heading', { name: 'Carrinho', level: 1 })).toBeVisible();
}

/**
 * Digita e aplica um cupom no carrinho.
 * @param {Page} page
 * @param {string} cupom
 */
export async function aplicarCupom(page, cupom) {
  await page.getByLabel('Cupom de desconto').fill(cupom);
  await page.getByRole('button', { name: 'Aplicar cupom' }).click();
}

/**
 * Valor do "Resumo do pedido".
 * @param {Page} page
 * @param {'subtotal' | 'desconto' | 'frete' | 'total'} campo
 */
export function valorDoResumo(page, campo) {
  return page.locator(`[data-valor="${campo}"]`);
}