import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/core/usecase/usecase.dart';
import 'package:animals_store/features/bits/domain/entities/pet_entity.dart';
import 'package:animals_store/features/bits/domain/repositories/pet_repository.dart';

/// Use case for getting all pets
class GetAllPets implements NoParamsUseCase<List<PetEntity>> {
  final PetRepository repository;

  GetAllPets(this.repository);

  @override
  Future<Either<Failure, List<PetEntity>>> call() async {
    return await repository.getAllPets();
  }
}
