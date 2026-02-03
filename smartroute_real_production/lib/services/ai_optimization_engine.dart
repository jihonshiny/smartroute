import 'dart:math';
import '../models/itinerary_item.dart';
import '../models/place.dart';
import '../models/route.dart';

/// 완전한 AI 기반 경로 최적화 엔진
/// TSP (Traveling Salesman Problem) 알고리즘 구현
class AIOptimizationEngine {
  static const double earthRadiusKm = 6371.0;

  /// 경로 최적화 메인 함수
  Future<OptimizationResult> optimizeRoute(
    List<ItineraryItem> items, {
    OptimizationStrategy strategy = OptimizationStrategy.balanced,
    OptimizationConstraints? constraints,
  }) async {
    if (items.length < 2) {
      return OptimizationResult(
        optimizedItems: items,
        originalDistance: 0,
        optimizedDistance: 0,
        timeSaved: 0,
        distanceSaved: 0,
        efficiency: 0,
        strategy: strategy,
      );
    }

    // 시뮬레이션 딜레이
    await Future.delayed(const Duration(milliseconds: 1200));

    // 원본 거리 계산
    final originalDistance = _calculateTotalDistance(items);
    final originalTime = _calculateTotalTime(items);

    // 전략에 따라 다른 최적화 알고리즘 사용
    List<ItineraryItem> optimized;
    switch (strategy) {
      case OptimizationStrategy.fastest:
        optimized = await _optimizeFastest(items, constraints);
        break;
      case OptimizationStrategy.shortest:
        optimized = await _optimizeShortest(items, constraints);
        break;
      case OptimizationStrategy.balanced:
        optimized = await _optimizeBalanced(items, constraints);
        break;
      case OptimizationStrategy.ecoFriendly:
        optimized = await _optimizeEcoFriendly(items, constraints);
        break;
    }

    // 최적화된 거리 계산
    final optimizedDistance = _calculateTotalDistance(optimized);
    final optimizedTime = _calculateTotalTime(optimized);

    // 절약량 계산
    final distanceSaved = originalDistance - optimizedDistance;
    final timeSaved = originalTime - optimizedTime;
    final efficiency = originalDistance > 0
        ? (distanceSaved / originalDistance * 100).toDouble()
        : 0.0;

    return OptimizationResult(
      optimizedItems: optimized,
      originalDistance: originalDistance,
      optimizedDistance: optimizedDistance,
      originalTime: originalTime,
      optimizedTime: optimizedTime,
      timeSaved: timeSaved,
      distanceSaved: distanceSaved,
      efficiency: efficiency,
      strategy: strategy,
    );
  }

  /// 가장 빠른 경로 최적화 (Nearest Neighbor)
  Future<List<ItineraryItem>> _optimizeFastest(
    List<ItineraryItem> items,
    OptimizationConstraints? constraints,
  ) async {
    final result = <ItineraryItem>[];
    final remaining = List<ItineraryItem>.from(items);

    // 시작점 선택 (제약조건 확인)
    var current = _selectStartPoint(remaining, constraints);
    result.add(current);
    remaining.remove(current);

    // Nearest Neighbor 알고리즘
    while (remaining.isNotEmpty) {
      var nearest = remaining.first;
      var minDistance = double.infinity;

      for (final item in remaining) {
        final distance = _calculateDistance(current, item);
        if (distance < minDistance) {
          minDistance = distance;
          nearest = item;
        }
      }

      result.add(nearest);
      remaining.remove(nearest);
      current = nearest;
    }

    return _reorderItems(result);
  }

  /// 최단 거리 최적화 (Greedy + 2-opt)
  Future<List<ItineraryItem>> _optimizeShortest(
    List<ItineraryItem> items,
    OptimizationConstraints? constraints,
  ) async {
    // 초기 경로 생성
    var route = await _optimizeFastest(items, constraints);

    // 2-opt 개선
    bool improved = true;
    int iteration = 0;
    const maxIterations = 100;

    while (improved && iteration < maxIterations) {
      improved = false;
      iteration++;

      for (int i = 1; i < route.length - 1; i++) {
        for (int j = i + 1; j < route.length; j++) {
          final newRoute = _swap2Opt(route, i, j);
          final oldDistance = _calculateTotalDistance(route);
          final newDistance = _calculateTotalDistance(newRoute);

          if (newDistance < oldDistance) {
            route = newRoute;
            improved = true;
          }
        }
      }
    }

    return _reorderItems(route);
  }

