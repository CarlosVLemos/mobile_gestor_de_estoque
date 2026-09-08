# Spec 007 - Validação de fechamento

## Objetivo

Registrar a validação da implementação da Spec 007 (Core de Rede, Erros e
Resultado). Os cenários permanecem como referência de regressão.

## O que verificar depois

A implementação comprova que:
- O pacote `dio` foi adicionado e as requisições HTTP ocorrem através dele;
- O `ApiClient` está configurado com timeouts de conexão e interceptores corretos;
- O `RedactionInterceptor` remove segredos dos logs impressos no console;
- Logs padrao so ficam ativos em builds de debug; URIs e mensagens de erro nao
  podem reintroduzir segredos mascarados em headers, query ou payload;
- Respostas HTTP com erro disparam exceções tipadas de rede;
- Falhas de conexão física (ex: modo avião, timeout) são capturadas e mapeadas para exceções;
- O mapeador converte exceções de rede em falhas de domínio;
- Repositórios remotos futuros podem converter exceções tipadas em
  `Result<Success, Failure>` sem expor Dio a application ou domain; nenhuma
  feature remota concreta faz parte desta spec.

## Cenários de Teste a Cobrir

### 1. Mascaramento de Informações Sensíveis (Redaction)
* **Verificar:**
  - Enviar requisição com cabeçalho `Authorization: Bearer meu-token-secreto`.
  - Enviar requisição com cabeçalho `X-Tenant-ID: 123`.
  - Enviar requisição com payload contendo `"password": "senha-secreta"`.
  - Confirmar nos logs gerados no console que os valores foram substituídos por `[REDACTED]`.
  - Confirmar tambem a ausencia dos valores originais, inclusive quando o
    segredo estiver na URI de request, response ou erro.

### 2. Mapeamento de Status HTTP
* **Simular via Mock Adapter:**
  - Resposta `200 OK` -> Retorna dados com sucesso.
  - Resposta `401 Unauthorized` -> Lança `UnauthorizedException`.
  - Resposta `403 Forbidden` -> Lança `ForbiddenException`.
  - Resposta `422 Unprocessable Entity` -> Lança `InvalidParamsException` (validando o carregamento dos erros de validação).
  - Resposta `429 Too Many Requests` -> Lança `RateLimitException`.
  - Resposta `500 Internal Server Error` -> Lança `ServerException`.

### 3. Falhas Físicas e Timeouts
* **Simular via Mock Adapter:**
  - Timeout de Conexão -> Lança `ConnectionTimeoutException`.
- Falha de Resolução DNS / SocketException -> Lança `NoInternetException`.
- Cancelamento pelo Dio -> Lança `RequestCancelledException` e pode ser
  distinguido de erro de conectividade.

### 4. Padrão Result
* **Verificar:**
  - Repositório intercepta as exceções mapeadas e as envelopa em `Result.failure(NetworkFailure)`.
  - Casos de sucesso retornam `Result.success(T)`.
  - Validação de código utilizando pattern matching (`switch`) do Dart para desestruturar o retorno.

## Checklist de Validação

- [x] Dependência do `dio` configurada no `pubspec.yaml`.
- [x] Interceptor de log censura cabeçalhos (`Authorization`, `X-Tenant-ID`, `Cookie`, `Set-Cookie`).
- [x] Interceptor de log censura chaves confidenciais no corpo do JSON (`password`, `token`, etc.).
- [x] Exceções para 401, 403, 422, 429, 5xx criadas e mapeadas.
- [x] Exceções para timeout e falta de rede criadas e mapeadas.
- [x] Classe `Result<S, F>` selada em `lib/core/result/result.dart`.
- [x] Testes unitários cobrem resposta `2xx`, mapeamento de exceções e redação de logs.
- [x] Testes validam a conversão de exceção de rede para falhas de domínio.
- [x] Redaction cobre URI de request/response/erro e os testes afirmam que os
  segredos originais nao aparecem no log.
- [x] Falhas de dominio preservam sua categoria semantica em
  `NetworkFailureKind`; cancelamento nao cai em erro desconhecido.
