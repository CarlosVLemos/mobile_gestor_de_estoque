# Tasks: Spec 007 - Core de Rede, Erros e Resultado

Status auditado em 18 de junho de 2026 com base no working tree, no diff local e
na execucao de `flutter analyze`, `flutter test test/core/network/api_client_test.dart`
e `flutter test test/architecture/layer_boundaries_test.dart`.

- [x] **Fase 1: Configuracao e Dependencias**
  - [x] Adicionar dependencia `dio` em `pubspec.yaml` e executar `flutter pub get`.

- [x] **Fase 2: Excecoes e Interceptores**
  - [x] Criar `lib/core/errors/api_exception.dart` mapeando as subclasses de `NetworkException` (`UnauthorizedException`, `NoInternetException`, `ConnectionTimeoutException`, etc.).
  - [x] Criar `lib/core/network/interceptors/redaction_interceptor.dart` para ocultar segredos (`Authorization`, `X-Tenant-ID`, query string e payloads sensiveis) em logs de depuracao.

- [x] **Fase 3: Core do Cliente de Rede**
  - [x] Criar `lib/core/network/api_client.dart` configurando timeouts, cabecalhos padrao e interceptores.
  - [x] Implementar mapeamento centralizado de erros no `ApiClient` para converter `DioException` (incluindo falhas fisicas e timeouts) nas excecoes personalizadas de `api_exception.dart`.

- [x] **Fase 4: Tipos Funcionais e Abstracao de Dominio**
  - [x] Criar `lib/core/result/result.dart` definindo a estrutura selada `Result<Success, Failure>`.
  - [x] Criar `lib/core/errors/failure.dart` e `lib/core/errors/network_failure.dart` mapeando erros de rede e conectividade para falhas inteligiveis pelo dominio.
    A extensao `ApiExceptionToNetworkFailure` centraliza a conversao e preserva
    erros de validacao por campo.

- [x] **Fase 5: Testes e Validacao**
  - [x] Criar testes unitarios em `test/core/network/api_client_test.dart` simulando respostas HTTP (`2xx`, `401`, `403`, `422`, `429`, `500`) e falhas de conexao/timeouts usando um mock adapter.
  - [x] Testar se segredos e payloads sensiveis sao de fato censurados nos outputs de log.
  - [x] Testar desestruturacao do pattern matching do `Result` com switch do Dart.
