# Execução dos Testes

## Ambiente

| Item | Valor |
|---|---|
| Loja | https://verzel-store.qa-test-verzel-store.workers.dev/ |
| Versão da entrega | 2.3.0 (card VZS-142) |
| Navegador | Google Chrome (versão: preencher) |
| Sistema operacional | Windows |
| Data da execução | preencher |
| Executado por | Anderson Romario Gomes |

## Legenda

✅ Passou | ❌ Falhou | ⏳ Não executado

## Resultados - Interface

| CT | Cenário | CA | Resultado | Evidência | Bug |
|---|---|---|---|---|---|
| CT01 | Aplicar cupom válido | CA01 | ⏳ | | |
| CT02 | Cupom com variações de escrita | CA02 | ⏳ | | |
| CT03 | Cupom inexistente | CA03 | ⏳ | | |
| CT04 | Cupom expirado | CA04 | ⏳ | | |
| CT05 | Impedir segundo cupom | CA05 | ⏳ | | |
| CT06 | Remover cupom aplicado | CA05 | ⏳ | | |
| CT07 | Frete grátis com subtotal R$ 200,00 | CA06 | ⏳ | | |
| CT08 | Frete cobrado com subtotal R$ 199,80 | CA07 | ⏳ | | |
| CT09 | Frete grátis acima de R$ 200,00 | CA06 | ⏳ | | |
| CT10 | Frete grátis mantido após desconto | CA08 | ⏳ | | |
| CT11 | Desconto somente sobre os produtos | CA09 | ⏳ | | |
| CT12 | Quantidade máxima permitida (5) | CA10 | ⏳ | | |
| CT13 | Impedir quantidade 6 | CA10 | ⏳ | | |
| CT14 | Impedir ultrapassar 5 ao adicionar novamente | CA10 | ⏳ | | |

## Resultados - API

| CT | Cenário | CA | Resultado | Evidência | Bug |
|---|---|---|---|---|---|
| CT15 | Listar produtos | - | ⏳ | | |
| CT16 | Consultar produto inexistente | - | ⏳ | | |
| CT17 | Calcular com cupom válido e frete grátis | CA01, CA06, CA09 | ⏳ | | |
| CT18 | Calcular com cupom inválido/expirado | CA03, CA04 | ⏳ | | |
| CT19 | Quantidade máxima na API | CA10 | ⏳ | | |
| CT20 | Arredondamento em 2 casas | CA11 | ⏳ | | |
| CT21 | Rejeitar quantidade inválida | - | ⏳ | | |
| CT22 | Rejeitar itens inválidos | - | ⏳ | | |
| CT23 | Rejeitar JSON inválido | - | ⏳ | | |
| CT24 | Criar pedido válido com cupom | CA01 | ⏳ | | |
| CT25 | Rejeitar pedido com cupom inválido/expirado | CA03, CA04 | ⏳ | | |
| CT26 | Rejeitar dados do cliente inválidos | Regressão | ⏳ | | |
| CT27 | Aceitar CEP com e sem hífen | Regressão | ⏳ | | |
| CT28 | Rejeitar método HTTP não permitido | - | ⏳ | | |

## Testes exploratórios

(preenchido durante a execução)