# Contract — Spec 023

Status: `DRAFT` | Version: 1 | Mode: `CRITICAL / cross-repo` | Human approval: pendente

Execution mode: `SINGLE_WRITER` para schema, contratos, auth/sync/outbox e arquivos compartilhados. `PARALLEL_SAFE` apenas com ownership explícito e até dois writers em paths distintos.

## Objetivo
Permitir negociação de preços com crédito individual do vendedor, sem comprometer controle financeiro, auditoria, isolamento e operação offline.

## Remote contract
Nenhuma rota Flex confirmada. Maquiavel deve auditar Laravel dev, models/pedidos/pagamentos, política comercial e sale-intents; registrar contrato cross-repo com endpoints, schemas, versão, códigos, permissões, idempotência e transações antes do freeze. Web gerencia políticas; backend é autoridade financeira.

Campos, tipos, IDs, paginação, erros, permissões, tenant scope e idempotência que mudarem precisam de tabela de contrato auditada e SHA do backend antes de FROZEN. Ausência de contrato bloqueia a parte dependente, não autoriza inventar API.

## Local contract
Conceitos propostos flex_accounts, flex_transactions, flex_policies, flex_reservations (nomes não congelados). Mobile mantém snapshot tipado autorizado e estimativas/intenções versionadas em Drift; ledger oficial não é local. Valores exatos conforme 019; migrations e payloads antigos preservados.

## UI states
Carrinho editável com crédito disponível/a receber, preço negociado, desconto/acréscimo, saldo restante estimado, aviso offline, restrição financeira e revisão de ajuste; extrato próprio. Gerente administra via web; não expor conceitos de ledger ao vendedor.

## Allowed paths (propostos, não autorização de escrita)
- Mobile: lib/features/sales/**, lib/features/flex/** (proposto), lib/core/database/**, lib/shared/widgets/** em coordenação
- Backend/web: CarlosVLemos/gestor_de_estoque, paths a identificar e contratar após auditoria; nenhuma escrita cross-repo automática
- test/features/**, test/core/database/**; testes transacionais backend e integração cross-repo em CI.

## Acceptance invariants
- **REQ-023-01** — Baseline proposto: conta individual por vendedor+tenant, saldo inicial zero; diferença positiva do preço-base autorizado gera crédito provisionado; diferença negativa consome disponível. Quantidade multiplica diferença; somar diferenças elegíveis do pedido e compensar itens se política permitir. Promoção empresarial não debita automaticamente vendedor.
- **REQ-023-02** — Fórmula conceitual em centavos: delta_i = (preço negociado − base elegível) × quantidade; delta líquido = soma de itens elegíveis; crédito provisionado = max(delta,0); compromisso = max(−delta,0). Limites por item/produto/cliente e preço mínimo aplicam-se antes de compensação. Base, regra de arredondamento e versionamento de política calculados pelo servidor; 100% da diferença é hipótese a aprovar.
- **REQ-023-03** — Provisão só liberada após evento de pagamento e conclusão manual conforme regra anterior discutida, a confirmar no contrato real; definir pagamentos parciais, devoluções e cancelamentos. Comprometer saldo no aceite do servidor; consumir ou liberar conforme ciclo financeiro congelado. Não liberar crédito de pedido ainda offline.
- **REQ-023-04** — Ledger append-only com tipos provisão/liberação/reserva/consumo/liberação de reserva/estorno/ajuste auditado; saldo derivado de lançamentos ou projeção transacional reconciliável. Uma operação não debita duas vezes; chaves únicas por tenant, vendedor, pedido/evento e tipo; locks/isolamento no banco e transação única com venda.
- **REQ-023-05** — Cancelamento/devolução gera movimentação compensatória, não edição de histórico; se crédito já usado, dívida excepcional bloqueia novos descontos até regularização; não permitir saldo negativo por nova concessão. Ajuste gerente exige permissão, justificativa, autor e trilha; sem transferências ou expiração automática inicialmente, sujeitos a aprovação.
- **REQ-023-06** — Offline v1/v2: consultar saldo e política com versão/freshness; permitir negociação como intenção estimada somente se política aprovada, descontar compromissos locais para orientação; servidor revalida saldo, base, limites e estoque. Concorrência em dois dispositivos não pode gastar mesmo saldo duas vezes. Se insuficiente, devolver revisão explícita, nunca mudar preço acordado em silêncio. Reserva garantida por dispositivo v3 fora do MVP.
- **REQ-023-07** — UX: preço base e negociado por item, editar valor ou percentual (um derivado do outro), impacto da negociação e saldo estimado; mostrar disponível e a receber separadamente; extrato simples e gerência web para políticas. Não revelar preço/saldo a perfil sem permissão explícita.
- **REQ-023-08** — API precisa versionar payload e política, suportar replay da venda antiga sem Flex, revisão/aceite, erros tipados e snapshot de saldo; não inventar nomes de rotas/permissões. Compatibilidade com clientes sem Flex e feature desativada; servidor ignora/recusa alteração não autorizada.

## Invariantes transversais
- Page → Controller → UseCase → Repository → DAO/API; domain sem Flutter, application sem Dio/Drift/JSON, presentation sem transporte/persistência.
- Contexto físico userId+tenantId; preço/estoque/autorização/confirmação remotos soberanos; demo isolado; price=null válido quando restrito.
- Nunca apagar pendências ou tratar intenção local como confirmada. Migration, ownership, rota, protocolo e contrato congelado só mudam via Change Request.
- Sem execução local de testes/analyze/format/build/codegen ou equivalentes sem autorização explícita. CI aprovado executa apenas comandos e gatilhos definidos na 015.

## Freeze checklist
- [ ] Confirmar preço-base (padrão/atacado/outro), percentual gerado, limites e preço mínimo, elegibilidade de produtos/clientes, compensação intra-pedido e promoção.
- [ ] Confirmar ciclo de compromisso/consumo/liberação, pagamento parcial, conclusão manual, estorno, saldo devedor, vencimento e ajustes gerenciais.
- [ ] Confirmar negociação offline sujeita a revisão, inclusão no primeiro release e política de divulgação de preço/saldo. Verificar documentação e implementação Laravel dev: referências de mercado não são contrato do Arara.
- [ ] Registrar SHA/base, paths definitivos, matriz de testes, riscos, responsável e aprovação humana.
