# Proposta 016A — proteção contra submissão duplicada

Status: `FROZEN` | Modo: `CRITICAL` | Base: `805873f6832c33a7213ceaaf52500c544a7829e4`
Rastreio: [issue #1](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/1), REQ-016-01 e QA-016-01.
Aprovação humana do recorte: 25/11/2026, nesta conversa. Este documento não congela a Spec 016 inteira.

## Problema e evidência

Na base indicada, `SalesController.registerSale` pode ser chamado novamente enquanto
aguarda o primeiro `useCase.call`. Cada invocação do caso de uso gera um novo UUID;
portanto, a idempotência do envio de uma mesma operação não impede duas operações
distintas. É risco constatado por leitura estática, ainda não reproduzido em teste.

`DriftSalesRepository.register` registra venda, itens e outbox em uma transação.
O retorno bem-sucedido do repositório marca o commit local, não a confirmação do
servidor. O contrato 010 e seus change requests continuam aplicáveis.

## Recorte proposto

- Uma única submissão em andamento por controller e contexto ativo. A guarda deve
  ser adquirida sincronamente antes do primeiro `await`, inclusive para chamadas
  diretas ao controller. Chamadas concorrentes devem ser recusadas sem criar
  outro UUID, registro ou mensagem de sucesso.
- Capturar cliente, itens, quantidades, tempo e timezone da tentativa antes de
  aguardar persistência. Enquanto ela estiver em curso, bloquear alterações do
  carrinho e do cliente na UI e também no controller, inclusive retorno de picker
  aberto antes da submissão. Desabilitar CTA e apresentar progresso acessível.
- Somente após confirmação do commit local, limpar o carrinho submetido e disparar
  sincronização em separado. Uma falha posterior no disparo de sync não deve ser
  apresentada como falha do registro local nem autorizar criar outra venda.
- Falha comprovadamente anterior ao commit ou rollback comprovado libera a guarda,
  preserva cliente e carrinho e permite nova tentativa. Não assumir rollback para
  toda exceção: quando o resultado do commit for desconhecido, impedir nova criação
  até reconciliar pelo identificador estável daquela tentativa no banco contextual.
  Se não for possível comprovar presença ou ausência, manter estado de atenção
  e preservar o rascunho; não apresentar venda confirmada ou oferecer retry cego.
- Cada tentativa lógica recebe um UUID antes da persistência, conservado durante
  reconciliação de resultado incerto; uma venda deliberadamente nova recebe outro.
  O envio/retry remoto continua usando a identidade e payload duráveis da outbox.
- Descarte ou troca de contexto durante a operação não pode limpar estado do
  contexto seguinte nem direcionar a venda ao banco de outra conta. Definir a
  guarda de lifecycle a partir da implementação contextual antes da mudança.

## Limites

Não muda API, payload, schema, migração, permissões, estados remotos nem política de
sessão offline. Não resolve retomada de rascunho após reinício ou deduplicação entre
dispositivos. Caso a reconciliação exija alteração de contrato persistente ou
migration, interromper o recorte e apresentar novo change request.

## Paths candidatos

`lib/features/sales/presentation/controllers/**`,
`lib/features/sales/presentation/state/**`,
`lib/features/sales/presentation/pages/sales_page.dart`,
`lib/features/sales/application/**`,
`lib/features/sales/domain/repositories/**`,
`lib/features/sales/data/repositories/**` e testes afetados.
Paths definitivos e interface de consulta dependem de inspeção; sem alteração de schema.

## Matriz mínima — NOT_RUN

| Cenário | Resultado esperado |
| --- | --- |
| Duas chamadas antes do primeiro commit | Uma invocação persistente, um UUID, uma venda e uma outbox |
| Dois toques rápidos | CTA ocupado; nenhuma segunda mensagem de sucesso |
| Picker aberto e edição concorrente | Snapshot preservado; nenhuma edição perdida silenciosamente |
| Rollback confirmado | Nenhuma venda/outbox; carrinho intacto; retry possível |
| Commit ocorreu, mas retorno é incerto | Reconciliação pelo mesmo UUID, sem nova venda |
| Resultado não verificável | Estado de atenção, rascunho preservado, sem retry cego |
| Falha após commit ao iniciar sync | Venda permanece registrada e não é duplicada |
| Descarte/troca de contexto durante await | Sem vazamento ou limpeza do contexto seguinte |
| Segunda venda deliberada após sucesso | Novo UUID e nova venda |
| Largura compacta e texto ampliado | Estado ocupado acessível sem overflow |

## Gates

Recorte 016A aprovado e FROZEN em 25/11/2026. Preparar testes
focados, widget e persistência, além de análise; não executar sem autorização
específica. A Spec 015 para merge e o veredito de revisão continuam pendentes.
Esta proposta não afirma execução de testes nem fechamento da issue.
