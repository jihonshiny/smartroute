import 'place.dart';

enum TransportMode { walk, car, bus, subway, taxi, bicycle }

extension TransportModeExtension on TransportMode {
  String get displayName {
    switch (this) {
      case TransportMode.walk: return '도보';
      case TransportMode.car: return '자동차';
      case TransportMode.bus: return '버스';
      case TransportMode.subway: return '지하철';
      case TransportMode.taxi: return '택시';
      case TransportMode.bicycle: return '자전거';
    }
  }
  
  String get icon {
    switch (this) {
      case TransportMode.walk: return '🚶';
      case TransportMode.car: return '🚗';
      case TransportMode.bus: return '🚌';
      case TransportMode.subway: return '🚇';
      case TransportMode.taxi: return '🚕';
      case TransportMode.bicycle: return '🚴';
    }
  }
}

class ItineraryItem {
  final String id;
  final Place place;
  final int order;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? estimatedDurationMin;
  final double? estimatedDistanceKm;
  final TransportMode transportMode;
  final String? notes;
  final bool completed;
  final DateTime? completedAt;
  final List<String>? photos;
  final double? actualDurationMin;
  final String? feedback;

  const ItineraryItem({
    required this.id,
    required this.place,
    required this.order,
    this.startTime,
    this.endTime,
    this.estimatedDurationMin,
    this.estimatedDistanceKm,
    this.transportMode = TransportMode.walk,
    this.notes,
    this.completed = false,
    this.completedAt,
    this.photos,
    this.actualDurationMin,
    this.feedback,
  });

  ItineraryItem copyWith({
    Place? place,
    int? order,
    DateTime? startTime,
    DateTime? endTime,
    int? estimatedDurationMin,
    double? estimatedDistanceKm,
    TransportMode? transportMode,
    String? notes,
    bool? completed,
    DateTime? completedAt,
    List<String>? photos,
    double? actualDurationMin,
    String? feedback,
  }) {
    return ItineraryItem(
      id: id,
      place: place ?? this.place,
      order: order ?? this.order,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      estimatedDurationMin: estimatedDurationMin ?? this.estimatedDurationMin,
      estimatedDistanceKm: estimatedDistanceKm ?? this.estimatedDistanceKm,
      transportMode: transportMode ?? this.transportMode,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      photos: photos ?? this.photos,
      actualDurationMin: actualDurationMin ?? this.actualDurationMin,
      feedback: feedback ?? this.feedback,
    );
  }

  Duration? get duration {
    if (startTime == null || endTime == null) return null;
    return endTime!.difference(startTime!);
  }

  bool get isActive {
    if (startTime == null || endTime == null) return false;
    final now = DateTime.now();
    return now.isAfter(startTime!) && now.isBefore(endTime!);
  }

  bool get isUpcoming {
    if (startTime == null) return false;
    return DateTime.now().isBefore(startTime!);
  }

  bool get isPast {
    if (endTime == null) return false;
    return DateTime.now().isAfter(endTime!);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place': place.toJson(),
      'order': order,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'estimatedDurationMin': estimatedDurationMin,
      'estimatedDistanceKm': estimatedDistanceKm,
      'transportMode': transportMode.name,
      'notes': notes,
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
      'photos': photos,
      'actualDurationMin': actualDurationMin,
      'feedback': feedback,
    };
  }

  factory ItineraryItem.fromJson(Map<String, dynamic> json) {
    return ItineraryItem(
      id: json['id'] as String,
      place: Place.fromJson(json['place'] as Map<String, dynamic>),
      order: json['order'] as int,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      estimatedDurationMin: json['estimatedDurationMin'] as int?,
      estimatedDistanceKm: json['estimatedDistanceKm'] != null ? (json['estimatedDistanceKm'] as num).toDouble() : null,
      transportMode: TransportMode.values.byName(json['transportMode'] as String),
      notes: json['notes'] as String?,
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      photos: json['photos'] != null ? List<String>.from(json['photos'] as List) : null,
      actualDurationMin: json['actualDurationMin'] != null ? (json['actualDurationMin'] as num).toDouble() : null,
      feedback: json['feedback'] as String?,
    );
  }
}
