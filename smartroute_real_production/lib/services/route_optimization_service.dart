import '../models/itinerary_item.dart';
import '../models/route.dart';
import 'dart:math';

class RouteOptimizationService {
  static final RouteOptimizationService _instance = RouteOptimizationService._internal();
  factory RouteOptimizationService() => _instance;
  RouteOptimizationService._internal();

  Future<RouteModel> optimizeRoute(List<ItineraryItem> items) async {
    if (items.length < 2) {
      return RouteModel(
        id: 'route_${DateTime.now().millisecondsSinceEpoch}',
        items: items,
        totalDurationMin: 0,
        totalDistanceKm: 0,
        segments: [],
        createdAt: DateTime.now(),
        isOptimized: false,
      );
    }

    // Simulate AI optimization
    await Future.delayed(const Duration(milliseconds: 1200));

    // Nearest Neighbor Algorithm (simplified)
    final optimized = _nearestNeighbor(items);
    final originalDistance = _calculateTotalDistance(items);
    final optimizedDistance = _calculateTotalDistance(optimized);
    final distanceSaved = originalDistance - optimizedDistance;
    final timeSaved = (distanceSaved / 30 * 60).round(); // 30km/h average

    final segments = _createSegments(optimized);

    return RouteModel(
      id: 'route_${DateTime.now().millisecondsSinceEpoch}',
      items: optimized,
      totalDurationMin: (optimizedDistance / 30 * 60).round(),
      totalDistanceKm: optimizedDistance,
      segments: segments,
      createdAt: DateTime.now(),
      isOptimized: true,
      costSavings: distanceSaved,
      timeSavings: timeSaved,
    );
  }

  List<ItineraryItem> _nearestNeighbor(List<ItineraryItem> items) {
    if (items.isEmpty) return [];
    
    final result = <ItineraryItem>[];
    final remaining = List<ItineraryItem>.from(items);
    
    var current = remaining.first;
    result.add(current);
    remaining.remove(current);

    while (remaining.isNotEmpty) {
      var nearest = remaining.first;
      var minDistance = double.infinity;

      for (final item in remaining) {
        final distance = _distance(current, item);
        if (distance < minDistance) {
          minDistance = distance;
          nearest = item;
        }
      }

      result.add(nearest);
      remaining.remove(nearest);
      current = nearest;
    }

    // Reorder
    return List.generate(
      result.length,
      (i) => result[i].copyWith(order: i + 1),
    );
  }

  double _calculateTotalDistance(List<ItineraryItem> items) {
    if (items.length < 2) return 0;
    double total = 0;
    for (int i = 0; i < items.length - 1; i++) {
      total += _distance(items[i], items[i + 1]);
    }
    return total;
  }

  double _distance(ItineraryItem from, ItineraryItem to) {
    final lat1 = from.place.lat;
    final lng1 = from.place.lng;
    final lat2 = to.place.lat;
    final lng2 = to.place.lng;

    const r = 6371.0; // Earth radius in km
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLng / 2) * sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  List<RouteSegment> _createSegments(List<ItineraryItem> items) {
    final segments = <RouteSegment>[];
    for (int i = 0; i < items.length - 1; i++) {
      final from = items[i];
      final to = items[i + 1];
      final distance = _distance(from, to);
      final duration = (distance / 30 * 60).round(); // 30km/h

      segments.add(RouteSegment(
        id: 'seg_$i',
        from: from,
        to: to,
        durationMin: duration,
        distanceKm: distance,
        transportMode: from.transportMode,
      ));
    }
    return segments;
  }
}
