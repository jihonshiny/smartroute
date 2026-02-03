import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../app/theme.dart';
import '../../../models/itinerary_item.dart';
import '../../../models/place.dart';
import '../../../providers/itinerary_provider.dart';
import '../../../providers/map_provider.dart';
import '../../../providers/transit_provider.dart';
import '../../../providers/reservation_provider.dart';
import '../../../utils/extensions.dart';
import 'search_screen.dart';
import 'place_detail_screen.dart';
import 'favorites_screen.dart';
import 'add_reservation_screen.dart';
import 'my_tab.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
          MapTab(),
          ItineraryTab(),
          TransitTab(),
          ReservationTab(),
          MyTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _tabController.index,
          onTap: (index) {
            setState(() {
              _tabController.animateTo(index);
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map_rounded),
              label: '지도',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              label: '일정',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus_rounded),
              label: '대중교통',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online_rounded),
              label: '예약',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'My',
            ),
          ],
        ),
      ),
    );
  }
}

// 지도 탭
class MapTab extends ConsumerStatefulWidget {
  const MapTab({super.key});

  @override
  ConsumerState<MapTab> createState() => _MapTabState();
}

class _MapTabState extends ConsumerState<MapTab> {
  late final WebViewController _controller;
  bool _isMapLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isMapLoaded = true;
            });
            _addMarkersForItinerary();
          },
        ),
      )
      ..loadFlutterAsset('assets/kakao_map.html');
  }

  void _addMarkersForItinerary() {
    final itinerary = ref.read(itineraryProvider);
    for (var i = 0; i < itinerary.items.length; i++) {
      final item = itinerary.items[i];
      _controller.runJavaScript(
        'window.addMarker(${item.place.lat}, ${item.place.lng}, "${item.place.name}", ${i + 1});',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itinerary = ref.watch(itineraryProvider);
    final favorites = ref.watch(favoritesProvider);

    // 일정이 변경되면 마커 업데이트
    ref.listen(itineraryProvider, (previous, next) {
      if (_isMapLoaded) {
        // AI 최적화가 적용되었는지 확인
        final wasOptimized = previous?.isOptimized == false && next.isOptimized == true;
        
        if (wasOptimized && previous != null && next.items.length >= 2) {
          // Before order
          final beforeOrder = List.generate(previous.items.length, (i) => i);
          // After order
          final afterOrder = List.generate(next.items.length, (i) => i);
          
          // 먼저 기존 마커들을 표시
          _controller.runJavaScript('window.clearMarkers();');
          _addMarkersForItinerary();
          
          // 최적화 애니메이션 표시
          _controller.runJavaScript(
            'window.showOptimization(${beforeOrder.toString()}, ${afterOrder.toString()});'
          );
        } else {
          _controller.runJavaScript('window.clearMarkers();');
          _addMarkersForItinerary();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartRoute', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${favorites.length}'),
              child: const Icon(Icons.favorite_rounded),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색바
          Padding(
            padding: const EdgeInsets.all(16),
            child: Hero(
              tag: 'search_bar',
              child: Material(
                child: TextField(
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchScreen()),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: '장소를 검색하세요...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 카카오 지도
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (!_isMapLoaded)
                    Container(
                      color: Colors.white,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('카카오 지도 로딩중...'),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 일정 요약 - 장소 목록 표시
          if (itinerary.items.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${itinerary.items.length}개 장소',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.location_on,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 장소 목록
                  ...itinerary.items.take(3).map((item) {
                    final index = itinerary.items.indexOf(item) + 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$index',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.place.name,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  if (itinerary.items.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '외 ${itinerary.items.length - 3}개 장소',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add_location_alt, color: Colors.white),
      ),
    );
  }
}

// 일정 탭
class ItineraryTab extends ConsumerWidget {
  const ItineraryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(itineraryProvider);
    final stats = ref.watch(currentDayStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('일정', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 통계 카드
                if (state.isOptimized && state.currentRoute != null)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade50, Colors.green.shade100],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.auto_awesome, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'AI 최적화 완료!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat(
                              Icons.access_time_rounded,
                              '${state.currentRoute!.timeSavings}분 절약',
                            ),
                            _buildStat(
                              Icons.straighten_rounded,
                              '${state.currentRoute!.costSavings?.toStringAsFixed(1)}km 단축',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // 일정 목록
                Expanded(
                  child: state.items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.list_alt_rounded, size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              const Text(
                                '일정이 없습니다',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '지도 탭에서 장소를 추가하세요',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ReorderableListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.items.length,
                          onReorder: (oldIndex, newIndex) async {
                            await ref.read(itineraryProvider.notifier).reorderItems(oldIndex, newIndex);
                          },
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return _buildItineraryCard(context, ref, item, key: ValueKey(item.id));
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: state.items.length >= 2 && !state.isOptimized
          ? FloatingActionButton.extended(
              onPressed: () async {
                await ref.read(itineraryProvider.notifier).optimizeRoute();
                if (context.mounted) {
                  context.showSnackBar('✨ AI 최적화 완료!');
                }
              },
              backgroundColor: AppTheme.accent,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('AI 최적화'),
            )
          : null,
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildItineraryCard(BuildContext context, WidgetRef ref, ItineraryItem item, {required Key key}) {
    final isFavorite = ref.watch(favoritesProvider).contains(item.place);
    
    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item.completed ? Colors.green : AppTheme.primary,
          child: item.completed
              ? const Icon(Icons.check, color: Colors.white)
              : Text(
                  '${item.order}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
        title: Text(
          item.place.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: item.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(item.place.address),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'favorite',
              child: Row(
                children: [
                  Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  const SizedBox(width: 8),
                  Text(isFavorite ? '즐겨찾기 제거' : '즐겨찾기 추가'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'complete',
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded),
                  SizedBox(width: 8),
                  Text('완료'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, color: Colors.red),
                  SizedBox(width: 8),
                  Text('삭제', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'favorite') {
              if (isFavorite) {
                ref.read(favoritesProvider.notifier).remove(item.place);
                if (context.mounted) {
                  context.showSnackBar('💔 즐겨찾기 제거됨');
                }
              } else {
                ref.read(favoritesProvider.notifier).add(item.place);
                if (context.mounted) {
                  context.showSnackBar('❤️ 즐겨찾기 추가됨!');
                }
              }
            } else if (value == 'complete') {
              await ref.read(itineraryProvider.notifier).completeItem(item.id);
              if (context.mounted) {
                context.showSnackBar('✅ ${item.place.name} 완료!');
              }
            } else if (value == 'delete') {
              await ref.read(itineraryProvider.notifier).removeItem(item.id);
              if (context.mounted) {
                context.showSnackBar('🗑️ ${item.place.name} 삭제됨');
              }
            }
          },
        ),
      ),
    );
  }
}

// 대중교통 탭
class TransitTab extends ConsumerStatefulWidget {
  const TransitTab({super.key});

  @override
  ConsumerState<TransitTab> createState() => _TransitTabState();
}

class _TransitTabState extends ConsumerState<TransitTab> {
  int _fromIndex = 0;
  int _toIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transitProvider);
    final itinerary = ref.watch(itineraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('대중교통', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (itinerary.items.length >= 2)
            IconButton(
              icon: const Icon(Icons.swap_vert),
              onPressed: () {
                final temp = _fromIndex;
                setState(() {
                  _fromIndex = _toIndex;
                  _toIndex = temp;
                });
              },
              tooltip: '출발지/도착지 바꾸기',
            ),
        ],
      ),
      body: Column(
        children: [
          if (itinerary.items.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_location_alt, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text(
                      '일정에 장소를 추가하세요',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '최소 2개 이상의 장소가 필요합니다',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else if (itinerary.items.length == 1)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_location, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text(
                      '장소를 1개 더 추가하세요',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '현재: ${itinerary.items[0].place.name}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 출발지 선택
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.trip_origin, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButton<int>(
                                value: _fromIndex,
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: itinerary.items.asMap().entries.map((entry) {
                                  return DropdownMenuItem(
                                    value: entry.key,
                                    child: Text(
                                      '${entry.key + 1}. ${entry.value.place.name}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null && value != _toIndex) {
                                    setState(() => _fromIndex = value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 도착지 선택
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButton<int>(
                                value: _toIndex,
                                isExpanded: true,
                                underline: const SizedBox(),
                                items: itinerary.items.asMap().entries.map((entry) {
                                  return DropdownMenuItem(
                                    value: entry.key,
                                    child: Text(
                                      '${entry.key + 1}. ${entry.value.place.name}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null && value != _fromIndex) {
                                    setState(() => _toIndex = value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 검색 버튼
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: state.isLoading || _fromIndex == _toIndex
                              ? null
                              : () async {
                                  final origin = itinerary.items[_fromIndex].place;
                                  final destination = itinerary.items[_toIndex].place;
                                  
                                  ref.read(transitProvider.notifier).setOrigin(origin);
                                  ref.read(transitProvider.notifier).setDestination(destination);
                                  await ref.read(transitProvider.notifier).search();
                                },
                          icon: state.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.search),
                          label: Text(state.isLoading ? '검색 중...' : '경로 검색'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.routes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_bus_rounded, size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            const Text('경로를 검색하세요', style: TextStyle(fontSize: 18, color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.routes.length,
                        itemBuilder: (context, index) {
                          final route = state.routes[index];
                          final colors = [Colors.blue, Colors.green, Colors.orange];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: colors[index % colors.length],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          route.name,
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildTransitInfo(Icons.access_time_rounded, '${route.totalDurationMin}분'),
                                      _buildTransitInfo(Icons.swap_horiz_rounded, '${route.transferCount}회'),
                                      _buildTransitInfo(Icons.payments_rounded, '${route.totalFare}원'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransitInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

// 예약 탭
class ReservationTab extends ConsumerWidget {
  const ReservationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reservationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('예약', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.reservations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book_online_rounded, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('예약 내역이 없습니다', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      const SizedBox(height: 8),
                      const Text(
                        '+ 버튼을 눌러 예약을 추가하세요',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = state.reservations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          Icons.book_online_rounded,
                          color: _getStatusColor(reservation.status),
                          size: 36,
                        ),
                        title: Text(
                          reservation.place.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${reservation.reservationTime.month}월 ${reservation.reservationTime.day}일 ${reservation.reservationTime.hour}:${reservation.reservationTime.minute.toString().padLeft(2, '0')}',
                            ),
                            if (reservation.partySize != null)
                              Text('${reservation.partySize}명'),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getStatusColor(reservation.status).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getStatusText(reservation.status),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getStatusColor(reservation.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'cancel',
                              child: Row(
                                children: [
                                  Icon(Icons.cancel_rounded, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('취소', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) async {
                            if (value == 'cancel') {
                              await ref.read(reservationProvider.notifier).cancel(reservation.id);
                              if (context.mounted) {
                                context.showSnackBar('예약이 취소되었습니다');
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddReservationScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('예약 추가'),
      ),
    );
  }

  Color _getStatusColor(status) {
    switch (status.toString()) {
      case 'ReservationStatus.confirmed':
        return Colors.green;
      case 'ReservationStatus.pending':
        return Colors.orange;
      case 'ReservationStatus.cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(status) {
    switch (status.toString()) {
      case 'ReservationStatus.confirmed':
        return '확정';
      case 'ReservationStatus.pending':
        return '대기중';
      case 'ReservationStatus.cancelled':
        return '취소됨';
      default:
        return '알수없음';
    }
  }
}
