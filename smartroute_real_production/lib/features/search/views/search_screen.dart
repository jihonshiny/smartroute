import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/place.dart';
import '../../../providers/map_provider.dart';
import '../../../widgets/common/place_card.dart';
import '../../../widgets/common/empty_state.dart';
import '../../map/views/place_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _recentSearches = [];
  String _selectedCategory = 'all';

  final List<SearchCategory> _categories = [
    SearchCategory('all', '전체', Icons.apps_rounded),
    SearchCategory('cafe', '카페', Icons.local_cafe_rounded),
    SearchCategory('food', '음식점', Icons.restaurant_rounded),
    SearchCategory('bank', '은행', Icons.account_balance_rounded),
    SearchCategory('hospital', '병원', Icons.local_hospital_rounded),
    SearchCategory('pharmacy', '약국', Icons.local_pharmacy_rounded),
    SearchCategory('market', '마트', Icons.shopping_cart_rounded),
    SearchCategory('parking', '주차장', Icons.local_parking_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    setState(() {
      _recentSearches = ['강남역', '스타벅스', '병원', '약국', '우체국'];
    });
  }

  void _addToRecentSearches(String query) {
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.sublist(0, 10);
      }
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    _addToRecentSearches(query);
    ref.read(searchProvider.notifier).search(query);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: '장소, 주소, 키워드 검색',
            border: InputBorder.none,
            suffixIcon: searchState.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchProvider.notifier).clear();
                          setState(() {});
                        },
                      )
                    : null,
          ),
          onSubmitted: _performSearch,
          onChanged: (value) => setState(() {}),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _showFilterBottomSheet(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category.id;
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(category.icon, size: 16, color: isSelected ? Colors.white : AppTheme.primary),
                      const SizedBox(width: 4),
                      Text(category.name),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category.id;
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
          ),
          const Divider(height: 1),
          Expanded(
            child: _buildBody(searchState),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchState state) {
    if (state.query.isEmpty) {
      return _buildRecentSearches();
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return EmptyState(
        icon: Icons.error_outline_rounded,
        title: '오류 발생',
        subtitle: state.error!,
        actionText: '다시 시도',
        onAction: () => ref.read(searchProvider.notifier).search(state.query),
      );
    }

    if (state.results.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: '검색 결과가 없습니다',
        subtitle: '다른 키워드로 검색해보세요',
      );
    }

    return ListView.builder(
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final place = state.results[index];
        return PlaceCard(
          place: place,
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
          },
          isFavorite: ref.read(favoritesProvider.notifier).isFavorite(place.id),
          trailing: IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              // Add to itinerary
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${place.name} 추가됨')),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) {
      return EmptyState(
        icon: Icons.history_rounded,
        title: '최근 검색 내역이 없습니다',
        subtitle: '장소를 검색해보세요',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '최근 검색',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _recentSearches.clear();
                });
              },
              child: const Text('전체 삭제'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._recentSearches.map((query) {
          return ListTile(
            leading: const Icon(Icons.history_rounded, color: Colors.grey),
            title: Text(query),
            trailing: IconButton(
              icon: const Icon(Icons.close_rounded, size: 20),
              onPressed: () {
                setState(() {
                  _recentSearches.remove(query);
                });
              },
            ),
            onTap: () {
              _searchController.text = query;
              _performSearch(query);
            },
          );
        }).toList(),
        const SizedBox(height: 24),
        const Text(
          '추천 장소',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildRecommendationCard(
          '주변 인기 카페',
          '가까운 곳의 평점 높은 카페',
          Icons.local_cafe_rounded,
          Colors.brown,
        ),
        _buildRecommendationCard(
          '주변 병원',
          '가까운 병원 및 약국',
          Icons.local_hospital_rounded,
          Colors.red,
        ),
        _buildRecommendationCard(
          '주변 편의시설',
          '은행, 우체국, 편의점',
          Icons.store_rounded,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          _searchController.text = title;
          _performSearch(title);
        },
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '필터',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('영업 중만 보기'),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('평점 4.0 이상'),
              value: false,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const Text('거리', style: TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: 5,
              min: 1,
              max: 10,
              divisions: 9,
              label: '5km',
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('초기화'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('적용'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class SearchCategory {
  final String id;
  final String name;
  final IconData icon;

  const SearchCategory(this.id, this.name, this.icon);
}
