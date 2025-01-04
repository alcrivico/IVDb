import 'package:ivdb/data/models/role_model.dart';

class UserModel {
  final int id;
  final String username;
  final String email;
  final String password;
  final String profileRoute;
  final int? roleId;
  final RoleModel? role;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.profileRoute,
    this.roleId,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      profileRoute: json['profileRoute'],
      roleId: json['roleId'],
      role: json['role'] != null ? RoleModel.fromJson(json['role']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'profileRoute': profileRoute,
      'roleId': roleId,
      'role': role?.toJson(),
    };
  }
}
