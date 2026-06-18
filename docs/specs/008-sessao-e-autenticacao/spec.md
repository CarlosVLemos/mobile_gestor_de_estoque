# Spec 008: Sessão e Autenticação

## Problema
O aplicativo atualmente se inicia diretamente na casca operacional (shell) com um perfil fixo carregado via mock fixtures (`appFixtureAccessProfile`). Para integrar o aplicativo com o ecossistema Laravel, precisamos gerenciar sessões reais, persistir tokens de acesso de forma criptografada e restringir a navegação caso o usuário não esteja autenticado.

## Objetivo
Implementar o ciclo de vida da sessão do usuário, incluindo login, logout, persistência criptografada do token de acesso (Laravel Sanctum), carregamento do perfil/permissões (`/api/mobile/me`) e controle dinâmico de rotas (redirecionamento da tela pública para privada).

## Fora de Escopo
* Armazenamento local de dados de negócio (Drift/SQLite).
* Renovação automática de sessão ou refresh token (conforme **DEP-002** em `06-registro-decisoes.md`).
* Fluxo de recuperação de senha por e-mail ou cadastro de novas contas via mobile.

## Regras de Negócio e Diretrizes Técnicas
1. **Armazenamento Seguro do Token (MOB-008):**
   * O token Sanctum deve ser salvo em armazenamento criptografado seguro (ex: Keychain no iOS e Keystore no Android via `flutter_secure_storage`).
   * Nunca gravar o token de sessão ou credenciais diretas em logs ou no `SharedPreferences` comum.
2. **Redirecionamento Declarativo de Rotas (MOB-007):**
   * Configurar a navegação do `go_router` para avaliar o estado de sessão:
     * Usuário NÃO autenticado -> Redirecionar para `/login`.
     * Usuário autenticado tentando acessar `/login` -> Redirecionar para o painel principal.
3. **Consumo de Contexto Inicial (`GET /api/mobile/me`):**
   * Ao efetuar login ou iniciar o app com um token válido pré-existente, realizar o carregamento do endpoint `/me` para preencher o `ShellProfile` com as features e permissões atualizadas do usuário.
4. **Dependência Temporária (DEP-001):**
   * Como o endpoint `POST /api/mobile/login` está planejado mas pode não estar implementado no momento da execução desta spec, os repositórios de autenticação remota devem prever uma flag/mock que simula a requisição retornando um token de acesso de teste e o payload correspondente de `/me`.

## Estrutura de Arquivos Proposta
```text
lib/features/auth/
  domain/
    entities/
      user_session.dart       # Entidade de sessão ativa
    repositories/
      auth_repository.dart    # Contrato de login, logout e sessão
  data/
    repositories/
      secure_auth_repository.dart  # Implementação usando Secure Storage & ApiClient
  presentation/
    controllers/
      auth_controller.dart    # Estado da sessão ativa (Unauthenticated, etc.)
    pages/
      login_page.dart         # Tela de credenciais
```

## Critérios de Aceite
* Adição de `flutter_secure_storage` sem quebras de build.
* Abertura do app sem token ativo redireciona o usuário para a tela de login.
* Submissão bem-sucedida de credenciais válidas grava o token de acesso no armazenamento seguro e navega para o painel principal.
* Um clique em "Sair" apaga o token do armazenamento criptografado e redireciona de volta para `/login`.
* A suíte de testes de rotas (`go_router`) valida as transições de estado (login/logout/token expirado).
