# Contract — Spec 017

Status: `DRAFT` | Version: 1 | Mode: `STANDARD (CRITICAL se alterar contrato funcional)` | Human approval: pendente

Execution mode: `SINGLE_WRITER` para schema, contratos, auth/sync/outbox e arquivos compartilhados. `PARALLEL_SAFE` apenas com ownership explícito e até dois writers em paths distintos.

## Objetivo
Fazer o aplicativo legível, previsível e rápido para profissionais acima de 40 anos, sem pressupor baixa capacidade técnica.

## Remote contract
Nenhum endpoint novo; widgets recebem modelos tipados e callbacks. Permissões/valores nulos e estoque soberano mantidos.

Campos, tipos, IDs, paginação, erros, permissões, tenant scope e idempotência que mudarem precisam de tabela de contrato auditada e SHA do backend antes de FROZEN. Ausência de contrato bloqueia a parte dependente, não autoriza inventar API.

## Local contract
Preferência de tema em armazenamento de configuração não sensível; nenhum dado financeiro persistido pelo componente. Estado de edição separado de valor validado; sem migration comercial.

## UI states
Loading/ready/empty/restricted/offline/refreshing/failure, erro inline, teclado sem bloquear CTA, focus order, tema claro/escuro, sem depender exclusivamente de cor.

## Allowed paths (propostos, não autorização de escrita)
- lib/shared/widgets/**, lib/app/theme/**, lib/shared/formatters/**
- lib/features/*/presentation/** somente superfícies coordenadas, test/shared/**, test/theme/**, test/goldens/**
- Sem acesso a Dio/Drift nem alteração de domínio nesta spec.

## Acceptance invariants
- **REQ-017-01** — Manter design system Spec 014, Instrument Sans, azul/navy, AppIcons/Lucide e estados existentes; reduzir densidade onde prejudicar leitura. Texto principal preferencialmente 16sp, contraste WCAG 4.5:1 para texto comum e 3:1 para grande/controles aplicáveis; toque >=48dp; 320dp e escala 2.0 sem overflow nos fluxos críticos.
- **REQ-017-02** — AppQuantityInput: teclado numérico, seleção/edição direta, +/−, validação inteira positiva e limites de contrato; aceitar estado vazio enquanto edita, não registrar inválido; atalhos opcionais avaliados com usuários. Campo deve permitir 1→100 sem 99 toques.
- **REQ-017-03** — AppMoneyInput/percentual: formato pt-BR, colagem, precisão em unidade monetária exata conforme 019/023; sem float como fonte de verdade; distinguir rascunho de valor validado.
- **REQ-017-04** — AppSearchField e pickers: label persistente, limpar busca, teclado/foco, resultados compreensíveis, estado vazio, seleção visível; sem gesto escondido como única ação.
- **REQ-017-05** — AppConnectivityStatus e AppPendingOperationCard usam estados tipados da 016/019, sem inventar online ou confirmação; CTA principal visível sem cobrir conteúdo.
- **REQ-017-06** — Persistir tema Sistema/Claro/Escuro como preferência não sensível; respeitar tema do SO. Remover jargões, fornecer Undo quando reversível e confirmação quando necessário.
- **REQ-017-07** — QA-014-16: TalkBack e ordem de foco em Android; teste qualitativo com 5–8 vendedores, incluindo pessoas 40+; não extrapolar a amostra. Registrar tempo, erros, necessidade de ajuda e feedback.

## Invariantes transversais
- Page → Controller → UseCase → Repository → DAO/API; domain sem Flutter, application sem Dio/Drift/JSON, presentation sem transporte/persistência.
- Contexto físico userId+tenantId; preço/estoque/autorização/confirmação remotos soberanos; demo isolado; price=null válido quando restrito.
- Nunca apagar pendências ou tratar intenção local como confirmada. Migration, ownership, rota, protocolo e contrato congelado só mudam via Change Request.
- Sem execução local de testes/analyze/format/build/codegen ou equivalentes sem autorização explícita. CI aprovado executa apenas comandos e gatilhos definidos na 015.

## Freeze checklist
- [ ] Aprovar hierarquia de tipografia e protótipos de quantidade/negociação com usuários.
- [ ] Confirmar se atalhos de quantidade são úteis; limites numéricos vêm do contrato, não de um valor arbitrário.
- [ ] Registrar SHA/base, paths definitivos, matriz de testes, riscos, responsável e aprovação humana.
