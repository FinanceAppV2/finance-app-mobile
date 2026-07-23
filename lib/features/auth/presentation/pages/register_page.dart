import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../routes/app_routes.dart';

class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length > 11) return old;

    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 3 || i == 6) buf.write('.');
      if (i == 9) buf.write('-');
      buf.write(digits[i]);
    }

    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length > 11) return old;

    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 0) buf.write('(');
      if (i == 2) buf.write(') ');
      if (i == 7) buf.write('-');
      buf.write(digits[i]);
    }

    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _cleanCpf(String cpf) => cpf.replaceAll(RegExp(r'[^\d]'), '');

  String _cleanPhone(String phone) => phone.replaceAll(RegExp(r'[^\d]'), '');

  void _nextStep() {
    final fields = [
      [_nameController, _lastNameController, _cpfController, _phoneController],
      [_emailController, _passwordController, _confirmPasswordController],
    ][_currentStep];

    final valid = fields.every((c) {
      final value = c.text;
      if (c == _cpfController) return _cleanCpf(value).length == 11;
      if (c == _phoneController) return _cleanPhone(value).length >= 10;
      if (c == _confirmPasswordController) return value == _passwordController.text;
      if (c == _passwordController) return value.length >= 6;
      if (c == _emailController) return value.contains('@');
      return value.trim().isNotEmpty;
    });

    if (!valid) {
      _formKey.currentState?.validate();
      return;
    }

    setState(() => _currentStep = 1);
  }

  void _previousStep() => setState(() => _currentStep = 0);

  Future<void> _onRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final dio = GetIt.instance<Dio>();
      await dio.post('/users', data: {
        'name': _nameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _cleanPhone(_phoneController.text),
        'cpf': _cleanCpf(_cpfController.text),
        'password': _passwordController.text,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } on DioException catch (e) {
      final message = e.response?.data?['message']?.toString() ?? 'Erro ao criar conta';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                  const SizedBox(height: 32),
                  _buildStepIndicator(),
                  const SizedBox(height: 32),
                  if (_currentStep == 0) _buildPersonalStep(),
                  if (_currentStep == 1) _buildAccessStep(),
                  const SizedBox(height: 32),
                  if (_currentStep == 0) _buildNextButton() else _buildRegisterButton(),
                  const SizedBox(height: 16),
                  _buildLoginLink(),
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
            Icons.person_add_outlined,
            size: 44,
            color: AppColors.verdeDestaque,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Criar conta',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Preencha os dados para se cadastrar',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.cinzaClaro,
              ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepDot(0, 'Dados\npessoais'),
        Container(
          width: 48,
          height: 2,
          color: _currentStep >= 1 ? AppColors.verdeDestaque : AppColors.cinzaEscuro,
        ),
        _stepDot(1, 'Dados\nde acesso'),
      ],
    );
  }

  Widget _stepDot(int step, String label) {
    final active = _currentStep >= step;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.verdeDestaque : AppColors.cinzaEscuro,
          ),
          child: Center(
            child: active
                ? const Icon(Icons.check, size: 20, color: AppColors.background)
                : Text(
                    '${step + 1}',
                    style: const TextStyle(
                      color: AppColors.branco,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: active ? AppColors.verdeDestaque : AppColors.cinzaEscuro,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalStep() {
    return Column(
      children: [
        _buildNameField(),
        const SizedBox(height: 16),
        _buildLastNameField(),
        const SizedBox(height: 16),
        _buildCpfField(),
        const SizedBox(height: 16),
        _buildPhoneField(),
      ],
    );
  }

  Widget _buildAccessStep() {
    return Column(
      children: [
        _buildEmailField(),
        const SizedBox(height: 16),
        _buildPasswordField(),
        const SizedBox(height: 16),
        _buildConfirmPasswordField(),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(color: AppColors.branco),
      decoration: const InputDecoration(
        labelText: 'Nome',
        hintText: 'Digite seu nome',
        prefixIcon: Icon(Icons.person_outline, color: AppColors.verdeMedio),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Nome é obrigatório';
        return null;
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(color: AppColors.branco),
      decoration: const InputDecoration(
        labelText: 'Sobrenome',
        hintText: 'Digite seu sobrenome',
        prefixIcon: Icon(Icons.person_outline, color: AppColors.verdeMedio),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Sobrenome é obrigatório';
        return null;
      },
    );
  }

  Widget _buildCpfField() {
    return TextFormField(
      controller: _cpfController,
      keyboardType: TextInputType.number,
      inputFormatters: [_CpfInputFormatter()],
      style: const TextStyle(color: AppColors.branco),
      decoration: const InputDecoration(
        labelText: 'CPF',
        hintText: '000.000.000-00',
        prefixIcon: Icon(Icons.badge_outlined, color: AppColors.verdeMedio),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'CPF é obrigatório';
        if (_cleanCpf(value).length != 11) return 'CPF deve ter 11 dígitos';
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [_PhoneInputFormatter()],
      style: const TextStyle(color: AppColors.branco),
      decoration: const InputDecoration(
        labelText: 'Telefone',
        hintText: '(11) 99999-9999',
        prefixIcon: Icon(Icons.phone_outlined, color: AppColors.verdeMedio),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Telefone é obrigatório';
        if (_cleanPhone(value).length < 10) return 'Telefone inválido';
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: AppColors.branco),
      decoration: const InputDecoration(
        labelText: 'E-mail',
        hintText: 'Digite seu e-mail',
        prefixIcon: Icon(Icons.email_outlined, color: AppColors.verdeMedio),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'E-mail é obrigatório';
        if (!value.contains('@')) return 'Digite um e-mail válido';
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
        hintText: 'Crie uma senha',
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

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      style: const TextStyle(color: AppColors.branco),
      decoration: InputDecoration(
        labelText: 'Confirmar senha',
        hintText: 'Repita a senha',
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.verdeMedio),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: AppColors.verdeMedio,
          ),
          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Confirme a senha';
        if (value != _passwordController.text) return 'Senhas não conferem';
        return null;
      },
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _nextStep,
        child: const Text(
          'Próximo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _onRegister,
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.background,
                    ),
                  )
                : const Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: TextButton(
            onPressed: _previousStep,
            child: const Text(
              'Voltar',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.cinzaClaro,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Já tem uma conta? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.cinzaEscuro,
              ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
          child: Text(
            'Entrar',
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
