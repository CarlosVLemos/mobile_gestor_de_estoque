# Spec 009C - Referência de Validação Futura

## Objetivo

Registrar como a futura implementação da Spec 009C (Sincronização de Leitura de Catálogo e Painel) deverá ser validada.

## O que verificar depois

A futura implementação deverá comprovar que:
- O catálogo de produtos e os KPIs do painel são alimentados a partir do banco de dados SQLite (Drift) via streams;
- A inicialização do aplicativo executa o bootstrap de dados com progresso observável;
- O fechamento da tela cancela a subscrição do stream do Drift;
- Desconectar a internet exibe os dados salvos localmente juntamente com um banner informativo;
- A restrição visual financeira (`price = null` no SQLite) exibe "Restrito" ou oculta o preço, sem quebrar os cards do catálogo.

## Cenários de Teste a Cobrir

### 1. Bootstrap Paginado e Retomável
* **Verificar:**
  - Iniciar o aplicativo sem banco local.
  - Simular o endpoint de produtos com 3 páginas de dados (e a flag `has_more_pages` verdadeira nas duas primeiras).
  - Validar que o app executa 3 requisições consecutivas (`page=1`, `page=2`, `page=3`).
  - Validar que o estado visual de bootstrap informa o progresso incremental.
  - Simular queda de rede na página 2, confirmar interrupção do bootstrap e verificar que ao reabrir o app o bootstrap é reiniciado a partir do cursor pendente.

### 2. Stream Auto-Disposable (Vazamentos de Memória)
* **Verificar:**
  - Abrir a página do catálogo.
  - Fechar a página (navegar para outra aba).
  - Validar nos logs ou testes de widget que a subscrição do stream do Drift foi devidamente cancelada (evitando consultas em background em abas invisíveis).

### 3. Convivência de Preços Nulos na UI
* **Verificar:**
  - Criar produtos com preços válidos e alguns com preços `null` no Drift.
  - Abrir o catálogo.
  - Validar que os produtos com preços normais exibem o valor formatado.
  - Validar que os produtos com preço `null` exibem um aviso estilizado ("Preço indisponível" ou "Restrito") e que a tela não sofre quebras ou transbordamento (RenderFlex overflow).

### 4. Modo Offline na UI
* **Verificar:**
  - Com dados locais carregados, ativar o modo offline (simular falha de rede física).
  - Abrir a página de catálogo ou painel.
  - Confirmar que a tela renderiza os dados em cache local imediatamente.
  - Confirmar a renderização do banner `OfflineStateBanner` informando que a sincronização falhou, permitindo o uso normal do catálogo de forma offline.

## Checklist de Validação

- [ ] `ProductSyncCollection` implementa paginação e cursor checkpoints.
- [ ] `DashboardSyncCollection` mapeia KPIs e salva localmente no Drift.
- [ ] Repositórios de Catálogo e Painel usam Streams reativas.
- [ ] Providers do Riverpod usam `.autoDispose`.
- [ ] UI responde a atualizações locais em background.
- [ ] `OfflineStateBanner` integrado e funcional em caso de erro de sync.
- [ ] Testes de integração validando o modo offline passando com sucesso.
- [ ] Testes de widget cobrindo `price = null` passando sem overflow.
