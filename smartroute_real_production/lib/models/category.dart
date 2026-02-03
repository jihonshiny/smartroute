import 'place.dart';

enum PlaceCategory {
  cafe, restaurant, bank, hospital, pharmacy, convenience, parking, gasStation,
  hotel, shopping, entertainment, education, gym, beauty, government, other
}

extension PlaceCategoryExtension on PlaceCategory {
  String get displayName {
    switch (this) {
      case PlaceCategory.cafe: return '카페';
      case PlaceCategory.restaurant: return '식당';
      case PlaceCategory.bank: return '은행';
      case PlaceCategory.hospital: return '병원';
      case PlaceCategory.pharmacy: return '약국';
      case PlaceCategory.convenience: return '편의점';
      case PlaceCategory.parking: return '주차장';
      case PlaceCategory.gasStation: return '주유소';
      case PlaceCategory.hotel: return '숙박';
      case PlaceCategory.shopping: return '쇼핑';
      case PlaceCategory.entertainment: return '엔터테인먼트';
      case PlaceCategory.education: return '교육';
      case PlaceCategory.gym: return '운동';
      case PlaceCategory.beauty: return '미용';
      case PlaceCategory.government: return '관공서';
      case PlaceCategory.other: return '기타';
    }
  }

  String get icon {
    switch (this) {
      case PlaceCategory.cafe: return '☕';
      case PlaceCategory.restaurant: return '🍴';
      case PlaceCategory.bank: return '🏦';
      case PlaceCategory.hospital: return '🏥';
      case PlaceCategory.pharmacy: return '💊';
      case PlaceCategory.convenience: return '🏪';
      case PlaceCategory.parking: return '🅿️';
      case PlaceCategory.gasStation: return '⛽';
      case PlaceCategory.hotel: return '🏨';
      case PlaceCategory.shopping: return '🛍️';
      case PlaceCategory.entertainment: return '🎬';
      case PlaceCategory.education: return '📚';
      case PlaceCategory.gym: return '💪';
      case PlaceCategory.beauty: return '💇';
      case PlaceCategory.government: return '🏛️';
      case PlaceCategory.other: return '📍';
    }
  }

  int get colorCode {
    switch (this) {
      case PlaceCategory.cafe: return 0xFF795548;
      case PlaceCategory.restaurant: return 0xFFFF9800;
      case PlaceCategory.bank: return 0xFF2196F3;
      case PlaceCategory.hospital: return 0xFFF44336;
      case PlaceCategory.pharmacy: return 0xFF4CAF50;
      case PlaceCategory.convenience: return 0xFF00BCD4;
      case PlaceCategory.parking: return 0xFF9C27B0;
      case PlaceCategory.gasStation: return 0xFFFF5722;
      case PlaceCategory.hotel: return 0xFF673AB7;
      case PlaceCategory.shopping: return 0xFFE91E63;
      case PlaceCategory.entertainment: return 0xFF3F51B5;
      case PlaceCategory.education: return 0xFF009688;
      case PlaceCategory.gym: return 0xFFFF5722;
      case PlaceCategory.beauty: return 0xFFE91E63;
      case PlaceCategory.government: return 0xFF607D8B;
      case PlaceCategory.other: return 0xFF9E9E9E;
    }
  }
}

class CategoryFilter {
  final Set<PlaceCategory> selectedCategories;
  final double? minRating;
  final double? maxDistance;
  final bool openNow;

  const CategoryFilter({
    this.selectedCategories = const {},
    this.minRating,
    this.maxDistance,
    this.openNow = false,
  });

  bool matches(Place place) {
    if (selectedCategories.isNotEmpty && place.category != null) {
      // Implementation
    }
    if (minRating != null && place.rating != null && place.rating! < minRating!) {
      return false;
    }
    return true;
  }
}
