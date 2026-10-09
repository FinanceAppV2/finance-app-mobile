import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/leme_logo.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = GetIt.instance<AuthController>();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _authController.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthStateChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (!mounted) return;

    if (_authController.status == AuthStatus.success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (_authController.status == AuthStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authController.errorMessage ?? 'Erro ao fazer login'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _onLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _authController.login(
      login: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.paddingOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              24,
              math.max(72, insets.top + 24),
              24,
              math.max(40, insets.bottom + 16),
            ),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: LemeLogo(),
                    ),
                    const SizedBox(height: 56),
                    _buildHeader(),
                    const SizedBox(height: 36),
                    _buildLoginField(),
                    const SizedBox(height: 18),
                    _buildPasswordField(),
                    const SizedBox(height: 18),
                    _buildRememberRow(),
                    const SizedBox(height: 26),
                    _buildLoginButton(),
                    const SizedBox(height: 24),
                    const Spacer(),
                    _buildSignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bem-vindo de volta',
          style: TextStyle(
            color: AppColors.marfim,
            fontSize: 30,
            height: 1.15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Entre para ver como está o seu mês.',
          style: TextStyle(
            color: AppColors.cinza,
            fontSize: 16,
            height: 1.5,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledField({required String label, required Widget field}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textoSuave,
              fontSize: 13,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Semantics(label: label, child: field),
      ],
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.cinza,
        fontSize: 16,
        letterSpacing: 0,
      ),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(0, 16, 12, 16),
      prefixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16, end: 12),
        child: Icon(icon, size: 20, color: AppColors.cinza),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 52),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 52),
    );
  }

  Widget _buildLoginField() {
    return _buildLabeledField(
      label: 'E-mail, CPF ou telefone',
      field: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        cursorColor: AppColors.lataoClaro,
        style: const TextStyle(
          color: AppColors.marfim,
          fontSize: 16,
          letterSpacing: 0,
        ),
        decoration: _fieldDecoration(
          hint: 'voce@email.com',
          icon: Icons.person_outline_rounded,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Campo é obrigatório';
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return _buildLabeledField(
      label: 'Senha',
      field: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _onLogin(),
        cursorColor: AppColors.lataoClaro,
        style: const TextStyle(
          color: AppColors.marfim,
          fontSize: 16,
          letterSpacing: 0,
        ),
        decoration: _fieldDecoration(
          hint: 'Sua senha',
          icon: Icons.lock_outline_rounded,
          suffix: Padding(
            padding: const EdgeInsetsDirectional.only(end: 4),
            child: IconButton(
              tooltip: _obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: AppColors.cinza,
              ),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Senha é obrigatória';
          if (value.length < 6) {
            return 'A senha deve ter pelo menos 6 caracteres';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRememberRow() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: InkWell(
              onTap: () => setState(() => _rememberMe = !_rememberMe),
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (value) =>
                            setState(() => _rememberMe = value ?? false),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(color: AppColors.marfim),
                        fillColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? AppColors.lataoClaro
                              : AppColors.marfim,
                        ),
                        checkColor: AppColors.background,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Flexible(
                      child: Text(
                        'Lembrar-me',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textoSuave,
                          fontSize: 15,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.lataoClaro,
              padding: const EdgeInsets.symmetric(vertical: 10),
              minimumSize: const Size(0, 44),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(
                fontSize: 15,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Esqueci a senha'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return ListenableBuilder(
      listenable: _authController,
      builder: (context, _) {
        final isLoading = _authController.status == AuthStatus.loading;
        return SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: isLoading ? null : _onLogin,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              disabledBackgroundColor: AppColors.marfim,
              disabledForegroundColor: AppColors.background,
              textStyle: const TextStyle(
                fontSize: 16,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.background,
                    ),
                  )
                : const Text('Entrar'),
          ),
        );
      },
    );
  }

  Widget _buildSignUpLink() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'Ainda não tem conta? ',
          style: TextStyle(
            color: AppColors.cinza,
            fontSize: 15,
            letterSpacing: 0,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.lataoClaro,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 44),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontSize: 15,
              letterSpacing: 0,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('Criar conta'),
        ),
      ],
    );
  }
}
