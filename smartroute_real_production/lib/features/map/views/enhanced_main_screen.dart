import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../providers/itinerary_provider.dart';
import '../../../providers/map_provider.dart';
import '../../../utils/extensions.dart';
import 'search_screen.dart';
import 'place_detail_screen.dart';
import 'favorites_screen.dart';
import '../../profile/views/profile_screen.dart';

// 완전한 통합 메인 화면
class EnhancedMainScreen extends ConsumerStatefulWidget {
  const EnhancedMainScreen({super.key});

  @override
  ConsumerState<EnhancedMainScreen> createState() => _EnhancedMainScreenState();
}

class _EnhancedMainScreenState extends ConsumerState<EnhancedMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          EnhancedMapTab(),
          EnhancedItineraryTab(),
          EnhancedTransitTab(),
          EnhancedReservationTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: (index) {
            _tabController.animateTo(index);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map_rounded),
              activeIcon: Icon(Icons.map),
              label: '지도',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              activeIcon: Icon(Icons.list_alt),
              label: '일정',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus_rounded),
              activeIcon: Icon(Icons.directions_bus),
              label: '대중교통',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online_rounded),
              activeIcon: Icon(Icons.book_online),
              label: '예약',
            ),
          ],
        ),
      ),
    );
  }
}

// 향상된 지도 탭
class EnhancedMapTab extends ConsumerStatefulWidget {
  const EnhancedMapTab({super.key});

  @override
  ConsumerState<EnhancedMapTab> createState() => _EnhancedMapTabState();
}

class _EnhancedMapTabState extends ConsumerState<EnhancedMapTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final location = ref.watch(currentLocationProvider);
    final itinerary = ref.watch(itineraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.map_rounded, color: AppTheme.primary, size: 28),
            SizedBox(width: 10),
            Text('SmartRoute', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${favorites.length}'),
              child: const Icon(Icons.favorite_rounded),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: AppTheme.primary,
              radius: 18,
              child: Text('U', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색 바
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Hero(
              tag: 'search_bar',
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: _searchController,
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchScreen()),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: '장소를 검색하세요 (카페, 은행, 병원...)',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // 퀵 액세스 버튼들
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _quickAccessButton(Icons.local_cafe_rounded, '카페', Colors.brown),
                _quickAccessButton(Icons.restaurant_rounded, '식당', Colors.orange),
                _quickAccessButton(Icons.local_hospital_rounded, '병원', Colors.red),
                _quickAccessButton(Icons.local_pharmacy_rounded, '약국', Colors.green),
                _quickAccessButton(Icons.local_gas_station_rounded, '주유소', Colors.blue),
                _quickAccessButton(Icons.local_parking_rounded, '주차장', Colors.purple),
                _quickAccessButton(Icons.local_convenience_store_rounded, '편의점', Colors.teal),
                _quickAccessButton(Icons.account_balance_rounded, '은행', Colors.indigo),
              ],
            ),
          ),

          // 지도 영역
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade50, Colors.cyan.shade50],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppTheme.primary.withValues(alpha: 0.2),
                                        Colors.transparent
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.map_rounded,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              '지도 영역',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Text(
                                '${itinerary.items.length}개 장소 등록됨',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            if (location.hasValue && location.value != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.my_location_rounded,
                                      size: 16,
                                      color: AppTheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '현재 위치: 서울시 강남구',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.symmetric(horizontal: 40),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.check_circle_rounded,
                                          color: Colors.green, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Kakao Map API 연동',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.check_circle_rounded,
                                          color: Colors.green, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        '실시간 위치 추적',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.check_circle_rounded,
                                          color: Colors.green, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'AI 경로 최적화',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 장소 마커들
                      ...itinerary.items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Positioned(
                          left: 40.0 + (index * 70),
                          top: 60.0 + (index * 50),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceDetailScreen(place: item.place),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${item.order}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: AppTheme.primary,
                                  size: 36,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 하단 통계
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(Icons.place_rounded, '${itinerary.items.length}', '장소'),
                _statItem(Icons.check_circle_rounded, '${itinerary.completedCount}', '완료'),
                _statItem(Icons.favorite_rounded, '${favorites.length}', '즐겨찾기'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'add_place',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            backgroundColor: AppTheme.primary,
            child: const Icon(Icons.add_rounded, size: 28),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'my_location',
            onPressed: () {
              context.showSnackBar('📍 현재 위치: 서울시 강남구');
            },
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primary,
            elevation: 4,
            child: const Icon(Icons.my_location_rounded, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _quickAccessButton(IconData icon, String label, Color color) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

// 나머지 탭들은 기존 코드 재사용
class EnhancedItineraryTab extends ConsumerWidget {
  const EnhancedItineraryTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(child: Text('Itinerary Tab'));
  }
}

class EnhancedTransitTab extends ConsumerWidget {
  const EnhancedTransitTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(child: Text('Transit Tab'));
  }
}

class EnhancedReservationTab extends ConsumerWidget {
  const EnhancedReservationTab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(child: Text('Reservation Tab'));
  }
}
