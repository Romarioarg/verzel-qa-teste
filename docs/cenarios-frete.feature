# language: pt
Funcionalidade: Frete grátis no carrinho
  Como cliente da Verzel Store
  Quero ganhar frete grátis em compras maiores
  Para pagar menos nas minhas compras

  # CA06 - Frete grátis a partir de R$ 200,00, inclusive (valor limite exato)
  Cenário: CT07 - Frete grátis com subtotal exatamente R$ 200,00
    Dado que tenho 2 "Mochila Urbana 20L" de R$ 100,00 no carrinho
    Então o subtotal deve ser R$ 200,00
    E o frete deve ser R$ 0,00
    E o total deve ser R$ 200,00

  # CA07 - Abaixo de R$ 200,00 cobra R$ 19,90 e informa quanto falta (logo abaixo do limite)
  Cenário: CT08 - Frete cobrado com subtotal R$ 199,80
    Dado que tenho 1 "Calça Jeans Slim" de R$ 139,90 no carrinho
    E tenho 1 "Camiseta Essencial" de R$ 59,90 no carrinho
    Então o subtotal deve ser R$ 199,80
    E o frete deve ser R$ 19,90
    E o carrinho deve informar que faltam R$ 0,20 para o frete grátis
    E o total deve ser R$ 219,70

  # CA06 - Frete grátis acima do limite
  Cenário: CT09 - Frete grátis com subtotal acima de R$ 200,00
    Dado que tenho 1 "Jaqueta Corta-Vento" de R$ 229,90 no carrinho
    Então o frete deve ser R$ 0,00
    E o total deve ser R$ 229,90

  # CA08 - Frete grátis considera o subtotal ANTES do desconto
  Cenário: CT10 - Manter frete grátis quando o desconto reduz o total abaixo de R$ 200,00
    Dado que tenho 2 "Mochila Urbana 20L" de R$ 100,00 no carrinho
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto deve ser R$ 20,00
    E o frete deve ser R$ 0,00
    E o total deve ser R$ 180,00

  # CA09 - O desconto do cupom não incide sobre o frete
  Cenário: CT11 - Desconto calculado somente sobre os produtos
    Dado que tenho 1 "Calça Jeans Slim" de R$ 139,90 no carrinho
    E tenho 1 "Camiseta Essencial" de R$ 59,90 no carrinho
    Quando aplico o cupom "BEMVINDO10"
    Então o desconto deve ser R$ 19,98
    E o frete deve ser R$ 19,90
    E o total deve ser R$ 199,72