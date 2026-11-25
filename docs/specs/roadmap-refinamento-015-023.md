# Roadmap 015–023 — Refinamento e lançamento

Data: 25/11/2026 | Estado: proposta de planejamento, contratos DRAFT.

## Visão
Não há correspondência 1:1 entre issues e specs. Issues são problemas/pendências; specs são capacidades coerentes com contrato e gate de validação. Novos requisitos de qualidade, design, gestão, observabilidade e Flex ultrapassam o backlog inicial.

| Spec | Capacidade | Modo | Dependências principais |
| --- | --- | --- | --- |
| [015](015-engenharia-qualidade-ci-cd/spec.md) | Engenharia de qualidade, CI/CD e governança de IA | CRITICAL | Nenhuma; habilita os gates das demais specs. |
| [016](016-confiabilidade-offline/spec.md) | Confiabilidade offline, sessão e recuperação | CRITICAL | 015 para merge; 020 para política de segurança; contrato Laravel para sessão/reconciliação. |
| [017](017-design-operacional-acessibilidade/spec.md) | Design system operacional e acessibilidade | STANDARD (CRITICAL se alterar contrato funcional) | 015; contrato 018 para integração de campos; 016 para semântica offline. |
| [018](018-experiencia-vendedor/spec.md) | Experiência comercial do vendedor e catálogo | CRITICAL | 015, 016 (registro), 017 (componentes); 023 para preço negociado/Flex. |
| [019](019-historico-conciliacao-gestao/spec.md) | Histórico, conciliação e gestão comercial | CRITICAL | 015, 016, 018 para jornada; 020 para dados financeiros; 023 para extrato Flex. |
| [020](020-seguranca-modernizacao/spec.md) | Segurança e modernização tecnológica | CRITICAL | 015 para gates; começa junto com 016; bloqueia release 021. |
| [021](021-homologacao-lancamento/spec.md) | Homologação, distribuição e lançamento | CRITICAL | 015, 016, 017, 018, 019, 020; 022 baseline; 023 se Flex for requisito do piloto. |
| [022](022-observabilidade-crescimento/spec.md) | Observabilidade e crescimento sustentável | STANDARD (CRITICAL para coleta de dados pessoais/contrato) | 015, 016 e 020; métricas comerciais da 019; baseline antes de 021, evolução pós-piloto. |
| [023](023-flex-credito-negociacao/spec.md) | Flex — Crédito de negociação comercial | CRITICAL / cross-repo | 015, 016, 017, 018, 019, 020; antes de 021 somente se requisito de lançamento. |

## Caminho crítico
1. Aprovar 015 e estabelecer checks confiáveis; inventário de segurança 020 e protótipos 017 podem começar em paralelo sem writers concorrentes.
2. 016 e 017: confiabilidade e componentes; 018 começa por busca e UX independente, mas integração de registro/rascunho respeita contrato e ownership.
3. 019: proposta/total/histórico/gestão; 020 conclui hardening. 022 instrumenta baseline desde o piloto, sem coleta não aprovada.
4. 023: auditoria comercial/backend pode iniciar cedo; implementação financeira depende dos contratos de 016/018/019/020. Se Flex obrigatório no MVP, bloqueia release; se não, feature desativada e compatibilidade comprovada.
5. 021: preparação de staging/assinatura pode começar cedo; distribuição só após gates e aceite humano. 022 evolui após piloto.

## Rastreabilidade das issues existentes
| Issue | Specs relacionadas | Cobertura |
| --- | --- | --- |
| [#1](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/1) | 016 | Submissão concorrente e retry |
| [#2](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/2) | 019, 023 | Proposta estruturada; negociação Flex quando aplicável |
| [#3](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/3) | 016, 020 | Sessão offline e risco de revogação |
| [#4](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/4) | 021, 015, 020 | Release, gates e assinatura |
| [#5](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/5) | 019, 018 | Histórico/detalhe e jornada |
| [#6](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/6) | 018, 022 | Busca e desempenho |
| [#7](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/7) | 018, 023 | Disponibilidade e contexto de negociação |
| [#8](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/8) | 018, 016 | Rascunho, recuperação e atomicidade |
| [#9](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/9) | 016, 022 | Reconexão e observabilidade |
| [#10](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/10) | 019, 023 | Total confirmado, valores Flex |
| [#11](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/11) | 017, 018 | Componentes e responsabilidades |
| [#12](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/12) | 019, 023 | Precisão e regras financeiras |
| [#13](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/13) | 016, 021 | Timezone e configuração de release |
| [#14](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/14) | 017 | Preferência de tema |
| [#15](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/15) | 016, 017, 020 | Falhas acionáveis, segurança e copy |
| [#16](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/16) | 015 e transversal | Contexto canônico e fechamento |
| [#17](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/17) | 015, 021 | Estratégia de branches e integração |
| [#18](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/18) | 017, 021 | TalkBack e gate de piloto |
| [#19](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/19) | 020, 015 | Dependências e validação |

## Decisões transversais de execução
- SINGLE_WRITER para schema, auth, sale-intents e arquivos compartilhados; até dois writers apenas em paths distintos com contrato claro.
- Coordenar schema v5 atual: uma cadeia de migrations, sem reservar números independentemente; testar upgrades e outbox.
- Não executar testes localmente sem autorização explícita; CI aprovado passa a ser fonte de evidência automática.
- Não impor prazo de 4/12 a todas as specs; separar release mínimo de evolução. Definir capacidade e disponibilidade de backend antes de estimar.
- Atualizar documentação canônica na 015 e a cada fechamento; não substituir 014 nem apagar histórico.
- Release mínimo exige integridade, segurança, UX crítica e piloto; observabilidade básica antes de distribuição; Flex entra conforme decisão.
