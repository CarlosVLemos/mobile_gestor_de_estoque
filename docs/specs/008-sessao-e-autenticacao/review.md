# Spec 008 - Revisão de Abertura

## Status

Planejada em 18 de junho de 2026. Não implementada.

## Escopo pretendido

- Adição da dependência `flutter_secure_storage` para guardar tokens de sessão de forma criptografada;
- Modelagem da entidade `UserSession` para carregar o token e o perfil do usuário logado;
- Interface do repositório de autenticação e implementação concreta (`SecureAuthRepository`);
- Provedor reativo de sessão de usuário via Riverpod (`authControllerProvider`);
- Lógica de redirecionamento dinâmico no `go_router` com base no estado da sessão (usuário logado/deslogado);
- Tela simples de login com validação local de credenciais;
- Integração da expiração de sessão (erro 401) com a desautenticação automática no controller;
- Testes automatizados cobrindo o ciclo de rotas e o comportamento do controller de sessão.

## Gate de implementação

FECHADO.

A abertura desta spec serve apenas para crítica de arquitetura e design das telas e fluxos. Nenhuma escrita em arquivos do app está autorizada.

## Fontes consultadas

- `para mobile/00-contexto-operacional.md`;
- `para mobile/05-arquitetura-mobile.md` (autenticação e segurança local);
- `para mobile/06-registro-decisoes.md` (decisões MOB-004, MOB-007, MOB-008, DEP-001, DEP-002);
- `docs/specs/007-core-rede-erros-resultado/` (integração de tratamento de erro 401).

## Decisões já assumidas pelo pedido do usuário

- O armazenamento dos segredos é criptografado;
- A tela de login é a única porta de entrada pública do aplicativo;
- O botão de "Sair" apaga todos os vestígios locais da sessão no armazenamento seguro.

## Pontos curtos a refinar antes de aprovar a spec

- Confirmar o fluxo de carregamento inicial: se o carregamento do `/me` falhar por problemas de rede física na abertura do app (com um token válido), o app deve entrar no modo de visualização offline dos dados locais persistidos, em vez de assumir sessão inválida e forçar logout. Isso é fundamental para o suporte a redes instáveis (MOB-001).

## Veredito

Especificação revisada e detalhada técnica e funcionalmente. O desenvolvimento permanece aguardando a liberação do gate correspondente.
