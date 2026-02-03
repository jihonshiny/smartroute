import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/place.dart';
import '../services/kakao_search_service.dart';
import '../services/location_service.dart';

// Services
final kakaoSearchServiceProvider = Provider((ref) => KakaoSearchService());
final locationServiceProvider = Provider((ref) => LocationService());

// Search State
class SearchState {
  final List<Place> results;
  final bool isLoading;
  final String? error;
  final String query;

  const SearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
  });

  SearchState copyWith({
    List<Place>? results,
    bool? isLoading,
    String? error,
    String? query,
  }) {
    return SearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      query: query ?? this.query,
    );
  }
}

// Search State Notifier
class SearchNotifier extends StateNotifier<SearchState> {
  final KakaoSearchService _searchService;

  SearchNotifier(this._searchService) : super(const SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(isLoading: true, query: query);

    try {
      final results = await _searchService.search(query);
      state = state.copyWith(
        results: results,
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

  void clear() {
    state = const SearchState();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final searchService = ref.watch(kakaoSearchServiceProvider);
  return SearchNotifier(searchService);
});

// Current Location Provider
final currentLocationProvider = FutureProvider<LocationData?>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return await locationService.getCurrentLocation();
});

// Selected Place Provider
final selectedPlaceProvider = StateProvider<Place?>((ref) => null);

// Map Center Provider
class MapCenter {
  final double lat;
  final double lng;
  final int zoom;

  const MapCenter({
    required this.lat,
    required this.lng,
    this.zoom = 3,
  });
}

final mapCenterProvider = StateProvider<MapCenter>((ref) {
  return const MapCenter(lat: 37.5665, lng: 126.9780);
});

// Favorites Provider
class FavoritesNotifier extends StateNotifier<List<Place>> {
  FavoritesNotifier() : super([]);

  void toggle(Place place) {
    if (state.any((p) => p.id == place.id)) {
      state = state.where((p) => p.id != place.id).toList();
    } else {
      state = [...state, place];
    }
  }

  void add(Place place) {
    if (!state.any((p) => p.id == place.id)) {
      state = [...state, place];
    }
  }

  void remove(Place place) {
    state = state.where((p) => p.id != place.id).toList();
  }

  void clear() {
    state = [];
  }

  bool isFavorite(String placeId) {
    return state.any((p) => p.id == placeId);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Place>>((ref) {
  return FavoritesNotifier();
});
