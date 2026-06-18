# Spec 008 - Referência de Validação Futura

## Objetivo

Registrar como a futura implementação da Spec 008 (Sessão e Autenticação) deverá ser validada.

## O que verificar depois

A futura implementação deverá comprovar que:
- O token da sessão é persistido e lido do armazenamento seguro (`flutter_secure_storage`);
- O aplicativo inicia em `/login` se o token não existir;
- O login com credenciais grava o token, busca o perfil `/me` e redireciona para a tela inicial (`/`);
- O logout remove o token do armazenamento seguro e redireciona para `/login`;
- Um erro `401 Unauthorized` retornado por qualquer chamada de API limpa o token e força o redirecionamento imediato para a tela de login.

## Cenários de Teste a Cobrir

### 1. Inicialização do App sem Token (Primeiro Acesso)
* **Verificar:**
  - Limpar qualquer dado do app.
  - Abrir o aplicativo.
  - Confirmar que o GoRouter redireciona para `/login`.

### 2. Login com Sucesso
* **Verificar:**
  - Digitar credenciais válidas.
  - Submeter o login.
  - Validar que o token Sanctum é armazenado de forma criptografada.
  - Validar que a requisição para `/api/mobile/me` é realizada com o token no header `Authorization`.
  - Confirmar que o usuário é redirecionado para o dashboard (`/`).

### 3. Logout Manual
* **Verificar:**
  - Estando autenticado, abrir o `AppDrawer`.
  - Clicar no botão "Sair".
  - Validar que o token de sessão foi excluído do armazenamento criptografado.
  - Confirmar o redirecionamento imediato do GoRouter para `/login`.

### 4. Expiração de Sessão por Rede (Erro 401)
* **Verificar:**
  - Estar navegando no aplicativo (autenticado).
  - Simular uma resposta `401 Unauthorized` de uma requisição HTTP qualquer (ex: ao atualizar o catálogo).
  - Validar que o app apaga o token do storage seguro automaticamente em background.
  - Confirmar que a tela é redirecionada de forma transparente para `/login`.

## Checklist de Validação

- [ ] Dependência do `flutter_secure_storage` configurada no `pubspec.yaml`.
- [ ] Entidade `UserSession` modelada com suporte a tokens e permissões.
- [ ] Classe `SecureAuthRepository` implementando `AuthRepository`.
- [ ] `AuthController` expondo estados reativos de carregamento e autenticação.
- [ ] GoRouter configurado com `redirect` reativo observando o `authControllerProvider`.
- [ ] Botão de logout chama o controller de forma síncrona.
- [ ] Callback para 401 conecta o interceptor de erros da API ao reset do estado de sessão.
- [ ] Testes unitários do controller e de integração de rotas com 100% de sucesso.
