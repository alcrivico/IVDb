import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ivdb/core/exceptions/fail_exception.dart';
import 'package:ivdb/data/repositories/grpc/cover_image_repository.dart';
import 'package:ivdb/domain/repositories/i_cover_image_repository.dart';
import 'package:ivdb/protos/generated/fileServices.pb.dart';

class DownloadCoverUsecase {
  final ICoverImageRepository _coverImageRepository;

  DownloadCoverUsecase({required ICoverImageRepository coverImageRepository})
      : _coverImageRepository = coverImageRepository;

  Future<Either<FailException, ImageResponse>> call(String path) {
    return _coverImageRepository.downloadCoverImage(path);
  }
}

final downloadCoverUsecaseProvider = Provider<DownloadCoverUsecase>((ref) {
  final coverImageRepository = ref.read(coverImageRepositoryProvider);
  return DownloadCoverUsecase(coverImageRepository: coverImageRepository);
});
