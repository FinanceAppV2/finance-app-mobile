import 'package:flutter/material.dart';

import '../../domain/usecases/register_usecase.dart';

enum RegisterStatus { initial, loading, success, error }

class RegisterController extends ChangeNotifier {
  final RegisterUseCase _registerUseCase;

  RegisterStatus _status = RegisterStatus.initial;
  String? _errorMessage;

  RegisterController(this._registerUseCase);

  RegisterStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> register({
    required String name,
    required String lastName,
    required String email,
    required String phone,
    required String cpf,
    required String password,
  }) async {
    _status = RegisterStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _registerUseCase.execute(
      name: name,
      lastName: lastName,
      email: email,
      phone: phone,
      cpf: cpf,
      password: password,
    );

    result.fold(
      (error) {
        _status = RegisterStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (_) {
        _status = RegisterStatus.success;
        notifyListeners();
      },
    );
  }
}