# Contract — Spec 018

Status: `DRAFT` | Version: 1 | Mode: `CRITICAL` | Human approval: pendente

Execution mode: `SINGLE_WRITER` para schema, contratos, auth/sync/outbox e arquivos compartilhados. `PARALLEL_SAFE` apenas com ownership explícito e até dois writers em paths distintos.

## Objetivo
Reduzir esforço de vendas presenciais, com busca rápida, carrinho editável e retomada de trabalho em regiões remotas.

## Remote contract
Usar contrato validado de clientes, produtos e sale-intents; IDs Product inteiro normalizado, Category UUID, clientes conforme contrato. Não criar endpoint para busca local; confirmar regras de disponibilidade/quantidade com Maquiavel.

Campos, tipos, IDs, paginação, erros, permissões, tenant scope e idempotência que mudarem precisam de tabela de contrato auditada e SHA do backend antes de FROZEN. Ausência de contrato bloqueia a parte dependente, não autoriza inventar API.

## Local contract
Adicionar rascunhos e índices por migration versionada após 009A schema v5; coordenar número de versão com 016/019/023. Repositório retorna páginas/modelos tipados, sem Drift na UI; queries indexadas conforme medição; integridade e atomicidade preservadas.

## UI states
Nova venda, seleção cliente, busca de produtos, carrinho, revisar, confirmar localmente, retomada/descarte. CTA ocupado, mensagens de estoque local, estados vazios, offline e restrito; nenhum módulo fictício.

## Allowed paths (propostos, não autorização de escrita)
- lib/features/sales/**, lib/features/clients/**, lib/features/catalog/**
- lib/app/router/** e shell somente para landing/rotas congeladas; lib/core/database/** para schema/índices aprovados
- test/features/**, test/core/database/**, test/app/**; design compartilhado com 017, ownership por arquivo.

## Acceptance invariants
- **REQ-018-01** — Home vendedor como central de trabalho (Nova venda, Minhas vendas, Produtos, pendências); gerente com dashboard conforme capacidade na 019. Proteger redirects e deep links; usuário com ambas capacidades segue política de landing aprovada.
- **REQ-018-02** — Busca local por nome/SKU e cliente por nome/código/cidade, tolerância a acentos, debounce e queries paginadas/indexadas no SQLite; não carregar todo catálogo e renderizar todos resultados. Ordem determinística, cancelar resultado obsoleto e manter scroll.
- **REQ-018-03** — Exibir estoque/status e data da última atualização, incluir produtos sem estoque no catálogo conforme regra vigente; picker respeita disponibilidade e permissões; alertar quantidade acima do estoque local sem inventar confirmação ou bloquear regra ainda não contratada.
- **REQ-018-04** — Carrinho com entrada direta e +/-; validar quantidade no use case; permitir editar/remover e revisar antes do CTA. Preservar price=null como restrição e evitar mostrar valores a perfis sem permissão.
- **REQ-018-05** — Persistir rascunho por contexto, snapshot do cliente/itens, versão e atualização; retomada e descarte explícitos. Conversão rascunho→venda+outbox e marcação de consumo atômicas; recuperação após falha/reinício; não apagar outro contexto.
- **REQ-018-06** — Histórico local acessível em um toque; integração com 019 sem duplicar query. Recentes somente dados autorizados do mesmo contexto, sem ranking inventado.
- **REQ-018-07** — Meta piloto: venda com cinco produtos até 90s; busca p95 <=300ms em 10 mil produtos em aparelho de referência a definir, incluindo latência UI; medir baseline antes de impor gate.

## Invariantes transversais
- Page → Controller → UseCase → Repository → DAO/API; domain sem Flutter, application sem Dio/Drift/JSON, presentation sem transporte/persistência.
- Contexto físico userId+tenantId; preço/estoque/autorização/confirmação remotos soberanos; demo isolado; price=null válido quando restrito.
- Nunca apagar pendências ou tratar intenção local como confirmada. Migration, ownership, rota, protocolo e contrato congelado só mudam via Change Request.
- Sem execução local de testes/analyze/format/build/codegen ou equivalentes sem autorização explícita. CI aprovado executa apenas comandos e gatilhos definidos na 015.

## Freeze checklist
- [ ] Quantidade máxima, comportamento de estoque insuficiente e regra de retenção/quantidade de rascunhos (proposta: um ativo por contexto no MVP).
- [ ] Política de landing híbrida e rotas; se recents/barcode não tiverem evidência de utilidade, ficam para iteração posterior.
- [ ] Registrar SHA/base, paths definitivos, matriz de testes, riscos, responsável e aprovação humana.
