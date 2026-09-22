import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_state_panel.dart';
import '../controllers/auth_controller.dart';
import '../state/auth_state.dart';
import '../widgets/auth_shell.dart';

const loginAccessCodeFieldKey = Key('login-access-code-field');
const loginPasswordFieldKey = Key('login-password-field');
const loginDeviceFieldKey = Key('login-device-field');

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _accessCode = TextEditingController();
  final _password = TextEditingController();
  final _device = TextEditingController(text: 'Arara-Gastos Mobile');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _accessCode.dispose();
    _password.dispose();
    _device.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final busy = state.status == AuthStatus.resolvingSession;

    return Scaffold(
      body: AuthShell(
        title: 'Bem-vindo',
        description: 'Acesse sua operação.',
        child: AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Credenciais',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  key: loginAccessCodeFieldKey,
                  controller: _accessCode,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofillHints: const [AutofillHints.username],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: const InputDecoration(
                    labelText: 'Código de acesso',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(AppIcons.account),
                  ),
                  validator: _required('Código de acesso'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  key: loginPasswordFieldKey,
                  controller: _password,
                  obscureText: _obscurePassword,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(AppIcons.lock),
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                      icon: Icon(
                        _obscurePassword
                            ? AppIcons.passwordVisible
                            : AppIcons.passwordHidden,
                      ),
                    ),
                  ),
                  validator: _required('Senha'),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'CONFIGURAÇÃO DESTE ACESSO',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Este nome identifica o dispositivo usado nesta operação.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  key: loginDeviceFieldKey,
                  controller: _device,
                  autocorrect: false,
                  enableSuggestions: true,
                  maxLength: 100,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                    labelText: 'Nome deste dispositivo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(AppIcons.settings),
                  ),
                  validator: _required('Nome deste dispositivo'),
                ),
                if (state.failure != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppStatePanel(
                    tone: AppStatePanelTone.failure,
                    layout: AppStatePanelLayout.banner,
                    title: 'Não foi possível entrar',
                    message: state.failure!.message,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: AppSizes.buttonHeight,
                  child: FilledButton(
                    onPressed: busy ? null : _submit,
                    child: busy
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Flexible(
                                child: Text(
                                  'Validando…',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : const Text('Entrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? Function(String?) _required(String label) =>
      (value) => value == null || value.trim().isEmpty ? 'Informe $label.' : null;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).login(
            accessCode: _accessCode.text,
            password: _password.text,
            deviceName: _device.text,
          );
    }
  }
}
