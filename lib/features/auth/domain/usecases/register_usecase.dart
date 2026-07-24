import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<String, User>> execute({
    required String name,
    required String lastName,
    required String email,
    required String phone,
    required String cpf,
    required String password,
  }) {
    return _repository.register(
      name: name,
      lastName: lastName,
      email: email,
      phone: phone,
      cpf: cpf,
      password: password,
    );
  }
}