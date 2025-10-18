import 'package:dartz/dartz.dart';
import 'package:animals_store/core/error/exceptions.dart';
import 'package:animals_store/core/error/failures.dart';
import 'package:animals_store/core/error/error_messages.dart';
import 'package:animals_store/core/network/network_info.dart';
import 'package:animals_store/features/bits/data/datasources/dog_remote_data_source.dart';
import 'package:animals_store/features/bits/domain/entities/breed_entity.dart';
import 'package:animals_store/features/bits/domain/entities/dog_image_entity.dart';
import 'package:animals_store/features/bits/domain/entities/source_entity.dart';
import 'package:animals_store/features/bits/domain/repositories/dog_repository.dart';

/// Implementation of DogRepository
class DogRepositoryImpl implements DogRepository {
  final DogRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DogRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BreedEntity>>> getAllBreeds({
    int limit = 10,
    int page = 0,
  }) async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(NetworkFailure(ErrorMessages.noInternetConnection));
      }

      final breeds = await remoteDataSource.getAllBreeds(
        limit: limit,
        page: page,
      );
      return Right(breeds);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DogImageEntity>>> getDogImages({
    int limit = 10,
    int page = 0,
    String? breedId,
    String? size,
    bool hasBreeds = false,
  }) async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(NetworkFailure(ErrorMessages.noInternetConnection));
      }

      final images = await remoteDataSource.getDogImages(
        limit: limit,
        page: page,
        breedId: breedId,
        size: size,
        hasBreeds: hasBreeds,
      );
      return Right(images);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DogImageEntity>> getImageById(String id) async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(NetworkFailure(ErrorMessages.noInternetConnection));
      }

      final image = await remoteDataSource.getImageById(id);
      return Right(image);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SourceEntity>>> getSources({
    int limit = 10,
    int page = 0,
  }) async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(NetworkFailure(ErrorMessages.noInternetConnection));
      }

      final sources = await remoteDataSource.getSources(
        limit: limit,
        page: page,
      );
      return Right(sources);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BreedEntity>>> searchBreeds(String query) async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(NetworkFailure(ErrorMessages.noInternetConnection));
      }

      final breeds = await remoteDataSource.searchBreeds(query);
      return Right(breeds);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
