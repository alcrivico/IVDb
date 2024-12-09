import '../../data/models/role_model.dart';
import '../entities/role_entity.dart';

extension RoleModelToEntity on RoleModel {
  RoleEntity toEntity() {
    return RoleEntity(id: id, name: name);
  }
}

extension RoleEntityToModel on RoleEntity {
  RoleModel toModel() {
    return RoleModel(id: id, name: name);
  }
}
