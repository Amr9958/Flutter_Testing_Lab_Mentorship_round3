import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/features/bits/domain/entities/breed_entity.dart';
import 'package:animals_store/features/bits/domain/entities/dog_image_entity.dart';
import 'package:animals_store/features/bits/domain/entities/source_entity.dart';

/// Dog Repository interface - Domain layer
abstract class DogRepository {
  /// Get all dog breeds
  Future<Either<Failure, List<BreedEntity>>> getAllBreeds({
    int limit = 10,
    int page = 0,
  });

  /// Get dog images
  Future<Either<Failure, List<DogImageEntity>>> getDogImages({
    int limit = 10,
    int page = 0,
    String? breedId,
    String? size,
    bool hasBreeds = false,
  });

  /// Get image by ID
  Future<Either<Failure, DogImageEntity>> getImageById(String id);

  /// Get sources
  Future<Either<Failure, List<SourceEntity>>> getSources({
    int limit = 10,
    int page = 0,
  });

  /// Search breeds by name
  Future<Either<Failure, List<BreedEntity>>> searchBreeds(String query);
}
