# Tasks — Spec 013D

Status: `PAUSED`

- [x] Congelar contrato e isolamento.
- [ ] Implementar `APP_MODE=normal|demo`, mantendo `normal` como default e rejeitando valor desconhecido.
- [ ] Selecionar o runtime somente no composition root, sem duplicar domínio, router, banco, outbox ou SyncEngine.
- [ ] Implementar autenticação demo local, sem token real, secure storage remoto ou tentativa de login HTTP.
- [ ] Criar o contexto isolado `demo-user/demo-tenant` e comprovar que seu arquivo Drift difere dos bancos reais.
- [ ] Implementar seed Drift idempotente como coleção do SyncEngine, com checkpoint próprio e reuso do banco já inicializado.
- [ ] Criar categorias com UUID realistas e produtos/clientes com IDs numéricos representados como String.
- [ ] Alimentar catálogo e dashboard pelos repositories Drift existentes.
- [ ] Conectar a venda demo a `RegisterSaleUseCase -> DriftSalesRepository -> outbox`.
- [ ] Implementar `DemoSaleIntentGateway` determinístico, sem Dio, preservando idempotência e replay confirmado.
- [ ] Exibir “Modo demonstração” globalmente e identificar dados fictícios em Settings.
- [ ] Garantir que logout/teardown demo feche apenas o contexto ativo e não apague token ou banco real.
- [ ] Provar que nenhuma chamada HTTP é tentada nos fluxos normais do demo.
- [ ] Provar que o runtime normal mantém os providers reais e não recebe seed/gateway demo.
- [ ] Testar parser, bootstrap, auth, isolamento, seed repetido, catálogo, dashboard, venda/outbox e teardown.
- [ ] Executar os gates autorizados: testes focados, suíte completa e análise estática.
- [ ] Documentar o comando `flutter run --dart-define=APP_MODE=demo`, limitações e procedimento de reset controlado.
