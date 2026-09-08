# Tasks — Spec 009C

Atualizado em 8 de setembro de 2026. Marcação de código escrito não é aceite.

## Implementação escrita

- [x] Fonte HTTP de produtos respeitando `per_page <= 50` e envelope documentado.
- [x] Coleção de produtos com páginas sequenciais e upsert transacional.
- [x] Replay de janela em nova execução, sem cursor/watermark presumido.
- [x] Fonte/coleção do dashboard com decoder explícito obrigatório.
- [x] Tabelas e substituição transacional de KPIs, alertas e snapshot local.
- [x] Repositórios Drift reativos e casos de uso de observação.
- [x] StreamProviders/controllers autoDispose e tratamento de resultados atrasados.
- [x] Cache durante refresh/falha e bloqueio visual em 401/403.
- [x] Composição condicional de engine/bootstrap/observer para banco validado.
- [x] Testes escritos de coleções, repositórios, controllers e UI reativa.
- [x] Documentação de estado e processo atualizada.

## Dependências e validação

- [ ] Obter contrato interno do DashboardResource e implementar decoder real.
- [ ] Integrar contexto autenticado e arquivo isolado via 008/008B.
- [ ] Confirmar cursor/watermark/tombstones para delta com avanço seguro.
- [ ] Resolver dependências, atualizar lockfile e gerar Drift.
- [ ] Executar dart format, flutter analyze e testes afetados.
- [ ] Validar UI em largura compacta/texto alto, offline e reinício real.
- [ ] Executar regressão e inspecionar goldens antes de aprovar entrega.
