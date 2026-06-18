# Spec 010: Outbox de Vendas e Resiliência Offline

## Problema
A realização de vendas no aplicativo precisa operar de forma resiliente mesmo quando o dispositivo estiver sem conexão à internet (ambiente instável ou sem sinal). Para garantir isso, o aplicativo não deve tentar enviar a transação diretamente pela rede; em vez disso, deve gravá-la localmente em uma fila de envio ("Outbox") e tentar a sincronização em segundo plano.

## Objetivo
Implementar o fluxo de vendas offline resiliente utilizando o padrão Outbox no banco de dados Drift, garantindo a gravação local imediata da transação, reenvio ordenado automático ao recuperar conexão e tratamento reativo de conflitos de sync.

## Fora de Escopo
* Lógicas complexas de faturamento direto no mobile (o servidor continua sendo o emissor final e autorizador fiscal).
* Cancelamento de vendas já confirmadas no servidor através do fluxo offline do aplicativo.

## Regras de Negócio e Diretrizes Técnicas
1. **Gravação Local Obrigatória (MOB-009):**
   * Nenhuma venda deve pular a fila de outbox. O fluxo padrão é: `Criar Venda -> Persistir no Banco Local e Adicionar no Outbox -> Disparar Sincronizador de Outbox`.
2. **Resiliência e Idempotência:**
   * Cada registro de outbox deve possuir um identificador único estável (UUID) gerado no mobile para que o servidor possa descartar requisições duplicadas caso ocorra perda de pacotes durante a confirmação.
   * O reenvio deve consumir os endpoints `POST /api/mobile/sale-intents` e subsequentemente `POST /api/mobile/sale-intents/{intent}/confirm`.
3. **Mapeamento de Falhas e Conflitos:**
   * Se o servidor rejeitar a transação (ex: erro `422` por falta de estoque real ou cliente inativo), a venda no outbox correspondente deve ser marcada com o status `failed` e o erro persistido.
   * A UI deve exibir alertas claros de erro de sincronização para que o usuário possa intervir manualmente (excluir ou reajustar a venda).
4. **Dependência Crítica (DEP-003):**
   * Esta especificação é dependente da estabilização dos endpoints de vendas no Laravel. Caso não estejam disponíveis no backend, a integração remota deve usar mocks explícitos.

## Estrutura de Arquivos Proposta
```text
lib/features/sales/
  data/
    models/
      outbox_event_model.dart # Modelo serialization JSON
    repositories/
      drift_sales_repository.dart  # Gravação local de vendas e inserção no outbox
  application/
    outbox_processor.dart     # Processador da fila Drift e envio via ApiClient
```

## Critérios de Aceite
* A gravação de uma nova venda registra imediatamente a transação nas tabelas locais e cria um registro com status `pending` na tabela de Outbox.
* A recuperação da conexão de rede inicia automaticamente a fila de processamento do Outbox.
* Sucesso na API atualiza o registro do Outbox para `synced` (ou remove da fila, conforme política de histórico).
* Erros de negócio retornados pelo servidor (`422`) travam a fila, marcam o item como `failed` e exibem um alerta de conflito na UI.
* Suíte de testes integrados valida o comportamento da fila diante de oscilações de conexão (sucesso após múltiplas falhas temporárias).
