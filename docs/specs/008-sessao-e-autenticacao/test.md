# Spec 008 — Validação futura

## Matriz de cenários

| Cenário | Evidência esperada |
| --- | --- |
| App sem token | startup termina em `/login`; shell não fica acessível. |
| Login válido | envia `access_code`, `password`, `device_name`; grava somente o token seguro; resolve `/me`. |
| Credenciais inválidas | `422` + `invalid_credentials` produz estado próprio, sem revelar senha. |
| Conta ou tenant inativo | `403` + `account_inactive` ou `tenant_inactive` permanece distinguível. |
| Rate limit | `429` exibe estado de nova tentativa sem perder credencial armazenada. |
| `/me` | interpreta envelope `data/meta`, `revision`, features e permissões. |
| Token restaurado | startup usa token seguro e envia `Authorization: Bearer`; nunca expõe token na UI/log. |
| `401` | sinalização global limpa token e redireciona para `/login`. |
| Offline/timeout/cancelamento | não executa logout; exibe indisponibilidade recuperável. |
| Logout | chama rota remota quando possível, remove token local e navega a `/login`. |
| Troca obrigatória | login com `must_change_password` bloqueia shell, permite `/me`, logout e `/change-password`. |
| Alterar senha | envia campos corretos; `invalid_current_password` é acionável; sucesso libera shell após reavaliar sessão. |
| Rotas | usuário autenticado não acessa `/login`; sem sessão não acessa shell; router não tem bypass de produção. |
| Fronteiras | `presentation`/`application` não importam Dio ou secure storage; core não importa feature/auth. |
| Sem mock produtivo | nenhum mock/flag de autenticação substitui a API real em build de produção. |

## Testes exigidos

- Unidade: DTOs, mapeamento de códigos, storage, repositório, casos de uso e
  transições do controller.
- Integração com adapter HTTP: payloads das quatro rotas, Bearer token,
  `401`, `403`, `422`, `429`, timeout e cancelamento.
- Widget/router: login, logout, bootstrap, proteção de rotas e troca
  obrigatória em largura mobile compacta e `textScaler` alto.
- Segurança: logs não contêm token, senha, `access_code` sensível ou corpo de
  troca de senha; storage não é SharedPreferences.

## Checklist de fechamento

- [ ] Contratos REQ-046 e envelope REQ-047 cobertos por testes.
- [ ] Token Sanctum somente em `flutter_secure_storage`.
- [ ] Códigos semânticos preservados até a camada que decide a UX.
- [ ] `must_change_password` não permite shell operacional localmente.
- [ ] `401` encerra sessão; indisponibilidade de rede não encerra.
- [ ] Logout e troca de senha não expõem segredos.
- [ ] Nenhuma importação proibida ou mock produtivo de autenticação.
- [ ] `dart format`, `flutter analyze`, testes afetados e suíte completa passam.
