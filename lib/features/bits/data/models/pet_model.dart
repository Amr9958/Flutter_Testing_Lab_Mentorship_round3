import 'package:animals_store/features/bits/domain/entities/pet_entity.dart';

/// Pet Model - extends PetEntity
/// Handles JSON serialization/deserialization
class PetModel extends PetEntity {
  const PetModel({
    required super.id,
    required super.name,
    required super.breed,
    required super.category,
    required super.age,
    required super.gender,
    required super.weight,
    required super.color,
    required super.location,
    required super.description,
    required super.imageUrl,
    required super.distance,
    required super.isFavorite,
  });

  /// Create PetModel from JSON
  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      breed: json['breed'] as String,
      category: json['category'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      weight: (json['weight'] as num).toDouble(),
      color: json['color'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
      distance: (json['distance'] as num).toDouble(),
    );
  }

  /// Convert PetModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'category': category,
      'age': age,
      'gender': gender,
      'weight': weight,
      'color': color,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'distance': distance,
    };
  }

  /// Create a copy with modified fields
  PetModel copyWith({
    String? id,
    String? name,
    String? breed,
    String? category,
    int? age,
    String? gender,
    double? weight,
    String? color,
    String? location,
    String? description,
    String? imageUrl,
    bool? isFavorite,
    double? distance,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      category: category ?? this.category,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      location: location ?? this.location,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      distance: distance ?? this.distance,
    );
  }
}
