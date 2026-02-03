import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/place.dart';
import '../../../app/theme.dart';
import '../../../providers/map_provider.dart';
import '../../../utils/extensions.dart';

class PlaceDetailScreen extends ConsumerWidget {
  final Place place;

  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(place);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            actions: [
              // 즐겨찾기 버튼
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  if (isFavorite) {
                    ref.read(favoritesProvider.notifier).remove(place);
                    context.showSnackBar('💔 즐겨찾기 제거됨');
                  } else {
                    ref.read(favoritesProvider.notifier).add(place);
                    context.showSnackBar('❤️ 즐겨찾기 추가됨!');
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(place.name),
              background: place.imageUrl != null
                  ? Image.network(place.imageUrl!, fit: BoxFit.cover)
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primary, AppTheme.accent],
                        ),
                      ),
                      child: const Icon(Icons.place, size: 80, color: Colors.white),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (place.category != null) _buildCategoryChip(place.category!),
                  const SizedBox(height: 16),
                  if (place.rating != null) _buildRatingRow(place.rating!, place.reviewCount),
                  const SizedBox(height: 24),
                  _buildInfoSection(
                    icon: Icons.location_on_rounded,
                    title: '주소',
                    content: place.address,
                  ),
                  if (place.phone != null)
                    _buildInfoSection(
                      icon: Icons.phone_rounded,
                      title: '전화번호',
                      content: place.phone!,
                    ),
                  if (place.openingHours != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      '영업시간',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...place.openingHours!.entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key),
                              Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )),
                  ],
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.phone_rounded),
                          label: const Text('전화'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('공유'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.navigation_rounded),
                      label: const Text('길찾기'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.accent,
        ),
      ),
    );
  }

  Widget _buildRatingRow(double rating, int? reviewCount) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor() ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 24,
          );
        }),
        const SizedBox(width: 8),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (reviewCount != null)
          Text(
            ' ($reviewCount 리뷰)',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
      ],
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
