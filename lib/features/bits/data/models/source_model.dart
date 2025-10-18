import 'package:animals_store/features/bits/domain/entities/source_entity.dart';

/// Source Model - for Dog API source data
class SourceModel extends SourceEntity {
  const SourceModel({
    required super.id,
    required super.name,
    required super.url,
    super.breedId,
  });

  /// Create SourceModel from JSON (Dog API response)
  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
      breedId: json['breed_id'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'breed_id': breedId,
    };
  }

  /// Create a copy with modified fields
  SourceModel copyWith({
    int? id,
    String? name,
    String? url,
    String? breedId,
  }) {
    return SourceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      breedId: breedId ?? this.breedId,
    );
  }
}
