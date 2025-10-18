import 'package:animals_store/features/bits/data/models/breed_model.dart';
import 'package:animals_store/features/bits/domain/entities/dog_image_entity.dart';

/// Dog Image Model - for Dog API image data
class DogImageModel extends DogImageEntity {
  const DogImageModel({
    required super.id,
    required super.url,
    super.width,
    super.height,
    super.breeds,
  });

  /// Create DogImageModel from JSON (Dog API response)
  factory DogImageModel.fromJson(Map<String, dynamic> json) {
    return DogImageModel(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      width: json['width'] as int?,
      height: json['height'] as int?,
      breeds: json['breeds'] != null
          ? (json['breeds'] as List)
              .map((breed) => BreedModel.fromJson(breed as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (breeds != null)
        'breeds': breeds!.map((breed) => (breed as BreedModel).toJson()).toList(),
    };
  }

  /// Create a copy with modified fields
  DogImageModel copyWith({
    String? id,
    String? url,
    int? width,
    int? height,
    List<BreedModel>? breeds,
  }) {
    return DogImageModel(
      id: id ?? this.id,
      url: url ?? this.url,
      width: width ?? this.width,
      height: height ?? this.height,
      breeds: breeds ?? this.breeds,
    );
  }
}
