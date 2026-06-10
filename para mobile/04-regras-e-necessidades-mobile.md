# Regras e Necessidades Mobile

## Necessidades do app mobile

O app mobile precisa lidar com quatro grupos de responsabilidade:

### 1. Contexto e acesso

- descobrir quem e o usuario autenticado;
- descobrir em qual tenant ele esta operando;
- descobrir quais features do tenant estao ativas;
- descobrir quais permissoes reais ele tem.

### 2. Consulta operacional

- mostrar dashboard resumido;
- listar produtos mesmo quando sem estoque;
- diferenciar disponibilidade para venda de simples existencia no catalogo;
- abrir o dashboard web quando a leitura mobile nao for suficiente.

### 3. Seguranca e consistencia

- nunca enviar `tenant_id` como verdade de dominio;
- nunca confiar em permissao inferida localmente;
- nunca assumir que preco sempre vira preenchido;
- tratar todos os dados do servidor como tenant-scoped.

### 4. Evolucao futura

- preparar cache local e sincronizacao incremental;
- suportar venda offline sem baixar estoque localmente como verdade;
- suportar reenvio idempotente de intencoes.

## Regras de negocio herdadas do sistema

## 1. Multi-tenant obrigatorio

- nenhum dado de um tenant pode aparecer para outro;
- IDs de categoria, produto, cliente e venda devem ser validados dentro do tenant atual;
- o app nao deve montar requests presumindo tenant unico.

## 2. Tenant bloqueado corta operacao

- se o tenant estiver inativo ou suspenso, o acesso operacional deve falhar;
- isso nao e uma regra visual, e uma regra de backend.

## 3. Feature flag bloqueia modulo

- o modulo de catalogo depende da feature `catalog`;
- se a feature estiver desativada, o app deve tratar `403` como indisponibilidade funcional do modulo.

## 4. Permissao backend sempre vence

- esconder botao no app nao substitui autorizacao;
- o backend continua sendo a barreira real para produtos, vendas e relatorios.

## 5. Estoque e transacional

- estoque real nao pode ser decidido pelo app;
- produto sem saldo pode aparecer na lista, mas isso nao garante venda;
- qualquer venda futura precisa ser confirmada pelo servidor em transacao.

## 6. Preco e dado sensivel

- o app deve mostrar preco somente quando o servidor permitir;
- `price = null` deve ser tratado como restricao valida, nao como defeito de payload.

## Regras planejadas para a futura venda offline

Baseadas na `Spec 22`.

### Fluxo esperado

1. O app registra localmente uma intencao de venda.
2. Ao sincronizar, envia `client_request_id`, `client_id`, `sold_at` e itens.
3. O servidor compara a solicitacao com o estoque real.
4. Se houver saldo suficiente, cria a venda.
5. Se houver saldo parcial, responde com proposta ajustada.
6. O app pede aceite explicito do vendedor.
7. O servidor revalida o estoque antes da confirmacao final.

### Regras obrigatorias

- nunca permitir estoque negativo;
- nunca criar venda duplicada ao reenviar a mesma intencao;
- nunca criar venda definitiva enquanto a proposta estiver aguardando confirmacao;
- sempre recalcular se o estoque mudar entre proposta e aceite.

## Contratos futuros que o app precisa prever

### Login por token

O mobile deve ser preparado para um fluxo futuro de token `Bearer` com Sanctum.

### Idempotencia

Cada venda offline futura deve carregar `client_request_id` unico por tenant e usuario.

### Sincronizacao incremental

O catalogo deve continuar preparado para sync por `updated_since`.

### Confirmacao segura

Quando existir proposta ajustada, a confirmacao futura deve depender de `intent_id` e `confirmation_token`.

## Decisoes praticas para o time mobile

- construir a navegacao com base em `features` e `permissions` vindos de `/api/mobile/me`;
- tratar dashboard como payload modular, nao como tela unica rigidamente acoplada;
- armazenar `updated_at` dos produtos para sync incremental;
- encapsular tratamento de `401`, `403`, `422` e `429` em uma camada de API compartilhada;
- preparar a modelagem local para `sale-intent`, mesmo antes do endpoint existir.
