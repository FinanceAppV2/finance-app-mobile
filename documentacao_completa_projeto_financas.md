# Projeto de Finanças — Documentação Consolidada da Conversa

> **Documento de consolidação do produto, regras de negócio, UX/UI, arquitetura conceitual e plano de implementação definidos até o momento.**
>
> **Data de consolidação:** 14/09/2026  
> **Status atual:** transição da definição do produto para a inspeção técnica e implementação.

---

# 1. Visão geral do projeto

O projeto consiste em uma aplicação de finanças pessoais cujo objetivo principal é ajudar o usuário a:

- registrar despesas;
- entender quanto dinheiro está comprometido;
- prever sua capacidade de gasto com base no salário;
- controlar dinheiro disponível em caixa;
- separar claramente dinheiro já disponível de compromissos que dependem de renda futura;
- acompanhar investimentos;
- acompanhar empréstimos e obrigações;
- visualizar relatórios;
- receber interpretações e feedback inteligente por IA;
- tomar melhores decisões financeiras sem que a aplicação execute ações financeiras automaticamente.

A aplicação foi inicialmente pensada com foco em pessoas de baixa e média renda, para as quais o controle do dinheiro disponível e dos compromissos futuros é particularmente importante.

A proposta central evoluiu para uma distinção explícita entre dois universos financeiros:

1. **Pós-pago**
2. **Pré-pago**

Essa separação tornou-se uma das decisões arquiteturais e de negócio mais importantes do projeto.

---

# 2. Objetivo do produto

O produto não deve ser apenas um aplicativo de lançamento de despesas.

A proposta é funcionar como uma ferramenta de **consciência financeira**, permitindo que o usuário responda rapidamente:

> **“Como estou financeiramente?”**

E, em seguida:

> **“Quanto posso gastar?”**

A aplicação deve mostrar de forma simples:

- quanto o usuário possui em dinheiro disponível;
- quanto já gastou;
- quanto está comprometido;
- quanto ainda pode gastar;
- se sua meta de economia está ameaçada;
- se seu salário já está comprometido;
- se o caixa disponível está próximo do fim;
- quais são seus investimentos e suas projeções;
- quais padrões financeiros merecem atenção.

A aplicação deve evitar transformar a experiência principal em uma planilha complexa.

---

# 3. Princípio central: Pós-pago x Pré-pago

Foi definido que existem dois modelos financeiros independentes.

## 3.1 Pós-pago

Representa gastos que dependem de renda futura, especialmente gastos feitos no cartão de crédito e outros compromissos que serão pagos posteriormente.

O Pós-pago trabalha principalmente com:

- salário;
- ciclo financeiro;
- despesas futuras;
- parcelamentos;
- compromissos;
- limite de gasto;
- meta de economia;
- fundo de emergência.

O Pós-pago responde:

> “Quanto do meu salário futuro já está comprometido?”

---

## 3.2 Pré-pago

Representa dinheiro que o usuário já possui disponível.

Exemplos:

- dinheiro em espécie;
- saldo disponível;
- dinheiro usado via Pix;
- dinheiro usado via débito;
- outras despesas que efetivamente consomem o caixa disponível.

O Pré-pago responde:

> “Quanto dinheiro eu tenho disponível agora?”

---

## 3.3 Independência entre os dois

As duas configurações são independentes.

Não existe transferência automática:

- Pós-pago → Pré-pago;
- Pré-pago → Pós-pago;
- salário → caixa;
- investimento → caixa;
- empréstimo → caixa.

Qualquer alteração no caixa precisa resultar de uma ação explícita do usuário.

Os relatórios podem futuramente analisar os dois universos em conjunto, mas os cálculos financeiros internos não devem misturar os dois modelos.

---

# 4. Modelo financeiro Pós-pago

## 4.1 Renda considerada

No Pós-pago, somente o **salário** é considerado como renda principal.

Não existe, inicialmente, suporte a renda variável automática.

O usuário informa:

- valor do salário;
- dia de recebimento do salário;
- dia de pagamento/quitação das despesas.

O dia de pagamento das despesas define o ciclo financeiro.

---

## 4.2 Ciclo financeiro

O ciclo não segue necessariamente o mês do calendário.

Ele é ancorado no **dia de pagamento das despesas** (`paymentDay`), não no dia do salário.

O usuário recebe o salário primeiro e se organiza para quitar todas as despesas no dia de pagamento.

O ciclo que fecha no mês M vai do dia seguinte ao pagamento do mês anterior até o dia de pagamento do mês M (o próprio dia de pagamento fecha o ciclo, ou seja, pertence ao ciclo que está sendo quitado).

### Exemplo

Se o usuário define o dia de pagamento das despesas como dia 25:

- ciclo de setembro: 26/08 → 25/09 (inclusive);
- ciclo de outubro: 26/09 → 25/10 (inclusive);
- ciclo de novembro: 26/10 → 25/11 (inclusive).

Portanto, uma despesa de 25/09 pertence ao ciclo de setembro (quitada em 25/09).

Uma despesa de 26/09 pertence ao novo ciclo (outubro).

O dia do salário (`salaryDay`) informa quando a renda entra, mas não define a fronteira do ciclo. Ex.: salário dia 20 e pagamento dia 25 → os dias 20 a 25 são usados para quitar as despesas do ciclo que fecha no dia 25.

Essa regra deve ser respeitada pelo mecanismo de cálculo e pelos relatórios relacionados ao Pós-pago.

---

## 4.3 Configurações do Pós-pago

A configuração conceitual possui:

- `monthlyIncome`
- dia de recebimento do salário;
- dia de pagamento/quitação das despesas;
- `savingsGoalMonthly`;
- `spendingLimitMonthly`;
- `emergencyFundGoal`.

### `monthlyIncome`

Valor mensal do salário.

### `savingsGoalMonthly`

Meta desejada de economia.

Não é um bloqueio.

É uma referência de saúde financeira.

### `spendingLimitMonthly`

Limite configurável de gastos.

Continua existindo separadamente da meta de economia.

### `emergencyFundGoal`

Meta de fundo de emergência.

---

# 5. Regras de alerta do Pós-pago

O aplicativo não deve impedir o usuário de gastar apenas porque seu salário foi ultrapassado.

A aplicação deve alertar.

## Estados definidos

### Verde

Quando:

> despesas < salário - meta de economia

Situação considerada normal.

---

### Amarelo

Quando:

> despesas >= salário - meta de economia

A meta de economia está comprometida.

---

### Vermelho — salário 100% comprometido

Quando:

> despesas = salário

Todo o salário está comprometido.

---

### Vermelho — salário excedido

Quando:

> despesas > salário

O usuário já comprometeu mais do que o salário disponível para aquele ciclo.

Mesmo nessa situação, o lançamento não deve ser bloqueado automaticamente.

---

# 6. Modelo financeiro Pré-pago

O Pré-pago representa o dinheiro que o usuário possui.

O usuário informa manualmente o caixa inicial.

Esse valor pode ser alterado manualmente posteriormente.

---

## 6.1 Componentes do caixa

O caixa é composto somente por:

1. valor inicial do caixa;
2. entradas de dinheiro cadastradas explicitamente pelo usuário;
3. despesas Pré-pago.

Fórmula:

```text
Caixa disponível =
Caixa inicial
+ Entradas de dinheiro
- Despesas Pré-pago
```

---

## 6.2 Regra fundamental

