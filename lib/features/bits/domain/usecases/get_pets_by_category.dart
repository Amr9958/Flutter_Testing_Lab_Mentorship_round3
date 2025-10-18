import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/core/usecase/usecase.dart';
import 'package:animals_store/features/bits/domain/entities/pet_entity.dart';
import 'package:animals_store/features/bits/domain/repositories/pet_repository.dart';

/// Use case for getting pets by category
class GetPetsByCategory implements UseCase<List<PetEntity>, String> {
  final PetRepository repository;

  GetPetsByCategory(this.repository);

  @override
  Future<Either<Failure, List<PetEntity>>> call(String category) async {
    return await repository.getPetsByCategory(category);
  }
}
