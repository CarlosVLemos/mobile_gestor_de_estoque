import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_context.dart';
import '../controllers/auth_controller.dart';
import '../state/auth_state.dart';

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Arara-Gastos',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Entre para acessar a operação da sua empresa.',
                        style: context.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      _field(_accessCode, 'Código de acesso', obscure: false),
                      const SizedBox(height: AppSpacing.md),
                      _field(_password, 'Senha'),
                      const SizedBox(height: AppSpacing.md),
                      _field(_device, 'Nome deste dispositivo', obscure: false),
                      if (state.failure != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          state.failure!.message,
                          style: TextStyle(color: context.colors.error),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton(
                        onPressed: busy ? null : _submit,
                        child: Text(busy ? 'Validando…' : 'Entrar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool obscure = true,
  }) => TextFormField(
    controller: controller,
    obscureText: obscure,
    autocorrect: false,
    enableSuggestions: !obscure,
    maxLength: label == 'Nome deste dispositivo' ? 100 : null,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    validator: (value) =>
        value == null || value.trim().isEmpty ? 'Informe $label.' : null,
  );

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .login(
            accessCode: _accessCode.text,
            password: _password.text,
            deviceName: _device.text,
          );
    }
  }
}
