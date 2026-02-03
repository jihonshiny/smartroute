import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/itinerary_item.dart';
import '../../../models/reservation.dart';
import '../../../providers/itinerary_provider.dart';
import '../../../providers/reservation_provider.dart';
import '../../../widgets/common/empty_state.dart';

final currentTabProvider = StateProvider<int>((ref) => 0);

class MainScreenComplete extends ConsumerWidget {
  const MainScreenComplete({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);
    
    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: const [
          CompleteMapTab(),
          CompleteItineraryTab(),
          CompleteTransitTab(),
          CompleteReservationTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (index) => ref.read(currentTabProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: '지도'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: '일정'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_bus_rounded), label: '대중교통'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online_rounded), label: '예약'),
        ],
      ),
    );
  }
}

class CompleteMapTab extends ConsumerWidget {
  const CompleteMapTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itineraryState = ref.watch(itineraryProvider);

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
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
          IconButton(icon: const CircleAvatar(backgroundColor: AppTheme.primary, radius: 16, child: Text('U', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold))), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: '장소를 검색하세요',
                prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade50, Colors.cyan.shade50],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))],
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
                          decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.map_rounded, size: 60, color: Colors.white),
                        ),
                        const SizedBox(height: 30),
                        const Text('지도 영역', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                          child: Text('${itineraryState.items.length}개 장소 등록됨', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                        ),
                      ],
                    ),
                  ),
                  ...List.generate(itineraryState.items.length, (index) {
                    return Positioned(
                      left: 40.0 + (index * 70),
                      top: 60.0 + (index * 50),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: Text('${index + 1}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                          ),
                          const Icon(Icons.location_on_rounded, color: AppTheme.primary, size: 36),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(heroTag: 'add', onPressed: () {}, backgroundColor: AppTheme.primary, child: const Icon(Icons.add_rounded, size: 28)),
          const SizedBox(height: 12),
          FloatingActionButton(heroTag: 'location', onPressed: () {}, backgroundColor: Colors.white, foregroundColor: AppTheme.primary, child: const Icon(Icons.my_location_rounded, size: 24)),
        ],
      ),
    );
  }
}

class CompleteItineraryTab extends ConsumerWidget {
  const CompleteItineraryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(itineraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘 일정'),
        actions: [
          if (state.isOptimized)
            IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: () => ref.read(itineraryProvider.notifier).reset()),
        ],
      ),
      body: Column(
        children: [
          if (state.isOptimized)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green.shade50, Colors.green.shade100]), borderRadius: BorderRadius.circular(18)),
              child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 40)), const SizedBox(width: 16), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('✨ AI 최적화 완료!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)), SizedBox(height: 10), Text('35분 절약 • 4.2km 단축', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15))]))]),
            ),
          Expanded(
            child: state.items.isEmpty
                ? EmptyState(icon: Icons.list_alt_rounded, title: '일정이 없습니다', subtitle: '지도에서 장소를 추가해보세요')
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    onReorder: (old, neu) => ref.read(itineraryProvider.notifier).reorderItems(old, neu),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Card(
                        key: ValueKey(item.id),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  gradient: item.completed ? LinearGradient(colors: [Colors.green.shade400, Colors.green.shade600]) : const LinearGradient(colors: [AppTheme.primary, Color(0xFF2666CC)]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(child: item.completed ? const Icon(Icons.check_rounded, color: Colors.white, size: 28) : Text('${item.order}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
                              ),
                              const SizedBox(width: 14),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.place.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, decoration: item.completed ? TextDecoration.lineThrough : null)), const SizedBox(height: 6), Text(item.place.address, style: TextStyle(fontSize: 13, color: Colors.grey[600]))])),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: !state.isOptimized && state.items.length >= 2 ? FloatingActionButton.extended(onPressed: () => ref.read(itineraryProvider.notifier).optimizeRoute(), backgroundColor: AppTheme.accent, icon: const Icon(Icons.auto_awesome_rounded, size: 24), label: const Text('AI 최적화', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))) : null,
    );
  }
}

class CompleteTransitTab extends StatelessWidget {
  const CompleteTransitTab({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('대중교통')), body: ListView(padding: const EdgeInsets.all(16), children: [TextField(decoration: InputDecoration(labelText: '출발지', prefixIcon: const Icon(Icons.trip_origin_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))), const SizedBox(height: 16), TextField(decoration: InputDecoration(labelText: '도착지', prefixIcon: const Icon(Icons.location_on_rounded), border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))), const SizedBox(height: 16), ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.search_rounded), label: const Text('경로 검색')), const SizedBox(height: 24), const Text('추천 경로', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 12), _card('빠른 경로', '45분', '1회 환승', '1,400원', Colors.blue), _card('최소 환승', '52분', '환승 없음', '1,250원', Colors.green), _card('저렴한 경로', '58분', '2회 환승', '1,150원', Colors.orange)]));

  static Widget _card(String t, String ti, String tr, String f, Color c) => Card(margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Container(width: 5, height: 65, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), const SizedBox(height: 10), Row(children: [const Icon(Icons.access_time_rounded, size: 16), const SizedBox(width: 4), Text(ti), const SizedBox(width: 16), const Icon(Icons.sync_alt_rounded, size: 16), const SizedBox(width: 4), Text(tr), const SizedBox(width: 16), const Icon(Icons.payments_rounded, size: 16), const SizedBox(width: 4), Text(f)])]))])));
}

class CompleteReservationTab extends ConsumerWidget {
  const CompleteReservationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationsAsync = ref.watch(reservationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('예약')),
      body: reservationsAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : reservationsAsync.reservations.isEmpty
              ? EmptyState(icon: Icons.book_online_rounded, title: '예약이 없습니다', subtitle: '새로운 예약을 추가해보세요')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reservationsAsync.reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = reservationsAsync.reservations[index];
                    final color = reservation.status == ReservationStatus.confirmed ? Colors.green : reservation.status == ReservationStatus.pending ? Colors.orange : Colors.blue;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(children: [Container(width: 5, height: 75, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(reservation.place.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), const SizedBox(height: 6), Row(children: [const Icon(Icons.access_time_rounded, size: 15), const SizedBox(width: 4), Text(reservation.reservationTime.toString().substring(0, 16))]), const SizedBox(height: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)), child: Text(reservation.status.toString(), style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)))])), const Icon(Icons.more_vert_rounded)]),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, backgroundColor: AppTheme.primary, icon: const Icon(Icons.add_rounded), label: const Text('예약 추가')),
    );
  }
}
