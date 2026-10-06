# language: pt
Funcionalidade: Cupom de desconto no carrinho
  Como cliente da Verzel Store
  Quero aplicar um cupom de desconto
  Para pagar menos nas minhas compras

  Contexto:
    Dado que tenho 1 "Mochila Urbana 20L" de R$ 100,00 no carrinho

  # CA01 - BEMVINDO10 aplica 10% de desconto sobre o subtotal
  Cenário: CT01 - Aplicar cupom válido
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto deve ser R$ 10,00
    E o total deve ser R$ 109,90

  # CA02 - Cupom não diferencia maiúsculas/minúsculas e ignora espaços nas pontas
  Esquema do Cenário: CT02 - Aplicar cupom com variações de escrita
    Quando aplico o cupom <cupom>
    Então o desconto deve ser R$ 10,00

    Exemplos:
      | variacao              | cupom            |
      | tudo minúsculo        | "bemvindo10"     |
      | maiúsculas misturadas | "BemVindo10"     |
      | espaços nas pontas    | "  BEMVINDO10  " |

  # CA03 - Cupom inexistente exibe mensagem e não aplica desconto
  Cenário: CT03 - Aplicar cupom inexistente
    Quando aplico o cupom "NAOEXISTE"
    Então devo ver a mensagem "Cupom inválido."
    E o desconto deve ser R$ 0,00
    E o total deve ser R$ 119,90

  # CA04 - Cupom fora da validade exibe mensagem e não aplica desconto
  Cenário: CT04 - Aplicar cupom expirado
    Quando aplico o cupom "VERAO2026"
    Então devo ver a mensagem "Cupom expirado."
    E o desconto deve ser R$ 0,00
    E o total deve ser R$ 119,90

  # CA05 - Apenas um cupom por vez
  Cenário: CT05 - Impedir aplicação de um segundo cupom
    Dado que o cupom "BEMVINDO10" já está aplicado
    Quando tento aplicar o cupom "VERAO2026"
    Então o sistema não deve aplicar um segundo cupom
    E o desconto deve continuar R$ 10,00

  # CA05 - Para trocar, o cliente remove o cupom atual
  Cenário: CT06 - Remover cupom aplicado
    Dado que o cupom "BEMVINDO10" já está aplicado
    Quando removo o cupom
    Então o desconto deve ser R$ 0,00
    E o total deve ser R$ 119,90
    E devo conseguir aplicar um novo cupom