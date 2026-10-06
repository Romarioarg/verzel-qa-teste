# language: pt
Funcionalidade: Quantidade máxima por produto no carrinho
  Como Verzel Store
  Quero limitar a quantidade de cada produto por pedido
  Para cumprir a regra comercial de no máximo 5 unidades

  # CA10 - Máximo de 5 unidades por produto (valor limite exato)
  Cenário: CT12 - Adicionar a quantidade máxima permitida
    Dado que tenho 1 "Kit 3 Pares de Meias" de R$ 29,90 no carrinho
    Quando aumento a quantidade para 5
    Então a quantidade deve ser 5
    E o subtotal deve ser R$ 149,50

  # CA10 - Logo acima do limite
  Cenário: CT13 - Impedir quantidade acima do máximo
    Dado que tenho 5 "Kit 3 Pares de Meias" de R$ 29,90 no carrinho
    Quando tento aumentar a quantidade para 6
    Então o sistema não deve permitir a alteração
    E a quantidade deve continuar 5
    E o subtotal deve continuar R$ 149,50

  # CA10 - Caso de borda: adicionar novamente o mesmo produto pela página da loja
  Cenário: CT14 - Impedir ultrapassar o máximo ao adicionar o mesmo produto novamente
    Dado que tenho 5 "Kit 3 Pares de Meias" de R$ 29,90 no carrinho
    Quando clico em adicionar ao carrinho o "Kit 3 Pares de Meias" novamente
    Então a quantidade no carrinho deve continuar 5