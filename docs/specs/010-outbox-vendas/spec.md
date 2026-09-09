# Spec 010: Outbox de Vendas e Resiliência Offline

## Status

`IN PROGRESS` — Fase A. O contrato congelado está em `contract.md`.

Esta fase evolui a `sync_outbox` existente. Idempotência usa
`client_request_id` no payload; `X-Request-ID` não é requisito. O backend é
soberano em preços e eles não são enviados. Clientes reais e recuperação do
token de confirmação aguardam `HANDOFF-010-BACKEND`.

## Problema
A realização de vendas no aplicativo precisa operar de forma resiliente mesmo quando o dispositivo estiver sem conexão à internet (ambiente instável ou sem sinal). Para garantir isso, o aplicativo não deve tentar enviar a transação diretamente pela rede; em vez disso, deve gravá-la localmente em uma fila de envio ("Outbox") e tentar a sincronização em segundo plano.

## Objetivo
Implementar o fluxo de vendas offline resiliente utilizando o padrão Outbox no banco de dados Drift, garantindo a gravação local imediata da transação, reenvio ordenado automático ao recuperar conexão e tratamento reativo de conflitos de sync.

## Fora de Escopo
* Lógicas complexas de faturamento direto no mobile (o servidor continua sendo o emissor final e autorizador fiscal).
* Cancelamento de vendas já confirmadas no servidor através do fluxo offline do aplicativo.

## Regras de Negócio e Diretrizes Técnicas
1. **Gravação Local Obrigatória e Atômica (MOB-009 / MOB-012):**
   * Nenhuma venda deve pular a fila de outbox. O fluxo padrão é: `Criar Venda -> Persistir no Banco Local e Adicionar no Outbox -> Disparar Sincronizador de Outbox`.
   * A gravação local da venda e a inserção do respectivo evento na outbox devem ocorrer de forma atômica dentro de uma única transação no Drift.
2. **Resiliência, Idempotência e Chaves UUID:**
   * Cada registro de outbox deve possuir um identificador único estável (UUID `client_request_id`) gerado no mobile.
   * O reenvio deve consumir os endpoints `POST /api/mobile/sale-intents` e subsequentemente `POST /api/mobile/sale-intents/{intent}/confirm`.
   * Para garantir a idempotência, o `client_request_id` é persistido e transmitido no payload JSON do intent em toda tentativa.
3. **Mapeamento de Falhas, Conflitos e Estados Canônicos:**
   * A coluna `status` na tabela de outbox deve adotar as strings correspondentes aos estados canônicos da arquitetura:
     | Status | Significado | Ação do Processador |
     | --- | --- | --- |
     | `pending` | Criado localmente e aguardando sync | Tenta sincronizar na próxima rodada |
     | `syncing` | Em processamento ativo na rede | Bloqueado para outras execuções |
     | `confirmed` | Confirmado pelo servidor | Mantido/arquivado conforme política |
     | `failed_retryable` | Falha temporária de rede/timeout | Retenta após o tempo de backoff |
     | `failed_permanent` | Falha de regra de negócio (erro 422) | Trava e exige intervenção manual |
     | `requires_acceptance` | Conflito que exige aceite do usuário | Trava e solicita interação visual |
     | `cancelled` | Cancelado localmente pelo usuário | Não tenta enviar |
4. **Algoritmo de Backoff Exponencial com Jitter:**
   * Itens em estado `failed_retryable` seguem uma política de recuo exponencial com ruído aleatório (jitter) para evitar sobrecarga no servidor.
   * A próxima tentativa é calculada por:
     $$\text{delay} = \min(2^{\text{attempts}} \times 30, 1800) + \text{random}(-15, 15) \text{ segundos}$$
   * O campo `next_attempt_at` é gravado com o carimbo de data/hora correspondente a esse delay. O processador ignora itens cujo `DateTime.now()` seja anterior a `next_attempt_at`.
5. **Evolução de Esquema e Payload Versioning:**
   * O campo `payload_json` conterá os dados brutos da venda. Para suportar atualizações de modelo futuras, a tabela outbox deve conter uma coluna `payload_version` (integer), permitindo mappers da camada de dados deserializar e migrar payloads antigos se necessário.
6. **Dependência Crítica (DEP-003):**
   * Esta especificação é dependente da estabilização dos endpoints de vendas no Laravel. Caso não estejam disponíveis no backend, a integração remota deve usar mocks explícitos.

## Estrutura de Arquivos Proposta
```text
lib/features/sales/
  data/
    models/
      outbox_event_model.dart # Modelo de serialização JSON
    repositories/
      drift_sales_repository.dart  # Gravação local de vendas e inserção no outbox
  application/
    outbox_processor.dart     # Processador da fila Drift e envio via ApiClient
```

## Critérios de Aceite
* A gravação de uma nova venda registra imediatamente a transação nas tabelas locais e cria um registro com status `pending` na tabela de Outbox de forma transacional.
* A recuperação da conexão de rede inicia automaticamente a fila de processamento do Outbox.
* Sucesso na API atualiza o registro do Outbox para `confirmed` e marca a venda correspondente como sincronizada.
* Erros de negócio retornados pelo servidor (`422`) travam a fila, marcam o item como `failed_permanent` e exibem um alerta de conflito na UI.
* Retentativas temporárias calculam corretamente o backoff exponencial com jitter e escrevem no campo `next_attempt_at`.
* O campo `client_request_id` permanece estável no payload v1 de todas as tentativas.
* Suíte de testes integrados valida o comportamento da fila diante de oscilações de conexão e retentativas ordenadas.
