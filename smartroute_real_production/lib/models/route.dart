import 'itinerary_item.dart';

class RouteModel {
  final String id;
  final List<ItineraryItem> items;
  final int totalDurationMin;
  final double totalDistanceKm;
  final List<RouteSegment> segments;
  final String? polyline;
  final DateTime createdAt;
  final bool isOptimized;
  final double? costSavings;
  final int? timeSavings;

  const RouteModel({
    required this.id,
    required this.items,
    required this.totalDurationMin,
    required this.totalDistanceKm,
    required this.segments,
    this.polyline,
    required this.createdAt,
    this.isOptimized = false,
    this.costSavings,
    this.timeSavings,
  });

  String get formattedDuration {
    final hours = totalDurationMin ~/ 60;
    final minutes = totalDurationMin % 60;
    if (hours > 0) return '$hours시간 $minutes분';
    return '$minutes분';
  }

  String get formattedDistance {
    if (totalDistanceKm < 1) return '${(totalDistanceKm * 1000).toStringAsFixed(0)}m';
    return '${totalDistanceKm.toStringAsFixed(1)}km';
  }
}

class RouteSegment {
  final String id;
  final ItineraryItem from;
  final ItineraryItem to;
  final int durationMin;
  final double distanceKm;
  final TransportMode transportMode;
  final String? instructions;
  final List<RouteStep>? steps;

  const RouteSegment({
    required this.id,
    required this.from,
    required this.to,
    required this.durationMin,
    required this.distanceKm,
    required this.transportMode,
    this.instructions,
    this.steps,
  });
}

class RouteStep {
  final String instruction;
  final int durationMin;
  final double distanceKm;
  final String? roadName;

  const RouteStep({
    required this.instruction,
    required this.durationMin,
    required this.distanceKm,
    this.roadName,
  });
}
