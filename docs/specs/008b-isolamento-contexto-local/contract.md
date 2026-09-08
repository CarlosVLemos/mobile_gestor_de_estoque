# Contrato 008B — Contexto local por usuário/tenant

## Status

FROZEN — autorizado pela solicitação de implementação da Spec 008B.

## Limites

- Não há endpoint, payload ou contrato remoto novo nesta entrega.
- O contexto local válido é o par `userId` + `tenantId` retornado pela sessão
  autenticada já existente.
- O banco físico é nomeado
  `app_database_u_<userId>_t_<tenantId>.db`, com cada segmento codificado para
  uso seguro em filename e preservando determinismo.

## Lifecycle obrigatório

1. A fábrica não abre banco sem um `LocalContext` autenticado.
2. A troca de contexto exige o fechamento concluído do banco anterior.
3. Logout e expiração aguardam: parar sync, fechar Drift, remover somente o
   cache do contexto, invalidar estado em memória e então alterar o estado de
   autenticação que redireciona para `/login`.
4. O arquivo SQLite nunca é removido pelo purge. Entradas pendentes de
   `sync_outbox` permanecem no mesmo arquivo e podem ser reencontradas no
   próximo login do mesmo par.

## Fora de escopo

O protocolo de envio, sync incremental e criação de vendas na outbox pertencem
às Specs 009/010 e não são introduzidos por este contrato.
