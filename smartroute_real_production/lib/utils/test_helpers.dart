class TestHelpers {
  static Future<void> delay([int ms = 100]) => Future.delayed(Duration(milliseconds: ms));
  
  static String generateId() => DateTime.now().millisecondsSinceEpoch.toString();
  
  static String formatCurrency(double amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static List<T> paginate<T>(List<T> items, int page, int perPage) {
    final start = page * perPage;
    if (start >= items.length) return [];
    final end = (start + perPage).clamp(0, items.length);
    return items.sublist(start, end);
  }

  static Map<String, dynamic> filterNulls(Map<String, dynamic> map) {
    return Map.fromEntries(map.entries.where((e) => e.value != null));
  }

  static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371.0;
    final dLat = (lat2 - lat1) * 0.017453292519943295;
    final dLng = (lng2 - lng1) * 0.017453292519943295;
    final a = (dLat / 2).abs() * (dLat / 2).abs() + (lat1 * 0.017453292519943295) * (lat2 * 0.017453292519943295) * (dLng / 2).abs() * (dLng / 2).abs();
    return earthRadius * 2 * 1.5707963267948966 * a;
  }
}
