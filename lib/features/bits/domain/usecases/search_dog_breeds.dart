import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/core/usecase/usecase.dart';
import 'package:animals_store/features/bits/domain/entities/breed_entity.dart';
import 'package:animals_store/features/bits/domain/repositories/dog_repository.dart';

/// Use case for searching dog breeds by name
class SearchDogBreeds implements UseCase<List<BreedEntity>, String> {
  final DogRepository repository;

  SearchDogBreeds(this.repository);

  @override
  Future<Either<Failure, List<BreedEntity>>> call(String query) async {
    return await repository.searchBreeds(query);
  }
}
