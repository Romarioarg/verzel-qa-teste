# Report de Bugs

Ambiente: https://verzel-store.qa-test-verzel-store.workers.dev/ · Versão 2.3.0 (card VZS-142) · Google Chrome 155.0.8059.39 · Windows · Executado em 06/10/2026

| ID | Título | Severidade | Prioridade | Camada |
|---|---|---|---|---|
| [BUG-01](#bug-01) | Frete não é grátis quando o subtotal é exatamente R$ 200,00 | Média | Alta | API (cálculo) |
| [BUG-02](#bug-02) | API aceita e cria pedido com mais de 5 unidades do mesmo produto | Alta | Alta | API (validação) |

---

## BUG-01

**Frete não é grátis quando o subtotal é exatamente R$ 200,00**

| Campo | Valor |
|---|---|
| Critério violado | CA06 (frete grátis a partir de R$ 200,00, **inclusive**) e, por consequência, CA08 |
| Severidade | Média: o cliente paga R$ 19,90 indevidamente, mas existe contorno (adicionar mais itens) |
| Prioridade | Alta: afeta valor cobrado, contradiz a regra comunicada ao cliente e a própria tela |
| Camada | API (`POST /api/carrinho/calcular`). A interface apenas exibe o valor recebido |
| Cenários afetados | CT07, CT10-a, EX03-a |

**Pré-condições:** carrinho vazio, sem cupom.

**Passos para reproduzir (interface):**
1. Acessar a loja e adicionar 2 unidades de "Mochila Urbana 20L" (R$ 100,00 cada)
2. Abrir o carrinho

**Passos para reproduzir (API):**

```
curl -s -i -X POST https://verzel-store.qa-test-verzel-store.workers.dev/api/carrinho/calcular -H "Content-Type: application/json" -d '{"itens":[{"produtoId":"P005","quantidade":2}]}'
```

**Resultado esperado:** subtotal R$ 200,00, frete R$ 0,00 (Grátis), total R$ 200,00. Na API: `"frete":0`, `"freteGratis":true`, `"total":200`.

**Resultado atual:** subtotal R$ 200,00, frete **R$ 19,90**, total **R$ 219,90**. A tela exibe ao mesmo tempo "Faltam R$ 0,00 para o frete grátis". Na API: `"frete":19.9`, `"freteGratis":false` e `"valorFaltanteFreteGratis":0`, ou seja, a própria resposta é contraditória.

**Informações adicionais:**
- Com subtotal R$ 199,80 o frete é cobrado corretamente (CT08) e com R$ 219,80 ou R$ 229,90 o frete é grátis (CT09, CT10-b). O erro ocorre **somente no valor limite exato**.
- Com cupom aplicado (2 mochilas + BEMVINDO10), o total fica R$ 199,90 em vez de R$ 180,00 (CT10-a).
- Hipótese de causa: comparação `subtotal > 200` em vez de `subtotal >= 200`.

**Evidências:**
- Interface: [CT07](../evidencias/CT07-frete-gratis-200.png) · [CT10-a](../evidencias/CT10-a-frete-gratis-apos-desconto-200.png) · [EX03-a](../evidencias/EX03-a-recalculo-2-mochilas.png)
- API: [BUG01-api-frete-subtotal-200.txt](../evidencias/api/BUG01-api-frete-subtotal-200.txt)

---

## BUG-02

**API aceita e cria pedido com mais de 5 unidades do mesmo produto**

| Campo | Valor |
|---|---|
| Critério violado | CA10 (máximo de 5 unidades por produto, **na interface e na API**) |
| Severidade | Alta: um pedido fora da regra comercial é confirmado com sucesso |
| Prioridade | Alta: a regra existe só na interface e pode ser contornada chamando a API diretamente |
| Camada | API (`POST /api/carrinho/calcular` e `POST /api/pedidos`) |
| Cenários afetados | CT19-b |

**Pré-condições:** nenhuma (chamada direta à API).

**Passos para reproduzir:**

1. Calcular carrinho com 6 unidades:

```
curl -s -i -X POST https://verzel-store.qa-test-verzel-store.workers.dev/api/carrinho/calcular -H "Content-Type: application/json" -d '{"itens":[{"produtoId":"P006","quantidade":6}]}'
```

2. Criar pedido com 6 unidades:

```
curl -s -i -X POST https://verzel-store.qa-test-verzel-store.workers.dev/api/pedidos -H "Content-Type: application/json" -d '{"cliente":{"nome":"Maria Silva","email":"maria@exemplo.com","cep":"01310-100"},"itens":[{"produtoId":"P006","quantidade":6}]}'
```

**Resultado esperado:** status **422** com `"codigo":"QUANTIDADE_MAXIMA_EXCEDIDA"` nas duas chamadas, conforme a tabela de códigos de erro da documentação.

**Resultado atual:**
- Cálculo: status **200**, carrinho calculado com 6 unidades (subtotal 179.4).
- Pedido: status **201 Created**, pedido **VZ-103409** confirmado com 6 unidades.

**Informações adicionais:**
- Na interface a regra funciona: o botão "+" fica desabilitado e a página de produtos exibe "Limite de 5 unidades atingido." (CT12, CT13, CT14). A validação existe **somente no frontend**.
- A API valida corretamente outras regras de quantidade (zero, negativo, decimal, texto: CT21) e bloqueia item duplicado (CT22-c), o que impede contornar o limite repetindo o produto.
- O código de erro `QUANTIDADE_MAXIMA_EXCEDIDA`, previsto na documentação, nunca é retornado.

**Evidências:**
- [CT19-b-quantidade-6.txt](../evidencias/api/CT19-b-quantidade-6.txt)
- [BUG02-api-pedido-quantidade-6.txt](../evidencias/api/BUG02-api-pedido-quantidade-6.txt)
- Interface bloqueando corretamente: [CT13](../evidencias/CT13-quantidade-6-bloqueada.png) · [CT14](../evidencias/CT14-limite-ao-adicionar-novamente.png)