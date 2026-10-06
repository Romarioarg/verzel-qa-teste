# language: pt
Funcionalidade: API da Verzel Store - carrinho, pedidos e produtos
  Como integração da Verzel Store
  Quero que a API aplique as mesmas regras da interface
  Para que nenhum pedido seja calculado ou criado fora das regras

  # ---------- Produtos ----------

  Cenário: CT15 - Listar produtos
    Quando envio GET para "/api/produtos"
    Então o status deve ser 200
    E a resposta deve conter 8 produtos

  Cenário: CT16 - Consultar produto inexistente
    Quando envio GET para "/api/produtos/P999"
    Então o status deve ser 404
    E o código de erro deve ser "PRODUTO_NAO_ENCONTRADO"

  # ---------- Cálculo do carrinho ----------

  # CA01, CA06, CA09 - Exemplo da própria documentação
  Cenário: CT17 - Calcular carrinho com cupom válido e frete grátis
    Quando envio POST para "/api/carrinho/calcular" com:
      | produtoId | quantidade |
      | P002      | 1          |
      | P004      | 2          |
    E o cupom "BEMVINDO10"
    Então o status deve ser 200
    E o subtotal deve ser 239.7
    E o desconto deve ser 23.97
    E o frete deve ser 0
    E o total deve ser 215.73
    E "cupom.aplicado" deve ser true

  # CA03, CA04 - No cálculo, cupom inválido NÃO gera erro (comportamento documentado)
  Esquema do Cenário: CT18 - Calcular carrinho com cupom inválido ou expirado
    Quando envio POST para "/api/carrinho/calcular" com 1 "P005" e o cupom "<cupom>"
    Então o status deve ser 200
    E o desconto deve ser 0
    E "cupom.aplicado" deve ser false
    E "cupom.mensagem" deve informar o motivo "<motivo>"

    Exemplos:
      | cupom     | motivo          |
      | NAOEXISTE | Cupom inválido. |
      | VERAO2026 | Cupom expirado. |

  # CA10 - Limite de 5 unidades também na API (valor limite)
  Esquema do Cenário: CT19 - Validar quantidade máxima na API
    Quando envio POST para "/api/carrinho/calcular" com <quantidade> "P006"
    Então o status deve ser <status>

    Exemplos:
      | quantidade | status | observacao                         |
      | 5          | 200    | limite exato                       |
      | 6          | 422    | erro QUANTIDADE_MAXIMA_EXCEDIDA    |

  # CA11 - Arredondamento em 2 casas (3 x 29.9 em ponto flutuante = 89.69999...)
  Cenário: CT20 - Arredondar valores para 2 casas decimais
    Quando envio POST para "/api/carrinho/calcular" com 3 "P006" e o cupom "BEMVINDO10"
    Então o subtotal deve ser exatamente 89.7
    E o desconto deve ser exatamente 8.97
    E o frete deve ser 19.9
    E o total deve ser exatamente 100.63

  # Validações de entrada da API
  Esquema do Cenário: CT21 - Rejeitar quantidade inválida
    Quando envio POST para "/api/carrinho/calcular" com a quantidade <quantidade> para "P001"
    Então o status deve ser 422
    E o código de erro deve ser "QUANTIDADE_INVALIDA"

    Exemplos:
      | quantidade | observacao      |
      | 0          | zero            |
      | -1         | negativo        |
      | 1.5        | decimal         |
      | "2"        | texto           |

  Esquema do Cenário: CT22 - Rejeitar carrinho com itens inválidos
    Quando envio POST para "/api/carrinho/calcular" com <situacao>
    Então o status deve ser 422
    E o código de erro deve ser "<codigo>"

    Exemplos:
      | situacao                          | codigo                 |
      | lista de itens vazia              | ITENS_OBRIGATORIOS     |
      | produto inexistente "P999"        | PRODUTO_NAO_ENCONTRADO |
      | o mesmo produto duas vezes        | ITEM_DUPLICADO         |

  Cenário: CT23 - Rejeitar corpo que não é JSON válido
    Quando envio POST para "/api/carrinho/calcular" com o corpo "isso não é json"
    Então o status deve ser 400
    E o código de erro deve ser "JSON_INVALIDO"

  # ---------- Pedidos ----------

  # Exemplo da própria documentação
  Cenário: CT24 - Criar pedido válido com cupom
    Quando envio POST para "/api/pedidos" com cliente válido, 1 "P005" e o cupom "BEMVINDO10"
    Então o status deve ser 201
    E o número do pedido deve seguir o formato "VZ-000000"
    E o total deve ser 109.9

  # CA03, CA04 - No pedido, cupom inválido GERA erro (comportamento documentado)
  Esquema do Cenário: CT25 - Rejeitar pedido com cupom inválido ou expirado
    Quando envio POST para "/api/pedidos" com cliente válido, 1 "P005" e o cupom "<cupom>"
    Então o status deve ser 422
    E o código de erro deve ser "<codigo>"

    Exemplos:
      | cupom     | codigo         |
      | NAOEXISTE | CUPOM_INVALIDO |
      | VERAO2026 | CUPOM_EXPIRADO |

  # Regressão - regras do cliente que já existiam antes da entrega
  Esquema do Cenário: CT26 - Rejeitar pedido com dados do cliente inválidos
    Quando envio POST para "/api/pedidos" com o campo "<campo>" igual a <valor>
    Então o status deve ser 422
    E o código de erro deve ser "DADOS_INVALIDOS"

    Exemplos:
      | campo | valor             | observacao           |
      | nome  | "Maria"           | sem sobrenome        |
      | email | "maria.exemplo"   | sem @                |
      | cep   | "0131010"         | 7 dígitos            |
      | cep   | "013101000"       | 9 dígitos            |

  Esquema do Cenário: CT27 - Aceitar CEP com e sem hífen
    Quando envio POST para "/api/pedidos" com cliente válido e o CEP <cep>
    Então o status deve ser 201

    Exemplos:
      | cep         |
      | "01310-100" |
      | "01310100"  |

  Cenário: CT28 - Rejeitar método HTTP não permitido
    Quando envio GET para "/api/pedidos"
    Então o status deve ser 405
    E o código de erro deve ser "METODO_NAO_PERMITIDO"