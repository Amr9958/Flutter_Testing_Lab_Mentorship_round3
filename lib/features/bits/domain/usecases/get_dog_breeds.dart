import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/core/usecase/usecase.dart';
import 'package:animals_store/features/bits/domain/entities/breed_entity.dart';
import 'package:animals_store/features/bits/domain/repositories/dog_repository.dart';

/// Parameters for getting dog breeds
class GetDogBreedsParams {
  final int limit;
  final int page;

  const GetDogBreedsParams({
    this.limit = 10,
    this.page = 0,
  });
}

/// Use case for getting all dog breeds
class GetDogBreeds implements UseCase<List<BreedEntity>, GetDogBreedsParams> {
  final DogRepository repository;

  GetDogBreeds(this.repository);

  @override
  Future<Either<Failure, List<BreedEntity>>> call(GetDogBreedsParams params) async {
    return await repository.getAllBreeds(
      limit: params.limit,
      page: params.page,
    );
  }
}
