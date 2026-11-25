# Spec 018 — Experiência comercial do vendedor e catálogo

Estado: `draft` | Classificação: `CRITICAL` | Data: 2026-11-25

## Objetivo
Reduzir esforço de vendas presenciais, com busca rápida, carrinho editável e retomada de trabalho em regiões remotas.

## Dependências e rastreabilidade
015, 016 (registro), 017 (componentes); 023 para preço negociado/Flex.

Issues existentes relacionadas: 6, 7, 8, 11. A relação é temática e muitos-para-muitos, não equivale a fechamento de issue.

## Escopo
- Central de trabalho do vendedor, clientes recentes, catálogo/picker paginado, estoque local, quantidades editáveis, rascunhos e revisão.
- Separar responsabilidades da SalesPage; perfis baseados em capacidades, não em nomes de cargos.

## Fora de escopo
- CRM completo, administração web, barcode obrigatório, preço negociado antes do contrato 023, atualização definitiva do estoque local.

## Requisitos e critérios de aceite
- **REQ-018-01** — Home vendedor como central de trabalho (Nova venda, Minhas vendas, Produtos, pendências); gerente com dashboard conforme capacidade na 019. Proteger redirects e deep links; usuário com ambas capacidades segue política de landing aprovada.
- **REQ-018-02** — Busca local por nome/SKU e cliente por nome/código/cidade, tolerância a acentos, debounce e queries paginadas/indexadas no SQLite; não carregar todo catálogo e renderizar todos resultados. Ordem determinística, cancelar resultado obsoleto e manter scroll.
- **REQ-018-03** — Exibir estoque/status e data da última atualização, incluir produtos sem estoque no catálogo conforme regra vigente; picker respeita disponibilidade e permissões; alertar quantidade acima do estoque local sem inventar confirmação ou bloquear regra ainda não contratada.
- **REQ-018-04** — Carrinho com entrada direta e +/-; validar quantidade no use case; permitir editar/remover e revisar antes do CTA. Preservar price=null como restrição e evitar mostrar valores a perfis sem permissão.
- **REQ-018-05** — Persistir rascunho por contexto, snapshot do cliente/itens, versão e atualização; retomada e descarte explícitos. Conversão rascunho→venda+outbox e marcação de consumo atômicas; recuperação após falha/reinício; não apagar outro contexto.
- **REQ-018-06** — Histórico local acessível em um toque; integração com 019 sem duplicar query. Recentes somente dados autorizados do mesmo contexto, sem ranking inventado.
- **REQ-018-07** — Meta piloto: venda com cinco produtos até 90s; busca p95 <=300ms em 10 mil produtos em aparelho de referência a definir, incluindo latência UI; medir baseline antes de impor gate.

## Decisões antes do freeze
- [ ] Quantidade máxima, comportamento de estoque insuficiente e regra de retenção/quantidade de rascunhos (proposta: um ativo por contexto no MVP).
- [ ] Política de landing híbrida e rotas; se recents/barcode não tiverem evidência de utilidade, ficam para iteração posterior.

## Fechamento
Contrato aprovado; tarefas e critérios atendidos; evidência de CI do SHA candidato, checks manuais quando aplicáveis e veredito de Mefisto. Jarvis registra fechamento somente após gate humano. Nenhum teste local sem autorização explícita atual.
