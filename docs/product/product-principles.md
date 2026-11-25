# Princípios de produto — Arara-Gastos Mobile

Status: proposta para aprovação | 25/11/2026

## Contexto comercial
Comércio presencial e força de vendas em campo, clientes em regiões de conectividade irregular; profissionais experientes, muitos acima dos 40 anos, nem sempre habituados a interfaces complexas. Não confundir idade com incapacidade. A plataforma web concentra administração; o mobile prioriza tarefas frequentes e decisões rápidas.

## Contextos de uso
- Vendedor: central de trabalho, nova venda, clientes/produtos, rascunho, histórico próprio, pendências e Flex quando habilitado.
- Gerência: painel comercial compacto, evolução, estoque e pendências conhecidas, respeitando permissões e atualidade dos dados.
- Administração: regras comerciais, usuários, auditoria e relatórios avançados predominantemente no web.
- Pessoa com capacidades múltiplas: definir landing por política explícita; não deduzir autorização pelo cargo.

## Invariantes de experiência e negócio
1. Operação local-first não equivale a autorização financeira definitiva offline.
2. Registrar localmente, enviar, confirmar e revisar são estados diferentes, sempre comunicados.
3. Ações frequentes exigem poucos toques; quantidade digitável, pesquisa tolerante a acentos, atalhos opcionais.
4. Respeitar dados restritos, tenant e autoridade do servidor; não usar dados fictícios para preencher UI normal.
5. Evitar perda de trabalho em falha, reinício ou atualização; preservar rascunhos e operações pendentes.
6. Prevenir erro em vez de apenas explicar depois; feedback acionável e sem jargão técnico.
7. Evoluir por evidência de uso e testes, não por volume de funcionalidades.

## Cenários de aceitação transversais
Vendedor trabalha o dia com conexão intermitente, retoma após reiniciar, registra venda de 5 itens e quantidade 100, enfrenta estoque alterado na reconexão e entende o ajuste. Gerente consulta dados confirmados e vê quando o painel foi atualizado. Uma atualização do aplicativo não perde pendências. Flex usa modelo de mercado adaptado ao offline, com saldo remoto soberano e regras financeiras congeladas separadamente.

Metas propostas (não medidas): venda 5 itens <=90s; p95 busca <=300ms em 10 mil produtos em dispositivo definido; alteração 1→100 por entrada direta; nenhuma perda/duplicação nos cenários de E2E; avaliar conclusão de tarefas sem ajuda em piloto qualitativo de 5–8 usuários. Fixar condições e baseline antes de tornar limiares bloqueantes.
