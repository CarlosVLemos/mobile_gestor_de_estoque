# Spec 005 - Tarefas

## Gate

- [x] Confirmar aprovacao explicita para implementar a Spec 005.
- [x] Nao iniciar alteracoes de codigo, assets ou dependencias apenas porque a
      spec foi criada ou revisada.

## Preparacao

- [x] Ler `para mobile/00-contexto-operacional.md`.
- [x] Ler as secoes aplicaveis de interface, arquitetura e decisoes.
- [x] Confirmar que mudancas locais do usuario nao conflitam com os arquivos
      afetados.
- [x] Registrar Flutter, Dart, plataforma e dispositivo no `review.md`.
- [x] Registrar as imagens de `docs/specs/Img/` usadas na validacao.
- [x] Confirmar o estado final da Spec 004 antes da migracao visual.

## Assets e dependencias

- [x] Validar origem e licenca da Instrument Sans.
- [x] Adicionar assets locais dos pesos 400, 500, 600 e 700.
- [x] Usar exatamente o diretorio `assets/fonts/instrument_sans/`.
- [x] Normalizar os quatro nomes de arquivo definidos em `spec.md`.
- [x] Versionar a licenca junto dos arquivos da fonte.
- [x] Declarar familia e pesos no `pubspec.yaml` usando o snippet normativo.
- [x] Ativar Instrument Sans em `AppTypography`.
- [x] Adicionar `lucide_icons_flutter ^3.1.14+2`.
- [x] Executar `flutter pub get`.
- [x] Confirmar que nenhuma dependencia visual adicional foi introduzida.

## Tema e fundacoes

- [x] Ajustar escala tipografica para Instrument Sans.
- [x] Revisar pesos, alturas de linha e tracking.
- [x] Reduzir raios de cards operacionais para a faixa de 12 a 16.
- [x] Reservar raios maiores para hero, sheets e dialogs.
- [x] Reduzir sombras e priorizar bordas sutis.
- [x] Manter fundo atmosferico discreto nos temas claro e escuro.
- [x] Manter blur apenas na shell inferior.
- [x] Revisar tokens de motion entre 160 e 250 ms.
- [x] Respeitar configuracao de reducao de movimento quando aplicavel.

## Iconografia

- [x] Mapear todos os aliases atuais conforme a tabela normativa da spec.
- [x] Manter imports de `LucideIcons` somente em `app_icons.dart`.
- [x] Adicionar aliases para navegacao, busca, filtro, conta e estados.
- [x] Definir icones de categoria usados pelo catalogo.
- [x] Definir fallback generico para categoria desconhecida.
- [x] Mapear Protecao, Eletrica, Acessorios e fallback.
- [x] Confirmar que cada identificador Lucide da tabela existe na versao travada.
- [x] Remover uso direto de Material Icons nas superficies migradas.
- [x] Verificar consistencia de tamanho e peso de traco.

## Shell e navegacao

- [x] Reimplementar `AppBottomNavigation` sem `NavigationBar`.
- [x] Preservar a API atual orientada a destinos.
- [x] Manter os tres destinos atuais.
- [x] Criar indicador ativo discreto com icone e label.
- [x] Garantir alvo minimo de 48 por 48.
- [x] Ler o inset inferior com `MediaQuery.paddingOf(context).bottom`.
- [x] Absorver a SafeArea inferior dentro de `AppBottomNavigation`.
- [x] Remover qualquer aplicacao duplicada do inset no componente pai.
- [x] Calcular padding do conteudo com altura visual mais inset inferior.
- [x] Garantir semantica de selecionado para leitores de tela.
- [x] Preservar navegacao e estado de branches do `go_router`.
- [x] Validar safe areas e padding do ultimo item rolavel.

## Headers

- [x] Criar `OperationalTopBar`.
- [x] Suportar titulo, subtitulo, leading e acoes opcionais.
- [x] Garantir adaptacao a escala de texto.
- [x] Mover acoes para linha propria quando o titulo nao couber.
- [x] Limitar titulo a duas linhas com ellipsis.
- [x] Criar `DashboardHero` exclusivo do painel.
- [x] Limitar metadados secundarios do hero.
- [x] Remover metricas, tags e decoracoes sem funcao dos headers compactos.
- [x] Migrar paginas e remover `OperationalPageHeader` quando nao houver uso.
- [x] Atualizar documentacao dos componentes compartilhados.

## Startup

- [x] Simplificar a composicao visual.
- [x] Destacar marca e mensagem de inicializacao.
- [x] Manter progresso, falha e retry.
- [x] Remover decoracao promocional ou metricas.
- [x] Confirmar que a tela nao simula autenticacao.

## Dashboard

- [x] Aplicar `DashboardHero`.
- [x] Remover CTA de abrir web enquanto nao houver comportamento real.
- [x] Revisar KPIs para tons semanticos explicitos.
- [x] Permitir crescimento vertical dos KPIs sem truncar valores.
- [x] Manter grade adaptativa de duas colunas.
- [x] Aplicar variante critica somente a dados criticos.
- [x] Compactar alertas de estoque.
- [x] Compactar movimentos recentes.
- [x] Preservar loading, refreshing, empty, offline, restricted e failure.
- [x] Nao adicionar grafico ou serie temporal.

