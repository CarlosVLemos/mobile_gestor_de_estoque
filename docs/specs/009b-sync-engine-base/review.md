# Spec 009B - Revisão de Abertura

## Status

Planejada em 18 de junho de 2026. Não implementada.

## Escopo pretendido

- Implementação do `SyncLock` como semáforo lógico em memória e persistência para controle concorrente;
- Liberação obrigatória do `SyncLock` em bloco `finally` para evitar travamentos permanentes em falhas;
- Definição da abstração `SyncCollection` com ciclo de vida estruturado de 4 passos (obter cursor, baixar remetente, salvar local, atualizar cursor);
- Implementação do orquestrador central `SyncEngine` que gerencia a fila de coleções registradas;
- Exposição reativa do estado de sync global (`syncStateProvider` do Riverpod);
- Criação do `SyncLifecycleObserver` para monitorar o estado `resumed` do app;
- Mecanismo de cooldown/throttling de 5 minutos para sincronizações automáticas pós-foco;
- Testes unitários para locks de concorrência, recuperação de erros e lógica de throttling.

## Gate de implementação

FECHADO.

Esta especificação define o motor central de reconciliação de dados. Nenhuma codificação de comportamento está liberada no app.

## Fontes consultadas

- `para mobile/00-contexto-operacional.md`;
- `para mobile/05-arquitetura-mobile.md` (motor de sincronização, checkpoints, gatilhos, concorrência);
- `para mobile/06-registro-decisoes.md` (decisões MOB-001, MOB-011).

## Decisões já assumidas pelo pedido do usuário

- Sincronização concorrente de coleções é proibida;
- Erros de rede abrem a trava logicamente;
- O relógio local não define cursores remotamente.

## Pontos curtos a refinar antes de aprovar a spec

- O cooldown de 5 minutos deve ser calculado em milissegundos e persistido em variável em memória. Não há necessidade de gravação em storage seguro, bastando o ciclo de vida da instância ativa do app.

## Veredito

Especificação refinada técnica e operacionalmente, cobrindo o controle estrito de concorrência e cooldown. O desenvolvimento continua bloqueado pelo gate.
