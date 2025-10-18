import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/exceptions.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/core/error/error_messages.dart';
import 'package:animals_store/core/network/network_info.dart';
import 'package:animals_store/features/bits/data/datasources/pet_data_source.dart';
import 'package:animals_store/features/bits/domain/entities/pet_entity.dart';
import 'package:animals_store/features/bits/domain/repositories/pet_repository.dart';

/// Implementation of PetRepository
class PetRepositoryImpl implements PetRepository {
  final PetDataSource dataSource;
  final NetworkInfo networkInfo;

  PetRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PetEntity>>> getAllPets() async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(NetworkFailure(ErrorMessages.noInternetConnection));
      }

      final pets = await dataSource.getAllPets();
      return Right(pets);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PetEntity>>> getFavoritePets() async {
    try {
      final pets = await dataSource.getFavoritePets();
      return Right(pets);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PetEntity>>> getPetsByCategory(String category) async {
    try {
      final pets = await dataSource.getPetsByCategory(category);
      return Right(pets);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PetEntity>> getPetById(String id) async {
    try {
      final pet = await dataSource.getPetById(id);
      return Right(pet);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(ErrorMessages.petNotFound));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String id) async {
    try {
      await dataSource.toggleFavorite(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(ErrorMessages.failedToToggleFavorite));
    }
  }
}
