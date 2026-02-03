import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/map_provider.dart';
import '../../../providers/itinerary_provider.dart';
import '../../../widgets/common/place_card.dart';
import '../../../widgets/common/empty_state.dart';
import '../../../utils/extensions.dart';
import 'place_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('즐겨찾기 전체 삭제'),
                    content: const Text('모든 즐겨찾기를 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('취소'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('삭제'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  ref.read(favoritesProvider.notifier).clear();
                  if (context.mounted) {
                    context.showSnackBar('🗑️ 모든 즐겨찾기 삭제됨');
                  }
                }
              },
            ),
        ],
      ),
      body: favorites.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border_rounded,
              title: '즐겨찾기가 없습니다',
              subtitle: '자주 가는 장소를 즐겨찾기에 추가하세요',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final place = favorites[index];
                return PlaceCard(
                  place: place,
                  isFavorite: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailScreen(place: place),
                      ),
                    );
                  },
                  onFavorite: () {
                    ref.read(favoritesProvider.notifier).toggle(place);
                    context.showSnackBar('💔 즐겨찾기 제거됨');
                  },
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'add_itinerary',
                        child: Row(
                          children: [
                            Icon(Icons.add_circle_outline),
                            SizedBox(width: 8),
                            Text('일정에 추가'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'directions',
                        child: Row(
                          children: [
                            Icon(Icons.directions_rounded),
                            SizedBox(width: 8),
                            Text('길찾기'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share_rounded),
                            SizedBox(width: 8),
                            Text('공유'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      switch (value) {
                        case 'add_itinerary':
                          await ref.read(itineraryProvider.notifier).addPlace(place);
                          if (context.mounted) {
                            context.showSnackBar('✅ ${place.name} 일정에 추가됨!');
                          }
                          break;
                        case 'directions':
                          // TODO: 길찾기 기능 구현
                          context.showSnackBar('길찾기 기능 준비중입니다');
                          break;
                        case 'share':
                          // TODO: 공유 기능 구현
                          context.showSnackBar('공유 기능 준비중입니다');
                          break;
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
