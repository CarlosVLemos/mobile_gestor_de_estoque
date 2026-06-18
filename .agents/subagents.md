# Playbook de Subagentes

Este repositorio nao exige multiagente em tarefas pequenas. Use divisao de
responsabilidades quando a tarefa envolver multiplas camadas, risco alto ou
validacao pesada.

## Quando vale a pena dividir

- feature com UI + regra + integracao;
- refactor amplo;
- mudanca de contrato;
- sync/offline;
- migracao de schema;
- revisao com risco de regressao visual e arquitetural.

## Papeis recomendados

### 1. Coordenacao

Responsavel por:

- definir escopo;
- escolher leitura minima;
- separar implementado de planejado;
- consolidar riscos, testes e fechamento.

Perguntas que este agente deve responder:

- o contrato ja existe?
- quais camadas serao afetadas?
- precisa abrir spec?
- quais estados de UI sao obrigatorios?

### 2. Contrato

Responsavel por:

- validar endpoints reais;
- mapear payloads e erros;
- verificar permissoes, feature flags e tenant scope;
- impedir que contrato planejado entre como se fosse real.

Leitura principal:

- `para mobile/03-endpoints-mobile.md`
- `para mobile/04-regras-e-necessidades-mobile.md`
- `para mobile/06-registro-decisoes.md`

### 3. Flutter

Responsavel por:

- implementar ou revisar `Page -> Controller -> UseCase -> Repository`;
- preservar fronteiras de camada;
- tratar estados visuais e responsividade;
- manter alinhamento com tema e widgets compartilhados.

Leitura principal:

- `para mobile/05-arquitetura-mobile.md`
- `para mobile/02-definicoes-de-interface.md`
- codigo da feature afetada

### 4. Qualidade

Responsavel por:

- definir testes minimos relevantes;
- checar risco de regressao arquitetural;
- checar risco de overflow ou regressao visual;
- confirmar limitacoes do ambiente.

Leitura principal:

- `para mobile/08-processo-de-trabalho.md`
- testes existentes da feature

## Sequencia recomendada

1. Coordenacao delimita escopo e leitura.
2. Contrato confirma o que e real e o que ainda depende de backend.
3. Flutter implementa ou revisa a mudanca.
4. Qualidade valida testes, estados e riscos.

## Saida esperada de um handoff curto

- objetivo da tarefa;
- arquivos e camadas afetadas;
- documentos obrigatorios;
- riscos conhecidos;
- o que ja esta implementado;
- o que continua dependente;
- validacao esperada.

## Regra importante

Subagente nao substitui documento canonico. Se aparecer conflito, seguir:

1. `06-registro-decisoes.md`
2. `05-arquitetura-mobile.md`
3. `04-regras-e-necessidades-mobile.md`
4. `02-definicoes-de-interface.md`
5. `03-endpoints-mobile.md`
