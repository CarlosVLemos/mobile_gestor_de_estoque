# Processo de Trabalho Mobile

## Objetivo

Este processo organiza uma entrega sem exigir releitura integral do projeto.

## Fluxo padrão

### 1. Orientar

- ler `00-contexto-operacional.md`;
- identificar feature e camadas afetadas;
- ler apenas os documentos indicados;
- verificar decisões aceitas e dependências abertas;
- inspecionar o código diretamente relacionado.

### 2. Classificar

Definir se a mudança é:

- correção;
- feature;
- arquitetura;
- interface;
- integração;
- sincronização/offline;
- documentação.

Abrir especificação formal quando houver múltiplas camadas, mudança de contrato,
suporte offline, migração, risco elevado ou trabalho dividido.

### 3. Decidir

Antes de implementar:

- confirmar contrato existente;
- listar estados de UI necessários;
- identificar persistência e migração;
- identificar permissões;
- registrar nova decisão arquitetural quando houver.

Não transformar hipótese em regra apenas porque o código precisa de uma resposta.

### 4. Implementar

- manter o escopo na feature;
- seguir as fronteiras de camadas;
- reaproveitar padrões existentes;
- adicionar testes junto da mudança;
- atualizar documentação somente quando comportamento ou decisão mudar.

### 5. Validar

Executar o subconjunto aplicável:

```text
dart format
flutter analyze
flutter test
teste de widget
teste de integração
validação visual
```

Para mudanças local-first:

- testar sem conexão;
- testar refresh mantendo dados;
- testar falha parcial;
- verificar persistência após reinício.

### 6. Fechar

Registrar:

- o que mudou;
- arquivos principais;
- testes executados;
- limitações;
- decisões novas;
- dependências externas abertas.

## Quando criar uma especificação

Criar pasta em `docs/specs/<id>-<nome>/` quando houver:

- nova feature relevante;
- alteração de contrato;
- mudança de schema;
- sincronização ou outbox;
- refactor amplo;
- mais de uma etapa de implementação;
- aceite que precise de validação formal.

Estrutura mínima:

```text
docs/specs/<id>-<nome>/
  spec.md
  tasks.md
  test.md
  review.md
```

Este repositório não deve depender de caminhos SDD existentes somente em outro
projeto. Se a feature também exigir backend, cada repositório mantém sua
execução e compartilha o contrato acordado.

## Conteúdo mínimo da spec

- problema;
- objetivo;
- fora de escopo;
- regras de negócio;
- decisões afetadas;
- contrato consumido;
- estados de interface;
- dados locais;
- riscos;
- critérios de aceite.

## Handoff por responsabilidade

Nomes de agentes podem comunicar responsabilidade, mas não substituem arquivos,
decisões ou testes.

| Responsabilidade | Entrega |
| --- | --- |
| Coordenação | escopo, ordem, aceite e fechamento |
| Contrato | payload, erros, permissões e sincronização |
| Flutter | arquitetura, estado, UI e persistência |
| Qualidade | testes, regressão, segurança e veredito |

Não é obrigatório usar múltiplos agentes em tarefas pequenas.

## Checklist de início

- [ ] Li o contexto operacional.
- [ ] Sei quais decisões aceitas se aplicam.
- [ ] Diferenciei contrato existente de planejado.
- [ ] Identifiquei camadas e arquivos afetados.
- [ ] Sei quais estados de UI tratar.
- [ ] Defini como validar.

## Checklist de fechamento

- [ ] Formatação executada.
- [ ] Análise estática executada.
- [ ] Testes relevantes executados.
- [ ] Estados de erro e offline verificados.
- [ ] Documentação atualizada quando necessário.
- [ ] Nova decisão registrada quando necessário.
- [ ] Limitações relatadas.

## Atalhos para novos pedidos

### Implementação de feature

```text
Implemente <feature>.
Use o contexto operacional e leia apenas os documentos indicados para a tarefa.
Escopo: <telas/casos de uso>.
Fora de escopo: <itens>.
Contrato: <existente, mock explícito ou dependente>.
Valide com <testes>.
Use os MCPs disponíveis conforme a política do projeto.
```

### Correção

```text
Corrija <problema> em <feature>.
Preserve as decisões aceitas e não amplie o escopo.
Investigue a causa, implemente a correção e execute os testes afetados.
```

### Decisão arquitetural

```text
Analise a decisão <tema>.
Compare opções, impactos, migração e riscos.
Não implemente antes de registrar a decisão em 06-registro-decisoes.md.
Use Sequential Thinking se estiver disponível.
```

### Interface

```text
Implemente/ajuste a tela <nome>.
Use 02-definicoes-de-interface.md e somente as seções relevantes do design.
Trate os estados <lista>.
Valide visualmente e com testes de widget aplicáveis.
```

### GitHub

```text
Use o GitHub MCP para <issue/PR/review>.
Repositório: CarlosVLemos/mobile_gestor_de_estoque.
Não faça escrita remota sem confirmar o alvo.
```