## Catalogo

- [x] Aplicar `OperationalTopBar`.
- [x] Revisar barra de busca e filtros.
- [x] Exibir contagens apenas quando derivadas de dados existentes.
- [x] Redesenhar `ProductCard` como linha compacta.
- [x] Exibir icone de categoria ou fallback.
- [x] Substituir iniciais por bloco tonal de 48 por 48 com icone outline.
- [x] Manter o icone de categoria neutro em estados de estoque.
- [x] Priorizar nome, SKU, quantidade e status principal.
- [x] Permitir duas linhas para o nome e uma linha com ellipsis para SKU.
- [x] Mover quantidade/status para bloco inferior em texto aumentado.
- [x] Reduzir badges e metadata secundaria.
- [x] Preservar preco opcional e restricao financeira.
- [x] Preservar estados de feature desativada e permissao ausente.
- [x] Nao adicionar FAB.

## Mais e contexto

- [x] Aplicar `OperationalTopBar` nas duas telas.
- [x] Reorganizar Mais em grupos de destinos.
- [x] Diferenciar destinos ativos, futuros e externos.
- [x] Remover metricas ficticias e badges redundantes.
- [x] Compactar resumo de tenant e usuario.
- [x] Agrupar features e permissoes de forma legivel.
- [x] Preservar explicacao de autorizacao remota.

## Estados compartilhados

- [x] Revisar cards de vazio, falha, offline e restricao.
- [x] Manter titulo, mensagem e acao sem excesso de containers.
- [x] Garantir que cor nao seja o unico sinal.
- [x] Garantir que refresh nao apague dados locais visiveis.
- [x] Confirmar contraste nos temas claro e escuro.
- [x] Preservar os containers tonais claros definidos em `spec.md`.
- [x] Mapear `AppColors.danger*` para `ColorScheme.error*`.
- [x] Confirmar que widgets consomem `ColorScheme.error*`.
- [x] Nao adicionar propriedades de danger/error em `AppColorTokens`.

## Acessibilidade

- [x] Validar alvos de toque minimos.
- [x] Validar labels semanticos de navegacao e acoes.
- [x] Testar escala de texto aumentada.
- [x] Validar reflow com `textScaler` equivalente a 1.3 e 2.0.
- [x] Confirmar que valores financeiros e quantidades nunca usam ellipsis.
- [x] Confirmar que badges quebram com `Wrap`.
- [x] Testar contraste de textos, bordas e status.
- [x] Garantir ordem de foco coerente.
- [x] Garantir que animacoes nao sejam essenciais para compreender estado.
- [x] Nao definir badges ou cores para estados futuros da outbox.

## Testes automatizados

- [x] Atualizar testes de tema e tipografia.
- [x] Criar teste de encapsulamento de `LucideIcons`.
- [x] Criar teste ou validacao estatica do mapeamento completo de `AppIcons`.
- [x] Criar teste dos tokens normativos do tema escuro.
- [x] Criar teste dos containers tonais normativos do tema claro.
- [x] Criar teste do mapeamento `AppColors.danger*` para `ColorScheme.error*`.
- [x] Confirmar por teste/inspecao que `AppColorTokens` nao duplica error.
- [x] Criar testes de widget para `AppBottomNavigation`.
- [x] Criar testes de widget para `OperationalTopBar`.
- [x] Criar testes de widget para `DashboardHero`.
- [x] Atualizar testes de `KpiCard` e `ProductCard`.
- [x] Atualizar testes das paginas afetadas.
- [x] Criar golden da shell em `390x844`, claro e escuro.
- [x] Criar golden do dashboard em `390x844`, claro e escuro.
- [x] Criar golden do catalogo em `390x844`, claro e escuro.
- [x] Fixar fontes, locale, tamanho e animacoes no harness de golden.

## Validacao

- [x] Executar `dart format`.
- [x] Executar `flutter analyze`.
- [x] Executar `flutter test`.
- [x] Validar visualmente em `360x800`.
- [x] Validar visualmente em `390x844`.
- [ ] Validar visualmente em `412x915`.
- [x] Validar tema claro.
- [x] Validar tema escuro.
- [x] Validar escala de texto aumentada.
- [x] Validar bottom navigation em dispositivo com inset inferior simulado.
- [x] Validar bottom navigation em dispositivo sem inset inferior.
- [x] Comparar hierarquia e densidade com `docs/specs/Img/`.
- [ ] Obter aprovacao visual do usuario.

## Fechamento

- [x] Registrar arquivos principais no `review.md`.
- [x] Registrar comandos e resultados.
- [x] Registrar validacao visual e dispositivos.
- [x] Registrar limitacoes e desvios.
- [x] Atualizar catalogo de componentes compartilhados.
- [x] Registrar qualquer decisao nova antes de considera-la aceita.
- [ ] Marcar a spec como implementada somente apos evidencias e aprovacao.
