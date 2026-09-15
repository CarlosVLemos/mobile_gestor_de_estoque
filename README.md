# Arara-Gastos Mobile

Aplicativo Flutter do Arara-Gastos, organizado por feature e camada para
evoluir como cliente operacional local-first.

## Orientação

- [Contexto operacional](para%20mobile/00-contexto-operacional.md)
- [Arquitetura mobile](para%20mobile/05-arquitetura-mobile.md)
- [Especificações](docs/specs)

Antes de alterar o aplicativo, siga as instruções de `AGENTS.md` e leia o
contexto operacional.

## Modo demonstração

```powershell
flutter run -d <ID_DO_DISPOSITIVO> --dart-define=APP_MODE=demo
```

O modo demo usa um banco isolado e não precisa de API ou credenciais. Ele traz
produtos com estados de estoque variados, clientes, indicadores e gráficos do
painel, movimentos fictícios e duas vendas históricas de exemplo. Vendas
registradas no app continuam persistidas no mesmo banco demo. A coleção de seed
`demo_seed_v6` atualiza instalações demo anteriores sem apagar essas vendas e
gera um novo snapshot para o mês corrente.
