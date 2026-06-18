# Roteamento de Leitura

Use este arquivo para descobrir a menor leitura adicional necessaria.

## Sempre

Leia:

- `AGENTS.md`
- `para mobile/00-contexto-operacional.md`
- este diretorio `.agents/`

## Se a tarefa for arquitetura, dependencias ou estrutura

Leia tambem:

- `para mobile/05-arquitetura-mobile.md`
- `para mobile/06-registro-decisoes.md`

Foco:

- camadas;
- decisoes aceitas;
- itens dependentes vs implementados.

## Se a tarefa for regra de negocio, permissao, offline ou sync

Leia tambem:

- `para mobile/04-regras-e-necessidades-mobile.md`
- partes relevantes de `para mobile/05-arquitetura-mobile.md`

Foco:

- multi-tenant;
- permissao backend;
- semantica de `price = null`;
- limites entre intencao offline e confirmacao remota.

## Se a tarefa for tela, componente ou estado visual

Leia tambem:

- `para mobile/02-definicoes-de-interface.md`

Leia `para mobile/designmobile.md` so se o trabalho visual for amplo.

Foco:

- estados de UI necessarios;
- responsividade mobile;
- identidade azul operacional;
- ausencia de overflow.

## Se a tarefa for integracao remota

Leia tambem:

- `para mobile/03-endpoints-mobile.md`
- `para mobile/06-registro-decisoes.md`

Foco:

- distinguir endpoint real de endpoint planejado;
- erros `401`, `403`, `422` e `429`;
- campos tenant-scoped;
- filtros e limites de payload.

## Se a tarefa for processo, spec ou handoff

Leia tambem:

- `para mobile/08-processo-de-trabalho.md`

Foco:

- quando abrir spec formal;
- o que validar;
- como fechar a entrega.

## Se a tarefa depender de ferramentas externas

Leia tambem:

- `para mobile/07-uso-de-mcps.md`

Foco:

- verificar MCP disponivel antes de presumir uso;
- usar fallback documentado;
- nao usar GitHub MCP/Connector enquanto estiver suspenso.

## O que nao fazer por padrao

- nao ler toda a pasta `para mobile/`;
- nao assumir que arquitetura alvo ja esta implementada;
- nao inventar endpoint ausente;
- nao mudar decisao aceita sem registrar primeiro.
