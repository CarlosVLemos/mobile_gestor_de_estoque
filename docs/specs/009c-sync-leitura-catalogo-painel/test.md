# Plano de validação — Spec 009C

## Produtos

### Bootstrap paginado

Simular `per_page` pequeno e validar várias páginas por `next_cursor`, sem duplicação e com `target_checkpoint` estável.

### Delta

Após rodada concluída, iniciar nova rodada com checkpoint anterior e receber apenas mudanças da nova janela.

### Tombstone

Produto previamente ativo recebe `{id, deleted_at}`: linha fica não operacional e referência histórica permanece. Se o produto reaparecer posteriormente, upsert limpa tombstone.

### Falha parcial

Falha antes do commit não promove cursor/checkpoint. Repetir a página produz o mesmo estado final.

### Cursor

- cursor adulterado/422 produz falha de sync acionável;
- nenhum reset de banco;
- cursor nunca é reutilizado entre contextos.

## Dashboard

- snapshot com revision A é persistido e emitido pela stream;
- novo snapshot revision B substitui atomicamente o mesmo escopo;
- falha de rede conserva revision A e dados visíveis;
- `can_view_financial = false` e valores financeiros null são aceitos;
- alteração de `goal_month` usa scope independente.

## UI local-first

- tela renderiza dados locais antes/durante refresh;
- sync concluído atualiza UI via Drift sem navegação manual;
- falha mostra estado offline/indisponível sem tela vazia;
- logout/troca de contexto cancela observações do banco anterior.

## Arquitetura

Testes de boundaries devem continuar impedindo Dio/Drift em presentation/application.
