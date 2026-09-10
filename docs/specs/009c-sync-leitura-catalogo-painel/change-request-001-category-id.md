# Change Request 009C-001 — ID UUID de categoria

Status: `APPROVED — IMPLEMENTED — STATIC ANALYSIS PENDING`
Data: 2026-09-09
Spec afetada: `009C — Sync de leitura do catálogo e painel`
Origem: auditoria forense pós-entrega
Tipo: correção contratual pontual
Spec de execução: [`../012-correcao-ids-categoria-catalogo/spec.md`](../012-correcao-ids-categoria-catalogo/spec.md)

## Razão do Change Request

O contrato da 009C está congelado e sua entrega foi encerrada. A auditoria confirmou que o backend usa UUID em `Category`, mas o mobile aplica o mesmo parser numérico `_requiredRemoteId()` a Product, Category e Tombstone. Isso rejeita uma categoria válida antes que a página de produtos seja materializada.

Alterar silenciosamente o contrato congelado apagaria a diferença entre a entrega originalmente validada e a correção posterior. Este CR registra a reabertura estritamente necessária.

## Evidência confirmada

- o model backend `Category` usa Laravel `HasUuids`;
- o model backend `Product` mantém ID numérico;
- `Product.category_id` referencia `Category`;
- o datasource mobile auditado antes da correção usava `_requiredRemoteId()` numérico para Product, Category e Tombstone;
- a representação interna de IDs no catálogo já é `String`;
- o schema Drift usa texto para o ID de categoria e para a FK de categoria do produto.

## Mudança solicitada

Substituir o uso genérico do validador numérico por regras semânticas separadas:

| Campo remoto | Regra corrigida no mobile |
| --- | --- |
| `data[].id` de Product | aceitar inteiro backend e materializar `String` numérica |
| `data[].category.id` | aceitar UUID backend e preservar como `String` UUID |
| `data[].category` | aceitar `null` |
| `tombstones[].id` de Product | aceitar inteiro backend e materializar `String` numérica |

A mudança não autoriza aceitar qualquer `String` em todos os IDs. Product e Tombstone continuam sujeitos à regra numérica. A validação de Category deve ser própria e compatível com UUID real do backend.

## Limites

- não alterar endpoints, paginação, checkpoint ou semântica de tombstone;
- não alterar IDs de Product;
- não alterar o contrato de persistência além do necessário para aceitar Category UUID;
- não criar migração Drift se a auditoria de implementação confirmar que as colunas `String`/texto atuais já atendem ao contrato;
- não ampliar para vendas, criação/edição de catálogo ou outras entidades UUID.

## Reabertura pontual da 009C

Após aprovação humana deste CR:

1. registrar a 009C como `in_progress — CR-009C-001`, preservando o histórico da entrega original;
2. congelar o contrato da Spec 012;
3. implementar somente os paths autorizados pela 012;
4. executar o perfil focado de QA definido em `012/test.md`, mediante autorização explícita do usuário;
5. registrar evidências em `012/validation-result.md` e neste CR;
6. obter veredito técnico de Mefisto;
7. se o veredito for `PASS`, marcar o CR como `ACCEPTED`, registrar o adendo no histórico da 009C e devolver a 009C a `done`/validada;
8. se houver `FAIL` ou `PARTIAL`, manter o CR aberto e a reabertura explícita até correção e nova validação autorizada.

## Aprovações

- [x] Jarvis confirma escopo e paths na preparação documental de 2026-09-09.
- [x] Maquiavel confirma o contrato remoto com base na auditoria forense concluída.
- [x] Missão de estabilização autoriza o CR e o congelamento da Spec 012 em 2026-09-09.
- [ ] Mefisto emite veredito final após `flutter analyze --no-pub`; testes focados e suíte completa já passaram.

O contrato histórico da 009C foi preservado; esta mudança permanece rastreada exclusivamente por este CR e pela Spec 012.
