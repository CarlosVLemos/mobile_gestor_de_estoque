# Base consultada e decisões não congeladas

## Fontes internas
Leitura direta da branch dev mobile na auditoria de 25/11/2026 e releitura das regras nesta preparação:
- [AGENTS.md](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/blob/dev/AGENTS.md)
- [Governança de specs](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/blob/dev/docs/specs/AGENTS.md)
- [Gate de autorização local](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/blob/dev/.agents/rules/user-run-validation.md)
- [Contexto operacional](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/blob/dev/para%20mobile/00-contexto-operacional.md)
- [Contrato 014](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/blob/dev/docs/specs/014-revitalizacao-visual-ux-operacional/contract.md) e [validação 014](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/blob/dev/docs/specs/014-revitalizacao-visual-ux-operacional/validation-result.md)
- [Endpoints mobile](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/blob/dev/para%20mobile/03-endpoints-mobile.md) — documento histórico, não comprova backend atual.
- [Issues 1–19](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues) e arquivos auditados anteriormente: SalesPage, SalesController, RegisterSaleUseCase, DriftSalesDraftRepository, DriftSalesRepository, auth repository, sync lifecycle, app_timezone, Android build.gradle.kts e pubspec.

## Referências externas para consulta na implementação
Links de referência; não houve nova auditoria externa nesta geração do pacote. Validar versões e aplicabilidade antes do freeze.
- [Flutter — testes](https://docs.flutter.dev/testing/overview), [acessibilidade](https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility), [offline-first](https://docs.flutter.dev/app-architecture/design-patterns/offline-first).
- [Android — offline-first](https://developer.android.com/topic/architecture/data-layer/offline-first), [app signing](https://developer.android.com/studio/publish/app-signing).
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/), [OWASP MASVS](https://mas.owasp.org/MASVS/), [GitHub Actions](https://docs.github.com/en/actions), [OSV-Scanner](https://google.github.io/osv-scanner/).
- Flex: referências de mercado discutidas anteriormente (Mercos, Sankhya). Não considerar suas regras como contrato vigente do Arara; verificar fontes e regras com Maquiavel/negócio.

## Decisões assumidas para organizar os rascunhos
- IDs 015–023 preservam o roadmap discutido; nenhuma spec anterior reaberta. Estado DRAFT, não FROZEN.
- Android primeiro, staging antes do piloto, gestão avançada web; Flex opcional no primeiro release até aprovação comercial.
- CI automático em runner aprovado; autorização local segue explícita. Nenhum workflow foi instalado.
- Proposta de ledger e saldo individual Flex, políticas configuráveis, negociação offline sujeita a confirmação. Liberação após pagamento/conclusão é regra relatada na conversa, não confirmada por fonte backend atual; percentual, limites, eventos e cancelamentos exigem aprovação.
- Desconto por pagamento a prazo/vencimento não é automaticamente Flex; especificar separadamente se necessário.
- Nenhum endpoint, schema version, novo permission key ou ferramenta de telemetria congelado por inferência.
- Metas quantitativas são hipóteses, não medições; não prometer conclusão em data específica.
