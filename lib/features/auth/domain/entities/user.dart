import 'package:equatable/equatable.dart';

import 'package:finance_app_mobile/features/plans/domain/entities/plan.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String? phone;
  final Plan? plan;

  const User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    this.phone,
    this.plan,
  });

  User copyWith({
    String? name,
    String? lastName,
    String? email,
    String? phone,
    Plan? plan,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      plan: plan ?? this.plan,
    );
  }

  @override
  List<Object?> get props => [id, name, lastName, email, phone, plan];
}