A única entrada de dinheiro que deve aumentar o caixa é:

> **o cadastro explícito de uma entrada de dinheiro.**

O sistema não deve inferir entradas.

Por isso:

- salário não entra automaticamente no caixa;
- empréstimo não entra automaticamente no caixa;
- investimento não entra automaticamente no caixa;
- outras receitas não entram automaticamente no caixa.

Se o usuário quiser aumentar o caixa por meio de uma receita extra, ele deverá registrar explicitamente uma **Entrada de dinheiro**.

---

# 7. Configurações do Pré-pago

A estrutura conceitual do Pré-pago possui:

- `cash`;
- `savingsGoal`;
- `spendingLimit`;
- `emergencyFundGoal`.

Esses valores são independentes dos equivalentes do Pós-pago.

---

## 7.1 Exemplo de independência

O usuário pode ter:

```text
Meta Pós-pago: R$ 500
Meta Pré-pago: R$ 300
```

Isso é válido.

Uma meta não altera a outra.

---

# 8. Regras de alerta do Pré-pago

## Verde

Quando:

> despesas < caixa - meta de economia

---

## Amarelo

Quando:

> despesas >= caixa - meta de economia

A meta de economia está comprometida.

---

## Vermelho

Quando:

> despesas = caixa

O caixa foi completamente consumido.

---

## Tentativa acima do caixa

Se o usuário tentar lançar uma despesa maior do que o dinheiro disponível:

> **a operação deve ser bloqueada.**

Mensagem conceitual:

> Saldo insuficiente para registrar esta despesa.

Diferentemente do Pós-pago, o Pré-pago não deve permitir saldo negativo.

---

# 9. Renda extra

Foi decidido que renda extra não deve ser adicionada ao salário.

Exemplo:

```text
Salário: R$ 2.500
Renda extra: R$ 500
```

O salário Pós-pago continua sendo:

```text
R$ 2.500
```

Os R$ 500 devem ser registrados explicitamente como:

> Entrada de dinheiro

E essa entrada pertence ao caixa Pré-pago.

Isso mantém o ciclo salarial estável e evita que uma renda eventual altere artificialmente a previsão mensal.

---

# 10. Entradas de dinheiro

Entradas de dinheiro devem possuir uma estrutura própria, separada das despesas.

Campos definidos inicialmente:

- valor;
- descrição;
- data;
- categoria.

Não existe recorrência para entradas neste momento.

A aplicação não deve misturar conceitualmente:

```text
Expense
```

com:

```text
Money Entry
```

São movimentos financeiros diferentes.

---

# 11. Despesas

A funcionalidade de despesas existente deve ser preservada.

Uma despesa deve possuir:

- valor;
- descrição;
- categoria;
- data;
- modo financeiro;
- tipo;
- forma de pagamento;
- cartão, quando aplicável;
- informações de parcelamento, quando aplicável;
- informações de recorrência, quando aplicável.

O modo financeiro pode ser:

```text
PREPAID
POSTPAID
```

---

# 12. Tipos de despesa

Foram definidos três tipos principais:

1. despesa única;
2. despesa parcelada;
3. despesa recorrente.

---

## 12.1 Despesa única

É uma despesa que acontece uma única vez.

Exemplo:

```text
Almoço
R$ 35
12/09/2026
```

Existe apenas uma ocorrência.

---

## 12.2 Despesa parcelada

Parcelamento é permitido apenas no Pós-pago.

Exemplo:

```text
Compra: R$ 1.200
Parcelas: 12
```

A compra deve gerar compromissos futuros.

A primeira parcela começa na data da compra.

O sistema precisa manter a relação entre:

- compra original;
- parcelas;
- valores;
- datas;
- status.

A lógica atual de parcelamento deve ser preservada.

---

## 12.3 Despesa recorrente

Recorrência é mensal.

Uma despesa recorrente gera ocorrências futuras automaticamente.

Exemplo:

```text
Academia
R$ 100
Mensal
```

A ocorrência deve continuar sendo criada enquanto a recorrência permanecer ativa.

O usuário pode posteriormente encerrar a recorrência.

---

# 13. Alteração e exclusão de despesas

Uma regra importante foi definida:

> **Sempre perguntar o escopo quando uma alteração puder afetar múltiplas ocorrências.**

---

## 13.1 Parceladas

Ao editar ou excluir uma despesa parcelada, perguntar se a ação se aplica a:

- parcela atual;
- parcelas restantes;
- compra inteira.

A nomenclatura final da interface pode ser refinada durante a implementação, mas a intenção é preservar essa decisão.

---

## 13.2 Recorrentes

Ao editar ou excluir uma recorrência, perguntar se a ação deve afetar:

- somente esta ocorrência;
- esta e as próximas;
- encerrar a recorrência.

---

## 13.3 Despesa única

Uma despesa única pode ser editada ou excluída diretamente, pois não possui dependências futuras.

---

# 14. Datas retroativas

O sistema permite cadastrar despesas retroativas.

A data informada pelo usuário é a data financeira da despesa.

Não deve ser usada automaticamente a data de criação do registro.

Exemplo:

Se hoje é 14/09, o usuário pode cadastrar:

```text
Despesa: R$ 100
Data: 10/09
```

A despesa pertence ao período correspondente a 10/09.

Isso é especialmente importante para o cálculo do ciclo Pós-pago.

---

# 15. Cartões

Foi decidido deliberadamente não criar um sistema excessivamente complexo de cartões.

O cartão serve principalmente para identificar:

> **em qual cartão uma despesa foi feita.**

A lógica existente de cartões deve ser preservada.

Não é necessário criar uma arquitetura excessivamente complexa de:

- fatura independente;
- ciclo de fechamento separado;
- múltiplas regras de vencimento;
- reconciliação automática;
- pagamentos automáticos de fatura.

O usuário explicitamente preferiu manter o cartão simples.

Quando uma despesa for paga por cartão:

- o cartão pode ser selecionado;
- a despesa fica vinculada ao cartão;
- parcelamentos podem ser associados à despesa.

---

# 16. Forma de pagamento

A forma de pagamento deve determinar quais campos adicionais aparecem.

Fluxo conceitual:

```text
Valor
↓
Descrição
↓
Pré-pago ou Pós-pago
↓
Forma de pagamento
↓
Campos específicos
```

---

## 16.1 Pré-pago

Pode possuir:

- categoria;
- data;
- forma de pagamento;
- recorrência.

Não pode possuir:

- parcelamento.

---

## 16.2 Pós-pago

Pode possuir:

- categoria;
- data;
- forma de pagamento;
- cartão, quando a forma for cartão;
- parcelamento;
- recorrência.

---

# 17. Regra: Pré-pago não possui parcelamento

Uma despesa Pré-pago consome dinheiro que já existe.

Por isso:

> **parcelamento não é permitido no Pré-pago.**

Parcelamentos são exclusivamente Pós-pago.

---

# 18. Empréstimos

A aplicação já possui lógica de empréstimos com:

- parcelas;
- juros;
- compromissos futuros.

Essa lógica deve ser preservada.

O usuário explicitamente não deseja alterar a lógica atual de empréstimos.

---

## 18.1 Empréstimo não é entrada

Mesmo que um empréstimo real gere dinheiro para o usuário, dentro do modelo da aplicação:

> empréstimo é uma obrigação.

Portanto, o valor recebido do empréstimo não deve automaticamente aumentar o caixa Pré-pago.

