import 'package:animals_store/core/network/api_constants.dart';
import 'package:animals_store/core/network/dio_client.dart';
import 'package:animals_store/features/bits/data/models/breed_model.dart';
import 'package:animals_store/features/bits/data/models/dog_image_model.dart';
import 'package:animals_store/features/bits/data/models/source_model.dart';

/// Abstract class for Dog remote data source
abstract class DogRemoteDataSource {
  /// Get all breeds
  Future<List<BreedModel>> getAllBreeds({int limit = 10, int page = 0});

  /// Get dog images
  Future<List<DogImageModel>> getDogImages({
    int limit = 10,
    int page = 0,
    String? breedId,
    String? size,
    bool hasBreeds = false,
  });

  /// Get image by ID
  Future<DogImageModel> getImageById(String id);

  /// Get sources
  Future<List<SourceModel>> getSources({int limit = 10, int page = 0});

  /// Search breeds by name
  Future<List<BreedModel>> searchBreeds(String query);
}

/// Implementation of Dog remote data source using Dog API
class DogRemoteDataSourceImpl implements DogRemoteDataSource {
  final DioClient client;

  DogRemoteDataSourceImpl({required this.client});

  @override
  Future<List<BreedModel>> getAllBreeds({int limit = 10, int page = 0}) async {
    try {
      final response = await client.get(
        ApiConstants.breeds,
        queryParameters: {
          ApiConstants.limitParam: limit,
          ApiConstants.pageParam: page,
        },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => BreedModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DogImageModel>> getDogImages({
    int limit = 10,
    int page = 0,
    String? breedId,
    String? size,
    bool hasBreeds = false,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        ApiConstants.limitParam: limit,
        ApiConstants.pageParam: page,
        ApiConstants.hasBreeds: hasBreeds ? 1 : 0,
      };

      if (breedId != null) {
        queryParams[ApiConstants.breedIdParam] = breedId;
      }

      if (size != null) {
        queryParams[ApiConstants.sizeParam] = size;
      }

      final response = await client.get(
        ApiConstants.images,
        queryParameters: queryParams,
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => DogImageModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DogImageModel> getImageById(String id) async {
    try {
      final response = await client.get(ApiConstants.imageById(id));

      return DogImageModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SourceModel>> getSources({int limit = 10, int page = 0}) async {
    try {
      final response = await client.get(
        ApiConstants.sources,
        queryParameters: {
          ApiConstants.limitParam: limit,
          ApiConstants.pageParam: page,
        },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => SourceModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BreedModel>> searchBreeds(String query) async {
    try {
      final response = await client.get(
        '${ApiConstants.breeds}/search',
        queryParameters: {'q': query},
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => BreedModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
