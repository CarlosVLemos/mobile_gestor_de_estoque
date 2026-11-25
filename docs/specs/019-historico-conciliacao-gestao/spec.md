# Spec 019 — Histórico, conciliação e gestão comercial

Estado: `draft` | Classificação: `CRITICAL` | Data: 2026-11-25

## Objetivo
Dar ao vendedor e à gerência visão confiável de vendas, pendências e crescimento, sem confundir estimativas com valores confirmados.

## Dependências e rastreabilidade
015, 016, 018 para jornada; 020 para dados financeiros; 023 para extrato Flex.

Issues existentes relacionadas: 2, 5, 10, 12. A relação é temática e muitos-para-muitos, não equivale a fechamento de issue.

## Escopo
- Histórico paginado e detalhes, proposta estruturada, total confirmado, representação monetária exata, visão gerencial por permissões.
- Integração de histórico remoto se contrato real permitir; indicador de abrangência e última atualização.

## Fora de escopo
- ERP móvel completo, inventar endpoints/indicadores, dashboards de BI profundos, alterações automáticas de preço sem aceite.

## Requisitos e critérios de aceite
- **REQ-019-01** — Histórico local com busca por cliente/identificador, período/status, paginação e detalhe de itens/quantidades; diferenciar local e confirmado; vendas em outros dispositivos só quando sincronizadas por contrato aprovado.
- **REQ-019-02** — Modelar proposta tipada com revisão, itens afetados, quantidade/preço original e proposto, motivos e total; aceitar/rejeitar conscientemente conforme API. Não interpretar proposalJson na UI; se detalhe indisponível, bloquear aceite cego e oferecer reconectar/consultar, sujeito a contrato aprovado.
- **REQ-019-03** — CAS/revisão vigente e aceite explícito; proposta expirada/alterada exige nova revisão. Sem autoaceite, sem reescrever negociação silenciosamente.
- **REQ-019-04** — Valores monetários exatos em centavos inteiros ou decimal contratado, arredondamento e escala explícitos; preservar null/restrição e payloads antigos. Total final vem do servidor; total histórico local é estimativa até reconciliação, nunca rotulado confirmado sem evidência.
- **REQ-019-05** — Gerência: visão compacta por período, vendas confirmadas, vendedores ativos, estoque baixo, pendências conhecidas e evolução; aproveitar dashboard real e permissões. Não apresentar pendências de aparelhos desconectados como contagem global completa; explicitar escopo, fuso, freshness e denominadores.
- **REQ-019-06** — Vendedor vê próprio escopo; gerência só agregados e registros autorizados. Histórico e filtros locais nunca misturam tenant, e cache não concede novas permissões.

## Decisões antes do freeze
- [ ] Auditar backend atual: campos da proposta, totais, IDs e histórico/paginação, quais métricas e permissões existem; bloquear partes ausentes.
- [ ] Definir política de rejeição/cancelamento e precisão/arredondamento com backend; definir significado de cada KPI e landing híbrida.

## Fechamento
Contrato aprovado; tarefas e critérios atendidos; evidência de CI do SHA candidato, checks manuais quando aplicáveis e veredito de Mefisto. Jarvis registra fechamento somente após gate humano. Nenhum teste local sem autorização explícita atual.