---

## 18.2 Parcelas do empréstimo

As parcelas representam compromissos futuros.

Elas podem ser consideradas no planejamento Pós-pago conforme a implementação existente.

---

## 18.3 Quitação antecipada

Foi sugerida a possibilidade de permitir quitação antecipada mantendo o histórico.

Essa ideia foi recomendada, mas não foi estabelecida como requisito obrigatório da implementação atual.

---

# 19. Investimentos

O conceito anteriormente chamado de “Patrimônio” foi corrigido para:

> **Investimentos**

A aplicação deve possuir um módulo de investimentos.

---

## 19.1 Objetivo

O usuário cadastra seus investimentos e a aplicação calcula projeções futuras.

Exemplo:

```text
Investimento:
R$ 10.000

Rentabilidade:
100% do CDI
```

A aplicação apresenta uma projeção de crescimento.

---

## 19.2 Fonte de taxa

A implementação existente tenta buscar uma taxa de referência, como CDI, em uma fonte governamental.

O conceito é considerado correto:

> buscar uma taxa de referência atual e utilizá-la para projeções.

Porém, foi identificado que a taxa atualmente obtida está incorreta.

Portanto, a fonte/cálculo precisa ser corrigida na implementação.

---

## 19.3 Projeções

As projeções devem ser apresentadas como:

> estimativas.

Não devem ser apresentadas como garantia de rentabilidade.

---

## 19.4 Tipos de investimento

Foi discutida a possibilidade de suportar:

- percentual de índice;
- taxa fixa;
- investimentos isentos de imposto;
- outras modalidades.

A modelagem final deve ser feita durante a inspeção do código existente, evitando quebrar o módulo atual.

---

## 19.5 Escopo atual

Não é necessário criar neste momento:

- integração com corretora;
- compra automática;
- venda automática;
- rebalanceamento;
- Open Finance;
- integração automática de carteira.

O módulo deve permanecer simples.

---

## 19.6 Integração com caixa

Investimentos são independentes do Pré-pago e Pós-pago.

Não existe:

```text
Investimento → Caixa
```

automático.

Nem:

```text
Caixa → Investimento
```

automático.

Qualquer operação futura deverá ser explicitamente registrada.

---

# 20. Inteligência Artificial

A IA possui um papel deliberadamente limitado no primeiro momento.

## Regra principal

> **A IA fornece feedback inteligente.**

Ela não executa ações financeiras.

---

## 20.1 A IA pode

- analisar os dados financeiros;
- identificar padrões;
- explicar situações;
- comparar períodos;
- responder perguntas sobre os dados;
- identificar possíveis problemas;
- sugerir comportamentos;
- interpretar relatórios;
- fornecer feedback.

---

## 20.2 A IA não pode

A IA não deve:

- criar despesas;
- editar despesas;
- excluir despesas;
- categorizar automaticamente;
- criar entradas;
- editar entradas;
- alterar configurações;
- criar investimentos;
- alterar investimentos;
- executar pagamentos;
- executar transferências;
- realizar operações financeiras.

A IA é consultiva.

---

# 21. Relatórios

Os relatórios já existem.

A decisão foi:

> **Os relatórios devem continuar existindo com pelo menos a funcionalidade atual.**

A aplicação já possui:

- gráficos;
- informações financeiras;
- chat com IA;
- possibilidade de enviar os dados do relatório para análise da IA.

---

## 21.1 Evolução futura

Foi discutida a possibilidade de criar análises mais avançadas cruzando:

- Pré-pago;
- Pós-pago;
- investimentos;
- empréstimos;
- categorias;
- comportamento histórico.

Essa evolução foi colocada em **standby**.

Não deve bloquear a implementação atual.

---

# 22. Categorias

Categorias são obrigatórias para despesas.

---

## 22.1 Categorias padrão

Foi proposta uma lista inicial:

1. Moradia
2. Alimentação
3. Transporte
4. Contas
5. Compras
6. Lazer
7. Saúde
8. Educação
9. Dívidas
10. Família
11. Viagem
12. Outros

---

## 22.2 Categorias personalizadas

O usuário pode criar suas próprias categorias.

As categorias são independentes do modo financeiro.

Uma categoria pode existir tanto em:

- Pré-pago;
- Pós-pago.

---

## 22.3 Exclusão de categoria

Não se deve apagar simplesmente o histórico de despesas.

Se uma categoria estiver sendo utilizada:

1. solicitar uma categoria substituta; ou
2. cancelar a exclusão.

Isso preserva o histórico.

---

## 22.4 Renomear

Renomear uma categoria deve preservar as despesas relacionadas.

---

## 22.5 IA e categorias

A IA não deve categorizar automaticamente neste estágio.

A IA apenas fornece feedback.

---

# 23. Home

A Home deve responder:

> **Como estou financeiramente?**

Ela não deve ser uma página de relatório gigante.

---

## 23.1 Estrutura

A Home deve apresentar separadamente:

### Bloco Pós-pago

Mostrar:

- salário do ciclo;
- valor comprometido;
- valor disponível;
- meta de economia;
- status.

### Bloco Pré-pago

Mostrar:

- caixa atual;
- valor gasto;
- valor disponível;
- meta de economia;
- status.

---

## 23.2 Status

Utilizar uma linguagem visual consistente:

- verde = normal;
- amarelo = meta comprometida;
- vermelho = situação crítica.

---

## 23.3 Ações

A Home deve possuir uma ação principal:

> **+ Nova despesa**

Também pode haver um pequeno menu de ações rápidas.

---

## 23.4 IA na Home

Pode existir um pequeno card de insight da IA.

A IA não deve dominar a interface.

Exemplo conceitual:

> “Seus gastos com alimentação aumentaram neste ciclo.”

---

## 23.5 Investimentos

Pode existir um pequeno resumo de investimentos.

A Home não deve mostrar todos os detalhes do módulo.

---

## 23.6 Lista de despesas

Foi decidido remover a lista completa de despesas da Home.

A lista detalhada deve ficar em:

> **Despesas**

A Home é situação financeira.

A tela de Despesas é movimentação.

---

# 24. Tela de Despesas

A tela deve ter:

- título “Despesas”;
- busca;
- filtros;
- período;
- total;
- lista agrupada por data;
- botão de adicionar.

---

## 24.1 Filtros

Filtros principais:

```text
Todas | Pós-pago | Pré-pago
```

---

## 24.2 Período

Pós-pago:

> respeita o ciclo financeiro (baseado no dia de pagamento das despesas).

Pré-pago:

> pode utilizar período de calendário.

---

## 24.3 Item da lista

Cada item deve mostrar, no mínimo:

- descrição;
- valor;
- categoria;
- modo;
- cartão, quando aplicável;
- número da parcela, quando aplicável;
- indicação de recorrência, quando aplicável.

---

# 25. Busca

A busca deve permitir encontrar despesas por:

- descrição;
- categoria;
- cartão.

---

# 26. Fluxo de nova despesa

O fluxo deve ser contextual.

Ordem conceitual:

```text
1. Valor
2. Descrição
3. Pré-pago ou Pós-pago
4. Campos específicos
5. Salvar
```

Ao escolher o modo, a interface mostra apenas os campos relevantes.

---

## Pré-pago

Campos:

- categoria;
- data;
- forma de pagamento;
- recorrência.

Sem parcelamento.

---

## Pós-pago

Campos:

