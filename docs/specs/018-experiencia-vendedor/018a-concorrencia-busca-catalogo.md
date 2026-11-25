# Recorte 018A — concorrência da busca local do catálogo

Estado: `in_progress` | Modo: `STANDARD` para correção local de apresentação
Base: `805873f6832c33a7213ceaaf52500c544a7829e4`

## Objetivo

Evitar que buscas e cancelamentos sobrepostos instalem assinaturas de uma consulta
antiga ou apliquem resultados após troca da consulta ou descarte do controller.
O recorte antecipa apenas a parte de cancelamento de resultado obsoleto de
REQ-018-02, sem alterar o contrato de backend, os dados ou as permissões.

As condições de corrida foram identificadas por inspeção do código; os testes
preparados não foram executados nesta alteração. A Spec 018 continua `draft` e
o contrato completo, inclusive paginação e schema, permanece pendente.

## Invariantes

- Mudança de busca ou categoria invalida imediatamente respostas em voo anteriores.
- Cancelamento tardio não instala observação para consulta antiga.
- Resultados e erros de assinatura descartada não alteram estado atual.
- Descarte não inicia nova carga nem assinatura.
- Sem alteração em schema, API, filtro, autorização ou contrato de estoque.

## Verificação

Testes focados de resposta fora de ordem, cancelamento atrasado e descarte:
`NOT_RUN`. `flutter analyze`: `NOT_RUN`. A issue #6 exige ainda benchmark,
paginação, índices e debounce; não é encerrada por este recorte. Os gates da 015
e revisão antes do merge continuam pendentes.
