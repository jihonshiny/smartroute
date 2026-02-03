import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    _tabController = TabController(length: 4, vsync: this);
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
          ],
        ),
      ),
    );
  }
}

// 지도 탭
class MapTab extends ConsumerWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itinerary = ref.watch(itineraryProvider);
    final favorites = ref.watch(favoritesProvider);

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
              context.showSnackBar('즐겨찾기: ${favorites.length}개');
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

          // 지도 영역
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.cyan.shade50],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.map_rounded, size: 60, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${itinerary.items.length}개 장소',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(item.place.name),
                              content: Text(item.place.address),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('닫기'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlaceDetailScreen(place: item.place),
                                      ),
                                    );
                                  },
                                  child: const Text('상세보기'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                '${item.order}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
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
        child: const Icon(Icons.add_rounded),
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
            if (value == 'complete') {
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
  final _originController = TextEditingController();
  final _destController = TextEditingController();

  @override
  void dispose() {
    _originController.dispose();
    _destController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transitProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('대중교통', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _originController,
                  decoration: InputDecoration(
                    labelText: '출발지',
                    prefixIcon: const Icon(Icons.trip_origin),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _destController,
                  decoration: InputDecoration(
                    labelText: '도착지',
                    prefixIcon: const Icon(Icons.location_on_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            if (_originController.text.isEmpty || _destController.text.isEmpty) {
                              context.showSnackBar('출발지와 도착지를 입력하세요', isError: true);
                              return;
                            }
                            await ref.read(transitProvider.notifier).search();
                          },
                    icon: const Icon(Icons.search),
                    label: const Text('경로 검색'),
                  ),
                ),
              ],
            ),
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
