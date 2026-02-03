import 'place.dart';

class VisitHistory {
  final String id;
  final Place place;
  final DateTime visitedAt;
  final int durationMinutes;
  final double? rating;
  final String? notes;
  final List<String> photos;
  final Map<String, dynamic>? metadata;

  const VisitHistory({
    required this.id,
    required this.place,
    required this.visitedAt,
    this.durationMinutes = 0,
    this.rating,
    this.notes,
    this.photos = const [],
    this.metadata,
  });

  VisitHistory copyWith({
    double? rating,
    String? notes,
    List<String>? photos,
  }) {
    return VisitHistory(
      id: id,
      place: place,
      visitedAt: visitedAt,
      durationMinutes: durationMinutes,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      photos: photos ?? this.photos,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place': place.toJson(),
      'visitedAt': visitedAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'rating': rating,
      'notes': notes,
      'photos': photos,
      'metadata': metadata,
    };
  }

  factory VisitHistory.fromJson(Map<String, dynamic> json) {
    return VisitHistory(
      id: json['id'] as String,
      place: Place.fromJson(json['place'] as Map<String, dynamic>),
      visitedAt: DateTime.parse(json['visitedAt'] as String),
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      notes: json['notes'] as String?,
      photos: json['photos'] != null ? List<String>.from(json['photos'] as List) : [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
