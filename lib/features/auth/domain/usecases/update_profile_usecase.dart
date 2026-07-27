import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<String, User>> execute({
    required String id,
    String? name,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return _repository.updateUser(
      id: id,
      name: name,
      lastName: lastName,
      email: email,
      phone: phone,
    );
  }
}
