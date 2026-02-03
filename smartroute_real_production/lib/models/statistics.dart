class DailyStatistics {
  final DateTime date;
  final int placesVisited;
  final double totalDistanceKm;
  final int totalDurationMin;
  final int completedTasks;
  final Map<String, int> categoryCounts;

  const DailyStatistics({
    required this.date,
    required this.placesVisited,
    required this.totalDistanceKm,
    required this.totalDurationMin,
    required this.completedTasks,
    required this.categoryCounts,
  });
}

class WeeklyStatistics {
  final DateTime weekStart;
  final List<DailyStatistics> dailyStats;
  final int totalPlacesVisited;
  final double avgDistancePerDay;
  final String mostVisitedCategory;

  const WeeklyStatistics({
    required this.weekStart,
    required this.dailyStats,
    required this.totalPlacesVisited,
    required this.avgDistancePerDay,
    required this.mostVisitedCategory,
  });
}
