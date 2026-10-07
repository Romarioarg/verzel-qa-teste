# Execução dos Testes

> **Resumo em 30 segundos**
>
> Foram testadas as duas novidades da Verzel Store: **cupom de desconto** e **frete grátis**, pela tela da loja e pela API (o "motor" que faz as contas por trás da tela).
>
> - **29 testes** executados: **26 passaram** e **3 falharam**
> - **4 testes exploratórios** (fora do roteiro): todos sem problemas
> - **2 bugs encontrados**: o frete grátis falha com compra de exatamente R$ 200,00, e a API aceita pedidos acima do limite de 5 unidades
>
> Detalhes de cada bug: [bugs.md](bugs.md)

---

## Como ler este documento

| Termo | O que significa |
|---|---|
| **CT** | Caso de Teste. Cada teste tem um número (CT01, CT02...) que também aparece nos arquivos de [cenários](.) |
| **CA** | Critério de Aceite. É a regra da documentação que o teste está verificando |
| **EX** | Teste exploratório: situações que a documentação não previa, testadas por iniciativa própria |
| ✅ | O sistema fez exatamente o que a regra pede |
| ❌ | O sistema fez algo diferente da regra (bug) |
| **Evidência** | Link para o print da tela ou para a resposta da API que prova o resultado |

---

## Ambiente

| Item | Valor |
|---|---|
| Loja | https://verzel-store.qa-test-verzel-store.workers.dev/ |
| Versão testada | 2.3.0 (card VZS-142) |
| Navegador | Google Chrome 155.0.8059.39 |
| Sistema operacional | Windows |
| Ferramenta para testar a API | curl (pelo terminal Git Bash) |
| Data | 06/10/2026 |
| Responsável | Anderson Romario Gomes |

---

## Resultado geral

| Assunto | Testes | ✅ Passou | ❌ Falhou |
|---|---|---|---|
| 1. Cupom de desconto (tela) | 6 | 6 | 0 |
| 2. Frete grátis (tela) | 6 | 4 | 2 |
| 3. Limite de quantidade (tela) | 3 | 3 | 0 |
| 4. API | 14 | 13 | 1 |
| **Total** | **29** | **26** | **3** |
| 5. Exploratórios | 4 | 4 | 0 |

### Bugs encontrados

