# Teste Técnico QA Júnior - Verzel Store

[![Playwright Tests](https://github.com/Romarioarg/verzel-qa-teste/actions/workflows/playwright.yml/badge.svg)](https://github.com/Romarioarg/verzel-qa-teste/actions/workflows/playwright.yml)

Validação da entrega **"Cupom de desconto e frete grátis"** (card VZS-142, versão 2.3.0) da loja fictícia Verzel Store, feita como num time de desenvolvimento real: análise da documentação, cenários de teste, execução manual e exploratória, report de bugs e automação.

## Resumo

| | |
|---|---|
| Cenários de teste (Gherkin) | 28 casos, cobrindo os 11 critérios de aceite, pela tela e pela API |
| Execuções | 29 testes: **26 passaram** e **3 falharam** |
| Testes exploratórios | 4, todos sem problemas novos |
| **Bugs encontrados** | **2** |
| Testes automatizados (Playwright) | 8 testes: 5 de interface e 3 de API, rodando no GitHub Actions a cada push |

### Bugs encontrados

| Bug | O problema | Severidade |
|---|---|---|
| [BUG-01](docs/bugs.md#bug-01) | Compra de **exatamente R$ 200,00** paga frete de R$ 19,90, mas a regra diz que o frete é grátis **a partir de** R$ 200,00 | Média |
| [BUG-02](docs/bugs.md#bug-02) | A tela limita 5 unidades por produto, mas a **API aceita e confirma pedidos com 6 ou mais** | Alta |

Os dois bugs estão na **API** (backend). No BUG-01, a interface só exibe o valor errado que a API calcula. No BUG-02, a regra existe só na interface e pode ser contornada chamando a API diretamente.

---

## Onde encontrar cada entrega

| Entrega pedida | Onde está |
|---|---|
| Cenários de teste (Gherkin) | [`docs/cenarios-cupom.feature`](docs/cenarios-cupom.feature) · [`docs/cenarios-frete.feature`](docs/cenarios-frete.feature) · [`docs/cenarios-quantidade.feature`](docs/cenarios-quantidade.feature) · [`docs/cenarios-api.feature`](docs/cenarios-api.feature) |
| Execução dos testes manuais e exploratórios, com o resultado de cada cenário | [`docs/execucao.md`](docs/execucao.md) |
| Report de todos os bugs | [`docs/bugs.md`](docs/bugs.md) |
| Evidências da execução | [`docs/execucao.md`](docs/execucao.md) (cada teste com link para sua evidência) · prints em [`evidencias/`](evidencias) · respostas da API em [`evidencias/api/`](evidencias/api) |
| Automação com Playwright | [`tests/`](tests) |
| Como rodar a automação | [seção abaixo](#como-rodar-a-automação) |

### Estrutura do repositório

```
verzel-qa-teste/
├── docs/
│   ├── cenarios-*.feature    → cenários de teste em Gherkin
│   ├── execucao.md           → resultado de cada teste, com link para a evidência
│   └── bugs.md               → report detalhado dos bugs
├── evidencias/               → prints dos testes de interface (CTxx e EXxx)
│   └── api/                  → respostas completas da API (status + corpo)
├── tests/
│   ├── helpers/carrinho.js   → funções reutilizadas pelos testes de interface
│   ├── cupom.spec.js         → CT01, CT03, CT04
│   ├── frete.spec.js         → CT08, CT07 (BUG-01)
│   └── api.spec.js           → CT17, CT19-a, CT19-b (BUG-02)
├── .github/workflows/        → execução automática dos testes no GitHub Actions
└── playwright.config.js      → configuração do Playwright
```

---

## Estratégia de testes

1. **Análise da documentação:** os 11 critérios de aceite (CA01 a CA11) foram a base. Cada um virou pelo menos um cenário. A seção "Sobre este ambiente" foi usada para não reportar como bug o que é simplificação proposital.
2. **Técnicas usadas:**
   - **Análise de valor limite** no frete (R$ 199,80 · R$ 200,00 · acima de R$ 200,00) e na quantidade (5 e 6 unidades). Foi assim que o BUG-01 apareceu.
   - **Particionamento de equivalência** nos cupons (válido, inexistente, expirado) e nos dados inválidos da API.
   - **Testes em camadas:** as regras foram testadas pela tela **e** direto na API. Foi assim que o BUG-02 apareceu, porque a tela esconde o problema.
   - **Regressão** das regras antigas da loja (nome, e-mail e CEP do cliente).
3. **Testes exploratórios** com foco em riscos fora do roteiro: o desconto chega até o pedido confirmado? O recálculo funciona ao mudar a quantidade? A regra do cupom vale na API ou só na tela?
4. **Automação** dos cenários de maior risco, cobrindo as duas novidades (cupom e frete) e as duas camadas (tela e API).

### Fora do escopo

Conforme o documento do teste: testes de carga, estresse e segurança (o ambiente é compartilhado com outros candidatos), além de login, cadastro, pagamento online e consulta de pedidos.

---

## Tecnologias

| Ferramenta | Uso |
|---|---|
| [Playwright](https://playwright.dev/) + JavaScript | Automação de testes de interface e de API |
| GitHub Actions | Execução automática dos testes a cada push |
| curl | Testes manuais da API (os comandos estão no [report de bugs](docs/bugs.md)) |
| Gherkin | Escrita dos cenários de teste |
| Google Chrome 155 | Execução manual |
| Claude (Anthropic) | Assistente de IA para ganhar agilidade (ver [Uso de IA](#uso-de-ia)) |

---

## Como rodar a automação

### Pré-requisitos

- [Node.js](https://nodejs.org/) versão 18 ou superior
- [Git](https://git-scm.com/)

### Passo a passo

1. Clonar o repositório e entrar na pasta:

```bash
git clone https://github.com/Romarioarg/verzel-qa-teste.git
cd verzel-qa-teste
```

2. Instalar as dependências:

```bash
npm ci
```

3. Instalar o navegador usado pelo Playwright:

```bash
npx playwright install chromium
```

4. Rodar todos os testes:

```bash
npx playwright test
```

5. Abrir o relatório HTML com o detalhe de cada teste:

```bash
npx playwright show-report
```

### Resultado esperado

```
8 passed
```

**Atenção:** dois testes aparecem com ✘ no terminal, mas são contados como "passed". É proposital:

- Os testes **CT07** (BUG-01) e **CT19-b** (BUG-02) verificam o comportamento **correto** da documentação e por isso **falham hoje**, por causa dos bugs.
- Eles estão marcados com `test.fail()`, que diz ao Playwright que a falha é **esperada e conhecida**. No relatório HTML, cada um aparece com uma etiqueta `bug` apontando para o report.
- **Quando um bug for corrigido**, o teste correspondente vai passar e o Playwright vai acusar isso, avisando que a marcação `test.fail()` pode ser removida.

Assim, a suíte fica verde para o que funciona, sem esconder os bugs.

### Outras formas de rodar

```bash
npx playwright test tests/api.spec.js   # só os testes de API
npx playwright test --headed            # vendo o navegador abrir
npx playwright test --ui                # modo visual interativo
```

---

## Decisões e limitações

- **Só o Chrome (Chromium)** na automação: é o mesmo navegador da execução manual, e rodar Firefox e Safari triplicaria o tempo sem ganho real para este escopo.
- **Locators acessíveis** (`getByRole`, `getByLabel`): encontram os elementos como o usuário enxerga (nome do botão, rótulo do campo), o que deixa os testes mais estáveis a mudanças de layout. Para os valores do resumo foi usado o atributo `data-valor`, que a própria loja expõe.
- **Testes independentes:** cada teste abre um navegador novo, então o carrinho sempre começa vazio e um teste não depende do outro.
- **Sem Page Objects:** com 8 testes, uma camada extra de abstração seria exagero. As funções repetidas ficam em [`tests/helpers/carrinho.js`](tests/helpers/carrinho.js).
- **Ambiguidades da documentação** e como foram interpretadas: ver a seção "Interpretações e decisões" em [`docs/execucao.md`](docs/execucao.md#interpretações-e-decisões).

---

## Uso de IA

Usei o **Claude (Anthropic)** como assistente durante todo o teste, do mesmo jeito que uso no dia a dia: para ganhar **velocidade e eficiência**, sem abrir mão de entender e validar cada passo.

**Onde a IA ajudou a acelerar:**

- Leitura da documentação e organização de um plano de trabalho para os 5 dias.
- Revisão dos cenários em Gherkin e sugestão das técnicas de teste (valor limite, particionamento).
- Montagem dos comandos curl e do código Playwright.
- Redação e formatação do report de bugs, do documento de execução e deste README.

**Como garanti que tudo está correto (a IA não decidiu sozinha):**

- **Executei pessoalmente todos os testes** na loja e na API, capturei cada evidência e conferi cada resultado contra a documentação.
- **Validei a automação na prática:** alterei de propósito um valor esperado para confirmar que o teste realmente falha quando deve, e abri o relatório para confirmar que os testes marcados com `test.fail()` falham **pelo motivo do bug**, e não por erro no próprio teste.
- **Ajustei a estratégia com base no que observei:** o CT10 foi dividido em "a" e "b" durante a execução, ao perceber que o valor de R$ 200,00 misturava o BUG-01 com a regra do CA08. A investigação do BUG-01 na API e do impacto do BUG-02 (pedido realmente criado com 6 unidades) também veio da análise dos resultados.
- **Revisei o que a IA sugeriu:** por exemplo, foi identificado que uma tabela de exemplos em Gherkin apagaria os espaços do cupom, e o teste do CA02 deixaria de testar o que dizia. O cenário foi corrigido antes da execução.

**Resultado:** a IA me deu agilidade para entregar mais (cenários de API, CI no GitHub Actions, testes exploratórios), e eu garanti a qualidade, entendendo e conseguindo explicar cada decisão deste repositório. É assim que pretendo trabalhar no time: **mais rápido, sem perder o rigor**.

---

Anderson Romario Gomes · QA · [GitHub](https://github.com/Romarioarg)