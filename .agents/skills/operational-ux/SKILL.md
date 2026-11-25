---
name: operational-ux
description: Use para projetar ou implementar fluxos comerciais de vendedores/gerentes no mobile, como busca, carrinho, quantidade, formulários, estados offline e acessibilidade. Não use para decidir política financeira ou criar telas administrativas complexas.
---
# UX operacional
Leia `docs/product/product-principles.md`, `docs/design/operational-design-system.md` e spec relevante. Preserve decisões visuais aceitas da 014 até mudança aprovada.

- Vendedor prioriza Nova venda, produtos/clientes e pendências; gerente prioriza indicadores autorizados. Não invente dados, ações ou módulos.
- Busca por nome/SKU/código/cidade conforme contrato; paginação local, cancelamento de consulta obsoleta e tolerância a acento quando contratado. Não filtrar toda coleção na UI se volume exige DAO paginado.
- Quantidade permite entrada numérica direta e +/-; validar inteiro positivo conforme domínio, mensagens claras, teclado não bloqueia CTA. Preço/percentual exigem escala/parse pt-BR conforme contrato.
- Touch targets 48dp, contraste 4,5:1 texto comum, 320dp/text scaling 200% como metas de fluxo crítico; rótulos, semântica e cor não exclusiva. Goldens não provam TalkBack/usabilidade.
- Offline preserva cache válido; diferencie pendente, confirmado, revisão e restrição. Nunca prometer estoque/saldo remoto com snapshot antigo.
- Testes focados: digitação de 100, vazio/inválido, 320dp, escala alta, tema, teclado, restrição e falha. Escreva testes, não execute sem autorização.
