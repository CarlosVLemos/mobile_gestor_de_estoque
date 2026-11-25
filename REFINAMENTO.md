# Arara-Gastos Mobile — pacote de refinamento

25/11/2026 | Versão de discussão, nenhuma spec congelada.

Pacote local de documentação Markdown, com a estrutura de specs do repositório. Não é implementação, PR, commit ou configuração de CI. Nenhum teste Flutter/Dart foi executado. Todos os arquivos validation-result estão NOT_RUN e reviews sem veredito.

## Como revisar
1. [Roadmap e matriz das 19 issues](docs/specs/roadmap-refinamento-015-023.md).
2. [Princípios de produto](docs/product/product-principles.md), [design operacional](docs/design/operational-design-system.md) e [quality gates](docs/engineering/quality-gates.md).
3. [Fontes e decisões pendentes](docs/engineering/sources-and-decisions.md).
4. Leia spec.md e contract.md de cada spec; os outros quatro arquivos registram tarefas, testes planejados e evidência futura.

## Specs
- [015 — Engenharia de qualidade, CI/CD e governança de IA](docs/specs/015-engenharia-qualidade-ci-cd/spec.md): Instituir uma cadeia de validação reproduzível, que permita agentes implementar e revisar sem executar comandos de validação localmente sem autorização.
- [016 — Confiabilidade offline, sessão e recuperação](docs/specs/016-confiabilidade-offline/spec.md): Permitir trabalho em campo com internet intermitente, preservando cada operação e evitando duplicação ou acesso indevido.
- [017 — Design system operacional e acessibilidade](docs/specs/017-design-operacional-acessibilidade/spec.md): Fazer o aplicativo legível, previsível e rápido para profissionais acima de 40 anos, sem pressupor baixa capacidade técnica.
- [018 — Experiência comercial do vendedor e catálogo](docs/specs/018-experiencia-vendedor/spec.md): Reduzir esforço de vendas presenciais, com busca rápida, carrinho editável e retomada de trabalho em regiões remotas.
- [019 — Histórico, conciliação e gestão comercial](docs/specs/019-historico-conciliacao-gestao/spec.md): Dar ao vendedor e à gerência visão confiável de vendas, pendências e crescimento, sem confundir estimativas com valores confirmados.
- [020 — Segurança e modernização tecnológica](docs/specs/020-seguranca-modernizacao/spec.md): Reduzir risco de exposição de dados, abuso de acesso, perda de operações e dependências legadas antes do piloto.
- [021 — Homologação, distribuição e lançamento](docs/specs/021-homologacao-lancamento/spec.md): Distribuir Android de forma controlada, com API real e continuidade de dados entre versões, antes de liberar para toda a força de vendas.
- [022 — Observabilidade e crescimento sustentável](docs/specs/022-observabilidade-crescimento/spec.md): Medir saúde operacional, adoção e desempenho com dados úteis e mínimos, sem transformar telemetria em vigilância ou sobrecarregar a rede.
- [023 — Flex — Crédito de negociação comercial](docs/specs/023-flex-credito-negociacao/spec.md): Permitir negociação de preços com crédito individual do vendedor, sem comprometer controle financeiro, auditoria, isolamento e operação offline.

## Integração futura
Após revisão humana, copiar os documentos aprovados para o repositório conforme governança; auditar Laravel dev e fixar SHA/contratos; aprovar alterações de regras de IA/CI separadamente. Não sobrescrever AGENTS.md automaticamente. Nenhuma issue foi criada, atualizada ou encerrada nesta etapa. Este pacote não autoriza commits ou push.
