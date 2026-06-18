# Spec 009C - Revisão de Abertura

## Status

Planejada em 18 de junho de 2026. Não implementada.

## Escopo pretendido

- Implementação do `ProductSyncCollection` integrando com `GET /api/mobile/products` com paginação em lote e cursor checkpoints;
- Implementação do `DashboardSyncCollection` integrando com `GET /api/mobile/dashboard`;
- Registro de ambas as coleções no `SyncEngine`;
- Criação dos repositórios `DriftProductRepository` e `DriftDashboardRepository` com streams reativas;
- Configuração dos provedores de catálogo e dashboard do Riverpod com modificador `.autoDispose` para gerenciar a subscrição de Streams sem vazamentos de memória;
- Ajuste das telas de catálogo e painel para atualizar de forma transparente quando novos dados forem salvos localmente;
- Tratamento de estados de erro remotos e offline na interface (exibindo dados locais com banner de aviso);
- Testes cobrindo comportamento offline, ausência de preço e descarte seguro de streams.

## Gate de implementação

FECHADO.

Esta especificação define o consumo real das coleções de leitura do catálogo e painel e sua renderização reativa. Nenhuma escrita em arquivos do app está autorizada.

## Fontes consultadas

- `para mobile/00-contexto-operacional.md`;
- `para mobile/02-definicoes-de-interface.md` (telas, componentes);
- `para mobile/05-arquitetura-mobile.md` (primeira sincronização, remoções, background);
- `para mobile/06-registro-decisoes.md` (decisões MOB-001, UI-005, UI-006, Questão Aberta 5).

## Decisões já assumidas pelo pedido do usuário

- Os repositórios ocultam a origem dos dados da interface;
- A tela não acessa banco de dados diretamente;
- O carregamento da primeira sincronização é paginado e informável na interface.

## Pontos curtos a refinar antes de aprovar a spec

- Esclarecer o comportamento de carregamento: na primeira carga (bootstrap), um spinner cobrindo a tela com percentual/contagem de itens é adequado. Nas cargas de atualização (delta sync), o carregamento deve ser silencioso (background) ou exibir apenas uma pequena badge de sincronização no topo, sem bloquear o uso das listas da UI.

## Veredito

Especificação detalhada e alinhada com as diretrizes de reatividade do Riverpod e resiliência offline. O gate permanece fechado.
