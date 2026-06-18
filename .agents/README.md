# `.agents/`

Camada de contexto rapido para agentes que trabalham neste repositorio.

Objetivo:

- reduzir releitura de documentos longos em tarefas comuns;
- apontar o menor caminho de leitura por tipo de trabalho;
- registrar o estado atual do app sem fingir que a arquitetura alvo ja existe;
- orientar handoff entre agentes quando a tarefa justificar.

Regras:

- esta pasta nao substitui `AGENTS.md` nem `para mobile/00-contexto-operacional.md`;
- em caso de conflito, valem os documentos canonicos;
- resumos aqui devem ser curtos, operacionais e atualizados junto com mudancas relevantes;
- nao registrar como implementado o que ainda estiver apenas planejado.

Arquivos:

- `quick-context.md`: fotografia curta do projeto e das restricoes mais importantes.
- `task-routing.md`: o que ler e o que evitar por tipo de tarefa.
- `subagents.md`: sugestao de divisao de responsabilidades para trabalho multiagente.

Uso recomendado:

1. Ler `quick-context.md`.
2. Ler `task-routing.md` para descobrir a leitura minima adicional.
3. Se a tarefa for grande, usar `subagents.md` para dividir responsabilidades.
4. Em duvida, voltar para `AGENTS.md` e `para mobile/00-contexto-operacional.md`.
