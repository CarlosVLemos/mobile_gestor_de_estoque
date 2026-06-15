# Spec 003 - Tarefas

## Preparacao

- [ ] Confirmar que a arvore de trabalho nao contem mudancas conflitantes nas
      areas de `app/router/`, `shared/widgets/` e features envolvidas.
- [ ] Registrar as versoes atuais de Flutter e Dart usadas na implementacao.
- [ ] Confirmar que nenhuma decisao nova de arquitetura ou interface e
      necessaria antes da implementacao.
- [ ] Confirmar quais exemplos visuais em `docs/specs/Img/` serao usados como
      referencia de composicao.
- [ ] Registrar em `review.md` as ferramentas disponiveis e os fallbacks
      utilizados.

## Dependencias

- [ ] Executar `flutter pub get`.
- [ ] Confirmar que nenhuma dependencia fora do escopo foi adicionada.
- [ ] Registrar no `review.md` se houve uso de fallback para o toolchain.

## Router e shell

- [ ] Expandir `app_routes.dart` com as rotas da shell operacional.
- [ ] Atualizar `app_router.dart` para incluir a shell e os destinos iniciais.
- [ ] Adicionar comentarios centrais indicando que a protecao real de rotas
      depende da futura spec de autenticacao mobile.
- [ ] Garantir que a navegacao primaria use bottom navigation.
- [ ] Garantir que destinos secundarios fiquem em `Mais`.
- [ ] Nao implementar login funcional, refresh token ou redirect final por
      sessao.

## Dashboard

- [ ] Criar a estrutura completa da feature `dashboard` conforme a arquitetura.
- [ ] Definir entidades e contratos minimos para os blocos visuais escolhidos.
- [ ] Criar use case e repository orientados ao contrato documentado.
- [ ] Implementar controller com estados explicitos.
- [ ] Construir a pagina do dashboard com hero, KPIs, alertas e movimentos.
- [ ] Prever CTA para abrir o dashboard web quando isso fizer sentido.
- [ ] Tratar restricao financeira sem apresentar erro de carregamento.

## Catalogo

- [ ] Criar a estrutura completa da feature `catalog` conforme a arquitetura.
- [ ] Definir entidade visual e contratos minimos para listagem de produtos.
- [ ] Preparar busca e filtros dentro do escopo aprovado.
- [ ] Implementar controller com estados explicitos.
- [ ] Construir a pagina de catalogo com cards de produto.
- [ ] Tratar `price = null` como restricao valida.
- [ ] Tratar feature desativada e permissao ausente como estados distintos.

## Contexto operacional e Mais

- [ ] Definir onde `Mais` e `Contexto operacional` moram na estrutura atual.
- [ ] Criar a pagina de `Mais` sem acumular placeholders sem responsabilidade.
- [ ] Criar a pagina de contexto operacional baseada em `GET /api/mobile/me`.
- [ ] Exibir usuario, tenant, features e permissoes relevantes.
- [ ] Usar o contexto para explicar disponibilidade de modulos no app.

## Fixtures e assinaturas futuras

- [ ] Criar fontes de fixture locais controladas por feature.
- [ ] Garantir que fixtures nao fiquem dentro de widgets.
- [ ] Preparar assinaturas remotas e comentarios de auth somente onde houver
      ganho real de clareza.
- [ ] Nao chamar endpoints protegidos como se o login mobile ja existisse.
- [ ] Nao tratar fixture como payload validado de producao.

## Componentes compartilhados

- [ ] Criar os componentes compartilhados realmente reutilizaveis em
      `lib/shared/widgets/`.
- [ ] Manter widgets especificos de feature dentro da propria feature.
- [ ] Criar ao menos os componentes base listados na spec ou justificar
      variacoes equivalentes no review.
- [ ] Garantir que os componentes recebam dados de apresentacao, nao
      repositorios ou DTOs.
- [ ] Evitar parametros excessivos e acoplamento visual indevido.

## Documentacao de componentes

- [ ] Preencher `components.md` para cada componente compartilhado criado.
- [ ] Documentar objetivo, API publica, variacoes e limites de uso.
- [ ] Incluir exemplos curtos e realistas.
- [ ] Registrar quando um padrao deve ficar na feature em vez de `shared`.

## Estados e UX

- [ ] Modelar `loading`, `ready`, `refreshing`, `empty`, `restricted`,
      `offline` e `failure` nas telas aplicaveis.
- [ ] Garantir que dados visiveis permanecam durante refresh quando aplicavel.
- [ ] Diferenciar indisponibilidade funcional de erro tecnico.
- [ ] Garantir que cor nao seja o unico sinal de estado.
- [ ] Preservar a identidade visual do tema global existente.

## Qualidade

- [ ] Executar `dart format`.
- [ ] Executar `flutter analyze`.
- [ ] Executar os testes unitarios e de widget afetados.
- [ ] Executar a suite relevante completa.
- [ ] Verificar se as fronteiras arquiteturais continuam aprovadas.
- [ ] Validar visualmente em larguras mobile relevantes.

## Fechamento

- [ ] Registrar arquivos principais no `review.md`.
- [ ] Registrar testes executados e resultados.
- [ ] Registrar limitacoes, dependencias abertas e proximos passos.
- [ ] Registrar qualquer desvio aprovado da spec.
- [ ] Nao marcar esta lista como concluida antes das evidencias.
