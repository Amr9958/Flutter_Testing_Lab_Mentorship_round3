import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/core/usecase/usecase.dart';
import 'package:animals_store/features/bits/domain/entities/dog_image_entity.dart';
import 'package:animals_store/features/bits/domain/repositories/dog_repository.dart';

/// Parameters for getting dog images
class GetDogImagesParams {
  final int limit;
  final int page;
  final String? breedId;
  final String? size;
  final bool hasBreeds;

  const GetDogImagesParams({
    this.limit = 10,
    this.page = 0,
    this.breedId,
    this.size,
    this.hasBreeds = false,
  });
}

/// Use case for getting dog images
class GetDogImages implements UseCase<List<DogImageEntity>, GetDogImagesParams> {
  final DogRepository repository;

  GetDogImages(this.repository);

  @override
  Future<Either<Failure, List<DogImageEntity>>> call(GetDogImagesParams params) async {
    return await repository.getDogImages(
      limit: params.limit,
      page: params.page,
      breedId: params.breedId,
      size: params.size,
      hasBreeds: params.hasBreeds,
    );
  }
}
