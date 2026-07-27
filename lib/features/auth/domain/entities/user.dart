import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String? phone;

  const User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    this.phone,
  });

  User copyWith({
    String? name,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [id, name, lastName, email, phone];
}