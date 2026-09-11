# Tasks — Spec 013D

Status: `IN_PROGRESS`

- [x] Congelar contrato e isolamento.
- [x] Implementar `APP_MODE=normal|demo`, mantendo `normal` como default e rejeitando valor desconhecido.
- [x] Selecionar o runtime somente no composition root, sem duplicar domínio, router, banco, outbox ou SyncEngine.
- [x] Implementar autenticação demo local, sem token real, secure storage remoto ou tentativa de login HTTP.
- [x] Criar o contexto isolado `demo-user/demo-tenant`.
- [x] Implementar seed Drift idempotente como coleção do SyncEngine, com checkpoint próprio e reuso do banco já inicializado.
- [x] Criar categorias com UUID realistas e produtos/clientes com IDs numéricos representados como String.
- [x] Alimentar catálogo e dashboard pelos repositories Drift existentes.
- [x] Conectar a venda demo a `RegisterSaleUseCase -> DriftSalesRepository -> outbox`.
- [x] Implementar `DemoSaleIntentGateway` determinístico, sem Dio.
- [x] Exibir “Modo demonstração” globalmente.
- [x] Logout/teardown demo usa o mesmo boundary contextual e não grava token.
- [ ] Provar por gate executado que nenhuma chamada HTTP é tentada nos fluxos normais do demo.
- [ ] Provar que o runtime normal mantém os providers reais e não recebe seed/gateway demo.
- [ ] Testar parser, bootstrap, auth, isolamento, seed repetido, catálogo, dashboard, venda/outbox e teardown.
- [ ] Executar os gates autorizados: testes focados, suíte completa e análise estática.
- [ ] Documentar o comando `flutter run --dart-define=APP_MODE=demo`, limitações e procedimento de reset controlado.
