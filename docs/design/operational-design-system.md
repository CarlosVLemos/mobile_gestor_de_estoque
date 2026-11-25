# Design operacional — extensão da Spec 014

Status: proposta | A 014 permanece encerrada com restrição QA-014-16.

Preservar identidade navy, Instrument Sans, Lucide/AppIcons, tokens e temas claro/escuro. Avaliar densidade e hierarquia a partir da tarefa, não simplesmente aumentar todos os elementos.

| Controle | Padrão |
| --- | --- |
| Quantidade | Campo editável +/−; teclado numérico; estado vazio durante edição; validar no use case; limites do contrato; atalhos se úteis. |
| Valor/percentual | Rótulo permanente; pt-BR; precisão exata; não converter erro em zero; percentual derivado da base e política. |
| Busca | Texto claro, limpar, tolerância a acentos, debounce, paginação, estado vazio e foco previsível. |
| Produto | Nome, SKU, estoque conhecido e atualização; preço só autorizado; seleção explícita. |
| Venda | Cliente, itens, edição, resumo, CTA destacado com trava e feedback; rascunho persistente; confirmação remota distinta. |
| Pendência | Estado em texto + ícone, motivo acionável, ação válida; não exibir enum/JSON. |
| Proposta | Comparar antes/depois, motivos e totais, aceite explícito da revisão; sem aceite cego. |
| Dashboard | Poucos indicadores relevantes à capacidade, escopo temporal e última atualização. |

## Linguagem
Aguardando envio; Enviando venda; Venda confirmada; Venda precisa de revisão; Aguardando nova tentativa; Venda não confirmada. Sem outbox, payload, tenant, cursor ou stack trace na UI. Offline não equivale a API indisponível: identificar o que é conhecido.

## Verificação
- Texto principal preferencialmente 16sp; toque >=48dp; contraste 4.5:1 normal e 3:1 grande/controles aplicáveis.
- 320dp, escala 2.0, teclado, scroll, foco, TalkBack, temas claro/escuro; cor nunca é o único sinal.
- Golden determinístico complementa widget/semântica e teste manual. Não aprovar mudança visual automaticamente.
- Avaliação qualitativa com vendedores e gerência; medir tarefa, erros, ajuda e hesitações. Manter feedback anônimo/minimizado.

## Navegação proposta
Central de trabalho para vendedor, dashboard para gerência; rotas e regras de landing deverão constar em contrato 018/019 antes de mudar router. Administração complexa permanece web. Não criar atalhos para módulos inexistentes.
