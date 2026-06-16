# Spec 005 - Revisao

## Status

Implementada e validada por testes em 15 de junho de 2026. Validação visual e manual pelo usuário pendente.

## Escopo previsto

- empacotamento da Instrument Sans;
- adocao de iconografia Lucide encapsulada;
- navegacao inferior propria;
- header compacto para telas operacionais;
- hero exclusivo do dashboard;
- revisao de KPIs e cards de produto;
- simplificacao de startup, Mais e contexto;
- preservacao de estados, permissoes e contratos;
- testes de widget, golden e validacao visual.

## Direcao aprovada para planejamento

- linguagem hibrida Arara baseada nas referencias;
- aplicacao no app atual inteiro;
- profundidade seletiva;
- fonte e iconografia dedicadas;
- nenhum grafico com dados inventados;
- nenhum FAB ou CTA sem comportamento real.

## Gate de implementacao

ABERTO. O usuário solicitou explicitamente a execução da Spec 005.

## Fontes consultadas

- `AGENTS.md`;
- `para mobile/00-contexto-operacional.md`;
- `para mobile/02-definicoes-de-interface.md`;
- `para mobile/06-registro-decisoes.md`;
- `para mobile/07-uso-de-mcps.md`;
- `para mobile/08-processo-de-trabalho.md`;
- `para mobile/designmobile.md`;
- Specs 002, 003 e 004;
- implementacao atual em `lib/`;
- imagens atuais em `docs/specs/Img/`.

## Dependencias planejadas

### Instrument Sans

- pesos previstos: 400, 500, 600 e 700;
- diretorio previsto: `assets/fonts/instrument_sans/`;
- nomes e snippet de `pubspec.yaml` definidos em `spec.md`;
- fonte oficial de referencia: Google Fonts;
- licenca prevista: SIL Open Font License (`OFL.txt`);
- arquivos estaticos e licenca foram versionados localmente com os seguintes hashes SHA256:
  - InstrumentSans-Regular.ttf: `44EF17EA334CA4B291986C5B6837202ACA1E06BE922E50FA0D3FAC3EDE7127A8`
  - InstrumentSans-Medium.ttf: `7CEE6751C259D8FE9F2E4D9FC32C6CBB7D5B9AE7508E66165CA9BD762CB346DF`
  - InstrumentSans-SemiBold.ttf: `4163EF466A8E115BDC39B999AA2D1B7FF8C76960929DF352502E56CD9DFA37F8`
  - InstrumentSans-Bold.ttf: `AE626B706CA8F831A9DCF93236C2FED1AD057E419599948C6EFC31B958A8BBFC`
  - OFL.txt: `9E27A72ED30EB49A08678F6A5D6ED98EC7BA5368F541637EE0683EC9134EF966`

### Lucide

- package planejado: `lucide_icons_flutter ^3.1.14+2`;
- licenca informada pelo catalogo do package: MIT;
- uso deve ficar encapsulado em `AppIcons`;
- mapeamento de aliases definido de forma normativa em `spec.md`;
- versao deve ser reconfirmada antes da implementacao.

## Decisoes detalhadas nesta revisao

- paleta escura especificada em HSL e hexadecimal;
- containers tonais claros especificados em HSL e hexadecimal;
- `danger` definido como token bruto e `error` como API semantica;
- `AppColorTokens` nao deve duplicar campos de erro do `ColorScheme`;
- placeholder por inicial substituido por bloco tonal com icone de categoria;
- bottom navigation responsavel pelo inset inferior exatamente uma vez;
- regras de reflow definidas para top bar, KPIs, produtos, navegacao e listas;
- valores e quantidades nao podem ser truncados;
- assets da fonte possuem estrutura e declaracao fixas.

Estados visuais de outbox foram mantidos fora do escopo. O mapeamento de
`pending`, `syncing`, `confirmed`, `failed_permanent` e estados equivalentes
deve ser decidido junto da futura spec que implementar sincronizacao e outbox.

## Ambiente

```text
Flutter: 3.44.1 (channel stable)
Dart: 3.12.1
Plataforma: Windows (PowerShell)
Dispositivos: 390x844 (golden tests); 360x800 e 412x915 pendentes
Tema: Claro e Escuro
Escala de texto: 1.0, 1.3, 2.0 (Reflow validation)
```

## Arquivos principais implementados

- `assets/fonts/instrument_sans/` (InstrumentSans-*.ttf, OFL.txt)
- `lib/app/theme/` (app_sizes.dart, app_decorations.dart, app_icons.dart)
- `lib/shared/widgets/` (operational_top_bar.dart, dashboard_hero.dart, app_bottom_navigation.dart, kpi_card.dart, product_card.dart)
- `lib/features/` (dashboard_page.dart, catalog_page.dart, more_page.dart, operational_context_page.dart)
- `test/` (operational_widgets_test.dart, visual_goldens_test.dart, icons_encapsulation_test.dart)

## Testes e validacoes

- `dart format --output=none --set-exit-if-changed lib test`: 88 arquivos,
  nenhuma alteração necessária;
- `flutter analyze`: nenhum problema encontrado;
- `flutter test`: 64 testes aprovados;
- seis goldens aprovados para shell, dashboard e catálogo em 390x844, nos
  temas claro e escuro;
- fontes Instrument Sans e Lucide carregadas obrigatoriamente no harness de
  golden, sem fallback silencioso.

## Limitacoes conhecidas

- as imagens sao referencias, nao especificacoes pixel a pixel;
- a implementacao atual usa fixtures;
- autenticacao real permanece fora de escopo;
- graficos dependem de contrato ou spec futura;
- aprovacao visual humana continua obrigatoria.

## Pendencias

- validação manual em 360x800, 390x844 e 412x915;
- aprovação visual do usuário;

## Veredito

Implementação concluída tecnicamente, aguardando validação manual e aprovação
visual do usuário.
