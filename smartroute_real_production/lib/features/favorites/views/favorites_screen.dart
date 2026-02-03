import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../providers/map_provider.dart';
import '../../../widgets/common/place_card.dart';
import '../../../widgets/common/empty_state.dart';
import '../../map/views/place_detail_screen.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  String _sortBy = 'recent';
  String _filterCategory = 'all';

  final List<String> _categories = ['all', '카페', '식당', '은행', '병원', '쇼핑'];

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        actions: [
          if (favorites.isNotEmpty)
            PopupMenuButton(
              icon: const Icon(Icons.sort_rounded),
              initialValue: _sortBy,
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'recent', child: Text('최근 추가순')),
                const PopupMenuItem(value: 'name', child: Text('이름순')),
                const PopupMenuItem(value: 'rating', child: Text('평점순')),
                const PopupMenuItem(value: 'distance', child: Text('거리순')),
              ],
              onSelected: (value) {
                setState(() {
                  _sortBy = value;
                });
              },
            ),
        ],
      ),
      body: favorites.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border_rounded,
              title: '즐겨찾기가 비어있습니다',
              subtitle: '자주 가는 장소를 즐겨찾기에 추가해보세요',
            )
          : Column(
              children: [
                _buildCategoryFilter(),
                Expanded(
                  child: _buildFavoritesList(favorites),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _filterCategory == category;
          
          return FilterChip(
            label: Text(category == 'all' ? '전체' : category),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _filterCategory = category;
              });
            },
            selectedColor: AppTheme.primary,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesList(List favorites) {
    var filtered = favorites;
    
    if (_filterCategory != 'all') {
      filtered = favorites.where((p) => p.category == _filterCategory).toList();
    }

    if (filtered.isEmpty) {
      return EmptyState(
        icon: Icons.filter_alt_off_rounded,
        title: '해당 카테고리에 즐겨찾기가 없습니다',
        subtitle: '다른 카테고리를 선택해보세요',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final place = filtered[index];
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${place.name} 즐겨찾기 해제')),
            );
          },
        );
      },
    );
  }
}