- categoria;
- data;
- forma de pagamento;
- cartão, se aplicável;
- parcelamento;
- recorrência.

---

# 27. Navegação

A estrutura recomendada é:

```text
Home
Despesas
Investimentos
Mais
```

Além disso, existe uma ação rápida `+`.

---

## 27.1 Menu Mais

Dentro de “Mais”:

- Empréstimos;
- Cartões;
- Relatórios;
- Configurações.

---

## 27.2 Separação conceitual

A navegação deve refletir:

```text
Home        = situação
Despesas    = movimentações
Investimentos = projeções
Relatórios  = análise
IA          = interpretação
```

A IA não precisa necessariamente ser uma aba principal.

---

# 28. Ação rápida +

O botão de ação rápida pode apresentar:

1. Nova despesa;
2. Nova entrada;
3. Novo investimento;
4. Novo empréstimo.

A ação mais importante é:

> Nova despesa.

---

# 29. Configurações

A tela de configuração existente deve ser adaptada para contemplar:

```text
Pós-pago | Pré-pago
```

Foi discutida a utilização de um switch, mas a recomendação de UX é um:

> **controle segmentado**

porque não se trata de simplesmente ativar/desativar uma função.

São dois modos financeiros.

---

# 30. Configuração Pós-pago

Campos:

- salário;
- dia do salário;
- dia de pagamento das despesas;
- limite de gastos;
- meta de economia;
- fundo de emergência.

---

# 31. Configuração Pré-pago

Campos:

- caixa;
- limite de gastos;
- meta de economia;
- fundo de emergência.

O caixa pode ser editado manualmente.

---

# 32. Regra de ausência de transferências automáticas

Uma das regras mais importantes do sistema é:

> Não criar movimentações implícitas.

O sistema não deve assumir que determinado dinheiro mudou de lugar.

Exemplo:

O usuário recebe salário.

O sistema não deve fazer:

```text
Salário
↓
Caixa Pré-pago
```

O salário continua sendo renda do Pós-pago.

Se o usuário quiser informar dinheiro disponível no Pré-pago, deve utilizar uma entrada explícita ou editar o caixa conforme a regra definida.

---

# 33. Open Finance

Open Finance foi considerado como uma possibilidade futura.

Não faz parte do MVP atual.

O MVP trabalha principalmente com:

> cadastro manual.

No futuro, Open Finance poderá automatizar:

- contas;
- entradas;
- transações;
- saldos;
- cartões;
- outras informações.

Mas não deve ser introduzido agora.

---

# 34. Arquitetura conceitual

A stack recomendada anteriormente para o produto é:

```text
Frontend
Next.js

Backend
Spring Boot

Banco
PostgreSQL

Cache / dados auxiliares
Redis
```

A aplicação possui potencialmente:

```text
Next.js
   ↓
Spring Boot
   ↓
PostgreSQL
   ↓
Redis
```

A IA pode ser integrada como camada de interpretação sobre dados autorizados da aplicação.

---

# 35. Entidades conceituais

A estrutura discutida ao longo do projeto inclui conceitos como:

- Usuário;
- Configuração financeira Pós-pago;
- Configuração financeira Pré-pago;
- Despesa;
- Entrada de dinheiro;
- Categoria;
- Cartão;
- Parcela;
- Recorrência;
- Empréstimo;
- Parcela de empréstimo;
- Investimento;
- Relatório;
- Dados para análise de IA.

A estrutura exata de tabelas não foi fechada definitivamente porque o próximo passo é inspecionar o código atual antes de alterar o banco.

---

# 36. Estrutura financeira conceitual

Uma representação simplificada:

```text
                         USUÁRIO
                            |
             +--------------+--------------+
             |                             |
         PÓS-PAGO                       PRÉ-PAGO
             |                             |
        Salário                         Caixa
             |                             |
     Ciclo financeiro            Entradas explícitas
             |                             |
       Compromissos                   Despesas
       Despesas                       Pré-pago
       Parcelas
       Empréstimos
             |
       Disponibilidade
```

Investimentos permanecem independentes:

```text
                         USUÁRIO
                            |
                      INVESTIMENTOS
                            |
                      Valor atual
                            |
                       Rentabilidade
                            |
                       Projeções
```

---

# 37. Empréstimos no modelo

O empréstimo deve ser tratado como:

```text
Obrigação
   ↓
Parcelas futuras
   ↓
Comprometimento financeiro
```

E não como:

```text
Entrada de dinheiro
```

---

# 38. Investimentos no modelo

Investimentos devem ser tratados como:

```text
Patrimônio financeiro investido
        ↓
Valor atual
        ↓
Taxa / índice
        ↓
Projeção
```

Mas o nome de interface é:

> Investimentos

e não Patrimônio.

---

# 39. Filosofia de cálculo

A aplicação deve diferenciar:

### Dinheiro disponível

Aquilo que efetivamente existe no Pré-pago.

### Renda futura

Aquilo que sustentará o Pós-pago.

### Obrigações futuras

Aquilo que compromete renda futura.

### Investimentos

Ativos financeiros acompanhados separadamente.

### Feedback

Interpretação sobre esses dados.

Essa separação evita cálculos financeiros confusos.

---

# 40. Filosofia de bloqueio

A aplicação deve ser permissiva quando o problema é de planejamento Pós-pago.

### Pós-pago

Pode ultrapassar salário.

A aplicação:

- alerta;
- sinaliza;
- mostra o problema;
- não bloqueia automaticamente.

### Pré-pago

Não pode gastar mais do que o caixa disponível.

A aplicação:

- bloqueia;
- informa saldo insuficiente.

Essa diferença é intencional.

---

# 41. Meta de economia

A meta de economia é uma referência de saúde financeira.

Ela não é uma trava.

Exemplo:

```text
Salário: R$ 3.000
Meta: R$ 500
```

O nível saudável de gastos seria inferior a:

```text
R$ 2.500
```

Se os gastos ultrapassarem esse ponto, a situação muda para alerta amarelo.

Se chegarem a R$ 3.000, fica vermelho.

Se ultrapassarem R$ 3.000, continua vermelho, mas o sistema permite registrar.

---

# 42. Limite de gastos

O limite de gastos permanece como configuração separada.

Não deve ser confundido com:

- salário;
- meta de economia;
- caixa;
- fundo de emergência.

Cada conceito tem uma função diferente.

---

# 43. Fundo de emergência

O fundo de emergência permanece como configuração/objetivo financeiro.

Ele não deve ser automaticamente misturado ao caixa.

A aplicação deve tratar o objetivo como planejamento.

---

# 44. Decisões de UX

Foi dada uma instrução geral pelo usuário:

> **Tudo que for layout deve ser decidido e documentado pelo assistente.**

Portanto, decisões menores de UI não devem ficar sendo devolvidas ao usuário para escolha.

O usuário deve validar apenas quando houver conflito com a visão do produto.

---

# 45. Princípios de UX

## Simplicidade

Mostrar primeiro aquilo que responde à pergunta mais importante.

## Contextualidade

Mostrar campos somente quando são relevantes.

## Separação

Não misturar Pré-pago e Pós-pago visualmente ou matematicamente.

## Feedback

Usar estados claros:

- normal;
- atenção;
- crítico.

## Baixa fricção

Cadastro de despesa deve ser rápido.

## Segurança contra alterações acidentais

Alterações em recorrências e parcelamentos devem perguntar o escopo.

---

