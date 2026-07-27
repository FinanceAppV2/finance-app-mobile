import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<Either<String, User>> execute({
    required String id,
    required String currentPassword,
    required String newPassword,
  }) {
    return _repository.updateUser(
      id: id,
      currentPassword: currentPassword,
      password: newPassword,
    );
  }
}
