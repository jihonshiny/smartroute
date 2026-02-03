import '../models/place.dart';

class RecommendationService {
  Future<List<Place>> getRecommendations({
    required double lat,
    required double lng,
    String? category,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return [];
  }

  Future<List<Place>> getTrendingPlaces() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  Future<List<Place>> getPersonalizedRecommendations(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [];
  }

  Future<List<Place>> getSimilarPlaces(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [];
  }
}