# 46. Estados visuais

O sistema deve manter uma linguagem visual consistente:

```text
VERDE
Situação normal

AMARELO
Meta comprometida / atenção

VERMELHO
Situação crítica
```

A implementação visual exata deve seguir o design system existente do aplicativo quando este for inspecionado.

---

# 47. Relacionamento entre módulos

O produto pode ser entendido como:

```text
HOME
  |
  +-- Pré-pago
  |
  +-- Pós-pago
  |
  +-- Pequeno resumo de investimentos
  |
  +-- Insight de IA

DESPESAS
  |
  +-- Todas
  +-- Pré-pago
  +-- Pós-pago

INVESTIMENTOS
  |
  +-- Investimentos
  +-- Rentabilidade
  +-- Projeções

MAIS
  |
  +-- Empréstimos
  +-- Cartões
  +-- Relatórios
  +-- Configurações
```

---

# 48. Funcionalidades que foram mantidas

As funcionalidades existentes não devem ser destruídas durante a evolução.

Devem ser preservadas especialmente:

- despesas;
- cartões;
- parcelamentos;
- recorrências;
- empréstimos;
- relatórios;
- chat com IA;
- investimentos.

A implementação deve ser incremental.

---

# 49. Funcionalidades deliberadamente simplificadas

Foram tomadas decisões para impedir crescimento desnecessário do MVP.

## Cartões

Manter simples.

## IA

Somente feedback.

## Investimentos

Sem integração com corretora.

## Entradas

Sem recorrência.

## Pré-pago

Sem parcelamento.

## Open Finance

Futuro.

## Relatórios avançados

Futuro/standby.

---

# 50. Funcionalidades em standby

Não devem bloquear a implementação atual:

- análises avançadas cruzando todos os módulos;
- Open Finance;
- automação de operações;
- integração com corretoras;
- IA executora;
- analytics avançado;
- retenção avançada;
- testes de mercado avançados;
- funcionalidades financeiras adicionais não essenciais.

---

# 51. Evolução do roadmap

O projeto foi inicialmente organizado em várias etapas de definição.

As etapas mais relevantes consolidadas foram:

## Etapas iniciais — Estratégia

Foram definidos:

- propósito do produto;
- proposta de valor;
- sustentabilidade do negócio;
- estrutura do produto;
- modelo financeiro.

---

## Etapa de modelo financeiro

Foi definida a separação:

```text
Pós-pago
```

e

```text
Pré-pago
```

Essa decisão substituiu uma abordagem mais genérica de patrimônio/caixa.

---

## Etapas de regras

Foram fechadas:

- ciclos;
- despesas;
- recorrência;
- parcelamentos;
- categorias;
- entradas;
- empréstimos;
- investimentos.

---

## Etapas de UX

Foram fechadas:

- Home;
- Despesas;
- navegação;
- ação rápida;
- configuração.

---

## Etapas puladas

Algumas etapas originalmente planejadas foram adiadas porque ainda não fazia sentido executá-las antes do desenvolvimento.

Especialmente:

- analytics;
- retenção;
- testes de comportamento;
- evolução avançada de relatórios.

A decisão foi priorizar a construção do produto.

---

# 52. Auditoria geral

Foi realizada uma consolidação das regras para eliminar conflitos.

Uma das principais correções foi:

> Pós-pago não bloqueia despesas ao ultrapassar o salário.

O comportamento correto é:

```text
Salário excedido
↓
Alerta
↓
Despesa continua podendo ser registrada
```

Enquanto:

```text
Pré-pago sem saldo
↓
Bloqueio
```

Essa distinção deve ser preservada.

---

# 53. Regras de data consolidadas

Toda despesa possui uma data financeira.

O sistema deve utilizar a data informada pelo usuário.

Para Pós-pago:

```text
data da despesa
↓
identificação do ciclo salarial
```

Para Pré-pago:

```text
data da despesa
↓
período de caixa / calendário
```

---

# 54. Regras de recorrência consolidadas

Recorrência:

- somente mensal;
- gera ocorrências futuras;
- continua até encerramento;
- não se aplica a entradas de dinheiro.

---

# 55. Regras de parcelamento consolidadas

Parcelamento:

- somente Pós-pago;
- primeira parcela inicia na data da compra;
- gera compromissos futuros;
- deve preservar vínculo com a compra;
- alterações devem perguntar o escopo.

---

# 56. Regras de categoria consolidadas

Toda despesa:

```text
categoria obrigatória
```

Categoria:

- independe do modo;
- pode ser personalizada;
- pode ser renomeada;
- não deve destruir histórico ao ser excluída.

---

# 57. Regras de entrada consolidadas

Entrada de dinheiro:

```text
valor
descrição
data
categoria
```

Sem recorrência.

Somente entradas explicitamente cadastradas alteram o caixa.

---

# 58. Regras de salário consolidadas

Salário:

- pertence ao Pós-pago;
- informa quando a renda entra (dia de recebimento), mas NÃO define o ciclo;
- o ciclo é definido pelo dia de pagamento das despesas (`paymentDay`);
- não entra automaticamente no caixa;
- não é misturado com renda extra;
- renda extra deve ser entrada explícita.

---

# 59. Regras de empréstimo consolidadas

Empréstimo:

- é obrigação;
- possui parcelas;
- pode possuir juros;
- não é tratado como renda;
- não aumenta automaticamente o caixa;
- compromissos futuros podem impactar planejamento Pós-pago;
- lógica existente deve ser preservada.

---

# 60. Regras de investimento consolidadas

Investimento:

- é independente dos dois modos;
- possui valor;
- possui rentabilidade;
- permite projeções;
- utiliza taxa de referência;
- projeções são estimativas;
- não movimenta automaticamente o caixa.

---

# 61. Regras de IA consolidadas

IA:

```text
ANALISA
EXPLICA
SUGERE
INTERPRETA
```

IA não:

```text
CRIA
EDITA
EXCLUI
EXECUTA
TRANSFERE
PAGA
```

---

# 62. Modelo de navegação final

```text
┌───────────────┐
│     HOME      │
└───────┬───────┘
        │
        ├───────────────┐
        │               │
        ▼               ▼
   PRÉ-PAGO          PÓS-PAGO
        │               │
        └───────┬───────┘
                │
                ▼
           DESPESAS

INVESTIMENTOS

MAIS
 ├── Empréstimos
 ├── Cartões
 ├── Relatórios
 └── Configurações
```

---

# 63. Modelo de decisão financeira

A aplicação pode seguir esta árvore:

```text
Nova despesa
     |
     ▼
É Pré-pago?
   /     \
 SIM      NÃO
 |         |
 ▼         ▼
Tem saldo? Pós-pago
 |         |
 NÃO       ▼
 |      Identifica ciclo
 ▼         |
Bloqueia   ▼
          Calcula comprometimento
                |
                ▼
          Exibe alerta
```

---

# 64. Cálculo conceitual Pós-pago

Simplificadamente:

```text
Disponível Pós-pago =
Salário do ciclo
- Compromissos/despesas do ciclo
```

E a comparação com a meta:

```text
Limite saudável =
Salário
- Meta de economia
```

A situação depende da relação entre gasto e esses valores.

---

# 65. Cálculo conceitual Pré-pago

```text
Disponível Pré-pago =
Caixa inicial
+ Entradas explícitas
- Despesas Pré-pago
```

Nunca deve ficar negativo.

---

