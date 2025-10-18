import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/features/bits/domain/entities/pet_entity.dart';

/// Pet Repository interface
/// Domain layer - defines the contract for data operations
abstract class PetRepository {
  Future<Either<Failure, List<PetEntity>>> getAllPets();
  Future<Either<Failure, List<PetEntity>>> getFavoritePets();
  Future<Either<Failure, List<PetEntity>>> getPetsByCategory(String category);
  Future<Either<Failure, PetEntity>> getPetById(String id);
  Future<Either<Failure, void>> toggleFavorite(String id);
}
