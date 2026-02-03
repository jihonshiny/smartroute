import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/review.dart';
import '../../../models/place.dart';
import '../../../services/review_service.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/common/empty_state.dart';

final reviewServiceProvider = Provider((ref) => ReviewService());

final placeReviewsProvider = FutureProviderFamily<List<Review>, String>((ref, placeId) async {
  final service = ref.watch(reviewServiceProvider);
  return await service.getPlaceReviews(placeId);
});

final myReviewsProvider = FutureProvider<List<Review>>((ref) async {
  final service = ref.watch(reviewServiceProvider);
  return await service.getMyReviews();
});

class PlaceReviewScreen extends ConsumerStatefulWidget {
  final Place place;

  const PlaceReviewScreen({super.key, required this.place});

  @override
  ConsumerState<PlaceReviewScreen> createState() => _PlaceReviewScreenState();
}

class _PlaceReviewScreenState extends ConsumerState<PlaceReviewScreen> {
  String _sortBy = 'recent';

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(placeReviewsProvider(widget.place.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('리뷰'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.sort_rounded),
            initialValue: _sortBy,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'recent', child: Text('최신순')),
              const PopupMenuItem(value: 'rating_high', child: Text('평점 높은순')),
              const PopupMenuItem(value: 'rating_low', child: Text('평점 낮은순')),
              const PopupMenuItem(value: 'helpful', child: Text('도움순')),
            ],
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
          ),
        ],
      ),
      body: reviewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류: $error')),
        data: (reviews) {
          if (reviews.isEmpty) {
            return EmptyState(
              icon: Icons.rate_review_rounded,
              title: '아직 리뷰가 없습니다',
              subtitle: '첫 리뷰를 작성해보세요',
              actionText: '리뷰 작성',
              onAction: () => _showWriteReview(null),
            );
          }

          final sortedReviews = _sortReviews(reviews);

          return Column(
            children: [
              _buildSummaryCard(reviews),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedReviews.length,
                  itemBuilder: (context, index) {
                    return _buildReviewCard(sortedReviews[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showWriteReview(null),
        icon: const Icon(Icons.edit_rounded),
        label: const Text('리뷰 작성'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  Widget _buildSummaryCard(List<Review> reviews) {
    final avgRating = reviews.fold<double>(0, (sum, r) => sum + r.rating) / reviews.length;
    final ratingCounts = _getRatingCounts(reviews);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < avgRating.floor() ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${reviews.length}개 리뷰',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      final rating = 5 - index;
                      final count = ratingCounts[rating] ?? 0;
                      final percentage = reviews.isEmpty ? 0.0 : count / reviews.length;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text('$rating', style: const TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            const Icon(Icons.star, size: 12, color: Colors.amber),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentage,
                                backgroundColor: Colors.grey[200],
                                color: Colors.amber,
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$count',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                  backgroundImage: review.userPhotoUrl != null
                      ? NetworkImage(review.userPhotoUrl!)
                      : null,
                  child: review.userPhotoUrl == null
                      ? Text(
                          review.userName[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < review.rating.floor() ? Icons.star : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            DateTimeUtils.formatRelative(review.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('수정')),
                    const PopupMenuItem(value: 'delete', child: Text('삭제')),
                    const PopupMenuItem(value: 'report', child: Text('신고')),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showWriteReview(review);
                    } else if (value == 'delete') {
                      _confirmDelete(review);
                    }
                  },
                ),
              ],
            ),
            if (review.comment != null) ...[
              const SizedBox(height: 12),
              Text(
                review.comment!,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
            if (review.photos?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.photos!.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        review.photos![index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
            if (review.tags?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: review.tags!.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () async {
                    await ref.read(reviewServiceProvider).markHelpful(review.id);
                    ref.invalidate(placeReviewsProvider(widget.place.id));
                  },
                  icon: Icon(
                    review.isHelpful ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 18,
                  ),
                  label: Text('도움돼요 ${review.helpfulCount}'),
                  style: TextButton.styleFrom(
                    foregroundColor: review.isHelpful ? AppTheme.primary : Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.comment_outlined, size: 18),
                  label: const Text('댓글'),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Review> _sortReviews(List<Review> reviews) {
    final sorted = List<Review>.from(reviews);
    
    switch (_sortBy) {
      case 'recent':
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'rating_high':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'rating_low':
        sorted.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case 'helpful':
        sorted.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
        break;
    }
    
    return sorted;
  }

  Map<int, int> _getRatingCounts(List<Review> reviews) {
    final counts = <int, int>{};
    for (final review in reviews) {
      final rating = review.rating.floor();
      counts[rating] = (counts[rating] ?? 0) + 1;
    }
    return counts;
  }

  void _showWriteReview(Review? existingReview) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteReviewScreen(
          place: widget.place,
          existingReview: existingReview,
        ),
      ),
    );
  }

  void _confirmDelete(Review review) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('리뷰 삭제'),
        content: const Text('이 리뷰를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(reviewServiceProvider).deleteReview(review.id);
      ref.invalidate(placeReviewsProvider(widget.place.id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('리뷰가 삭제되었습니다')),
      );
    }
  }
}

class WriteReviewScreen extends StatefulWidget {
  final Place place;
  final Review? existingReview;

  const WriteReviewScreen({
    super.key,
    required this.place,
    this.existingReview,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _commentController = TextEditingController();
  double _rating = 5.0;
  final List<String> _selectedTags = [];
  bool _isSubmitting = false;

  final List<String> _availableTags = [
    '깨끗해요',
    '친절해요',
    '맛있어요',
    '빨라요',
    '저렴해요',
    '주차편해요',
    '조용해요',
    '넓어요',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _rating = widget.existingReview!.rating;
      _commentController.text = widget.existingReview!.comment ?? '';
      _selectedTags.addAll(widget.existingReview!.tags);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingReview == null ? '리뷰 작성' : '리뷰 수정'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.place_rounded, color: AppTheme.primary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.place.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.place.address,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '평점',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating.floor() ? Icons.star : Icons.star_border,
                        size: 40,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = (index + 1).toDouble();
                        });
                      },
                    );
                  }),
                ),
                Text(
                  _rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '리뷰',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 6,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: '이 장소에 대한 경험을 공유해주세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '태그',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
                selectedColor: AppTheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitReview,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(widget.existingReview == null ? '등록' : '수정'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('리뷰 내용을 입력해주세요')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Submit review logic here

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existingReview == null ? '리뷰가 등록되었습니다' : '리뷰가 수정되었습니다'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
