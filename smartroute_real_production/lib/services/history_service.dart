import '../models/visit_history.dart';
import '../models/place.dart';

class HistoryService {
  final List<VisitHistory> _history = [];

  Future<List<VisitHistory>> getHistory({int? limit, DateTime? after, DateTime? before}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    var filtered = List<VisitHistory>.from(_history);
    
    if (after != null) {
      filtered = filtered.where((h) => h.visitedAt.isAfter(after)).toList();
    }
    
    if (before != null) {
      filtered = filtered.where((h) => h.visitedAt.isBefore(before)).toList();
    }
    
    filtered.sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
    
    if (limit != null && filtered.length > limit) {
      filtered = filtered.sublist(0, limit);
    }
    
    return filtered;
  }

  Future<List<VisitHistory>> getTodayHistory() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return getHistory(after: startOfDay);
  }

  Future<List<VisitHistory>> getThisWeekHistory() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return getHistory(after: startOfWeek);
  }

  Future<Map<String, int>> getCategoryStats() async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final stats = <String, int>{};
    for (final history in _history) {
      final category = history.place.category ?? '기타';
      stats[category] = (stats[category] ?? 0) + 1;
    }
    
    return stats;
  }

  Future<void> addHistory(VisitHistory history) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _history.add(history);
  }

  Future<void> updateHistory(VisitHistory history) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _history.indexWhere((h) => h.id == history.id);
    if (index != -1) {
      _history[index] = history;
    }
  }

  Future<void> deleteHistory(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _history.removeWhere((h) => h.id == id);
  }

  Future<void> clearHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _history.clear();
  }
}