# 66. O que não deve acontecer

## Não transferir salário automaticamente

Errado:

```text
salário recebido
→ aumenta caixa
```

## Não transformar empréstimo em entrada

Errado:

```text
empréstimo recebido
→ entrada de dinheiro
```

## Não transformar investimento em caixa

Errado:

```text
investimento
→ aumenta caixa
```

## Não misturar modos

Errado:

```text
despesa Pré-pago
→ reduz salário Pós-pago
```

## Não permitir parcelamento Pré-pago

Errado:

```text
Pix Pré-pago
→ 12 parcelas
```

## Não deixar IA executar ações

Errado:

```text
IA analisa
→ cria despesa
```

---

# 67. O que deve acontecer

## Renda extra

```text
Renda extra
→ usuário cadastra entrada
→ caixa aumenta
```

## Despesa Pós-pago

```text
Despesa
→ ciclo salarial
→ aumenta comprometimento
→ alerta se necessário
```

## Despesa Pré-pago

```text
Despesa
→ verifica saldo
→ se suficiente, registra
→ se insuficiente, bloqueia
```

## Investimento

```text
Cadastro
→ calcula projeção
→ mostra estimativa
```

## IA

```text
Dados
→ análise
→ feedback
```

---

# 68. Prioridade de implementação

A próxima fase deve ser feita com base no código existente.

Não se deve começar alterando banco ou frontend às cegas.

A ordem definida é:

## Fase 1 — Inspeção técnica

Verificar:

- estrutura do projeto;
- frontend;
- backend;
- banco;
- entidades;
- serviços;
- controllers;
- repositories;
- migrations;
- telas;
- rotas;
- componentes;
- cálculos atuais;
- cartões;
- empréstimos;
- investimentos;
- relatórios;
- IA.

---

# 69. Fase 2 — Banco de dados

Depois da inspeção:

- identificar entidades existentes;
- reaproveitar tabelas;
- criar apenas estruturas necessárias;
- criar migrations;
- preservar dados existentes;
- evitar duplicação desnecessária.

Uma possibilidade discutida foi uma estrutura de planejamento financeiro com tipo:

```text
PREPAID
POSTPAID
```

Mas isso é uma decisão conceitual, não uma decisão definitiva de schema.

A estrutura final deverá ser determinada após a inspeção do código atual.

---

# 70. Fase 3 — Backend

Implementar ou adaptar:

- cálculo Pós-pago;
- cálculo Pré-pago;
- ciclos;
- entradas;
- categorias;
- regras de despesas;
- parcelamentos;
- recorrências;
- validação de saldo Pré-pago;
- alertas Pós-pago;
- investimentos;
- preservação de empréstimos;
- preservação de cartões;
- relatórios.

---

# 71. Fase 4 — Frontend

Adaptar:

- Home;
- Despesas;
- configuração;
- investimentos;
- navegação;
- ações rápidas;
- filtros;
- indicadores de status;
- formulários contextuais.

---

# 72. Fase 5 — Preservação

Durante a implementação, garantir que não sejam quebrados:

- empréstimos existentes;
- cartões existentes;
- parcelamentos existentes;
- recorrências existentes;
- relatórios existentes;
- IA existente;
- investimentos existentes.

---

# 73. Fase 6 — Testes

Testar principalmente regras financeiras.

## Pós-pago

- salário normal;
- gasto abaixo da meta;
- gasto acima da meta;
- salário 100% comprometido;
- salário excedido;
- ciclo com datas diferentes;
- despesas retroativas;
- parcelamento;
- recorrência.

## Pré-pago

- caixa positivo;
- entrada;
- despesa;
- saldo zerado;
- tentativa de saldo negativo;
- edição manual do caixa.

## Geral

- categorias;
- cartões;
- empréstimos;
- investimentos;
- relatórios.

---

# 74. Casos de teste importantes

## Caso 1 — ciclo por dia de pagamento

```text
Salário = R$ 3.000
Dia do salário = 20
Dia de pagamento das despesas = 25
```

Despesa:

```text
25/09
```

Pertence ao ciclo que fecha em:

```text
25/09 (ciclo 26/08 → 25/09)
```

Despesa:

```text
26/09
```

Pertence ao novo ciclo:

```text
25/10 (ciclo 26/09 → 25/10)
```

---

## Caso 2 — meta

```text
Salário = R$ 3.000
Meta = R$ 500
```

Limite saudável:

```text
R$ 2.500
```

Gasto:

```text
R$ 2.400
```

Status:

```text
Verde
```

Gasto:

```text
R$ 2.600
```

Status:

```text
Amarelo
```

Gasto:

```text
R$ 3.000
```

Status:

```text
Vermelho
```

Gasto:

```text
R$ 3.100
```

Status:

```text
Vermelho
```

Mas a despesa continua podendo ser registrada.

---

## Caso 3 — Pré-pago

```text
Caixa = R$ 500
```

Despesa:

```text
R$ 300
```

Disponível:

```text
R$ 200
```

Nova despesa:

```text
R$ 250
```

Resultado:

```text
Bloqueada
```

---

# 75. Estado atual do produto

Até este ponto, a maior parte das decisões de produto e regras financeiras foi consolidada.

O projeto está saindo da fase de:

> definição

e entrando na fase de:

> implementação.

Entretanto, antes de escrever código, existe uma etapa técnica obrigatória:

> **inspecionar o código atual.**

---

# 76. Por que inspecionar antes de programar

O produto já possui funcionalidades.

Modificar diretamente sem conhecer a implementação pode:

- duplicar entidades;
- quebrar migrations;
- quebrar empréstimos;
- quebrar cartões;
- quebrar relatórios;
- quebrar investimentos;
- alterar cálculos existentes incorretamente;
- criar lógica duplicada;
- gerar inconsistência de dados.

Por isso a implementação deve começar por uma auditoria técnica.

---

# 77. O que deve ser descoberto no código

## Backend

Identificar:

- linguagem;
- framework;
- estrutura de packages;
- entities;
- DTOs;
- repositories;
- services;
- controllers;
- security;
- configurações;
- migrations;
- testes.

---

## Banco

Identificar:

- PostgreSQL;
- tabelas;
- relacionamentos;
- enums;
- constraints;
- índices;
- migrations;
- dados existentes.

---

## Frontend

Identificar:

- Next.js;
- rotas;
- páginas;
- componentes;
- hooks;
- services;
- chamadas HTTP;
- autenticação;
- design system;
- estado global;
- telas atuais.

---

# 78. Primeiro mapa técnico esperado

Após inspeção, deverá ser produzido algo semelhante a:

| Área | Existe? | Situação | Ação |
|---|---:|---|---|
| Despesas | Sim/Não | atual | preservar/adaptar |
| Categorias | Sim/Não | atual | adaptar |
| Entradas | Sim/Não | atual | criar/adaptar |
| Pré-pago | Sim/Não | atual | implementar |
| Pós-pago | Sim | atual | adaptar |
| Ciclo (por pagamento) | Sim/Não | atual | corrigir/adaptar |
| Cartões | Sim | atual | preservar |
| Parcelamento | Sim | atual | preservar |
| Recorrência | Sim | atual | preservar |
| Empréstimos | Sim | atual | preservar |
| Investimentos | Sim | atual | corrigir/adaptar |
| Relatórios | Sim | atual | preservar |
| IA | Sim | atual | limitar a feedback |
| Home | Sim | atual | reorganizar |
| Navegação | Sim | atual | reorganizar |

