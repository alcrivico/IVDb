import 'package:ivdb/domain/mappers/role_mapper.dart';

import '../../data/models/user_model.dart';
import '../entities/user_entity.dart';

extension UserModelToEntity on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      email: email,
      profileRoute: profileRoute,
      roleId: roleId,
      role: role?.toEntity(),
    );
  }
}

extension UserEntityToModel on UserEntity {
  UserModel toModel() {
    return UserModel(
      id: id,
      username: username,
      email: email,
      password: '', // No se incluye el password en la entidad
      profileRoute: profileRoute,
      roleId: roleId,
      role: role?.toModel(),
    );
  }
}
