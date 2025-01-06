import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/domain/entities/application_entity.dart';
import 'package:ivdb/data/repositories/rest/user_repository.dart';
import 'package:ivdb/domain/repositories/i_user_repository.dart';

class ShowApplicationsUseCase {
  final IUserRepository _userRepository;

  ShowApplicationsUseCase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  /// Método para obtener las solicitudes de aplicación desde el API
  Future<Either<FailException, List<ApplicationEntity>>> call() async {
    try {
      // Llama al método del repositorio para obtener la lista de solicitudes
      final applicationList = await _userRepository.getApplications();

      // Si la llamada fue exitosa, retorna las solicitudes
      if (applicationList.isRight()) {
        return applicationList;
      }

      // Retorna el error si ocurrió un fallo
      return applicationList;
    } catch (e) {
      // Manejo genérico de errores no controlados
      return Left(ServerException(e.toString()));
    }
  }
}

/// Provider para inyectar la lógica del caso de uso
final showApplicationsUseCaseProvider = Provider<ShowApplicationsUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return ShowApplicationsUseCase(userRepository: userRepository);
});
