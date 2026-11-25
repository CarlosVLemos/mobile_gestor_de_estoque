# Spec 016 — Confiabilidade offline, sessão e recuperação

Estado: `draft` | Classificação: `CRITICAL` | Data: 2026-11-25

## Objetivo
Permitir trabalho em campo com internet intermitente, preservando cada operação e evitando duplicação ou acesso indevido.

## Dependências e rastreabilidade
015 para merge; 020 para política de segurança; contrato Laravel para sessão/reconciliação.

Issues existentes relacionadas: 1, 3, 9, 13, 15. A relação é temática e muitos-para-muitos, não equivale a fechamento de issue.

## Escopo
- Submissão única, cold start offline, política de sessão, reconexão foreground, retry, timezone, linguagem de erros e recuperação.
- Cenários de processo encerrado, token expirado, permissões revogadas e conflito de estoque.

## Fora de escopo
- Autorização remota offline definitiva; background como garantia; purga automática de vendas pendentes; mudanças de Flex (023).

## Requisitos e critérios de aceite
- **REQ-016-01** — Travar submissão no controller/use case na fronteira da operação e CTA ocupado; snapshot do carrinho e identidade estável por tentativa lógica; duas chamadas concorrentes não geram duas vendas. Retry após falha usa identidade quando resultado é incerto; nova venda deliberada recebe ID novo.
- **REQ-016-02** — Restaurar sessão normal via /me quando possível; offline somente com contexto previamente validado e política de validade aprovada. Nunca permitir primeiro login offline ou reutilizar identidade de outro contexto; não renovar TTL apenas por abrir app; relógio adulterado ou contexto inválido falha fechado.
- **REQ-016-03** — Distinguir offline, conexão sem API, erro transitório, credencial inválida, tenant suspenso e troca obrigatória de senha. Na reconexão revalidar sessão/permissões antes de drenar outbox; revogação bloqueia ações, preserva dados pendentes em quarentena sem envio não autorizado.
- **REQ-016-04** — Foreground reconecta com debounce, single-flight, cooldown/backoff e cancelamento contextual; não tratar Wi-Fi como prova de reachability. Garantir retry futuro com gatilho/timer controlado e sem polling agressivo; background best effort fica fora do gate inicial.
- **REQ-016-05** — Validar zona IANA existente, timezone configurável por operação/empresa conforme contrato; não inferir America/Sao_Paulo para Pará. Guardar timestamps e offset conforme contrato; não alterar datas históricas.
- **REQ-016-06** — Erros humanos sem Text(error) bruto; classificação tipada e mensagem acionável; logs sem PII/segredos. Nunca esconder cache válido por falha transitória nem chamar pendência de venda confirmada.
- **REQ-016-07** — Exercitar jornada de um dia desconectado: login prévio, múltiplas vendas, reinício, retomada e envio; perda zero e duplicação zero no cenário autorizado.

## Decisões antes do freeze
- [ ] TTL offline, escopo de ações, política de dispositivo compartilhado/relógio e recuperação por revogação (proposta: janela limitada configurável; não congelar número sem negócio/segurança).
- [ ] Definir se comprovante offline existe e como rotulá-lo; sem comprovação definitiva até confirmação.

## Fechamento
Contrato aprovado; tarefas e critérios atendidos; evidência de CI do SHA candidato, checks manuais quando aplicáveis e veredito de Mefisto. Jarvis registra fechamento somente após gate humano. Nenhum teste local sem autorização explícita atual.
