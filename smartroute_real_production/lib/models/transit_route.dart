class TransitRoute {
  final int totalTime; // 총 소요 시간 (분)
  final double totalDistance; // 총 거리 (미터)
  final int totalFare; // 총 요금 (원)
  final int transferCount; // 환승 횟수
  final List<TransitStep> steps; // 이동 단계

  TransitRoute({
    required this.totalTime,
    required this.totalDistance,
    required this.totalFare,
    required this.transferCount,
    required this.steps,
  });

  // 소요 시간을 "XX분" 형식으로 반환
  String get formattedTime {
    if (totalTime < 60) {
      return '$totalTime분';
    } else {
      final hours = totalTime ~/ 60;
      final minutes = totalTime % 60;
      return '$hours시간 $minutes분';
    }
  }

  // 거리를 "X.X km" 형식으로 반환
  String get formattedDistance {
    if (totalDistance < 1000) {
      return '${totalDistance.toInt()}m';
    } else {
      return '${(totalDistance / 1000).toStringAsFixed(1)}km';
    }
  }

  // 요금을 "X,XXX원" 형식으로 반환
  String get formattedFare {
    return '${totalFare.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}원';
  }

  // 환승 정보 반환
  String get transferInfo {
    if (transferCount == 0) {
      return '환승 없음';
    } else {
      return '환승 $transferCount회';
    }
  }

  factory TransitRoute.fromJson(Map<String, dynamic> json) {
    final info = json['info'];
    final subPath = json['subPath'] as List? ?? [];

    return TransitRoute(
      totalTime: info['totalTime'] ?? 0,
      totalDistance: (info['totalDistance'] ?? 0).toDouble(),
      totalFare: info['payment'] ?? 0,
      transferCount: (info['busTransitCount'] ?? 0) + (info['subwayTransitCount'] ?? 0),
      steps: subPath
          .map((step) => TransitStep.fromJson(step))
          .toList(),
    );
  }
}

class TransitStep {
  final String type; // 'subway', 'bus', 'walk'
  final String name; // 노선명 (예: "2호선", "150번")
  final String startStation; // 출발 정류장/역
  final String endStation; // 도착 정류장/역
  final int stationCount; // 정류장 개수
  final double distance; // 거리 (미터)
  final int time; // 소요 시간 (분)

  TransitStep({
    required this.type,
    required this.name,
    required this.startStation,
    required this.endStation,
    required this.stationCount,
    required this.distance,
    required this.time,
  });

  // 아이콘 이름 반환
  String get iconName {
    switch (type) {
      case 'subway':
        return 'subway';
      case 'bus':
        return 'directions_bus';
      case 'walk':
        return 'directions_walk';
      default:
        return 'help_outline';
    }
  }

  // 표시할 텍스트
  String get displayText {
    switch (type) {
      case 'subway':
        return '$name ($startStation → $endStation)';
      case 'bus':
        return '$name ($startStation → $endStation)';
      case 'walk':
        return '도보 이동';
      default:
        return '이동';
    }
  }

  // 상세 정보
  String get detailText {
    if (type == 'walk') {
      return '${(distance / 1000).toStringAsFixed(1)}km · $time분';
    } else {
      return '$stationCount개 정류장 · $time분';
    }
  }

  factory TransitStep.fromJson(Map<String, dynamic> json) {
    String type = 'unknown';
    switch (json['trafficType']) {
      case 1:
        type = 'subway';
        break;
      case 2:
        type = 'bus';
        break;
      case 3:
        type = 'walk';
        break;
    }

    String name = '';
    if (json['lane'] != null && json['lane'].isNotEmpty) {
      name = json['lane'][0]['name'] ?? '';
    }

    return TransitStep(
      type: type,
      name: name,
      startStation: json['startName'] ?? '',
      endStation: json['endName'] ?? '',
      stationCount: json['stationCount'] ?? 0,
      distance: (json['distance'] ?? 0).toDouble(),
      time: json['sectionTime'] ?? 0,
    );
  }
}
