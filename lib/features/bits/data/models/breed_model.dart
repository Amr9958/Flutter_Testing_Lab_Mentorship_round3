import 'package:animals_store/features/bits/domain/entities/breed_entity.dart';

/// Breed Model - for Dog API breed data
class BreedModel extends BreedEntity {
  const BreedModel({
    required super.id,
    required super.name,
    super.breedGroup,
    super.bredFor,
    super.temperament,
    super.lifeSpan,
    super.origin,
    super.weight,
    super.height,
    super.imageUrl,
  });

  /// Create BreedModel from JSON (Dog API response)
  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      breedGroup: json['breed_group'] as String?,
      bredFor: json['bred_for'] as String?,
      temperament: json['temperament'] as String?,
      lifeSpan: json['life_span'] as String?,
      origin: json['origin'] as String?,
      weight: json['weight']?['metric'] as String?,
      height: json['height']?['metric'] as String?,
      imageUrl: json['image']?['url'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'breed_group': breedGroup,
      'bred_for': bredFor,
      'temperament': temperament,
      'life_span': lifeSpan,
      'origin': origin,
      'weight': {'metric': weight},
      'height': {'metric': height},
      if (imageUrl != null) 'image': {'url': imageUrl},
    };
  }

  /// Create a copy with modified fields
  BreedModel copyWith({
    String? id,
    String? name,
    String? breedGroup,
    String? bredFor,
    String? temperament,
    String? lifeSpan,
    String? origin,
    String? weight,
    String? height,
    String? imageUrl,
  }) {
    return BreedModel(
      id: id ?? this.id,
      name: name ?? this.name,
      breedGroup: breedGroup ?? this.breedGroup,
      bredFor: bredFor ?? this.bredFor,
      temperament: temperament ?? this.temperament,
      lifeSpan: lifeSpan ?? this.lifeSpan,
      origin: origin ?? this.origin,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
