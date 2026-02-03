import '../models/review.dart';

class ReviewService {
  final List<Review> _reviews = [];

  Future<List<Review>> getPlaceReviews(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _reviews.where((r) => r.placeId == placeId).toList();
  }

  Future<List<Review>> getMyReviews() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reviews;
  }

  Future<Review> createReview(Review review) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _reviews.add(review);
    return review;
  }

  Future<void> updateReview(Review review) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _reviews.indexWhere((r) => r.id == review.id);
    if (index != -1) {
      _reviews[index] = review;
    }
  }

  Future<void> deleteReview(String reviewId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _reviews.removeWhere((r) => r.id == reviewId);
  }

  Future<void> markHelpful(String reviewId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      _reviews[index] = _reviews[index].copyWith(
        helpfulCount: _reviews[index].helpfulCount + 1,
        isHelpful: true,
      );
    }
  }
}
