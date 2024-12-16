import 'package:ivdb/domain/entities/role_entity.dart';

class UserEntity {
  final int id;
  final String username;
  final String email;
  final String profileRoute;
  final int? roleId;
  final RoleEntity? role;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.profileRoute,
    this.roleId,
    this.role,
  });
}
