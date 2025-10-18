import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/core/usecase/usecase.dart';
import 'package:animals_store/features/bits/domain/repositories/pet_repository.dart';

/// Use case for toggling favorite status
class ToggleFavorite implements UseCase<void, String> {
  final PetRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.toggleFavorite(id);
  }
}
