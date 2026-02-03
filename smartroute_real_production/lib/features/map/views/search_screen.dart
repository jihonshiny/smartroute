import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/place.dart';
import '../../../providers/map_provider.dart';
import '../../../providers/itinerary_provider.dart';
import '../../../app/theme.dart';
import '../../../utils/extensions.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  
  final List<String> _categories = [
    '카페', '식당', '은행', '병원', '약국', '편의점', '주차장', '주유소',
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    ref.read(searchProvider.notifier).search(query);
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
            hintText: '장소, 주소, 카테고리 검색...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchProvider.notifier).clear();
                      setState(() {});
                    },
                  )
                : null,
          ),
          textInputAction: TextInputAction.search,
          onChanged: (value) => setState(() {}),
          onSubmitted: _performSearch,
        ),
      ),
      body: _buildBody(searchState),
    );
  }

  Widget _buildBody(SearchState searchState) {
    if (searchState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(searchState.error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _performSearch(searchState.query),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (searchState.query.isNotEmpty && searchState.results.isNotEmpty) {
      return _buildSearchResults(searchState.results);
    }

    if (searchState.query.isNotEmpty && searchState.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '"${searchState.query}"에 대한\n결과가 없습니다',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return _buildSearchSuggestions();
  }

  Widget _buildSearchResults(List<Place> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '검색 결과 ${results.length}개',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final place = results[index];
              final isFavorite = ref.watch(favoritesProvider).contains(place);
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.place_rounded, color: AppTheme.primary),
                  ),
                  title: Text(
                    place.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(place.address),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 즐겨찾기 버튼
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
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
                      // 일정 추가 버튼
                      IconButton(
                        icon: const Icon(Icons.add_circle_rounded, color: AppTheme.primary),
                        onPressed: () async {
                          await ref.read(itineraryProvider.notifier).addPlace(place);
                          if (context.mounted) {
                            context.showSnackBar('✅ ${place.name} 추가됨!');
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // 상세 화면으로 이동
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '카테고리',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            return ActionChip(
              label: Text(category),
              avatar: const Icon(Icons.category_rounded, size: 18),
              onPressed: () {
                _searchController.text = category;
                _performSearch(category);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text(
          '추천 장소',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._getSuggestedPlaces().map((place) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.place_rounded, color: AppTheme.primary),
              ),
              title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(place.address),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle_rounded, color: AppTheme.primary),
                onPressed: () async {
                  await ref.read(itineraryProvider.notifier).addPlace(place);
                  if (context.mounted) {
                    context.showSnackBar('✅ ${place.name} 추가됨!');
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  List<Place> _getSuggestedPlaces() {
    return [
      Place(
        id: 'suggest_1',
        name: '스타벅스 강남역점',
        address: '서울시 강남구 강남대로 396',
        lat: 37.4979,
        lng: 127.0276,
        category: '카페',
      ),
      Place(
        id: 'suggest_2',
        name: '신세계백화점 강남점',
        address: '서울시 서초구 신반포로 176',
        lat: 37.5048,
        lng: 127.0047,
        category: '쇼핑',
      ),
      Place(
        id: 'suggest_3',
        name: '코엑스몰',
        address: '서울시 강남구 영동대로 513',
        lat: 37.5115,
        lng: 127.0590,
        category: '쇼핑',
      ),
    ];
  }
}
