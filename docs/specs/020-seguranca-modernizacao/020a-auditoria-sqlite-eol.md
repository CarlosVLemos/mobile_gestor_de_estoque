# Auditoria 020A — sqlite3_flutter_libs

Estado: `in_progress` | Base: `805873f6832c33a7213ceaaf52500c544a7829e4` | Issue: [#19](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/19)

## Constatações

- `pubspec.yaml` declara `sqlite3: ^3.5.2`, `drift: ^2.34.4` e `sqlite3_flutter_libs: ^0.6.0+eol`. No lock, sqlite3 é 3.5.2 e o pacote EOL aparece como dependência direta.
- `database_factory.dart` usa `drift/native.dart`, `NativeDatabase.createInBackground` e configura `sqlite3.tempDirectory`. A pesquisa no código e nas pastas de plataforma não encontrou imports ou chamadas ao pacote EOL.
- A [documentação do pacote](https://pub.dev/packages/sqlite3_flutter_libs) informa que a versão 0.6.0 não contém funcionalidade e que o pacote não é necessário após migrar para sqlite3 3.x.
- A [documentação Drift para plataformas nativas](https://drift.simonbinder.eu/platforms/vm/) descreve suporte nativo via `drift/native.dart` com Drift 2.32+ e sqlite3 3.x. Isso é evidência de compatibilidade geral, não comprovação do build ou da atualização de dados deste app.

## Limites e próximo passo

A remoção direta é candidata à implementação após o contrato aplicável e a validação
das plataformas alvo. Antes da remoção, conferir o grafo de dependências resolvido:
uma dependência transitiva pode manter o pacote no lock mesmo depois da remoção direta.
Não editar `pubspec.lock` manualmente como substituto de resolução do gerenciador.

Validar resolução e inicialização do banco, migrations suportadas, abertura de dados
existentes com outbox, build Android, instalação limpa e atualização sobre uma
instalação existente. Testar outras plataformas somente se forem alvo do produto.
Não apagar ou recriar o banco para contornar falha de migração.

## Evidência de execução

Grafo resolvido, testes, migrações, build, instalação e atualização: `NOT_RUN`.
Flutter/Dart não disponíveis no ambiente de auditoria. Não houve alteração em
dependências, lockfile, schema ou runtime. Issue #19 continua aberta.
