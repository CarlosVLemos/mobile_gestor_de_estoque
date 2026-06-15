# Spec 003 - Plano de Testes

## Objetivo

Validar que a interface operacional inicial e navegavel, coerente com a
arquitetura por feature e camada, visualmente consistente com o tema global e
preparada para a futura autenticacao sem fingir que ela ja existe.

## Ambiente de referencia

Registrar durante a implementacao:

```text
Flutter:
Dart:
Plataforma:
Dispositivo ou navegador:
Modo de dados: fixture local / outro fallback aprovado
```

## Testes automatizados

### T-000 - Estrutura e fronteiras

**Tipo:** arquitetura

**Resultado esperado:**

- novas paginas ficam em `presentation/pages/`;
- controllers ficam em `presentation/controllers/`;
- use cases ficam em `application/use_cases/`;
- repositories concretos ficam em `data/repositories/`;
- `presentation` nao importa Dio, Drift, DTO ou repositorio concreto;
- `application` nao conhece widget, JSON ou transporte.

### T-001 - Router e shell

**Tipo:** widget

**Resultado esperado:**

- a shell operacional existe;
- a bottom navigation contem os destinos previstos;
- `Mais` agrega destinos secundarios;
- a startup continua sendo o ponto de entrada do app;
- comentarios de auth existem nos pontos centrais da navegacao.

### T-002 - Dashboard loading

**Tipo:** widget

**Resultado esperado:**

- a pagina renderiza estado de carregamento sem overflow;
- hero e cabecalho respeitam a identidade visual;
- nao ha consulta direta a fixture pelo widget.

### T-003 - Dashboard ready

**Tipo:** widget

**Resultado esperado:**

- KPIs resumidos aparecem em cards reutilizaveis;
- alertas de estoque sao apresentados com semantica correta;
- movimentos recentes sao legiveis em formato compacto;
- CTA para o dashboard web aparece quando o modelo o fornecer.

### T-004 - Dashboard restricted

**Tipo:** widget

**Resultado esperado:**

- restricao financeira nao vira erro generico;
- o usuario entende que o dado existe, mas esta restrito;
- o estado usa componente apropriado e nao solucao improvisada.

### T-005 - Dashboard empty e failure

**Tipo:** widget

**Resultado esperado:**

- `empty` e `failure` possuem mensagens distintas;
- o estado de falha nao apaga os contratos de navegacao da tela;
- o retry, se existir, fica no controller e nao em acesso direto a dados.

### T-006 - Catalogo loading e ready

**Tipo:** widget

**Resultado esperado:**

- a lista de produtos renderiza em cards ou listas mobile;
- nome, SKU, marca, estoque e disponibilidade sao legiveis;
- imagem opcional possui placeholder adequado;
- `price` aparece somente quando estiver disponivel.

### T-007 - Catalogo com preco restrito

**Tipo:** widget

**Resultado esperado:**

- `price = null` nao gera excecao;
- o componente visualiza restricao valida;
- o card continua util mesmo sem preco.

### T-008 - Catalogo restricted e feature disabled

**Tipo:** widget

**Resultado esperado:**

- permissao ausente produz estado restrito;
- feature `catalog` desativada produz modulo indisponivel;
- os dois cenarios nao compartilham a mesma copy sem criterio.

### T-009 - Catalogo empty, filtro e failure

**Tipo:** widget

**Resultado esperado:**

- lista vazia e filtro sem resultado sao distinguiveis;
- `422` orienta ajuste de filtro;
- `429` exibe mensagem acionavel;
- falha tecnica nao e confundida com ausencia de dados.

### T-010 - Contexto operacional

**Tipo:** widget

**Resultado esperado:**

- usuario, tenant, features e permissoes sao apresentados;
- a tela ajuda a entender disponibilidade do app;
- informacoes sensiveis nao sao expostas alem do necessario.

### T-011 - Mais

**Tipo:** widget

**Resultado esperado:**

- a tela centraliza destinos secundarios;
- nao vira deposito de itens sem responsabilidade;
- contexto operacional pode ser aberto por ela.

### T-012 - Componentes compartilhados

**Tipo:** widget/unidade

**Resultado esperado:**

- os componentes base listados na spec possuem testes dedicados quando o risco
  justificar;
- os componentes nao chamam repositorios ou acessam fixture diretamente;
- as variacoes visuais principais sao cobertas.

### T-013 - Reuso e localizacao correta

**Tipo:** arquitetura/estatico

**Resultado esperado:**

- componente compartilhado fica em `shared/widgets/`;
- componente exclusivo fica na feature;
- nao ha duplicata clara de componente entre dashboard e catalogo.

### T-014 - Estados offline e refresh

**Tipo:** widget/controller

**Resultado esperado:**

- telas aplicaveis modelam `offline` e `refreshing`;
- dados visiveis permanecem quando a regra permitir;
- refresh nao zera o conteudo util por padrao.

### T-015 - Regressao do app

**Tipo:** widget/arquitetura

**Resultado esperado:**

- `AraraApp` continua iniciando corretamente;
- tema global existente permanece funcional;
- testes arquiteturais anteriores continuam aprovados.

## Verificacoes estaticas

Executar:

```text
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Tambem revisar buscas por:

```text
AppColors.
Map<String, dynamic>
TODO(auth)
Colors.white
Colors.black
package:dio
package:drift
```

Ocorrencias devem ser interpretadas no contexto. Em especial:

- `TODO(auth)` e esperado apenas em pontos centrais de navegacao e fontes
  remotas futuras;
- `AppColors.` nao deve vazar para widgets fora do tema;
- `Map<String, dynamic>` nao deve sustentar estado visual final.

## Validacao visual

Validar ao menos:

- 360x800;
- 390x844;
- tema claro;
- tema escuro.

Verificar:

- densidade operacional coerente;
- hero escuro do dashboard;
- cards compactos e legiveis;
- badges com semantica correta;
- bottom navigation clara;
- ausencia de overflow;
- ausencia de horizontal scroll como fluxo principal.

## Evidencias

Registrar em `review.md`:

- comandos executados;
- resultados;
- largura e modo visual validados;
- componentes compartilhados criados;
- limitacoes;
- desvios aprovados;
- veredito final.
