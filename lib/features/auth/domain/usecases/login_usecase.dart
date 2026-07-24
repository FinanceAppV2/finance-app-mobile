import 'package:fpdart/fpdart.dart';

import '../entities/login_result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<String, LoginResult>> execute({
    required String login,
    required String password,
  }) {
    return _repository.login(login: login, password: password);
  }
}