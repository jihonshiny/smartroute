import 'dart:collection';

class CacheService<K, V> {
  final int maxSize;
  final Duration expirationDuration;
  final LinkedHashMap<K, CacheEntry<V>> _cache = LinkedHashMap();

  CacheService({this.maxSize = 100, this.expirationDuration = const Duration(hours: 24)});

  void put(K key, V value) {
    if (_cache.length >= maxSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = CacheEntry(value, DateTime.now().add(expirationDuration));
  }

  V? get(K key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.value;
  }

  void remove(K key) => _cache.remove(key);
  void clear() => _cache.clear();
  bool containsKey(K key) => _cache.containsKey(key) && !_cache[key]!.isExpired;
  int get size => _cache.length;
  List<K> get keys => _cache.keys.toList();
}

class CacheEntry<V> {
  final V value;
  final DateTime expiresAt;
  CacheEntry(this.value, this.expiresAt);
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
