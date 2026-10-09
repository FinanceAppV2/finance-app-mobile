import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/usecases/update_profile_usecase.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final _picker = ImagePicker();
  bool _isLoading = false;
  String? _userId;
  File? _avatarFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    _userId = await _storage.read(key: 'user_id');
    _nameController.text = await _storage.read(key: 'user_name') ?? '';
    _lastNameController.text = await _storage.read(key: 'user_lastName') ?? '';
    _emailController.text = await _storage.read(key: 'user_email') ?? '';
    _phoneController.text = await _storage.read(key: 'user_phone') ?? '';
    setState(() {});
  }

  String get _initial {
    final name = _nameController.text.trim();
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source, maxWidth: 512);
    if (file != null) {
      setState(() => _avatarFile = File(file.path));
    }
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.elevado,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.latao),
                title: const Text('Câmera', style: TextStyle(color: AppColors.marfim)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.latao),
                title: const Text('Galeria', style: TextStyle(color: AppColors.marfim)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_avatarFile != null || _initial != '?')
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.error),
                  title: const Text('Remover avatar', style: TextStyle(color: AppColors.error)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _avatarFile = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label é obrigatório';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'E-mail é obrigatório';
    if (!value.contains('@')) return 'E-mail inválido';
    return null;
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final useCase = GetIt.instance<UpdateProfileUseCase>();
    final result = await useCase.execute(
      id: _userId!,
      name: _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      },
      (user) async {
        await _storage.write(key: 'user_name', value: user.name);
        await _storage.write(key: 'user_lastName', value: user.lastName);
        await _storage.write(key: 'user_email', value: user.email);
        if (user.phone != null) {
          await _storage.write(key: 'user_phone', value: user.phone!);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
    );

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showAvatarOptions,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: AppColors.latao,
                          backgroundImage:
                              _avatarFile != null ? FileImage(_avatarFile!) : null,
                          child: _avatarFile == null
                              ? Text(
                                  _initial,
                                  style: const TextStyle(
                                    color: AppColors.marfim,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.latao,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 20,
                              color: AppColors.marfim,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: AppColors.marfim),
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.cinza),
                    ),
                    validator: (v) => _validateRequired(v, 'Nome'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    style: const TextStyle(color: AppColors.marfim),
                    decoration: const InputDecoration(
                      labelText: 'Sobrenome',
                      prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.cinza),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: AppColors.marfim),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.cinza),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    style: const TextStyle(color: AppColors.marfim),
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Celular',
                      prefixIcon: Icon(Icons.phone_outlined, color: AppColors.cinza),
                    ),
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
