# Spec 022 — Observabilidade e crescimento sustentável

Estado: `draft` | Classificação: `STANDARD (CRITICAL para coleta de dados pessoais/contrato)` | Data: 2026-11-25

## Objetivo
Medir saúde operacional, adoção e desempenho com dados úteis e mínimos, sem transformar telemetria em vigilância ou sobrecarregar a rede.

## Dependências e rastreabilidade
015, 016 e 020; métricas comerciais da 019; baseline antes de 021, evolução pós-piloto.

Issues existentes relacionadas: Novos requisitos; complementa 5, 6, 9 e 10. A relação é temática e muitos-para-muitos, não equivale a fechamento de issue.

## Escopo
- Métricas de confiabilidade, experiência, crescimento, versão e sync; diagnóstico e alertas; orçamento de dados e desempenho.
- Instrumentação opt-in/legítima conforme decisão de privacidade; agregação gerencial de indicadores contratados.

## Fora de escopo
- Enviar PII, texto de busca, preço/cliente individual ou payload de venda na telemetria; monitorar funcionário de forma invasiva; big data/stack onerosa sem demanda.

## Requisitos e critérios de aceite
- **REQ-022-01** — Definir eventos tipados mínimos: início/fim sync, resultado/categoria de falha, duração, contagem de operações conhecidas, versão e jornada de venda (duração/resultado, sem identificação de cliente/produto). Separar logs técnicos de métricas comerciais.
- **REQ-022-02** — Métricas: taxa de conclusão de tarefa, p50/p95 de busca e sync, falhas por categoria, idade de pendência conhecida, replay/duplicação, versões em uso e falha de startup. Cada uma com denominador, janela, fonte, cobertura e tratamento de dados ausentes.
- **REQ-022-03** — Offline: armazenar somente eventos mínimos com fila limitada por tamanho/idade; backoff e envio em lote; telemetria nunca bloqueia venda, auth ou outbox; dados não enviados não contam como zero global.
- **REQ-022-04** — Manter cardinalidade baixa, sem IDs de pessoas/tenants em labels públicos; restringir acesso, retenção e agregação conforme 020; não usar dados reais em CI.
- **REQ-022-05** — Baseline piloto: p95 busca <=300ms com 10 mil produtos e aparelho definido, venda cinco itens <=90s como hipótese, zero duplicação/perda nos cenários E2E. Medir antes de alertar; alertas com dono e ação.
- **REQ-022-06** — Visão gerencial simples (019) consome métricas comerciais do servidor, não eventos de analytics; operação técnica fica em painel separado para equipe. Capacidade: medir volume, tempo e consumo com dataset sintético; não pressupor necessidade de microsserviço.

## Decisões antes do freeze
- [ ] Escolher transporte e destino de telemetria de acordo com infraestrutura/custo/privacidade; MVP pode usar evidência local e backend existente se adequado.
- [ ] Definir retenção, consentimento/base legal aplicável, acesso e limiares após baseline; nenhuma coleta remota antes da aprovação.

## Fechamento
Contrato aprovado; tarefas e critérios atendidos; evidência de CI do SHA candidato, checks manuais quando aplicáveis e veredito de Mefisto. Jarvis registra fechamento somente após gate humano. Nenhum teste local sem autorização explícita atual.