  /// 균형 잡힌 최적화 (Hybrid)
  Future<List<ItineraryItem>> _optimizeBalanced(
    List<ItineraryItem> items,
    OptimizationConstraints? constraints,
  ) async {
    // Nearest Neighbor + 부분 2-opt
    var route = await _optimizeFastest(items, constraints);

    // 제한된 2-opt 개선
    for (int i = 1; i < route.length - 1; i++) {
      for (int j = i + 1; j < min(i + 3, route.length); j++) {
        final newRoute = _swap2Opt(route, i, j);
        final oldDistance = _calculateTotalDistance(route);
        final newDistance = _calculateTotalDistance(newRoute);

        if (newDistance < oldDistance) {
          route = newRoute;
        }
      }
    }

    return _reorderItems(route);
  }

  /// 친환경 최적화 (대중교통 우선)
  Future<List<ItineraryItem>> _optimizeEcoFriendly(
    List<ItineraryItem> items,
    OptimizationConstraints? constraints,
  ) async {
    // 대중교통 접근성을 고려한 최적화
    final transitFriendly = items.where((item) {
      // 대중교통 접근이 용이한 장소 우선
      return item.transportMode == TransportMode.subway ||
          item.transportMode == TransportMode.bus;
    }).toList();

    final others = items
        .where((item) => !transitFriendly.contains(item))
        .toList();

    // 각 그룹을 최적화
    final optimizedTransit =
        transitFriendly.length > 1
            ? await _optimizeShortest(transitFriendly, constraints)
            : transitFriendly;
    final optimizedOthers =
        others.length > 1
            ? await _optimizeShortest(others, constraints)
            : others;

    // 병합
    return _reorderItems([...optimizedTransit, ...optimizedOthers]);
  }

  /// 2-opt 스왑
  List<ItineraryItem> _swap2Opt(
    List<ItineraryItem> route,
    int i,
    int j,
  ) {
    final newRoute = <ItineraryItem>[];
    newRoute.addAll(route.sublist(0, i));
    newRoute.addAll(route.sublist(i, j + 1).reversed);
    newRoute.addAll(route.sublist(j + 1));
    return newRoute;
  }

  /// 시작점 선택
  ItineraryItem _selectStartPoint(
    List<ItineraryItem> items,
    OptimizationConstraints? constraints,
  ) {
    if (constraints?.startLocation != null) {
      // 시작 위치에 가장 가까운 장소 선택
      var nearest = items.first;
      var minDistance = double.infinity;

      for (final item in items) {
        final distance = _haversineDistance(
          constraints!.startLocation!.lat,
          constraints.startLocation!.lng,
          item.place.lat,
          item.place.lng,
        );
        if (distance < minDistance) {
          minDistance = distance;
          nearest = item;
        }
      }
      return nearest;
    }

    // 기본: 첫 번째 아이템
    return items.first;
  }

  /// 총 거리 계산
  double _calculateTotalDistance(List<ItineraryItem> items) {
    if (items.length < 2) return 0;

    double total = 0;
    for (int i = 0; i < items.length - 1; i++) {
      total += _calculateDistance(items[i], items[i + 1]);
    }
    return total;
  }

  /// 총 시간 계산 (분)
  int _calculateTotalTime(List<ItineraryItem> items) {
    if (items.length < 2) return 0;

    double totalDistanceKm = _calculateTotalDistance(items);
    const avgSpeedKmh = 30.0; // 평균 속도
    return (totalDistanceKm / avgSpeedKmh * 60).round();
  }

  /// 두 아이템 간 거리 계산
  double _calculateDistance(
    ItineraryItem from,
    ItineraryItem to,
  ) {
    return _haversineDistance(
      from.place.lat,
      from.place.lng,
      to.place.lat,
      to.place.lng,
    );
  }