A tabela real deve ser preenchida depois da inspeção do projeto.

---

# 79. Regra para desenvolvimento

A implementação deve seguir:

```text
Código existente
      ↓
Inspeção
      ↓
Mapa técnico
      ↓
Alterações de banco
      ↓
Backend
      ↓
Frontend
      ↓
Testes
      ↓
Validação
```

Não:

```text
Ideia
↓
Reescrever tudo
```

---

# 80. Princípio de preservação

O projeto não deve ser tratado como um aplicativo novo do zero.

É uma evolução de um sistema já existente.

Portanto:

> **Reaproveitar antes de recriar.**

Se uma entidade atual atende ao requisito, ela deve ser adaptada em vez de duplicada.

Se uma regra atual já funciona, deve ser preservada.

---

# 81. Pontos que precisam de validação técnica posterior

Algumas decisões conceituais estão claras, mas dependem da estrutura existente para determinar a implementação:

- se Pré-pago e Pós-pago terão tabelas separadas;
- se haverá uma tabela de planejamento com enum de tipo;
- como o ciclo atual está implementado;
- como parcelas atuais são representadas;
- como recorrências atuais são representadas;
- como cartões são ligados às despesas;
- como empréstimos são ligados às despesas/compromissos;
- como investimentos armazenam rentabilidade;
- como a fonte de CDI atual é consultada;
- como relatórios obtêm os dados;
- como a IA recebe contexto;
- como o frontend organiza as rotas.

---

# 82. Decisões já consideradas definitivas de produto

As seguintes decisões devem ser tratadas como regras consolidadas:

1. Existem Pré-pago e Pós-pago.
2. Os dois são independentes.
3. Não existem transferências automáticas entre eles.
4. Pós-pago usa salário e ciclo baseado no dia de pagamento das despesas.
5. Pré-pago usa caixa.
6. Salário não entra automaticamente no caixa.
7. Renda extra entra no caixa somente mediante cadastro explícito.
8. Empréstimo não é entrada.
9. Investimento não movimenta automaticamente caixa.
10. Pré-pago não permite parcelamento.
11. Pós-pago pode ter parcelamento.
12. Pós-pago pode ultrapassar salário, mas gera alerta.
13. Pré-pago não pode ficar negativo.
14. Categorias são obrigatórias para despesas.
15. Recorrência é mensal.
16. Entradas não são recorrentes neste momento.
17. Alterações em recorrências e parcelas devem perguntar o escopo.
18. Cartões continuam simples.
19. Empréstimos existentes devem ser preservados.
20. Investimentos substituem o conceito de “Patrimônio”.
21. Investimentos fazem projeções.
22. Projeções são estimativas.
23. IA somente fornece feedback.
24. Relatórios continuam existindo.
25. Home mostra situação, não uma lista completa de despesas.
26. Despesas possuem tela própria.
27. Navegação principal simplificada.
28. Layouts devem ser definidos/documentados pelo assistente.
29. Open Finance fica para depois.
30. Recursos avançados ficam em standby.

---

# 83. Decisões descartadas ou corrigidas

## “Patrimônio”

Foi substituído por:

> Investimentos.

---

## Salário entrando automaticamente no caixa

Foi rejeitado.

---

## Renda extra aumentando salário

Foi rejeitado.

---

## Empréstimo sendo entrada

Foi rejeitado.

---

## Transferências automáticas entre Pré-pago e Pós-pago

Foram rejeitadas.

---

## Bloqueio de gasto Pós-pago acima do salário

Foi rejeitado.

O sistema deve apenas alertar.

---

## Parcelamento Pré-pago

Foi rejeitado.

---

## Sistema complexo de cartão/fatura

Foi rejeitado em favor da manutenção do modelo simples existente.

---

## IA executora

Foi rejeitada.

A IA é somente consultiva.

---

## Evolução imediata dos relatórios

Foi colocada em standby.

---

# 84. Identidade conceitual das telas

Uma regra importante para manter o produto compreensível:

### Home

> “Como estou?”

### Despesas

> “O que aconteceu?”

### Investimentos

> “Como meu dinheiro pode evoluir?”

### Relatórios

> “O que meus dados mostram?”

### IA

> “O que isso significa e o que posso melhorar?”

Essa divisão evita sobreposição entre telas.

---

# 85. Modelo mental do usuário

O usuário não deve precisar conhecer conceitos técnicos como:

- engine Pós-pago;
- engine Pré-pago;
- cálculo de ciclo;
- agregador;
- serviço de projeção.

A interface deve falar em termos simples:

- Pós-pago;
- Pré-pago;
- salário;
- caixa;
- despesas;
- investimentos;
- empréstimos;
- relatórios.

---

# 86. Regra de simplicidade do MVP

Quando houver dúvida entre:

```text
solução simples
```

e:

```text
solução altamente configurável
```

a preferência do MVP deve ser:

> solução simples, desde que preserve a regra financeira definida.

Complexidade só deve ser adicionada quando houver necessidade real.

---

# 87. Potencial modelo de negócio

O projeto começou com a preocupação de construir um modelo sustentável de negócio.

A proposta de valor é baseada em:

- controle financeiro;
- previsão;
- organização;
- investimentos;
- feedback inteligente;
- facilidade de uso.

Funcionalidades avançadas podem futuramente servir como base para monetização.

Entretanto, a prioridade atual é construir um produto financeiro coerente e utilizável antes de expandir monetização.

---

# 88. Filosofia de monetização futura

A monetização não deve destruir o valor central do aplicativo.

O produto precisa primeiro provar:

```text
Usuário registra
↓
Usuário entende
↓
Usuário prevê
↓
Usuário melhora
↓
Usuário continua usando
```

Depois:

```text
retenção
↓
valor percebido
↓
monetização
```

As etapas de analytics e retenção foram propositalmente adiadas para depois da construção principal.

---

# 89. Estado da documentação

Este documento consolida as decisões tomadas na conversa até o ponto atual.

Ele deve servir como referência para:

- produto;
- backend;
- frontend;
- banco;
- UX;
- testes;
- futuras decisões.

Quando uma decisão nova contradizer este documento, deve-se atualizar a regra correspondente em vez de manter duas versões conflitantes.

---

# 90. Próximo passo imediato

O próximo passo não é criar mais regras de produto.

É:

> **inspecionar o projeto existente.**

Precisamos identificar a estrutura real antes de implementar.

A inspeção deve produzir:

1. mapa do projeto;
2. mapa do banco;
3. mapa do backend;
4. mapa do frontend;
5. funcionalidades existentes;
6. pontos que podem ser reaproveitados;
7. pontos que precisam ser alterados;
8. novas entidades necessárias;
9. migrations necessárias;
10. ordem exata de implementação.

---

# 91. Marco atual — Etapa 26

A Etapa 26 é:

> **Plano de Implementação**

Ela possui seis grandes fases:

```text
1. Banco de dados
2. Backend
3. Frontend
4. Preservação das funcionalidades existentes
5. Testes
6. Migração / validação
```

Antes delas, foi identificada a necessidade de uma fase técnica inicial:

```text
0. Inspeção do código existente
```

Essa inspeção é a próxima ação prática.

---

# 92. Início efetivo da programação

A programação propriamente dita começa depois que o código atual for disponibilizado/inspecionado.

Não é recomendável escrever as alterações de implementação antes disso.

