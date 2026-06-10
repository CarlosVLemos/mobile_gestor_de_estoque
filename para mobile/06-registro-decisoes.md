# Registro de Decisões Mobile

## Como usar

Este arquivo é a fonte canônica para decisões técnicas e de produto mobile.

Status:

- `aceita`: deve ser seguida;
- `proposta`: ainda pode mudar e não orienta implementação definitiva;
- `dependente`: aguarda contrato ou decisão externa;
- `substituída`: mantida apenas como histórico.

Mudanças em decisões aceitas devem explicar impacto, migração e documentos
afetados.

## Decisões aceitas

| ID | Decisão | Consequência |
| --- | --- | --- |
| MOB-001 | O app será local-first | A UI lê estado local; rede reconcilia dados |
| MOB-002 | Código organizado por feature e camadas | Mudanças permanecem isoladas e testáveis |
| MOB-003 | `application` não conhece Dio, Drift ou JSON | Casos de uso dependem de contratos |
| MOB-004 | Riverpod controla estado e injeção | Evitar singletons globais e facilitar testes |
| MOB-005 | Drift + SQLite é banco operacional | Pendências não são cache descartável |
| MOB-006 | Dio concentra comunicação HTTP | Transporte e erros ficam centralizados |
| MOB-007 | `go_router` controla navegação | Sessão e acesso usam redirecionamento declarativo |
| MOB-008 | Segredos ficam em armazenamento seguro | Tokens não entram em preferências ou logs |
| MOB-009 | Operações offline usam outbox | Reenvio preserva identidade estável |
| MOB-010 | Fonte remota é soberana | Estoque, permissão e confirmação local não são finais |
| MOB-011 | Sync principal ocorre em foreground | Background é otimização, não garantia |
| MOB-012 | Migração não apaga pendências | Atualizações preservam outbox e operações locais |
| MOB-013 | Imagens ficam no filesystem privado | Drift armazena apenas metadados |
| MOB-014 | Interface mantém identidade azul operacional | Mobile é extensão visual do produto web |
| MOB-015 | Permissões orientam UI, não substituem autorização | Ações continuam sujeitas à validação remota |
| MOB-016 | Contrato planejado não equivale a implementado | Mocks e flags deixam a diferença explícita |

## Decisões de interface aceitas

| ID | Decisão | Consequência |
| --- | --- | --- |
| UI-001 | Navegação primária usa bottom navigation | Destinos secundários ficam em `Mais` |
| UI-002 | Tabelas desktop viram cards/listas | Evitar rolagem horizontal como fluxo principal |
| UI-003 | Dashboard mantém hero escuro | Preserva a principal assinatura visual |
| UI-004 | Badges usam semântica consistente | Verde sucesso, amarelo atenção, vermelho erro |
| UI-005 | Dados locais continuam visíveis durante refresh | Loading não apaga conteúdo útil |
| UI-006 | `price = null` é estado restrito válido | Não apresentar erro de carregamento |
| UI-007 | Conflitos de sync exigem estado explícito | Não esconder ajuste, rejeição ou pendência |

## Decisões dependentes

| ID | Tema | Dependência | Regra até decidir |
| --- | --- | --- | --- |
| DEP-001 | Login mobile | Contrato remoto de autenticação | Preparar abstrações sem inventar endpoint |
| DEP-002 | Renovação de sessão | Política de token | Não implementar refresh presumido |
| DEP-003 | Venda offline | Contrato de intenção e confirmação | Modelar somente quando entrar no escopo |
| DEP-004 | Cursor de sync | Contrato remoto estável | Repositório esconde o formato do cursor |
| DEP-005 | Relatórios mobile | Endpoints e permissões | Não incluir como módulo funcional |
| DEP-006 | Área admin mobile | Escopo de produto | Manter apenas referência visual |

## Questões abertas

- O banco será único por instalação ou separado por usuário/empresa?
- Qual será a política de expiração e reautenticação?
- Quais coleções entram no primeiro bootstrap?
- Qual limite inicial de cache de imagens?
- Haverá localização além de `pt-BR`?
- Quais ambientes e URLs serão suportados no primeiro release?

Questões abertas não devem ser resolvidas silenciosamente durante uma feature.
Quando uma resposta for necessária, ela deve virar uma decisão aceita.

## Decisão substituída

| ID | Decisão antiga | Substituída por |
| --- | --- | --- |
| OLD-001 | `application` pode conhecer Dio, Drift e JSON | MOB-003 |
