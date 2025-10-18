import 'package:animals_store/core/network/dio_client.dart';
import 'package:animals_store/core/network/api_constants.dart';
import 'package:animals_store/features/bits/data/models/pet_model.dart';

/// Abstract class for Pet data source
abstract class PetDataSource {
  Future<List<PetModel>> getAllPets();
  Future<List<PetModel>> getFavoritePets();
  Future<List<PetModel>> getPetsByCategory(String category);
  Future<PetModel> getPetById(String id);
  Future<void> toggleFavorite(String id);
}

/// Implementation of Pet data source using Dog API
class PetDataSourceImpl implements PetDataSource {
  final DioClient client;

  PetDataSourceImpl({required this.client});

  // Local favorites storage (in production, use SharedPreferences or Database)
  final Set<String> _favorites = {};

  @override
  Future<List<PetModel>> getAllPets() async {
    try {
      // Get dog images with breed info from Dog API
      final response = await client.get(
        ApiConstants.images,
        queryParameters: {
          ApiConstants.limitParam: 20,
          ApiConstants.hasBreeds: 1,
        },
      );

      if (response.data is List) {
        return (response.data as List).map((json) {
          return _convertDogApiToPetModel(json as Map<String, dynamic>);
        }).toList();
      }

      return [];
    } catch (e) {
      // Return empty list on error (or throw exception)
      return [];
    }
  }

  @override
  Future<List<PetModel>> getFavoritePets() async {
    final allPets = await getAllPets();
    return allPets.where((pet) => _favorites.contains(pet.id)).toList();
  }

  @override
  Future<List<PetModel>> getPetsByCategory(String category) async {
    final allPets = await getAllPets();
    if (category == 'All') return allPets;
    return allPets.where((pet) => pet.category == category).toList();
  }

  @override
  Future<PetModel> getPetById(String id) async {
    final allPets = await getAllPets();
    return allPets.firstWhere(
      (pet) => pet.id == id,
      orElse: () => throw Exception('Pet not found'),
    );
  }

  @override
  Future<void> toggleFavorite(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
  }

  /// Convert Dog API response to PetModel
  PetModel _convertDogApiToPetModel(Map<String, dynamic> json) {
    final breeds = json['breeds'] as List?;
    final breedData = (breeds != null && breeds.isNotEmpty)
        ? breeds.first as Map<String, dynamic>
        : <String, dynamic>{};

    return PetModel(
      id: json['id'] as String? ?? '',
      name: breedData['name'] as String? ?? 'Unknown Dog',
      breed: breedData['name'] as String? ?? 'Mixed',
      category: 'Dog',
      age: 2, // Default age
      gender: 'Unknown',
      weight: _parseWeight(breedData['weight']),
      color: 'Various',
      location: breedData['origin'] as String? ?? 'Unknown',
      description: breedData['temperament'] as String? ?? 'Friendly dog',
      imageUrl: json['url'] as String? ?? '',
      isFavorite: _favorites.contains(json['id']),
      distance: 5.0, // Default distance
    );
  }

  /// Parse weight from Dog API format
  double _parseWeight(dynamic weightData) {
    if (weightData is Map) {
      final metric = weightData['metric'] as String?;
      if (metric != null) {
        // Parse "10 - 15" to get average
        final parts = metric.split(' - ');
        if (parts.isNotEmpty) {
          return double.tryParse(parts.first) ?? 10.0;
        }
      }
    }
    return 10.0; // Default weight
  }
}