| Bug | O problema, em uma frase | Testes que falharam |
|---|---|---|
| [BUG-01](bugs.md#bug-01) | Quem compra **exatamente R$ 200,00** paga frete, mas a regra diz que a partir de R$ 200,00 o frete é grátis | CT07, CT10-a |
| [BUG-02](bugs.md#bug-02) | A tela limita 5 unidades por produto, mas a API **aceita e confirma pedidos com 6 ou mais** | CT19 |

---

## 1. Cupom de desconto (tela)

Todos os testes usam 1 Mochila Urbana 20L (R$ 100,00). Sem desconto, o total é R$ 119,90 (R$ 100,00 + R$ 19,90 de frete).

| CT | O que foi testado | O que deveria acontecer | O que aconteceu | Resultado | Evidência |
|---|---|---|---|---|---|
| CT01 | Aplicar o cupom BEMVINDO10 | Desconto de R$ 10,00 (10%) e total R$ 109,90 | Igual ao esperado | ✅ | [print](../evidencias/CT01-cupom-valido.png) |
| CT02 | Digitar o cupom de jeitos diferentes: tudo minúsculo, maiúsculas misturadas e com espaços antes e depois | O cupom funciona em todos os casos | Funcionou nos três | ✅ | minúsculo: [digitado](../evidencias/CT02-a-minusculo-digitado.png) / [aplicado](../evidencias/CT02-a-minusculo.png) · misturado: [digitado](../evidencias/CT02-b-misturado-digitado.png) / [aplicado](../evidencias/CT02-b-misturado.png) · espaços: [digitado](../evidencias/CT02-c-espacos-digitado.png) / [aplicado](../evidencias/CT02-c-espacos.png) |
| CT03 | Digitar um cupom que não existe (NAOEXISTE) | Mensagem "Cupom inválido." e nenhum desconto | Igual ao esperado | ✅ | [print](../evidencias/CT03-cupom-inexistente.png) |
| CT04 | Digitar um cupom vencido (VERAO2026) | Mensagem "Cupom expirado." e nenhum desconto | Igual ao esperado | ✅ | [print](../evidencias/CT04-cupom-expirado.png) |
| CT05 | Tentar usar um segundo cupom com um já aplicado | Não permitir dois cupons ao mesmo tempo | O campo de cupom some depois de aplicar o primeiro | ✅ | [print](../evidencias/CT05-segundo-cupom-bloqueado.png) |
| CT06 | Remover o cupom aplicado | Desconto volta a zero e o campo de cupom reaparece | Igual ao esperado | ✅ | [print](../evidencias/CT06-cupom-removido.png) |

---

## 2. Frete grátis (tela)

A regra: compras **a partir de R$ 200,00** têm frete grátis. Abaixo disso, o frete custa R$ 19,90. Os valores foram escolhidos **em cima, logo abaixo e acima** de R$ 200,00, porque é na fronteira que os erros costumam aparecer.

| CT | O que foi testado | O que deveria acontecer | O que aconteceu | Resultado | Evidência |
|---|---|---|---|---|---|
| CT07 | Compra de **exatamente R$ 200,00** (2 mochilas) | Frete grátis, total R$ 200,00 | Cobrou frete de R$ 19,90 (total R$ 219,90) e ainda mostrou "Faltam R$ 0,00 para o frete grátis" | ❌ | [print](../evidencias/CT07-frete-gratis-200.png) · [BUG-01](bugs.md#bug-01) |
| CT08 | Compra de R$ 199,80 (calça + camiseta), **logo abaixo** do limite | Frete R$ 19,90 e aviso "Faltam R$ 0,20" | Igual ao esperado | ✅ | [print](../evidencias/CT08-frete-cobrado-199-80.png) |
| CT09 | Compra de R$ 229,90 (jaqueta), **acima** do limite | Frete grátis | Igual ao esperado | ✅ | [print](../evidencias/CT09-frete-gratis-acima-200.png) |
| CT10-a | Compra de exatamente R$ 200,00 **com cupom** (total cai para R$ 180,00) | Frete continua grátis, porque a regra olha o valor **antes** do desconto | Cobrou frete (total R$ 199,90). Mesmo problema do CT07 | ❌ | [print](../evidencias/CT10-a-frete-gratis-apos-desconto-200.png) · [BUG-01](bugs.md#bug-01) |
| CT10-b | Compra de R$ 219,80 **com cupom** (total cai para R$ 197,82) | Frete continua grátis | Igual ao esperado | ✅ | [print](../evidencias/CT10-b-frete-gratis-apos-desconto-219-80.png) |
| CT11 | Cupom numa compra de R$ 199,80 que paga frete | Desconto só sobre os produtos (R$ 19,98), sem mexer no frete | Igual ao esperado (total R$ 199,72) | ✅ | [print](../evidencias/CT11-desconto-sem-frete.png) |

---

## 3. Limite de quantidade (tela)

A regra: no máximo **5 unidades** de cada produto por pedido. Produto usado: Kit 3 Pares de Meias (R$ 29,90).

| CT | O que foi testado | O que deveria acontecer | O que aconteceu | Resultado | Evidência |
|---|---|---|---|---|---|
| CT12 | Colocar 5 unidades no carrinho | Aceitar, subtotal R$ 149,50 | Aceitou e mostrou o aviso "Limite de 5 unidades por produto." | ✅ | [print](../evidencias/CT12-quantidade-maxima-5.png) |
| CT13 | Tentar passar para 6 no botão "+" do carrinho | Não permitir | O botão fica desativado; clicando várias vezes, continua 5 | ✅ | [print](../evidencias/CT13-quantidade-6-bloqueada.png) |
| CT14 | Com 5 no carrinho, tentar adicionar de novo pela página de produtos | Não permitir | Botão desativado com a mensagem "Limite de 5 unidades atingido." | ✅ | [print](../evidencias/CT14-limite-ao-adicionar-novamente.png) |

---

## 4. API

A **API** é a parte do sistema que faz as contas e registra os pedidos. A tela da loja só pergunta para ela e mostra a resposta. Testar a API diretamente garante que as regras valem **mesmo para quem não usa a tela**.

Cada resposta tem um **código de status**: **200** = deu certo · **201** = pedido criado · **400 / 404 / 405 / 422** = a API recusou, cada um por um motivo previsto na documentação.

### Consulta de produtos

| CT | O que foi testado | O que deveria acontecer | O que aconteceu | Resultado | Evidência |
|---|---|---|---|---|---|
| CT15 | Pedir a lista de produtos | Status 200 com os 8 produtos e preços da documentação | Igual ao esperado | ✅ | [resposta](../evidencias/api/CT15-listar-produtos.txt) |
| CT16 | Pedir um produto que não existe (P999) | Status 404, erro PRODUTO_NAO_ENCONTRADO | Igual ao esperado | ✅ | [resposta](../evidencias/api/CT16-produto-inexistente.txt) |

### Cálculo do carrinho

| CT | O que foi testado | O que deveria acontecer | O que aconteceu | Resultado | Evidência |
|---|---|---|---|---|---|
| CT17 | Calcular calça + 2 bonés com cupom (exemplo da documentação) | Subtotal 239,70, desconto 23,97, frete grátis, total 215,73 | Igual ao esperado | ✅ | [resposta](../evidencias/api/CT17-calcular-cupom-valido.txt) |
| CT18 | Calcular com cupom inexistente e com cupom vencido | Status 200, sem desconto, com o motivo na mensagem (aqui não é erro, é só aviso) | Igual ao esperado nos dois | ✅ | [inexistente](../evidencias/api/CT18-a-calcular-cupom-inexistente.txt) · [vencido](../evidencias/api/CT18-b-calcular-cupom-expirado.txt) |
| CT19 | Calcular com 5 unidades e com 6 unidades | 5 aceito; 6 recusado com erro QUANTIDADE_MAXIMA_EXCEDIDA | 5 aceito, mas **6 também foi aceito**. Também foi possível **criar um pedido** com 6 | ❌ | [5 unidades](../evidencias/api/CT19-a-quantidade-5.txt) · [6 unidades](../evidencias/api/CT19-b-quantidade-6.txt) · [pedido com 6](../evidencias/api/BUG02-api-pedido-quantidade-6.txt) · [BUG-02](bugs.md#bug-02) |
| CT20 | Conta que costuma gerar "dízimas" no computador (3 × 29,90 com cupom) | Todos os valores com no máximo 2 casas decimais | Igual ao esperado (89,7 · 8,97 · 100,63) | ✅ | [resposta](../evidencias/api/CT20-arredondamento.txt) |
| CT21 | Quantidade zero, negativa, decimal (1,5) e em texto ("2") | Recusar todas com erro QUANTIDADE_INVALIDA | Recusou as quatro | ✅ | [zero](../evidencias/api/CT21-a-quantidade-zero.txt) · [negativa](../evidencias/api/CT21-b-quantidade-negativa.txt) · [decimal](../evidencias/api/CT21-c-quantidade-decimal.txt) · [texto](../evidencias/api/CT21-d-quantidade-texto.txt) |
| CT22 | Carrinho vazio, produto inexistente e o mesmo produto repetido | Recusar cada um com seu erro próprio | Recusou os três com o erro certo | ✅ | [vazio](../evidencias/api/CT22-a-itens-vazios.txt) · [inexistente](../evidencias/api/CT22-b-produto-inexistente.txt) · [repetido](../evidencias/api/CT22-c-item-duplicado.txt) |
| CT23 | Mandar um texto qualquer em vez de dados no formato JSON | Status 400, erro JSON_INVALIDO, sem travar o sistema | Igual ao esperado | ✅ | [resposta](../evidencias/api/CT23-json-invalido.txt) |

Prova complementar do BUG-01 pela API (2 mochilas = R$ 200,00 cobrando frete): [resposta](../evidencias/api/BUG01-api-frete-subtotal-200.txt)

### Pedidos

| CT | O que foi testado | O que deveria acontecer | O que aconteceu | Resultado | Evidência |
|---|---|---|---|---|---|
| CT24 | Criar pedido válido com cupom | Status 201, número no formato VZ-000000 e total 109,90 | Igual ao esperado (pedido VZ-482106) | ✅ | [resposta](../evidencias/api/CT24-pedido-valido-com-cupom.txt) |
| CT25 | Criar pedido com cupom inexistente e com cupom vencido | Recusar (status 422). Diferente do cálculo, aqui o cupom errado **é** erro | Recusou os dois com o erro certo | ✅ | [inexistente](../evidencias/api/CT25-a-pedido-cupom-inexistente.txt) · [vencido](../evidencias/api/CT25-b-pedido-cupom-expirado.txt) |
| CT26 | Nome sem sobrenome, e-mail sem @, CEP com 7 e com 9 dígitos (regras que já existiam antes) | Recusar cada um, apontando o campo errado | Recusou os quatro e indicou o campo | ✅ | [nome](../evidencias/api/CT26-a-nome-sem-sobrenome.txt) · [e-mail](../evidencias/api/CT26-b-email-invalido.txt) · [CEP 7](../evidencias/api/CT26-c-cep-7-digitos.txt) · [CEP 9](../evidencias/api/CT26-d-cep-9-digitos.txt) |
| CT27 | CEP com hífen (01310-100) e sem hífen (01310100) | Aceitar os dois | Aceitou os dois | ✅ | [com hífen](../evidencias/api/CT27-a-cep-com-hifen.txt) · [sem hífen](../evidencias/api/CT27-b-cep-sem-hifen.txt) |
| CT28 | Usar um tipo de chamada não permitido (GET em vez de POST) | Status 405, erro METODO_NAO_PERMITIDO | Igual ao esperado | ✅ | [resposta](../evidencias/api/CT28-metodo-nao-permitido.txt) |

---

## 5. Testes exploratórios

Testes feitos **fora do roteiro**, imaginando como um cliente real usaria a loja, para achar problemas que a documentação não previa.

| EX | Pergunta investigada | O que aconteceu | Resultado | Evidência |
|---|---|---|---|---|
| EX01 | O desconto visto no carrinho **chega até o pedido confirmado**? | Sim. Pedido confirmado com o mesmo desconto e valores, número no formato certo e carrinho esvaziado depois | ✅ | [print](../evidencias/EX01-pedido-confirmado.png) |
| EX02 | A tela de finalizar compra **avisa** quando nome, e-mail ou CEP estão errados? | Sim. Mostra uma mensagem clara embaixo de cada campo e não cria o pedido | ✅ | [print](../evidencias/EX02-validacao-formulario.png) |
| EX03 | Se o cliente **muda a quantidade depois de aplicar o cupom**, desconto e frete se atualizam? | Sim, recalcula na hora. Com 2 mochilas (R$ 200,00) o BUG-01 aparece de novo; com 3, o frete fica grátis | ✅ | [2 mochilas](../evidencias/EX03-a-recalculo-2-mochilas.png) · [3 mochilas](../evidencias/EX03-b-recalculo-3-mochilas.png) |
| EX04 | Quem corrige o cupom digitado em minúsculo e com espaços: a tela ou a API? | A API. Ela aceita "  bemvindo10  " e devolve "BEMVINDO10", então a regra vale mesmo sem a tela | ✅ | [resposta](../evidencias/api/EX04-api-cupom-minusculo-com-espacos.txt) |

---

## Interpretações e decisões

Pontos em que a documentação não era totalmente clara, e como foram tratados:

- **CT05 (segundo cupom):** a documentação não diz *como* a tela deve impedir dois cupons. Observado: depois de aplicar um cupom, o campo some e só aparece "Remover cupom". Isso foi considerado correto.
- **CT10 dividido em "a" e "b":** o teste original usava exatamente R$ 200,00, que é o valor do BUG-01. Assim não daria para saber se a regra do CA08 funciona. Por isso foi criado o CT10-b, com R$ 219,80. Resultado: a regra do CA08 **funciona**; a falha do CT10-a vem do BUG-01.
- **CT02 (espaços):** espaços em branco quase não aparecem em print. O recuo do texto no campo mostra os espaços iniciais, e o EX04 confirma pela API que os espaços são ignorados.
- **CT13 (botão "+"):** o botão parece desativado ao chegar em 5, mas foi clicado várias vezes para confirmar que o bloqueio é real, e não só visual.