# Spec 004 - Revitalização Estética e Acabamento Premium

## Status

Planejada em 12 de junho de 2026. Pendente de aprovação do usuário.

## Classificacao

- interface;
- refinamento visual;
- componentes reutilizaveis;
- motion / micro-interacoes;
- documentacao.

## Fontes e hierarquia

Esta spec é governada pelo `AGENTS.md` da raiz e usa `para mobile/00-contexto-operacional.md` como ponto de entrada.

Fontes aplicáveis, na ordem de precedência do projeto:

1. decisões aceitas em `para mobile/06-registro-decisoes.md`;
2. interface em `para mobile/02-definicoes-de-interface.md`;
3. blueprint visual em `para mobile/designmobile.md`;
4. processo em `para mobile/08-processo-de-trabalho.md`;
5. implementação atual em `lib/`.

## Problema

O aplicativo atual possui uma fundação visual funcional, mas a experiência de uso ainda é percebida como **"genérica e seca"**. Isso ocorre pelos seguintes fatores:

- **Estilo Material 3 Padrão**: As superfícies (cards e botões) são estáticas, sem efeitos táteis ou de profundidade quando pressionadas ou navegadas.
- **Fundo Chapado**: Embora exista um gradiente atmosférico, ele carece de profundidade visual premium e transições suaves.
- **Transição de Estados Rígida**: Quando a tela muda de estado (ex: de carregando para pronto), a troca de conteúdo é instantânea e abrupta, em vez de fluida.
- **Barras sem Efeito de Vidro**: A barra de navegação inferior (`AppBottomNavigation`) e banners superiores não utilizam efeitos translúcidos reais com blur de fundo, o que tira a sensação moderna de camadas sobrepostas.

## Objetivo

Transformar a interface do aplicativo para que transmita uma sensação **premium, moderna e reativa**, mantendo a identidade analítica e o tom profissional baseados em tons de azul e superfícies limpas.

### Metas Visuais:
1. **Toque Reativo (Feedback Tátil/Visual)**: Adicionar micro-animações de escala e elevação nos cartões principais (`ProductCard`, `KpiCard`) e botões ao serem pressionados.
2. **Glassmorphism Real**: Adicionar efeito de vidro real com desfoque de fundo (`BackdropFilter` com blur de `10.0` a `15.0`) na barra de navegação inferior (`AppBottomNavigation`) e sobreposições.
3. **Fundo Fluido**: Enriquecer o `atmosphericGradient` para melhor difusão dos tons azulados e dourados.
4. **Transições de Estados Suaves**: Envolver as transições de carregamento, sucesso, falha e estado vazio em componentes de animação (`AnimatedSwitcher` com curvas de entrada de desaceleração).

---

## Escopo Técnico e Arquitetura Visual

### 1. Sistema de Temas e Decorações
* **Local**: `lib/app/theme/app_decorations.dart` e `lib/app/theme/app_theme.dart`
* **Mudança**:
  * Refinar o `atmosphericGradient` do tema claro e escuro para suavizar a transição cromática.
  * Ajustar as sombras em `AppShadows` para tons mais suaves (usando dispersões maiores com menor opacidade) para dar aparência de painel flutuante de alta qualidade.
  * Adicionar suporte no `glassSurface` para aplicar um filtro de desfoque real quando acoplado na shell.

### 2. Feedback Interativo de Escala
* **Local**: `lib/shared/widgets/interactive_card.dart` [NOVO]
* **Especificação**: Criar um widget reativo reutilizável que envolve qualquer elemento interativo (cards de produtos, KPIs ou botões). Ao ser tocado, ele:
  * Reduz suavemente sua escala para `0.97` ou `0.98` usando um `TweenAnimationBuilder` ou um `ImplicitlyAnimatedWidget`.
  * Modifica ligeiramente o blur da sombra para dar impressão de que o componente fisicamente "afundou" na tela.
  * Restaura o estado original de forma amortecida (ease-out curve) ao soltar.

### 3. Glassmorphism na Navegação Inferior
* **Local**: `lib/shared/widgets/app_shell_scaffold.dart` e `lib/shared/widgets/app_bottom_navigation.dart`
* **Especificação**:
  * Ajustar o scaffold para permitir que o conteúdo principal (`body`) role por baixo da barra de navegação inferior (`extendBody: true`).
  * Aplicar `BackdropFilter` na decoração `glassSurface` do container da barra inferior para desfocar o conteúdo que passa sob ela.

### 4. Transições de Estado Fluidas nas Páginas
* **Local**: Páginas operacionais (ex: `lib/features/dashboard/presentation/pages/dashboard_page.dart` e `lib/features/catalog/presentation/pages/catalog_page.dart`)
* **Especificação**:
  * Substituir o chaveamento direto de estados por um `AnimatedSwitcher` com uma duração de transição de `250ms` e curva `Curves.easeInOutCubic`.
  * Isso impedirá o "piscar" brusco de telas brancas ao alternar entre carregamento e pronto.

### 5. Reorganização Estrutural de Telas e Posicionamento (Com base no Mockup de Referência)

As diretrizes de layout e organização espacial abaixo seguem o design demonstrado na imagem de referência fornecida pelo usuário, a fim de garantir consistência visual em todo o app.

