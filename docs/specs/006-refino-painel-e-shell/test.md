# Spec 006 - Validacao da implementacao

## Resultado registrado

A implementacao foi entregue no commit `3799379`. A validacao mais recente
executada sobre o codigo da spec registrou:

- `flutter analyze`: sem issues;
- `flutter test`: 137 testes passando;
- cobertura de drawer, toggle de tema, vendas em memoria, dashboard, goldens,
  largura compacta e `textScaler` alto.

Os testes comprovam o comportamento local e visual. Eles nao comprovam
persistencia, sincronizacao, autenticacao ou envio remoto, que permanecem fora
do escopo desta spec.

## Referencia de validacao e historico

## Objetivo

Registrar os cenarios usados para validar a implementacao da Spec 006.

Esta lista foi usada como referencia da entrega e e mantida para futuras
regressoes.

## O que verificar depois

A implementacao comprova que:

- o topo ganhou alternancia real de tema;
- o menu lateral passou a funcionar;
- `Vendas` entrou como destino principal da shell;
- o hero atual do painel foi removido;
- a copy generica foi removida;
- o card de ultima atualizacao foi introduzido;
- os graficos adicionados ficaram restritos aos blocos permitidos;
- a responsividade mobile foi preservada sem overflow.

## Cenarios cobertos pela implementacao

### 1. Toggle de tema

Verificar:

- alternancia entre claro e escuro;
- permanencia visual coerente da shell;
- convivencia com a acao de busca no topo.

### 2. Drawer lateral

Verificar:

- abertura e fechamento pelo menu;
- largura compatível com meia tela;
- exibicao de conta, tenant, `Ver conta` e `Alterar nome`;
- ausencia de overflow em largura compacta.

### 3. Módulo de Vendas (Venda Offline em Memória)

Verificar:
- presença de `Vendas` na barra de navegação inferior;
- navegação correta para a tela de vendas;
- seleção de um cliente da fixture via modal, exibindo nome e dados do cliente ativo;
- capacidade de buscar e adicionar múltiplos produtos da fixture do catálogo ao carrinho;
- alteração correta das quantidades com seletores `+` e `-`, alterando subtotais e valor total (se com permissão financeira);
- ocultação de valores e exibição de "Financeiro restrito" se a permissão `view_financial_metrics` for falsa;
- comportamento ao clicar em "Registrar Venda", confirmando a inserção em `pendingSalesProvider` e exibindo mensagem de sucesso e banner offline;
- ausência de crashes ou vazamento de estado ao zerar o carrinho ou alternar de tela.

### 4. Remocao do hero atual

Verificar:

- ausencia do hero textual antigo;
- ausencia do banner generico associado ao painel;
- preservacao da legibilidade geral da tela.

### 5. Remocao de copy generica

Verificar:

- ausencia dos textos explicitamente proibidos na spec;
- ausencia de subtitulos redundantes equivalentes;
- manutencao de titulos curtos e operacionais.

### 6. Card de ultima atualizacao

Verificar:

- presenca do card no painel;
- destaque claro para `updatedAtLabel`;
- texto curto e util.

### 7. Graficos permitidos

Verificar:

- uso apenas de `operational_goal_chart` e `stock_level_chart`;
- ausencia de graficos fora do escopo documental;
- dados fixture deterministas enquanto nao houver integracao real.

### 8. Responsividade e ausencia de overflow

Verificar:

- largura mobile compacta;
- `textScaler` alto;
- ausencia de `RenderFlex overflow`;
- legibilidade da top bar, drawer, cards e bottom navigation.

## Checklist de validacao visual

- [x] Topo funcional e legivel.
- [x] Drawer funcional e legivel.
- [x] Navegacao inferior com `Vendas` legivel.
- [x] Painel sem hero generico.
- [x] Painel sem copy ornamental.
- [x] Card de ultima atualizacao presente.
- [x] Graficos restritos ao escopo permitido.
- [x] Sem overflow em mobile compacta.
- [x] Sem overflow com texto aumentado.
- [ ] Direcao editorial aprovada pelo usuario.

## Observacao final

Os cenarios remotos e de persistencia continuam pendentes de specs e contratos
proprios.
