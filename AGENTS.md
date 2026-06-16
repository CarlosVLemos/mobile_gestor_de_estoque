# Instruções do Projeto Mobile

## Objetivo

Este repositório contém o aplicativo Flutter do Arara-Gastos.

Antes de implementar, leia `para mobile/00-contexto-operacional.md`. Esse é o
ponto de entrada canônico e informa quais documentos adicionais são necessários
para cada tipo de tarefa.

## Leitura por tipo de tarefa

Não leia toda a documentação por padrão.

| Tarefa | Leitura obrigatória |
| --- | --- |
| Qualquer alteração | `00-contexto-operacional.md` |
| Arquitetura, dependências ou estrutura | `05-arquitetura-mobile.md` e `06-registro-decisoes.md` |
| Regra de negócio, permissão ou offline | `04-regras-e-necessidades-mobile.md` |
| Tela, componente ou estado visual | `02-definicoes-de-interface.md` |
| Integração remota | `03-endpoints-mobile.md` |
| Trabalho visual amplo | `designmobile.md` |
| Processo, spec ou handoff | `08-processo-de-trabalho.md` |
| Uso de ferramentas externas | `07-uso-de-mcps.md` |

## Hierarquia das fontes

Quando houver conflito, use esta ordem:

1. decisão aceita em `06-registro-decisoes.md`;
2. arquitetura em `05-arquitetura-mobile.md`;
3. regras de negócio em `04-regras-e-necessidades-mobile.md`;
4. regras de interface em `02-definicoes-de-interface.md`;
5. contrato implementado em `03-endpoints-mobile.md`;
6. blueprint visual em `designmobile.md`;
7. comentários e código legado.

Não trate item marcado como `proposto`, `planejado` ou `dependente` como se já
estivesse implementado.

## Regras de implementação

- Organizar código por feature e camada.
- Fluxo padrão: `Page -> Controller -> UseCase -> Repository -> DAO/API`.
- `presentation` não acessa Dio ou Drift.
- `application` não conhece Dio, Drift, JSON ou widgets.
- `domain` não conhece Flutter, transporte ou persistência.
- A UI lê estado operacional por repositórios e fontes locais.
- Operações offline relevantes são persistidas antes de aparecer como salvas.
- Permissão visual não substitui autorização remota.
- Preço ausente pode ser uma restrição válida, não um erro.
- Não inventar campos ou endpoints ausentes.
- Não alterar decisões aceitas silenciosamente; registrar a mudança primeiro.

## Erros de interface que não podem voltar

- Não recriar overflow horizontal em componentes mobile, especialmente em cards de catálogo.
- Houve um erro real em `lib/shared/widgets/product_card.dart`: um `Row` estourou `12 px` à direita no celular porque `coreContent` e `infoContent` tentaram coexistir na mesma linha sem reflow suficiente para larguras compactas.
- Em Flutter, `Row` com texto, badges, preço e metadados não pode assumir largura de desktop ou web. Sempre prever telas estreitas e textos maiores.
- Quando houver conteúdo principal e trailing no mesmo eixo horizontal, o bloco que pode encolher deve usar `Expanded` ou `Flexible`, e o trailing deve respeitar limite de largura ou quebrar para baixo.
- Textos variáveis devem usar `maxLines` e `TextOverflow.ellipsis` quando a perda controlada de conteúdo for aceitável.
- Se nome, SKU, marca, badges e preço disputarem espaço, prefira reflow vertical em largura compacta em vez de forçar tudo na mesma linha.
- Mudanças em cards, listas e barras horizontais devem ser validadas pelo menos em largura mobile compacta e com `textScaler` alto, para evitar novos `RenderFlex overflowed by ... pixels`.

## Qualidade

Toda alteração deve executar o menor conjunto relevante:

- `dart format`;
- `flutter analyze`;
- testes unitários, de widget ou integração afetados;
- validação visual para mudanças de interface.

Se uma ferramenta não puder ser executada, registre isso no fechamento.

## MCPs

Use os MCPs conforme `para mobile/07-uso-de-mcps.md`.

Disponibilidade varia por sessão. Nunca presuma que um MCP está instalado:
verifique as ferramentas disponíveis e use o fallback documentado.

Por decisão temporária do projeto, não use o GitHub Connector nem o GitHub MCP
até nova orientação.
