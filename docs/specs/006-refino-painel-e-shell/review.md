# Spec 006 - Revisao de fechamento

## Status

Implementada em 18 de junho de 2026 no commit `3799379`.

O arquivo anterior era uma revisao de abertura, criada antes da implementacao.
Ele declarava a spec como planejada e o gate como fechado. O codigo foi entregue
mais tarde no mesmo dia, mas esse registro nao foi atualizado; esta revisao
corrige essa inconsistência documental.

## Entrega confirmada

- `OperationalTopBar` ganhou toggle funcional de tema;
- as telas da shell usam `AppDrawer`, com conta, tenant, `Ver conta` e alteracao
  local de nome;
- a barra inferior contem Painel, Produtos, Vendas e Mais;
- Vendas permite selecionar cliente, montar carrinho, respeitar a restricao
  financeira e registrar um rascunho na fila Riverpod em memoria;
- o dashboard removeu o hero textual anterior e usa card de atualizacao,
  `operational_goal_chart` e `stock_level_chart` de fixture;
- testes cobrem estados, navegacao, responsividade em 320 px e `textScaler`
  alto, alem dos goldens.

## Validacao

Em 8 de setembro de 2026, sobre o codigo entregue:

- `flutter analyze`: sem issues;
- `flutter test`: 137 testes passando.

## Limites preservados

- tema, nome e rascunhos de venda existem somente durante a sessao;
- `pendingSalesProvider` nao e outbox persistente;
- nao ha autenticacao mobile, armazenamento seguro, banco Drift, sync ou envio
  de venda ao servidor;
- nenhum endpoint planejado foi simulado como existente.

## Veredito

`implemented_with_in_memory_limits`
