# Spec 017 — Design system operacional e acessibilidade

Estado: `draft` | Classificação: `STANDARD (CRITICAL se alterar contrato funcional)` | Data: 2026-11-25

## Objetivo
Fazer o aplicativo legível, previsível e rápido para profissionais acima de 40 anos, sem pressupor baixa capacidade técnica.

## Dependências e rastreabilidade
015; contrato 018 para integração de campos; 016 para semântica offline.

Issues existentes relacionadas: 11 (componentização visual), 14, 18. A relação é temática e muitos-para-muitos, não equivale a fechamento de issue.

## Escopo
- Tokens existentes, componentes de quantidade/moeda/busca, estados, tema, acessibilidade e testes com usuários representativos.
- Padrões de entrada e feedback, não apenas estética.

## Fora de escopo
- Trocar identidade navy/Instrument Sans; reescrever rotas; calcular preço ou autorizar venda no widget; redesign total sem evidência.

## Requisitos e critérios de aceite
- **REQ-017-01** — Manter design system Spec 014, Instrument Sans, azul/navy, AppIcons/Lucide e estados existentes; reduzir densidade onde prejudicar leitura. Texto principal preferencialmente 16sp, contraste WCAG 4.5:1 para texto comum e 3:1 para grande/controles aplicáveis; toque >=48dp; 320dp e escala 2.0 sem overflow nos fluxos críticos.
- **REQ-017-02** — AppQuantityInput: teclado numérico, seleção/edição direta, +/−, validação inteira positiva e limites de contrato; aceitar estado vazio enquanto edita, não registrar inválido; atalhos opcionais avaliados com usuários. Campo deve permitir 1→100 sem 99 toques.
- **REQ-017-03** — AppMoneyInput/percentual: formato pt-BR, colagem, precisão em unidade monetária exata conforme 019/023; sem float como fonte de verdade; distinguir rascunho de valor validado.
- **REQ-017-04** — AppSearchField e pickers: label persistente, limpar busca, teclado/foco, resultados compreensíveis, estado vazio, seleção visível; sem gesto escondido como única ação.
- **REQ-017-05** — AppConnectivityStatus e AppPendingOperationCard usam estados tipados da 016/019, sem inventar online ou confirmação; CTA principal visível sem cobrir conteúdo.
- **REQ-017-06** — Persistir tema Sistema/Claro/Escuro como preferência não sensível; respeitar tema do SO. Remover jargões, fornecer Undo quando reversível e confirmação quando necessário.
- **REQ-017-07** — QA-014-16: TalkBack e ordem de foco em Android; teste qualitativo com 5–8 vendedores, incluindo pessoas 40+; não extrapolar a amostra. Registrar tempo, erros, necessidade de ajuda e feedback.

## Decisões antes do freeze
- [ ] Aprovar hierarquia de tipografia e protótipos de quantidade/negociação com usuários.
- [ ] Confirmar se atalhos de quantidade são úteis; limites numéricos vêm do contrato, não de um valor arbitrário.

## Fechamento
Contrato aprovado; tarefas e critérios atendidos; evidência de CI do SHA candidato, checks manuais quando aplicáveis e veredito de Mefisto. Jarvis registra fechamento somente após gate humano. Nenhum teste local sem autorização explícita atual.
