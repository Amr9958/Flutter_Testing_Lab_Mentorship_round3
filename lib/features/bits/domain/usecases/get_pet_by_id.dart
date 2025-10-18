import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/core/usecase/usecase.dart';
import 'package:animals_store/features/bits/domain/entities/pet_entity.dart';
import 'package:animals_store/features/bits/domain/repositories/pet_repository.dart';

/// Use case for getting a pet by ID
class GetPetById implements UseCase<PetEntity, String> {
  final PetRepository repository;

  GetPetById(this.repository);

  @override
  Future<Either<Failure, PetEntity>> call(String id) async {
    return await repository.getPetById(id);
  }
}
