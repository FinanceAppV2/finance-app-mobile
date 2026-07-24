import 'package:fpdart/fpdart.dart';

import '../entities/login_result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, LoginResult>> login({
    required String login,
    required String password,
  });

  Future<Either<String, User>> register({
    required String name,
    required String lastName,
    required String email,
    required String phone,
    required String cpf,
    required String password,
  });
}