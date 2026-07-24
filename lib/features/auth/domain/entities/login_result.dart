import 'package:equatable/equatable.dart';

import 'user.dart';

class LoginResult extends Equatable {
  final String token;
  final User user;

  const LoginResult({
    required this.token,
    required this.user,
  });

  @override
  List<Object?> get props => [token, user];
}