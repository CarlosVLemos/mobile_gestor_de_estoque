# Spec 007 - Referência de Validação Futura

## Objetivo

Registrar como a futura implementação da Spec 007 (Core de Rede, Erros e Resultado) deverá ser validada. Este arquivo serve exclusivamente como referência para a fase posterior de testes.

## O que verificar depois

A futura implementação deverá comprovar que:
- O pacote `dio` foi adicionado e as requisições HTTP ocorrem através dele;
- O `ApiClient` está configurado com timeouts de conexão e interceptores corretos;
- O `RedactionInterceptor` remove segredos dos logs impressos no console;
- Respostas HTTP com erro disparam exceções tipadas de rede;
- Falhas de conexão física (ex: modo avião, timeout) são capturadas e mapeadas para exceções;
- O mapeador converte exceções de rede em falhas de domínio;
- A UI ou UseCases recebem e processam a estrutura `Result<Success, Failure>`.

## Cenários de Teste a Cobrir

### 1. Mascaramento de Informações Sensíveis (Redaction)
* **Verificar:**
  - Enviar requisição com cabeçalho `Authorization: Bearer meu-token-secreto`.
  - Enviar requisição com cabeçalho `X-Tenant-ID: 123`.
  - Enviar requisição com payload contendo `"password": "senha-secreta"`.
  - Confirmar nos logs gerados no console que os valores foram substituídos por `[REDACTED]`.

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

### 4. Padrão Result
* **Verificar:**
  - Repositório intercepta as exceções mapeadas e as envelopa em `Result.failure(NetworkFailure)`.
  - Casos de sucesso retornam `Result.success(T)`.
  - Validação de código utilizando pattern matching (`switch`) do Dart para desestruturar o retorno.

## Checklist de Validação

- [ ] Dependência do `dio` configurada no `pubspec.yaml`.
- [ ] Interceptor de log censura cabeçalhos (`Authorization`, `X-Tenant-ID`, `Cookie`, `Set-Cookie`).
- [ ] Interceptor de log censura chaves confidenciais no corpo do JSON (`password`, `token`, etc.).
- [ ] Exceções para 401, 403, 422, 429, 5xx criadas e mapeadas.
- [ ] Exceções para timeout e falta de rede criadas e mapeadas.
- [ ] Classe `Result<S, F>` selada em `lib/core/result/result.dart`.
- [ ] Testes unitários cobrindo o mapeamento de exceções e a redação de logs passando com sucesso.
- [ ] Testes validando o mapeamento de exceção de rede para falhas de domínio.
