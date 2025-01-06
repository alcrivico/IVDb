import '../../data/models/application_model.dart';
import '../entities/application_entity.dart';

extension ApplicationModelToEntity on ApplicationModel {
  ApplicationEntity toEntity() {
    return ApplicationEntity(
      id: id,
      request: request,
      requestDate: requestDate,
      state: state,
      userId: userId,
      email: email,
    );
  }
}

extension ApplicationEntityToModel on ApplicationEntity {
  ApplicationModel toModel() {
    return ApplicationModel(
      id: id!,
      request: request,
      requestDate: requestDate,
      state: state,
      userId: userId,
      email: email,
    );
  }
}