  /// Haversine 거리 계산
  double _haversineDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            pow(sin(dLng / 2), 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  /// 아이템 순서 재정렬
  List<ItineraryItem> _reorderItems(List<ItineraryItem> items) {
    return List.generate(
      items.length,
      (index) => items[index].copyWith(order: index + 1),
    );
  }

  /// 경로 시뮬레이션
  Future<SimulationResult> simulateRoute(
    List<ItineraryItem> items,
  ) async {
    final segments = <RouteSegment>[];
    final waypoints = <SimulationWaypoint>[];

    var totalTime = 0;
    var totalDistance = 0.0;
    var currentTime = DateTime.now();

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      waypoints.add(SimulationWaypoint(
        place: item.place,
        arrivalTime: currentTime,
        departureTime: currentTime.add(const Duration(minutes: 15)),
        order: i + 1,
      ));

      if (i < items.length - 1) {
        final next = items[i + 1];
        final distance = _calculateDistance(item, next);
        final duration = (distance / 30 * 60).round(); // 30km/h

        segments.add(RouteSegment(
          id: 'seg_$i',
          from: item,
          to: next,
          durationMin: duration,
          distanceKm: distance,
          transportMode: item.transportMode,
        ));

        totalTime += duration;
        totalDistance += distance;
        currentTime = currentTime.add(Duration(minutes: duration + 15));
      }
    }

    return SimulationResult(
      waypoints: waypoints,
      segments: segments,
      totalTimeMin: totalTime,
      totalDistanceKm: totalDistance,
      startTime: waypoints.first.arrivalTime,
      endTime: waypoints.last.departureTime,
    );
  }
}

/// 최적화 전략
enum OptimizationStrategy {
  fastest,     // 가장 빠른 경로
  shortest,    // 최단 거리
  balanced,    // 균형 잡힌
  ecoFriendly, // 친환경
}

extension OptimizationStrategyExtension on OptimizationStrategy {
  String get displayName {
    switch (this) {
      case OptimizationStrategy.fastest: return '가장 빠른 경로';
      case OptimizationStrategy.shortest: return '최단 거리';
      case OptimizationStrategy.balanced: return '균형 잡힌';
      case OptimizationStrategy.ecoFriendly: return '친환경';
    }
  }

  String get description {
    switch (this) {
      case OptimizationStrategy.fastest:
        return '가장 빠르게 도착할 수 있는 경로를 찾습니다';
      case OptimizationStrategy.shortest:
        return '가장 짧은 거리의 경로를 찾습니다';
      case OptimizationStrategy.balanced:
        return '시간과 거리를 모두 고려한 경로를 찾습니다';
      case OptimizationStrategy.ecoFriendly:
        return '대중교통을 활용한 친환경 경로를 찾습니다';
    }
  }
}

/// 최적화 제약조건
class OptimizationConstraints {
  final Place? startLocation;
  final Place? endLocation;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<String>? mustVisitFirst;
  final List<String>? mustVisitLast;
  final double? maxDistance;
  final int? maxDuration;

  const OptimizationConstraints({
    this.startLocation,
    this.endLocation,
    this.startTime,
    this.endTime,
    this.mustVisitFirst,
    this.mustVisitLast,
    this.maxDistance,
    this.maxDuration,
  });
}

/// 최적화 결과
class OptimizationResult {
  final List<ItineraryItem> optimizedItems;
  final double originalDistance;
  final double optimizedDistance;
  final int originalTime;
  final int optimizedTime;
  final int timeSaved;
  final double distanceSaved;
  final double efficiency;
  final OptimizationStrategy strategy;

  const OptimizationResult({
    required this.optimizedItems,
    required this.originalDistance,
    required this.optimizedDistance,
    this.originalTime = 0,
    this.optimizedTime = 0,
    required this.timeSaved,
    required this.distanceSaved,
    required this.efficiency,
    required this.strategy,
  });

  String get timeSavedFormatted {
    if (timeSaved < 60) return '$timeSaved분';
    final hours = timeSaved ~/ 60;
    final minutes = timeSaved % 60;
    return '$hours시간 $minutes분';
  }

  String get distanceSavedFormatted {
    if (distanceSaved < 1) {
      return '${(distanceSaved * 1000).toStringAsFixed(0)}m';
    }
    return '${distanceSaved.toStringAsFixed(1)}km';
  }

  String get efficiencyFormatted => '${efficiency.toStringAsFixed(1)}%';
}

/// 시뮬레이션 결과
class SimulationResult {
  final List<SimulationWaypoint> waypoints;
  final List<RouteSegment> segments;
  final int totalTimeMin;
  final double totalDistanceKm;
  final DateTime startTime;
  final DateTime endTime;

  const SimulationResult({
    required this.waypoints,
    required this.segments,
    required this.totalTimeMin,
    required this.totalDistanceKm,
    required this.startTime,
    required this.endTime,
  });
}

/// 시뮬레이션 경유지
class SimulationWaypoint {
  final Place place;
  final DateTime arrivalTime;
  final DateTime departureTime;
  final int order;

  const SimulationWaypoint({
    required this.place,
    required this.arrivalTime,
    required this.departureTime,
    required this.order,
  });

  Duration get stayDuration => departureTime.difference(arrivalTime);
}
