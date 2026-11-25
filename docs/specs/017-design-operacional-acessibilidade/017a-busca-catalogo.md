# Recorte 017A — busca do catálogo

Estado: `in_progress` | Modo: `STANDARD` | Base: `805873f6832c33a7213ceaaf52500c544a7829e4`

## Objetivo e escopo

Melhorar a identificação e limpeza do campo de busca já existente no catálogo,
como etapa limitada de REQ-017-04. Preservar a consulta existente e a categoria
selecionada. O filtro passa a ter rótulo permanente e ação identificada de limpeza;
mudanças externas de consulta devem atualizar o texto sem disparar nova consulta.

Não implementar paginação, tolerância a acentos, debounce ou novos critérios de
busca: são trabalhos relacionados a REQ-018-02 e à issue #6, que não é encerrada
por este recorte. Não modificar API, banco, permissões ou regras comerciais.

## Paths

- `lib/features/catalog/presentation/widgets/catalog_filter_bar.dart`
- `test/features/catalog/catalog_filter_bar_test.dart`
- este documento.

## Verificação planejada

| Cenário | Estado |
| --- | --- |
| Texto, rótulo e limpeza; categoria preservada | NOT_RUN |
| Atualização externa, largura 320 e escala 2.0 | NOT_RUN |
| Análise estática Flutter | NOT_RUN |
| TalkBack, foco e inspeção visual em aparelho | NOT_RUN |

A 017 permanece em `draft`; este PR não significa fechamento da spec nem aprovação
de acessibilidade. A 015 continua dependência para os gates de integração.
