---
name: financial-flex-contract
description: Use ao auditar ou implementar contratos de Flex, crédito comercial, descontos, preço-base, valores confirmados e estornos. Não use para inventar política financeira, endpoint, saldo ou regra de pagamento.
---
# Flex e integridade financeira
Leia spec 023 e 019, `maquiavel-api-contract`; todas as regras novas dependem de aprovação e auditoria do Laravel. Não trate o draft como implementação.

- Servidor soberano; use precisão exata em centavos/decimal conforme contrato, snapshot de preço-base/política e cálculo determinístico. `price=null` representa restrição.
- Distinguir crédito provisionado, disponível, reservado, consumido e estornado conforme contrato. Ledger auditável e transação atômica com venda; idempotência, locks/constraints e tenant/seller scope.
- Condição proposta: acréscimo libera crédito após pagamento e conclusão; desconto compromete saldo em aceite; compensação e políticas configuráveis ainda precisam de freeze. Não confundir crédito comercial com desconto por vencimento.
- Offline mostra estimativa e pendência, nunca garante saldo compartilhado; conflito exige revisão explícita, sem alteração silenciosa de preço. Se reservas por dispositivo forem necessárias, novo contrato.
- Casos de teste: duas vendas concorrentes, replay timeout, pagamento repetido, cancelamento após consumo, saldo insuficiente, alteração de política, permissão restrita, reconciliação offline. Nenhuma execução local sem autorização.
