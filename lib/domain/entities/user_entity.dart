class UserEntity {
  final int id;
  final String username;
  final String email;
  final String profileRoute;
  final int? roleId;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.profileRoute,
    this.roleId,
  });
}
