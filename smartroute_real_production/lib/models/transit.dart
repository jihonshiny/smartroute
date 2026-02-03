enum TransitType { walk, bus, subway, train }

class TransitRoute {
  final String id;
  final String name;
  final List<TransitStep> steps;
  final int totalDurationMin;
  final int totalFare;
  final int transferCount;
  final DateTime departureTime;
  final DateTime arrivalTime;

  const TransitRoute({
    required this.id,
    required this.name,
    required this.steps,
    required this.totalDurationMin,
    required this.totalFare,
    required this.transferCount,
    required this.departureTime,
    required this.arrivalTime,
  });
}

class TransitStep {
  final String id;
  final TransitType type;
  final String? lineName;
  final String? lineColor;
  final String fromStation;
  final String toStation;
  final int durationMin;
  final int stationCount;
  final int fare;

  const TransitStep({
    required this.id,
    required this.type,
    this.lineName,
    this.lineColor,
    required this.fromStation,
    required this.toStation,
    required this.durationMin,
    required this.stationCount,
    this.fare = 0,
  });
}
