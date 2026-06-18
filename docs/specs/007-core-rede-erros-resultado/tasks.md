# Tasks: Spec 007 - Core de Rede, Erros e Resultado

- [ ] **Fase 1: Configuração e Dependências**
  - [ ] Adicionar dependência `dio` em `pubspec.yaml` e executar `flutter pub get`.
  
- [ ] **Fase 2: Exceções e Interceptores**
  - [ ] Criar `lib/core/network/api_exception.dart` mapeando as subclasses de `NetworkException` (`UnauthorizedException`, etc.).
  - [ ] Criar `lib/core/network/interceptors/redaction_interceptor.dart` para ocultar segredos (`Authorization`, etc.) em logs.

- [ ] **Fase 3: Core do Cliente de Rede**
  - [ ] Criar `lib/core/network/api_client.dart` configurando timeouts, cabeçalhos padrão e interceptores.
  - [ ] Implementar mapeamento centralizado de erros no `ApiClient` para converter `DioException` nas exceções personalizadas de `api_exception.dart`.

- [ ] **Fase 4: Tipos Funcionais e Abstração de Domínio**
  - [ ] Criar `lib/core/utils/result.dart` definindo a estrutura `Result<Success, Failure>`.
  - [ ] Criar `lib/core/failures/failure.dart` e `lib/core/failures/network_failure.dart` mapeando erros de rede para falhas inteligíveis pelo domínio.

- [ ] **Fase 5: Testes e Validação**
  - [ ] Criar testes unitários em `test/core/network/api_client_test.dart` simulando respostas HTTP (`2xx`, `401`, `403`, `422`, `429`, `500`) usando um mock adapter.
  - [ ] Testar se segredos são de fato censurados nos outputs de log.
