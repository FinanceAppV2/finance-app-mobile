import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 48),
                  _buildLoginField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 16),
                  _buildRememberRow(),
                  const SizedBox(height: 32),
                  _buildLoginButton(),
                  const SizedBox(height: 24),
                  _buildSignUpLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.verdeEscuro,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.monetization_on_outlined,
            size: 44,
            color: AppColors.verdeDestaque,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Bem-vindo de volta',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Faça login para continuar',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.cinzaClaro,
              ),
        ),
      ],
    );
  }

  Widget _buildLoginField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.text,
      style: const TextStyle(color: AppColors.branco),
      decoration: const InputDecoration(
        labelText: 'E-mail, CPF ou telefone',
        hintText: 'Digite seu e-mail, CPF ou telefone',
        prefixIcon: Icon(Icons.person_outline, color: AppColors.verdeMedio),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo é obrigatório';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: AppColors.branco),
      decoration: InputDecoration(
        labelText: 'Senha',
        hintText: 'Digite sua senha',
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.verdeMedio),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.verdeMedio,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Senha é obrigatória';
        if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
        return null;
      },
    );
  }

  Widget _buildRememberRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _rememberMe ? AppColors.verdeDestaque : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _rememberMe ? AppColors.verdeDestaque : AppColors.cinzaEscuro,
                    width: 2,
                  ),
                ),
                child: _rememberMe
                    ? const Icon(Icons.check, size: 14, color: AppColors.background)
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                'Lembrar-me',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.cinzaClaro,
                    ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Esqueceu a senha?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.verdeDestaque,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ListenableBuilder(
      listenable: _authController,
      builder: (context, _) {
        final isLoading = _authController.status == AuthStatus.loading;
        return SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isLoading ? null : _onLogin,
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.background,
                    ),
                  )
                : const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.cinzaEscuro,
              ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.register),
          child: Text(
            'Cadastre-se',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.verdeDestaque,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
