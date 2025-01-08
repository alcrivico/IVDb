import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/rest/videogame_repository.dart';
import 'package:ivdb/domain/entities/rating_entity.dart';
import 'package:ivdb/domain/repositories/i_videogame_repository.dart';

class ShowVideogameUsecase {
  final IVideogameRepository _videogameRepository;

  ShowVideogameUsecase(this._videogameRepository);

  Future<Either<FailException, RatingEntity>> call(
      String title, DateTime releaseDate, String email) async {
    final rate =
        await _videogameRepository.showUserRating(title, releaseDate, email);

    return rate;
  }
}

final showVideogameUsecaseProvider = Provider<ShowVideogameUsecase>((ref) {
  final videogameRepository = ref.read(videogameRepositoryProvider);
  return ShowVideogameUsecase(videogameRepository);
});
