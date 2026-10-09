import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/usecases/change_password_usecase.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final userId = await _storage.read(key: 'user_id');
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não autenticado'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final useCase = GetIt.instance<ChangePasswordUseCase>();
    final result = await useCase.execute(
      id: userId,
      currentPassword: _currentController.text,
      newPassword: _newController.text,
    );

    if (!mounted) return;

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Senha alterada com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      },
    );

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Alterar Senha')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 64,
                    color: AppColors.latao,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _currentController,
                    obscureText: _obscureCurrent,
                    style: const TextStyle(color: AppColors.marfim),
                    decoration: InputDecoration(
                      labelText: 'Senha atual',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.cinza),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.latao,
                        ),
                        onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Senha atual é obrigatória' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newController,
                    obscureText: _obscureNew,
                    style: const TextStyle(color: AppColors.marfim),
                    decoration: InputDecoration(
                      labelText: 'Nova senha',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.cinza),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.latao,
                        ),
                        onPressed: () => setState(() => _obscureNew = !_obscureNew),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Nova senha é obrigatória';
                      if (v.length < 6) return 'Mínimo de 6 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    style: const TextStyle(color: AppColors.marfim),
                    decoration: InputDecoration(
                      labelText: 'Confirmar nova senha',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.cinza),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.latao,
                        ),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Confirmação é obrigatória';
                      if (v != _newController.text) return 'Senhas não conferem';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onSave,
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
                              'Salvar',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
