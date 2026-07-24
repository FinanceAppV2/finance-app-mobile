import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/usecases/login_usecase.dart';

enum AuthStatus { initial, loading, success, error }

class AuthController extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final FlutterSecureStorage _storage;

  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  AuthController(this._loginUseCase, this._storage);

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<void> login({
    required String login,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _loginUseCase.execute(login: login, password: password);

    result.fold(
      (error) {
        _status = AuthStatus.error;
        _errorMessage = error;
        notifyListeners();
      },
      (loginResult) async {
        await _storage.write(key: 'access_token', value: loginResult.token);
        await _storage.write(key: 'user_id', value: loginResult.user.id);
        await _storage.write(key: 'user_name', value: loginResult.user.name);
        await _storage.write(
            key: 'user_email', value: loginResult.user.email);

        _status = AuthStatus.success;
        notifyListeners();
      },
    );
  }
}