#### 5.1 Dashboard Page (`dashboard_page.dart` - Referência: "Dashboard Mobile")
* **Cabeçalho/App Bar**: Exibe o título "InventoryPro" em negrito à esquerda, acompanhado de um ícone de notificações (sino) e o avatar circular do usuário à direita.
* **Grid 2x2 de KPIs**: Organizado em duas colunas. Cada cartão possui um rótulo cinza, o valor em destaque (negrito grande) e um indicador de tendência/subtítulo.
  * **Card Crítico (Estoque Baixo)**: Se houver alertas críticos (ex: baixo estoque), o cartão deve refletir isso visualmente através de uma **borda vermelha suave**, fundo levemente avermelhado e texto principal na cor destrutiva (`danger`) para atrair atenção imediata.
* **Card de Gráfico**: "Movimento de Estoque (7 Dias)" exibido em um card unificado com gráfico de barras semanais.
* **Grupo de Movimentos Recentes**: Título "Movimentos Recentes" alinhado a um botão de atalho "Ver Todos". Os itens são agrupados em um único cartão com separadores. Cada linha exibe:
  * Um ícone circular de status à esquerda (símbolo `+` azul para recebimentos, `-` cinza para vendas e um triângulo vermelho para ajustes manuais).
  * O código SKU e o tipo de operação.
  * O saldo movimentado e a data no canto direito.

#### 5.2 Catalog Page e Cards (`catalog_page.dart` e `product_card.dart` - Referência: "Produtos Mobile")
* **Busca e Indicador de Críticos**: Barra de pesquisa arredondada com ícone de lupa e botão de refinamento. Abaixo dela, uma linha com a contagem total de itens ("124 itens no catálogo") e um indicador vermelho destacado à direita mostrando a quantidade de itens críticos ("3 Críticos").
* **Estrutura dos Cards de Produtos**:
  * Imagem/Placeholder arredondado à esquerda.
  * Nome do produto destacado e SKU/marca centralizados.
  * Badge de status (ex: "Ativo" em azul ou "Estoque Baixo" em vermelho) alinhado com a quantidade em estoque ("45 un" com ícone de caixa) e o preço em negrito à direita.
  * **Card de Item Crítico**: O produto em baixo estoque recebe um destaque visual na borda lateral esquerda (indicador vermelho vertical sutil) ou uma borda levemente colorida para indicar urgência.
* **Botão Flutuante (FAB)**: Botão circular escuro de adição (`+`) posicionado no canto inferior direito sobre a lista.

#### 5.3 Navegação Auxiliar (`more_page.dart` - Referência: "Menu e Acessos Web")
* **Perfil do Usuário**: Card no topo contendo o avatar circular do usuário, seu nome ("Administrador Ops"), e-mail ("admin@inventorypro.com") e o botão de logout posicionado à direita.
* **Card Consolidado de Acessos**: Um único cartão grande contendo todos os atalhos agrupados com divisores finos:
  * Itens: *Categories*, *Stock Movements*, *Reports*, *Users & Permissions*, *Offline Sync*, *Business Rules*.
  * Cada item apresenta um ícone representativo à esquerda, texto em peso médio e um ícone indicador de link externo (`openInNew` e seta `chevronRight`) à direita.
* **Ações Secundárias**: Um cartão separado contendo *Settings* (engrenagem) e *Help Center* (interrogação).

---


## Fora de Escopo

- Alteração na lógica de negócios, repositórios, Drift ou Riverpod providers.
- Implementação de novos endpoints ou alteração de contratos.
- Substituição radical de paletas de cores (devemos preservar o azul operacional do `designmobile.md`).

## Riscos e Mitigações

| Risco | Impacto | Mitigação |
| --- | --- | --- |
| Queda de performance em dispositivos antigos devido ao `BackdropFilter` | Médio | Manter o desfoque (`sigmaX`, `sigmaY`) em valores otimizados (máximo `12.0`) e usar `extendBody` somente onde necessário. |
| Quebras de layout na rolagem sob a bottom navigation | Médio | Adicionar preenchimento inferior extra (`bottomPadding` proporcional à altura da bottom navigation) na lista rolável das páginas principais. |
| Testes de widgets existentes falharem por conta de novas transições de animação | Baixo | Utilizar `tester.pumpAndSettle()` adequadamente nos testes de widget para esperar as animações de switcher terminarem. |

## Critérios de Aceite

- [ ] `flutter analyze` não reporta avisos ou erros.
- [ ] O fundo do aplicativo apresenta uma transição de gradiente sutil e limpa.
- [ ] A barra de navegação inferior tem efeito translúcido (vidro com desfoque de fundo) funcional na rolagem.
- [ ] Cartões de produtos e KPIs respondem de forma dinâmica e amortecida ao toque do usuário (micro-escala).
- [ ] Mudanças de estado (como carregar a lista de produtos) aparecem com transição em fade e deslize suave.
- [ ] O dashboard exibe KPIs em grade de 2 colunas e agrupa alertas e movimentos em cartões consolidados com divisórias.
- [ ] O catálogo de produtos utiliza barra de busca compacta e os cards possuem uma estrutura colunar mais limpa e organizada.
- [ ] Atalhos da página "Mais" são agrupados em uma lista única consolidada dentro de um cartão de vidro.

