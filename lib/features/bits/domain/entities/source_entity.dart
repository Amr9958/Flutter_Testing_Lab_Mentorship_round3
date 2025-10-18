import 'package:equatable/equatable.dart';

/// Source Entity - Domain layer model for dog data sources
class SourceEntity extends Equatable {
  final int id;
  final String name;
  final String url;
  final String? breedId;

  const SourceEntity({
    required this.id,
    required this.name,
    required this.url,
    this.breedId,
  });

  @override
  List<Object?> get props => [id, name, url, breedId];
}
