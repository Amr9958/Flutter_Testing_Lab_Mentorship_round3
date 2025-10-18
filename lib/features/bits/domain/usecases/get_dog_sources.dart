import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/core/usecase/usecase.dart';
import 'package:animals_store/features/bits/domain/entities/source_entity.dart';
import 'package:animals_store/features/bits/domain/repositories/dog_repository.dart';

/// Parameters for getting dog sources
class GetDogSourcesParams {
  final int limit;
  final int page;

  const GetDogSourcesParams({
    this.limit = 10,
    this.page = 0,
  });
}

/// Use case for getting dog sources
class GetDogSources implements UseCase<List<SourceEntity>, GetDogSourcesParams> {
  final DogRepository repository;

  GetDogSources(this.repository);

  @override
  Future<Either<Failure, List<SourceEntity>>> call(GetDogSourcesParams params) async {
    return await repository.getSources(
      limit: params.limit,
      page: params.page,
    );
  }
}
