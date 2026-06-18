# Tasks: Spec 008 - Sessão e Autenticação

- [ ] **Fase 1: Infraestrutura e Dependências**
  - [ ] Adicionar dependência `flutter_secure_storage` em `pubspec.yaml` e executar `flutter pub get`.
  
- [ ] **Fase 2: Domínio e Entidades**
  - [ ] Criar entidade `UserSession` em `lib/features/auth/domain/entities/user_session.dart`.
  - [ ] Definir a interface `AuthRepository` com os métodos `login`, `logout`, `getCurrentSession` e `saveSession`.

- [ ] **Fase 3: Persistência Criptografada e Mock de API**
  - [ ] Criar `lib/features/auth/data/repositories/secure_auth_repository.dart` que grava e lê tokens usando `flutter_secure_storage`.
  - [ ] Criar uma implementação mock do provedor de autenticação remota caso o backend Laravel não esteja concluído (flag mockable).

- [ ] **Fase 4: Controle de Estado e Rotas**
  - [ ] Criar `lib/features/auth/presentation/controllers/auth_controller.dart` gerenciando a máquina de estados de sessão (Iniciando, Não Autenticado, Autenticado, Deslogando).
  - [ ] Atualizar `lib/app/router/app_router.dart` para escutar as mudanças do `authControllerProvider` e efetuar redirecionamentos (`redirect`).

- [ ] **Fase 5: Interface e Páginas**
  - [ ] Criar tela de Login básica em `lib/features/auth/presentation/pages/login_page.dart` coletando e submetendo dados.
  - [ ] Vincular o botão de "Sair" do `AppDrawer` para limpar o token e chamar a máquina de desautenticação do controller.

- [ ] **Fase 6: Testes**
  - [ ] Criar testes unitários para o `AuthController` testando a inicialização com e sem token guardado.
  - [ ] Criar testes de integração/widget de rotas para assegurar o redirecionamento automático para a tela de login.
