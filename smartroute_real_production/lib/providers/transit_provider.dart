import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/place.dart';
import '../models/transit.dart';
import '../services/transit_service.dart';

final transitServiceProvider = Provider((ref) => TransitService());

class TransitSearchState {
  final Place? origin;
  final Place? destination;
  final List<TransitRoute> routes;
  final bool isLoading;
  final String? error;
  final DateTime? departureTime;

  const TransitSearchState({
    this.origin,
    this.destination,
    this.routes = const [],
    this.isLoading = false,
    this.error,
    this.departureTime,
  });

  TransitSearchState copyWith({
    Place? origin,
    Place? destination,
    List<TransitRoute>? routes,
    bool? isLoading,
    String? error,
    DateTime? departureTime,
  }) {
    return TransitSearchState(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      routes: routes ?? this.routes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      departureTime: departureTime ?? this.departureTime,
    );
  }

  bool get canSearch => origin != null && destination != null;
}

class TransitNotifier extends StateNotifier<TransitSearchState> {
  final TransitService _transitService;

  TransitNotifier(this._transitService) : super(const TransitSearchState());

  void setOrigin(Place place) {
    state = state.copyWith(origin: place);
  }

  void setDestination(Place place) {
    state = state.copyWith(destination: place);
  }

  void setDepartureTime(DateTime time) {
    state = state.copyWith(departureTime: time);
  }

  Future<void> search() async {
    if (!state.canSearch) return;

    state = state.copyWith(isLoading: true);

    try {
      final departureTime = state.departureTime ?? DateTime.now();
      final routes = await _transitService.searchRoutes(
        state.origin!,
        state.destination!,
        departureTime,
      );

      state = state.copyWith(
        routes: routes,
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
    state = const TransitSearchState();
  }

  void swapOriginDestination() {
    if (state.origin != null && state.destination != null) {
      state = state.copyWith(
        origin: state.destination,
        destination: state.origin,
      );
    }
  }
}

final transitProvider = StateNotifierProvider<TransitNotifier, TransitSearchState>((ref) {
  final transitService = ref.watch(transitServiceProvider);
  return TransitNotifier(transitService);
});
