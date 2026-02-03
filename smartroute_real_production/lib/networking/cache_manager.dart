import 'dart:convert';

class CacheManager {
  final Map<String, CacheEntry> _cache = {};
  final int maxSize;
  final Duration defaultDuration;

  CacheManager({
    this.maxSize = 100,
    this.defaultDuration = const Duration(hours: 1),
  });

  void put<T>(String key, T data, {Duration? duration}) {
    _cache[key] = CacheEntry(
      data: data,
      expiresAt: DateTime.now().add(duration ?? defaultDuration),
    );

    if (_cache.length > maxSize) {
      _evictOldest();
    }
  }

  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    return entry.data as T;
  }

  bool has(String key) {
    return _cache.containsKey(key) && !_cache[key]!.isExpired;
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  void _evictOldest() {
    if (_cache.isEmpty) return;

    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _cache.entries) {
      if (oldestTime == null || entry.value.createdAt.isBefore(oldestTime)) {
        oldestTime = entry.value.createdAt;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      _cache.remove(oldestKey);
    }
  }

  int get size => _cache.length;

  void cleanExpired() {
    _cache.removeWhere((key, value) => value.isExpired);
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime createdAt;
  final DateTime expiresAt;

  CacheEntry({
    required this.data,
    required this.expiresAt,
  }) : createdAt = DateTime.now();

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
