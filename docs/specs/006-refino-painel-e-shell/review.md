# Spec 006 - Revisao de Abertura

## Status

Planejada em 18 de junho de 2026. Nao implementada.

## Escopo pretendido

- toggle real de tema no topo;
- drawer lateral operacional;
- conta e alteracao local de nome;
- entrada principal de vendas na navegacao;
- tela inicial de vendas em preparacao;
- remocao do hero generico do dashboard;
- remocao de copy generica e redundante;
- card de ultima atualizacao;
- dois blocos graficos iniciais do painel;
- regra editorial anti-slop documentada.

## Gate de implementacao

FECHADO.

A abertura desta spec nao autoriza implementacao. Esta etapa serve apenas para
criar os arquivos da spec e deixa-los prontos para leitura, critica e
iteracao.

## Fontes consultadas

- `AGENTS.md`;
- `para mobile/00-contexto-operacional.md`;
- `para mobile/02-definicoes-de-interface.md`;
- `para mobile/03-endpoints-mobile.md`;
- `para mobile/designmobile.md`;
- implementacao atual da shell e do dashboard em `lib/`;
- padrao de specs existente em `docs/specs/005-identidade-visual-operacional/`.

## Decisoes ja assumidas pelo pedido do usuario

- a etapa atual e apenas documental;
- a pasta da spec usara o nome `006-refino-painel-e-shell`;
- a spec seguira o padrao de quatro arquivos `.md`;
- o painel sera documentado para perder hero e copy generica;
- o topo sera documentado com toggle de tema;
- a shell sera documentada com drawer lateral funcional;
- `Vendas` entrara como destino principal pretendido;
- a tela de vendas sera documentada como modulo em preparacao;
- a regra contra texto generico desnecessario sera explicita.

## Pontos curtos a refinar antes de aprovar a spec

- confirmar o destino final da acao `Ver conta`;
- confirmar se o drawer tera apenas conta e tenant ou tambem atalhos secundarios;
- refinar o texto curto da futura tela de vendas em preparacao;
- refinar os titulos das futuras secoes do painel.

## Veredito

Spec aberta apenas para leitura e iteracao.

Os quatro arquivos foram criados como documentacao de intencao futura e nao
devem ser lidos como autorizacao de execucao.
