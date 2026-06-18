# Spec 007: Core de Rede, Erros e Resultado

## Problema
O aplicativo não possui um cliente HTTP configurado e centralizado, dependendo de mock repositories e dados em memória (fixtures). Para preparar a integração com as rotas do Laravel, é crucial estruturar a camada de transporte de forma segura, com políticas claras de tratamento de erros, formatação de logs sem vazamento de segredos e um padrão de retorno consistente para as camadas de aplicação.

## Objetivo
Implementar a infraestrutura base de rede do aplicativo usando o pacote `Dio`, estabelecendo interceptores de segurança, mapeamento estruturado de erros HTTP (`401`, `403`, `422`, `429`, `5xx`) e o padrão de retorno `Result` para comunicação segura entre repositórios e casos de uso.

## Fora de Escopo
* Integração direta com persistência local (Drift/SQLite).
* Telas de login/logout ou lógica de gerenciamento de sessão ativa.
* Chamadas reais aos endpoints de catálogo, dashboard ou vendas.

## Regras de Negócio e Diretrizes Técnicas
1. **Ocultação de Segredos em Logs (Redaction):**
   * O interceptor de logs (`LogInterceptor` do Dio ou customizado) deve interceptar cabeçalhos (`Authorization`, `X-Tenant-ID`) e mascarar valores sensíveis (ex: substituindo por `[REDACTED]`).
2. **Mapeamento de Status HTTP:**
   * `401 Unauthorized` -> `UnauthorizedException` (Sinaliza que o token expirou ou é inválido).
   * `403 Forbidden` -> `ForbiddenException` (Acesso negado à feature ou tenant bloqueado).
   * `422 Unprocessable Entity` -> `InvalidParamsException` (Erros de validação do Laravel).
   * `429 Too Many Requests` -> `RateLimitException` (Limite de requisições excedido).
   * `5xx Server Error` -> `ServerException` (Erros internos do backend).
3. **Casos de Uso Imunes a Detalhes de Transporte:**
   * Seguindo a regra **MOB-003**, a camada de `application` e `domain` não deve importar ou conhecer classes do `Dio` ou exceções de rede brutas.
   * Os repositórios devem capturar as exceções e retornar um wrapper de resultado `Result<T, Failure>`.

## Estrutura de Arquivos Proposta
```text
lib/core/
  network/
    api_client.dart           # Wrapper em torno do Dio
    api_exception.dart        # Exceções mapeadas (401, 403, etc.)
    interceptors/
      redaction_interceptor.dart  # Cobre segredos nos logs
  failures/
    failure.dart              # Classe base de falhas do domínio
    network_failure.dart      # Falhas de rede mapeadas para domínio
  utils/
    result.dart               # Padrão funcional Result/Either
```

## Critérios de Aceite
* A adição de `dio` no `pubspec.yaml` não causa conflitos de versão.
* Um cliente `ApiClient` pode ser instanciado e injetado via Riverpod.
* Requisições que retornam códigos de status de erro disparam as exceções de rede correspondentes.
* Mensagens impressas no console durante requisições não exibem segredos de autenticação em texto claro.
* A suíte de testes unitários cobre o mapeamento de status de erro e o interceptor de redação de segredos.
