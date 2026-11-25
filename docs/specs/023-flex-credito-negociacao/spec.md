# Spec 023 — Flex — Crédito de negociação comercial

Estado: `draft` | Classificação: `CRITICAL / cross-repo` | Data: 2026-11-25

## Objetivo
Permitir negociação de preços com crédito individual do vendedor, sem comprometer controle financeiro, auditoria, isolamento e operação offline.

## Dependências e rastreabilidade
015, 016, 017, 018, 019, 020; antes de 021 somente se requisito de lançamento.

Issues existentes relacionadas: Novo escopo de negócio; relaciona 2, 10, 12 e 7. A relação é temática e muitos-para-muitos, não equivale a fechamento de issue.

## Escopo
- Ledger transacional no Laravel, políticas de preços, saldo disponível/provisionado/comprometido, negociação no carrinho, extrato, ajustes gerenciais e reconciliação offline.
- Modelo de mercado como referência (Mercos/Sankhya), simplificado para vendedores; web para políticas e administração.

## Fora de escopo
- Crédito ao cliente, cashback, empréstimo, desconto por pagamento antecipado/vencimento (regra separada se solicitada), microsserviço obrigatório, reserva por dispositivo no MVP, transferência entre vendedores sem decisão.

## Requisitos e critérios de aceite
- **REQ-023-01** — Baseline proposto: conta individual por vendedor+tenant, saldo inicial zero; diferença positiva do preço-base autorizado gera crédito provisionado; diferença negativa consome disponível. Quantidade multiplica diferença; somar diferenças elegíveis do pedido e compensar itens se política permitir. Promoção empresarial não debita automaticamente vendedor.
- **REQ-023-02** — Fórmula conceitual em centavos: delta_i = (preço negociado − base elegível) × quantidade; delta líquido = soma de itens elegíveis; crédito provisionado = max(delta,0); compromisso = max(−delta,0). Limites por item/produto/cliente e preço mínimo aplicam-se antes de compensação. Base, regra de arredondamento e versionamento de política calculados pelo servidor; 100% da diferença é hipótese a aprovar.
- **REQ-023-03** — Provisão só liberada após evento de pagamento e conclusão manual conforme regra anterior discutida, a confirmar no contrato real; definir pagamentos parciais, devoluções e cancelamentos. Comprometer saldo no aceite do servidor; consumir ou liberar conforme ciclo financeiro congelado. Não liberar crédito de pedido ainda offline.
- **REQ-023-04** — Ledger append-only com tipos provisão/liberação/reserva/consumo/liberação de reserva/estorno/ajuste auditado; saldo derivado de lançamentos ou projeção transacional reconciliável. Uma operação não debita duas vezes; chaves únicas por tenant, vendedor, pedido/evento e tipo; locks/isolamento no banco e transação única com venda.
- **REQ-023-05** — Cancelamento/devolução gera movimentação compensatória, não edição de histórico; se crédito já usado, dívida excepcional bloqueia novos descontos até regularização; não permitir saldo negativo por nova concessão. Ajuste gerente exige permissão, justificativa, autor e trilha; sem transferências ou expiração automática inicialmente, sujeitos a aprovação.
- **REQ-023-06** — Offline v1/v2: consultar saldo e política com versão/freshness; permitir negociação como intenção estimada somente se política aprovada, descontar compromissos locais para orientação; servidor revalida saldo, base, limites e estoque. Concorrência em dois dispositivos não pode gastar mesmo saldo duas vezes. Se insuficiente, devolver revisão explícita, nunca mudar preço acordado em silêncio. Reserva garantida por dispositivo v3 fora do MVP.
- **REQ-023-07** — UX: preço base e negociado por item, editar valor ou percentual (um derivado do outro), impacto da negociação e saldo estimado; mostrar disponível e a receber separadamente; extrato simples e gerência web para políticas. Não revelar preço/saldo a perfil sem permissão explícita.
- **REQ-023-08** — API precisa versionar payload e política, suportar replay da venda antiga sem Flex, revisão/aceite, erros tipados e snapshot de saldo; não inventar nomes de rotas/permissões. Compatibilidade com clientes sem Flex e feature desativada; servidor ignora/recusa alteração não autorizada.

## Decisões antes do freeze
- [ ] Confirmar preço-base (padrão/atacado/outro), percentual gerado, limites e preço mínimo, elegibilidade de produtos/clientes, compensação intra-pedido e promoção.
- [ ] Confirmar ciclo de compromisso/consumo/liberação, pagamento parcial, conclusão manual, estorno, saldo devedor, vencimento e ajustes gerenciais.
- [ ] Confirmar negociação offline sujeita a revisão, inclusão no primeiro release e política de divulgação de preço/saldo. Verificar documentação e implementação Laravel dev: referências de mercado não são contrato do Arara.

## Fechamento
Contrato aprovado; tarefas e critérios atendidos; evidência de CI do SHA candidato, checks manuais quando aplicáveis e veredito de Mefisto. Jarvis registra fechamento somente após gate humano. Nenhum teste local sem autorização explícita atual.