A partir do momento em que o projeto estiver acessível, a sequência deve ser:

```text
INSPECIONAR
    ↓
DOCUMENTAR ARQUITETURA ATUAL
    ↓
COMPARAR COM REGRAS DESTE DOCUMENTO
    ↓
IDENTIFICAR GAPs
    ↓
DEFINIR MIGRATIONS
    ↓
IMPLEMENTAR BACKEND
    ↓
IMPLEMENTAR FRONTEND
    ↓
TESTAR
    ↓
VALIDAR
```

---

# 93. Critério de sucesso do MVP

O MVP estará coerente quando um usuário conseguir:

### Configurar Pós-pago

```text
Salário
Dia do salário
Dia de pagamento das despesas
Meta
Limite
Fundo de emergência
```

### Configurar Pré-pago

```text
Caixa
Meta
Limite
Fundo de emergência
```

### Registrar despesas

Com:

- categoria;
- modo;
- data;
- pagamento;
- cartão quando aplicável;
- parcelamento quando aplicável;
- recorrência quando aplicável.

### Registrar entradas

Sem alterar salário.

### Visualizar Home

Com Pré-pago e Pós-pago separados.

### Visualizar despesas

Com busca e filtros.

### Visualizar investimentos

Com projeções.

### Continuar usando empréstimos

Sem quebrar a lógica existente.

### Continuar usando relatórios

Sem perder o que já existe.

### Usar IA

Recebendo feedback, mas sem permitir que a IA execute ações financeiras.

---

# 94. Checklist final de regras financeiras

## Pós-pago

- [x] Salário
- [x] Dia do salário
- [x] Dia de pagamento das despesas (define o ciclo)
- [x] Ciclo por pagamento
- [x] Meta de economia
- [x] Limite de gastos
- [x] Fundo de emergência
- [x] Parcelamento
- [x] Recorrência
- [x] Alertas
- [x] Pode exceder salário

## Pré-pago

- [x] Caixa
- [x] Entrada explícita
- [x] Meta de economia
- [x] Limite de gastos
- [x] Fundo de emergência
- [x] Sem parcelamento
- [x] Sem saldo negativo
- [x] Alertas

## Despesas

- [x] Categoria obrigatória
- [x] Data
- [x] Tipo
- [x] Modo
- [x] Forma de pagamento
- [x] Cartão quando aplicável
- [x] Parcelamento Pós-pago
- [x] Recorrência mensal
- [x] Edição com escopo
- [x] Exclusão com escopo
- [x] Datas retroativas

## Entradas

- [x] Tabela separada
- [x] Valor
- [x] Descrição
- [x] Data
- [x] Categoria
- [x] Sem recorrência
- [x] Aumenta caixa apenas quando cadastrada

## Empréstimos

- [x] Preservar lógica existente
- [x] Parcelas
- [x] Juros
- [x] Obrigação
- [x] Não é entrada

## Investimentos

- [x] Nome “Investimentos”
- [x] Cadastro
- [x] Valor
- [x] Rentabilidade
- [x] Projeção
- [x] Taxa de referência
- [x] Estimativa
- [x] Independente do caixa

## IA

- [x] Feedback
- [x] Análise
- [x] Interpretação
- [x] Sugestões
- [x] Sem execução de ações

## Relatórios

- [x] Continuam existindo
- [x] Manter funcionalidade atual
- [x] IA integrada
- [x] Evolução avançada em standby

---

# 95. Checklist de UX

- [x] Home simplificada
- [x] Pós-pago separado
- [x] Pré-pago separado
- [x] Despesas em tela própria
- [x] Investimentos em tela própria
- [x] Menu Mais
- [x] Ação rápida
- [x] Nova despesa como ação principal
- [x] Filtros Pré/Pós
- [x] Busca
- [x] Indicadores verde/amarelo/vermelho
- [x] Formulário contextual
- [x] Parcelamento somente Pós-pago
- [x] Escopo ao editar/excluir recorrências
- [x] Escopo ao editar/excluir parcelamentos
- [x] Configuração com controle segmentado
- [x] IA sem dominar a navegação

---

# 96. Checklist técnico para o próximo ciclo

Antes de modificar código:

- [ ] localizar projeto;
- [ ] identificar frontend;
- [ ] identificar backend;
- [ ] identificar banco;
- [ ] identificar migrations;
- [ ] localizar entidade de usuário;
- [ ] localizar configuração financeira;
- [ ] localizar despesas;
- [ ] localizar categorias;
- [ ] localizar cartões;
- [ ] localizar parcelas;
- [ ] localizar recorrências;
- [ ] localizar empréstimos;
- [ ] localizar investimentos;
- [ ] localizar relatórios;
- [ ] localizar integração de IA;
- [ ] mapear APIs;
- [ ] mapear telas;
- [ ] mapear autenticação;
- [ ] mapear testes;
- [ ] criar plano de alteração;
- [ ] somente então começar a modificar.

---

# 97. Conclusão

O produto evoluiu de um simples aplicativo de registro de despesas para uma plataforma de organização financeira baseada em dois universos claramente separados:

```text
                    FINANÇAS DO USUÁRIO
                           |
              +------------+------------+
              |                         |
           PÓS-PAGO                 PRÉ-PAGO
              |                         |
        Salário/ciclo                 Caixa
              |                         |
       Compromissos              Entradas explícitas
       Parcelamentos                   |
       Empréstimos                  Despesas
              |                         |
              +------------+------------+
                           |
                     VISÃO FINANCEIRA
                           |
             +-------------+-------------+
             |             |             |
          Relatórios   Investimentos     IA
                                        |
                                     Feedback
```

A principal preocupação do projeto passa a ser manter essa separação clara tanto no banco quanto no backend, nos cálculos e na experiência do usuário.

O próximo movimento deve ser técnico:

> **analisar o código existente e transformar todas as regras deste documento em um plano de implementação específico para o projeto real.**

Nenhuma alteração estrutural relevante deve ser feita antes dessa inspeção.

---

## Histórico de decisões resumido

| Tema | Decisão final |
|---|---|
| Modelo financeiro | Pré-pago + Pós-pago |
| Relação entre modos | Independentes |
| Salário | Somente Pós-pago |
| Renda extra | Entrada explícita no Pré-pago |
| Empréstimo recebido | Não é entrada |
| Investimentos | Independentes |
| Caixa | Manual + entradas explícitas - despesas |
| Saldo Pré-pago negativo | Não permitido |
| Pós-pago acima do salário | Permitido com alerta |
| Meta de economia | Referência, não bloqueio |
| Limite de gastos | Configuração independente |
| Ciclo | Baseado no dia de pagamento das despesas (salário informa a entrada) |
| Parcelamento | Somente Pós-pago |
| Recorrência | Mensal |
| Entrada recorrente | Não |
| Categorias | Obrigatórias |
| Cartões | Simples |
| Empréstimos | Preservar lógica existente |
| Investimentos | Projeções |
| Patrimônio | Renomeado para Investimentos |
| IA | Apenas feedback |
| Relatórios | Manter atuais |
| Open Finance | Futuro |
| Home | Situação financeira |
| Despesas | Tela própria |
| Navegação | Home / Despesas / Investimentos / Mais |
| Configuração | Pré-pago / Pós-pago |
| UX | Decisões de layout ficam com o assistente |
| Implementação | Inspecionar código antes de alterar |

---

**Fim da documentação consolidada.**
