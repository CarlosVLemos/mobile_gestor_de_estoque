# Contexto Operacional Mobile

## Para que serve

Este é o primeiro documento de contexto do Arara-Gastos Mobile. Ele resume somente o estado comprovado e aponta onde buscar detalhes sem reler toda a documentação.

## Estado atual

- Fundação Flutter materializada em `lib/`, com Riverpod, `go_router`, tema claro/escuro, shell operacional e organização por feature/camada.
- Shell principal com Painel, Produtos, Vendas e Mais.
- Spec 007 concluída: Dio, redaction, erros tipados, `Result` e fronteira de rede.
- Spec 008 concluída e mergeada na `dev`: autenticação Sanctum real, `flutter_secure_storage`, login, logout, `/api/mobile/me`, troca obrigatória de senha, restauração de sessão, sinal global de `401`, guards e `API_BASE_URL` configurável por `--dart-define`.
- Dashboard, catálogo e vendas ainda contêm fixtures/estado local e não constituem fluxo local-first real completo.
- Drift, sync incremental, outbox persistente e isolamento definitivo do banco por usuário/tenant continuam como próximas entregas.
- O backend mobile já possui contratos reais para auth/perfil, dashboard, produtos e `sale-intents`; contratos antigos do mobile devem ser auditados novamente antes de 009A/009B/009C/010.
- Venda real depende de cliente remoto válido; antes de 009C/010 deve existir/ser confirmado contrato mobile de clientes no backend.

Documentação descreve intenção; código, contrato implementado, testes e evidências comprovam estado real.

## Sequência estrutural atual

```text
007  Core de rede                      ✅
008  Sessão/autenticação                ✅
008B Contexto/isolamento                próximo
009A Drift/schema/migrações             pendente
009B Sync incremental                   pendente
009C Dashboard/produtos/clientes reais  pendente
010  Outbox + sale-intents              pendente
Release/VPS/APK                         pendente
```

## Produto

O app é uma extensão operacional mobile do Arara-Gastos.

Prioridades:

1. identidade, sessão e contexto user/tenant;
2. persistência local segura;
3. dashboard e catálogo reais local-first;
4. operação resiliente a conexão instável;
5. vendas com outbox, idempotência e reconciliação;
6. APK funcional conectado à API implantada.

## Decisões fixas

- Flutter para Android/iOS.
- Arquitetura local-first.
- Organização por feature e camada.
- Riverpod para estado/injeção.
- Drift + SQLite como banco operacional local.
- Dio para HTTP.
- `go_router` para navegação.
- token em armazenamento seguro.
- Outbox para ações offline relevantes.
- servidor soberano para estoque, autorização e confirmação.
- foreground sync como mecanismo principal; background como apoio.
- identidade visual azul operacional.

Detalhes: `06-registro-decisoes.md`.

## Invariantes

- `Page -> Controller -> UseCase -> Repository -> DAO/API`.
- `presentation` não acessa Dio ou Drift.
- `application` não conhece Dio, Drift, JSON ou widgets.
- `domain` não conhece Flutter, persistência ou transporte.
- pending local != confirmed remoto.
- tenant/user nunca compartilham dados locais indevidamente.
- `price = null` pode ser restrição válida.
- produto sem estoque pode continuar visível conforme contrato.
- permissão visual não substitui autorização remota.
- falha de migração não autoriza apagar banco/outbox.
- contrato planejado não pode ser consumido como existente.

## Estados de UI

Use o subconjunto aplicável:

- initial;
- loading;
- ready;
- refreshing;
- empty;
- offline;
- restricted;
- syncing;
- failure.

Dados locais podem permanecer visíveis durante refresh/falha quando a feature for local-first.

## Como escolher o que ler

Use `.agents/task-routing.md`. Não leia toda a pasta `para mobile/` por padrão.

- arquitetura/dependências: `05-arquitetura-mobile.md` + `06-registro-decisoes.md`;
- negócio/offline: `04-regras-e-necessidades-mobile.md`;
- interface: `02-definicoes-de-interface.md`;
- integração: `03-endpoints-mobile.md` + auditoria do backend real;
- processo/agentes: `08-processo-de-trabalho.md` + `.agents/`;
- MCPs: `07-uso-de-mcps.md`.

## Próximo caminho crítico

1. 008B: lifecycle de contexto user/tenant.
2. 009A: Drift e migrações seguras.
3. 009B/009C: sync e leituras reais, incluindo clientes.
4. 010: outbox + protocolo real de `sale-intents`.
5. release: ambiente, INTERNET/HTTPS, VPS, APK e smoke E2E.

A auditoria do endpoint mobile de clientes pode seguir em paralelo antes de 009C/010.

## Definição curta de pronto

Entrega pronta respeita boundaries, contrato real, estados relevantes, persistência/isolamento quando aplicável, testes proporcionais ao risco e gate de Mefisto. Em trabalho CRITICAL, o contrato precisa estar FROZEN antes da implementação dependente.
