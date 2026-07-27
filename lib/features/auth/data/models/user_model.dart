import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String? phone;

  const UserModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      if (phone != null) 'phone': phone,
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      lastName: lastName,
      email: email,
      phone: phone,
    );
  }

  @override
  List<Object?> get props => [id, name, lastName, email, phone];
}