# Spec 008B - Revisão de Abertura

## Status

Planejada em 18 de junho de 2026. Não implementada.

## Escopo pretendido

- Implementação do `DatabaseFactory` para abrir caminhos de arquivos SQLite nomeados dinamicamente (`app_database_u_${userId}_t_${tenantId}.db`);
- Instanciação tardia (lazy) da conexão Drift vinculada à autenticação ativa do usuário;
- Criação do `DataPurgeService` para limpeza estruturada de dados pós-logout;
- Estabelecimento do sequenciamento estrito de expurgo de dados antes de redirecionar a navegação;
- Preservação da fila Outbox de forma física para cada usuário, permitindo o logout seguro sem perda de transações offline pendentes;
- Alerta visual opcional se o usuário deslogar com pendências de envio;
- Testes cobrindo múltiplos logins sequenciais com caminhos físicos isolados no SQLite.

## Gate de implementação

FECHADO.

Esta especificação serve como guia de isolamento físico e purificação do banco. Nenhum código no aplicativo está liberado para escrita.

## Fontes consultadas

- `para mobile/00-contexto-operacional.md`;
- `para mobile/05-arquitetura-mobile.md` (concorrência e segurança local);
- `para mobile/06-registro-decisoes.md` (decisões MOB-005, MOB-012, MOB-013, Questão Aberta 1).

## Decisões já assumidas pelo pedido do usuário

- Os bancos de dados locais são separados por par de usuário/tenant;
- Deslogar fecha ativamente as conexões do Drift para evitar corrupção de arquivos;
- Estados de Riverpod em memória são completamente invalidados no logout.

## Pontos curtos a refinar antes de aprovar a spec

- Esclarecer o comportamento de limpeza: a limpeza de imagens temporárias deve atingir apenas o cache do usuário ativo, preservando outras imagens que possam ser úteis caso o mesmo dispositivo seja operado offline com frequência por outros membros da mesma organização.

## Veredito

Especificação detalhada e em total conformidade com a arquitetura local-first. O gate permanece fechado até aprovação final de implementação.
