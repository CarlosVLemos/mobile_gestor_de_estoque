import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_state_panel.dart';
import '../controllers/auth_controller.dart';
import '../state/auth_state.dart';
import '../widgets/auth_shell.dart';

const changePasswordCurrentFieldKey = Key('change-password-current-field');
const changePasswordNewFieldKey = Key('change-password-new-field');
const changePasswordConfirmationFieldKey =
    Key('change-password-confirmation-field');

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  void dispose() {
    _current.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final busy = state.status == AuthStatus.resolvingSession;

    return Scaffold(
      body: AuthShell(
        title: 'Atualize sua senha',
        description:
            'Por segurança, sua senha precisa ser alterada antes de continuar.',
        child: AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _passwordField(
                  controller: _current,
                  label: 'Senha atual',
                  obscure: _obscureCurrent,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.next,
                  onToggle: () => setState(
                    () => _obscureCurrent = !_obscureCurrent,
                  ),
                  onSubmitted: () => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: AppSpacing.md),
                _passwordField(
                  controller: _password,
                  label: 'Nova senha',
                  obscure: _obscurePassword,
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: TextInputAction.next,
                  onToggle: () => setState(
                    () => _obscurePassword = !_obscurePassword,
                  ),
                  onSubmitted: () => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: AppSpacing.md),
                _passwordField(
                  controller: _confirmation,
                  label: 'Confirme a nova senha',
                  obscure: _obscureConfirmation,
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: TextInputAction.done,
                  onToggle: () => setState(
                    () => _obscureConfirmation = !_obscureConfirmation,
                  ),
                  onSubmitted: _submit,
                ),
                if (state.failure != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppStatePanel(
                    tone: AppStatePanelTone.failure,
                    layout: AppStatePanelLayout.banner,
                    title: 'Não foi possível atualizar a senha',
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
                                  'Atualizando…',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : const Text('Atualizar senha'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton.icon(
                  onPressed: busy
                      ? null
                      : () => ref.read(authControllerProvider.notifier).logout(),
                  icon: const Icon(AppIcons.logout),
                  label: const Text('Sair da conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required List<String> autofillHints,
    required TextInputAction textInputAction,
    required VoidCallback onToggle,
    required VoidCallback onSubmitted,
  }) {
    return TextFormField(
      key: switch (label) {
        'Senha atual' => changePasswordCurrentFieldKey,
        'Nova senha' => changePasswordNewFieldKey,
        _ => changePasswordConfirmationFieldKey,
      },
      controller: controller,
      obscureText: obscure,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      onFieldSubmitted: (_) => onSubmitted(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(AppIcons.lock),
        suffixIcon: IconButton(
          tooltip: obscure ? 'Mostrar $label' : 'Ocultar $label',
          onPressed: onToggle,
          icon: Icon(
            obscure ? AppIcons.passwordVisible : AppIcons.passwordHidden,
          ),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Informe $label.' : null,
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).changePassword(
            currentPassword: _current.text,
            password: _password.text,
            confirmation: _confirmation.text,
          );
    }
  }
}
