import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/itinerary_item.dart';
import '../models/place.dart';
import '../models/route.dart';
import '../services/route_optimization_service.dart';

// Service
final routeOptimizationServiceProvider = Provider((ref) => RouteOptimizationService());

// Itinerary State
class ItineraryState {
  final List<ItineraryItem> items;
  final RouteModel? currentRoute;
  final bool isOptimized;
  final bool isLoading;
  final String? error;

  const ItineraryState({
    this.items = const [],
    this.currentRoute,
    this.isOptimized = false,
    this.isLoading = false,
    this.error,
  });

  ItineraryState copyWith({
    List<ItineraryItem>? items,
    RouteModel? currentRoute,
    bool? isOptimized,
    bool? isLoading,
    String? error,
  }) {
    return ItineraryState(
      items: items ?? this.items,
      currentRoute: currentRoute ?? this.currentRoute,
      isOptimized: isOptimized ?? this.isOptimized,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  int get completedCount => items.where((item) => item.completed).length;
  int get totalCount => items.length;
  double get completionRate => totalCount > 0 ? completedCount / totalCount : 0.0;
}

// Itinerary Notifier
class ItineraryNotifier extends StateNotifier<ItineraryState> {
  final RouteOptimizationService _routeService;

  ItineraryNotifier(this._routeService) : super(const ItineraryState()) {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Mock data
    final mockPlaces = [
      Place(id: '1', name: 'KB국민은행 강남점', address: '서울시 강남구 테헤란로 123', lat: 37.5012, lng: 127.0396, category: '은행'),
      Place(id: '2', name: '이마트 역삼점', address: '서울시 강남구 역삼동 456', lat: 37.5000, lng: 127.0360, category: '마트'),
      Place(id: '3', name: '온누리약국 테헤란점', address: '서울시 강남구 테헤란로 130', lat: 37.5015, lng: 127.0400, category: '약국'),
      Place(id: '4', name: '강남우체국', address: '서울시 강남구 논현로 789', lat: 37.4990, lng: 127.0350, category: '우체국'),
    ];

    final items = mockPlaces.asMap().entries.map((entry) {
      return ItineraryItem(
        id: 'item_${entry.key + 1}',
        place: entry.value,
        order: entry.key + 1,
        transportMode: TransportMode.walk,
      );
    }).toList();

    state = state.copyWith(items: items);
  }

  Future<void> addPlace(Place place) async {
    final newItem = ItineraryItem(
      id: 'item_${DateTime.now().millisecondsSinceEpoch}',
      place: place,
      order: state.items.length + 1,
      transportMode: TransportMode.walk,
    );

    state = state.copyWith(items: [...state.items, newItem]);
  }

  Future<void> removeItem(String itemId) async {
    final updatedItems = state.items.where((item) => item.id != itemId).toList();
    final reordered = List.generate(
      updatedItems.length,
      (i) => updatedItems[i].copyWith(order: i + 1),
    );
    state = state.copyWith(items: reordered, isOptimized: false);
  }

  Future<void> reorderItems(int oldIndex, int newIndex) async {
    final items = List<ItineraryItem>.from(state.items);
    if (newIndex > oldIndex) newIndex--;
    
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    final reordered = List.generate(
      items.length,
      (i) => items[i].copyWith(order: i + 1),
    );

    state = state.copyWith(items: reordered, isOptimized: false);
  }

  Future<void> optimizeRoute() async {
    if (state.items.length < 2) return;

    state = state.copyWith(isLoading: true);

    try {
      final optimizedRoute = await _routeService.optimizeRoute(state.items);
      state = state.copyWith(
        items: optimizedRoute.items,
        currentRoute: optimizedRoute,
        isOptimized: true,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> completeItem(String itemId) async {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(
          completed: true,
          completedAt: DateTime.now(),
        );
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  Future<void> updateTransportMode(String itemId, TransportMode mode) async {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(transportMode: mode);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems, isOptimized: false);
  }

  void reset() {
    state = state.copyWith(isOptimized: false, currentRoute: null);
  }
}

final itineraryProvider = StateNotifierProvider<ItineraryNotifier, ItineraryState>((ref) {
  final routeService = ref.watch(routeOptimizationServiceProvider);
  return ItineraryNotifier(routeService);
});

// Current Day Statistics
final currentDayStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final itinerary = ref.watch(itineraryProvider);
  
  return {
    'totalPlaces': itinerary.totalCount,
    'completed': itinerary.completedCount,
    'remaining': itinerary.totalCount - itinerary.completedCount,
    'completionRate': itinerary.completionRate,
    'totalDistance': itinerary.currentRoute?.totalDistanceKm ?? 0.0,
    'totalDuration': itinerary.currentRoute?.totalDurationMin ?? 0,
  };
});
