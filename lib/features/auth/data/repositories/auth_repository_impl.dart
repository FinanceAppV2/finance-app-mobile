import 'package:fpdart/fpdart.dart';

import '../../domain/entities/login_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, LoginResult>> login({
    required String login,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        login: login,
        password: password,
      );
      return Right(LoginResult(
        token: response.token,
        user: response.user.toEntity(),
      ));
    } catch (e) {
      return Left('Erro ao fazer login: $e');
    }
  }

  @override
  Future<Either<String, User>> register({
    required String name,
    required String lastName,
    required String email,
    required String phone,
    required String cpf,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        name: name,
        lastName: lastName,
        email: email,
        phone: phone,
        cpf: cpf,
        password: password,
      );
      return Right(response.toEntity());
    } catch (e) {
      return Left('Erro ao criar conta: $e');
    }
  }
}