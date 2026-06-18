# Spec 006 - Tarefas de Documentacao

## Objetivo desta etapa

Este arquivo acompanha apenas a abertura documental da Spec 006.

Nao descreve execucao de produto. Nao descreve alteracoes em `lib/`, rotas,
widgets, testes, assets ou dependencias.

## Tarefas

- [x] Criar a pasta `docs/specs/006-refino-painel-e-shell/`.
- [x] Criar `spec.md`.
- [x] Criar `tasks.md`.
- [x] Criar `test.md`.
- [x] Criar `review.md`.
- [x] Consolidar as fontes consultadas nos arquivos da spec.
- [x] Registrar as decisoes ja fechadas pelo pedido do usuario.
- [x] Registrar que a etapa atual nao autoriza implementacao.
- [x] Registrar que `tasks.md` cobre apenas o trabalho documental da spec.
- [x] Revisar consistencia interna entre `spec.md`, `tasks.md`, `test.md` e `review.md`.

## Decisoes ja fechadas para esta abertura

- [x] A pasta da spec usara o nome `006-refino-painel-e-shell`.
- [x] A spec sera escrita em portugues.
- [x] A spec sera orientada a leitura e refinamento, nao a execucao.
- [x] O dashboard tera remocao pretendida de hero generico e copy redundante.
- [x] O topo tera toggle de tema como intencao futura.
- [x] O drawer lateral funcional entrara como intencao futura.
- [x] `Vendas` entrará como destino principal da barra inferior.
- [x] A tela de vendas ficará documentada com fluxo funcional interativo de carrinho e cliente em memória.
- [x] `Alterar nome` ficará documentado como ação local e visual.
- [x] A regra anti-slop textual ficará explícita na spec.

## Pontos ainda abertos para refinamento textual

- [x] Integrar a dependência futura de persistência física local (chave-valor/SQLite) no roadmap da spec.
- [x] Detalhar os cenários de carrinho de compras e seletor de cliente no módulo de vendas.
- [ ] Confirmar se `Ver conta` deve apontar para a tela atual de contexto operacional.
- [ ] Confirmar se o drawer terá apenas conta e tenant ou também atalhos secundários.

## Checklist de pronta para leitura

- [x] O status da spec esta marcado como planejado.
- [x] O gate de implementacao esta fechado.
- [x] Nenhum arquivo descreve implementacao como se ja existisse.
- [x] Nenhum arquivo autoriza mudanca em codigo do app.
- [x] O conjunto esta curto, legivel e orientado a revisao humana.
- [x] A etapa atual esta identificada explicitamente como criacao documental.
