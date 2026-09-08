# Tasks: Spec 008 — Sessão e Autenticação

Status: implementada e validada no cliente Flutter; pendências posteriores
continuam pertencendo às Specs 008B e 009A.

- [x] **1. Contratos e DTOs**
  - [ ] Modelar request de login, resposta de login, envelope `data/meta` de
    `/me` e resposta de troca de senha conforme REQ-046.
  - [x] Preservar `code` semântico para `invalid_credentials`,
    `account_inactive`, `tenant_inactive`, `password_change_required` e
    `invalid_current_password`.
  - [ ] Registrar o pequeno handoff para ampliar a fronteira de erro da Spec
    007 caso o modelo atual não transporte esse `code`.

- [x] **2. Domínio e armazenamento seguro**
  - [x] Definir entidade de sessão e contrato de repositório sem Dio, JSON ou
    storage concreto.
  - [x] Adicionar `flutter_secure_storage` e implementar armazenamento somente
    do token Sanctum; não usar SharedPreferences nem criar refresh token.

- [x] **3. Fonte remota e repositório**
  - [x] Implementar login, logout, `/me` e troca de senha via `ApiClient`.
  - [x] Injetar `Authorization: Bearer <token>` somente na camada de dados.
  - [x] Converter exceções da Spec 007 e códigos de erro em resultados de
    domínio/aplicação acionáveis.

- [x] **4. Casos de uso e sessão**
  - [x] Implementar login, restauração de token, resolução de perfil, logout e
    alteração de senha.
  - [x] Modelar estados: iniciando, não autenticado, resolvendo perfil,
    autenticado, troca obrigatória de senha, indisponível e falha.
  - [x] Tratar `401` como invalidade de sessão; timeout, conectividade e
    cancelamento não podem limpar token.

- [x] **5. Bootstrap, router e 401 global**
  - [x] Trocar o bootstrap fixture pela resolução de sessão.
  - [x] Configurar redirecionamento declarativo: sem sessão -> `/login`;
    sessão normal -> shell; troca obrigatória -> `/change-password`; usuário
    autenticado não acessa `/login`.
  - [x] Criar sinalização neutra de sessão inválida entre core de rede e a
    composição da aplicação, sem `core/network` importar `features/auth`.

- [x] **6. Interface**
  - [x] Criar login com `access_code`, senha e `device_name`.
  - [x] Criar fluxo bloqueante de troca de senha, mantendo logout disponível.
  - [x] Ligar logout da shell ao caso de uso e exibir estados sem expor token,
    senha, detalhes do Dio ou códigos internos sem tratamento.

- [x] **7. Testes e validação**
  - [ ] Cobrir contratos, storage, repositório, casos de uso, controller,
    bootstrap, router e redaction.
  - [x] Executar `dart format`, `flutter analyze`, testes afetados e suíte
    completa; validar visualmente login e troca de senha em largura compacta.

## Handoffs explícitos

- **008B:** separar banco, caches e estados por usuário/tenant no logout ou
  troca de sessão; esta spec não cria nem expurga Drift.
- **009A:** persistir perfil/contexto e dados operacionais quando o schema
  local existir; esta spec apenas consome o perfil remoto em memória.
- **Spec 007:** preservar códigos semânticos HTTP na fronteira de falhas antes
  de a feature de autenticação depender deles.
