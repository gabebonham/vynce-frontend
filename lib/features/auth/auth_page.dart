import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String session = 'login';
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmNewPassword = true;
  bool isSubmitting = false;

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _forgotPasswordFormKey = GlobalKey<FormState>();
  final _forgotPasswordCodeFormKey = GlobalKey<FormState>();
  final _forgotPasswordUpdateFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _registerNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();

  final _forgotPasswordEmailController = TextEditingController();
  final _forgotPasswordCodeController = TextEditingController();
  final _forgotPasswordNewPasswordController = TextEditingController();
  final _forgotPasswordConfirmNewPasswordController = TextEditingController();

  // Guarda o e-mail em recuperação para reenvio de código / update final.
  String? _recoveryEmail;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    _forgotPasswordEmailController.dispose();
    _forgotPasswordCodeController.dispose();
    _forgotPasswordNewPasswordController.dispose();
    _forgotPasswordConfirmNewPasswordController.dispose();
    super.dispose();
  }

  bool get _isForgotPasswordFlow =>
      session == 'forgot-password' ||
      session == 'forgot-password-code' ||
      session == 'forgot-password-update';

  void _goToForgotPassword() {
    setState(() => session = 'forgot-password');
  }

  void _backToLogin() {
    setState(() {
      session = 'login';
      _recoveryEmail = null;
      _forgotPasswordEmailController.clear();
      _forgotPasswordCodeController.clear();
      _forgotPasswordNewPasswordController.clear();
      _forgotPasswordConfirmNewPasswordController.clear();
    });
  }

  Future<void> _handleSubmit() async {
    switch (session) {
      case 'login':
        await _submitLogin();
        break;
      case 'registration':
        await _submitRegister();
        break;
      case 'forgot-password':
        await _submitForgotPasswordEmail();
        break;
      case 'forgot-password-code':
        await _submitForgotPasswordCode();
        break;
      case 'forgot-password-update':
        await _submitForgotPasswordUpdate();
        break;
    }
  }

  Future<void> _submitLogin() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    setState(() => isSubmitting = true);
    try {
      // TODO: chamada real de login
      await Future.delayed(const Duration(seconds: 2));
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Erro ao fazer login, tente novamente.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.surface,
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> _submitRegister() async {
    if (!(_registerFormKey.currentState?.validate() ?? false)) return;
    setState(() => isSubmitting = true);
    try {
      // TODO: chamada real de cadastro
      await Future.delayed(const Duration(seconds: 2));
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Erro ao cadastrar, tente novamente.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.surface,
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> _submitForgotPasswordEmail() async {
    if (!(_forgotPasswordFormKey.currentState?.validate() ?? false)) return;
    setState(() => isSubmitting = true);
    try {
      // TODO: chamada real para envio do código por e-mail
      await Future.delayed(const Duration(seconds: 2));
      _recoveryEmail = _forgotPasswordEmailController.text;
      if (mounted) setState(() => session = 'forgot-password-code');
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Erro no envio de email, tente novamente.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.surface,
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> _submitForgotPasswordCode() async {
    if (!(_forgotPasswordCodeFormKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => isSubmitting = true);
    try {
      // TODO: chamada real para validar o código recebido
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) setState(() => session = 'forgot-password-update');
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Erro na validação do código, tente novamente.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.surface,
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Future<void> _submitForgotPasswordUpdate() async {
    if (!(_forgotPasswordUpdateFormKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => isSubmitting = true);
    try {
      // TODO: chamada real para atualizar a senha (usar _recoveryEmail)
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Fluttertoast.showToast(
          msg: "Senha atualizada com sucesso",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Theme.of(context).colorScheme.primary,
          textColor: Theme.of(context).colorScheme.surface,
        );
        _backToLogin();
      }
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Erro na atualização de senha, tente novamente.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.surface,
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isForgotPasswordFlow
                        ? _backButton()
                        : _selectSectionContainer(),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: _sessionContainer(),
                  ),
                  const SizedBox(height: 24),
                  _submitButton(),
                  const SizedBox(height: 24),
                  _disclaimer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sessionContainer() {
    switch (session) {
      case 'login':
        return _loginForm();
      case 'registration':
        return _registerForm();
      case 'forgot-password':
        return _forgotPasswordForm();
      case 'forgot-password-code':
        return _forgotPasswordCodeForm();
      case 'forgot-password-update':
        return _forgotPasswordUpdateForm();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _header() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Icon(
            Icons.local_fire_department,
            size: 32,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "vynce",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text("Conecte-se por eventos"),
      ],
    );
  }

  Widget _backButton() {
    return Align(
      key: const ValueKey('back-button'),
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: isSubmitting ? null : _backToLogin,
        icon: const Icon(Icons.arrow_back, size: 16),
        label: const Text('Voltar para o login'),
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
      ),
    );
  }

  Widget _selectSectionContainer() {
    return Container(
      key: const ValueKey('select-tabs'),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        children: [
          Expanded(child: _selectTab('login', 'Entrar')),
          Expanded(child: _selectTab('registration', 'Cadastrar')),
        ],
      ),
    );
  }

  Widget _selectTab(String value, String label) {
    final isSelected = session == value;
    return GestureDetector(
      onTap: isSubmitting ? null : () => setState(() => session = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }

  Widget _forgotPasswordForm() {
    return Form(
      key: _forgotPasswordFormKey,
      child: Column(
        key: const ValueKey('forgotPassword'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Informe seu e-mail e enviaremos um código de recuperação.',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          _inputField(
            label: 'E-mail',
            icon: Icons.mail_outline,
            controller: _forgotPasswordEmailController,
            validator: _emailValidator,
          ),
        ],
      ),
    );
  }

  Widget _forgotPasswordCodeForm() {
    return Form(
      key: _forgotPasswordCodeFormKey,
      child: Column(
        key: const ValueKey('code'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _recoveryEmail == null
                ? 'Digite o código enviado para seu e-mail.'
                : 'Digite o código enviado para $_recoveryEmail.',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          _inputField(
            label: 'Código',
            icon: Icons.pin_outlined,
            controller: _forgotPasswordCodeController,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Informe o código recebido'
                : null,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isSubmitting
                  ? null
                  : () {
                      // TODO: chamada real de reenvio de código
                    },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text('Reenviar código'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _forgotPasswordUpdateForm() {
    return Form(
      key: _forgotPasswordUpdateFormKey,
      child: Column(
        key: const ValueKey('updatePassword'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _inputField(
            label: 'Nova senha',
            icon: Icons.lock_outline,
            controller: _forgotPasswordNewPasswordController,
            isPassword: true,
            obscureText: obscureNewPassword,
            onToggleObscure: () =>
                setState(() => obscureNewPassword = !obscureNewPassword),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe uma senha';
              if (value.length < 6) return 'Mínimo de 6 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _inputField(
            label: 'Confirmar nova senha',
            icon: Icons.lock_outline,
            controller: _forgotPasswordConfirmNewPasswordController,
            isPassword: true,
            obscureText: obscureConfirmNewPassword,
            onToggleObscure: () => setState(
              () => obscureConfirmNewPassword = !obscureConfirmNewPassword,
            ),
            validator: (value) {
              if (value != _forgotPasswordNewPasswordController.text) {
                return 'As senhas não coincidem';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        key: const ValueKey('login'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _inputField(
            label: 'E-mail',
            icon: Icons.mail_outline,
            controller: _loginEmailController,
            validator: _emailValidator,
          ),
          const SizedBox(height: 16),
          _inputField(
            label: 'Senha',
            icon: Icons.lock_outline,
            controller: _loginPasswordController,
            isPassword: true,
            obscureText: obscurePassword,
            onToggleObscure: () =>
                setState(() => obscurePassword = !obscurePassword),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe sua senha' : null,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isSubmitting ? null : _goToForgotPassword,
              style: TextButton.styleFrom(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
              ),
              child: const Text('Esqueci minha senha'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        key: const ValueKey('register'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _inputField(
            label: 'Nome',
            icon: Icons.person_outline,
            controller: _registerNameController,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Informe seu nome'
                : null,
          ),
          const SizedBox(height: 16),
          _inputField(
            label: 'E-mail',
            icon: Icons.mail_outline,
            controller: _registerEmailController,
            validator: _emailValidator,
          ),
          const SizedBox(height: 16),
          _inputField(
            label: 'Senha',
            icon: Icons.lock_outline,
            controller: _registerPasswordController,
            isPassword: true,
            obscureText: obscurePassword,
            onToggleObscure: () =>
                setState(() => obscurePassword = !obscurePassword),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe uma senha';
              if (value.length < 6) return 'Mínimo de 6 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _inputField(
            label: 'Confirmar senha',
            icon: Icons.lock_outline,
            controller: _registerConfirmPasswordController,
            isPassword: true,
            obscureText: obscureConfirmPassword,
            onToggleObscure: () => setState(
              () => obscureConfirmPassword = !obscureConfirmPassword,
            ),
            validator: (value) {
              if (value != _registerPasswordController.text) {
                return 'As senhas não coincidem';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Informe seu e-mail';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) return 'E-mail inválido';
    return null;
  }

  Widget _inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  enabled: !isSubmitting,
                  obscureText: isPassword && obscureText,
                  style: const TextStyle(fontSize: 13),
                  validator: validator,
                  decoration: InputDecoration(
                    hintText: label == 'E-mail' ? 'seu@email.com' : label,
                    hintStyle: const TextStyle(fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    errorStyle: const TextStyle(fontSize: 11),
                  ),
                ),
              ),
              if (isPassword)
                IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: isSubmitting ? null : onToggleObscure,
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _submitLabel() {
    switch (session) {
      case 'login':
        return 'Entrar';
      case 'registration':
        return 'Cadastrar';
      case 'forgot-password':
        return 'Enviar código';
      case 'forgot-password-code':
        return 'Confirmar código';
      case 'forgot-password-update':
        return 'Atualizar senha';
      default:
        return 'Continuar';
    }
  }

  Widget _submitButton() {
    return FilledButton(
      onPressed: isSubmitting ? null : _handleSubmit,
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isSubmitting
          ? SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.surface,
              ),
            )
          : Text(
              _submitLabel(),
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
    );
  }

  Widget _disclaimer() {
    return const Text(
      "Ao continuar, você concorda com os Termos de Uso e Política de Privacidade",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11),
    );
  }
}
