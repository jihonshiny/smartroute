import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reservation.dart';
import '../models/place.dart';
import '../services/reservation_service.dart';

final reservationServiceProvider = Provider((ref) => ReservationService());

class ReservationState {
  final List<Reservation> reservations;
  final bool isLoading;
  final String? error;

  const ReservationState({
    this.reservations = const [],
    this.isLoading = false,
    this.error,
  });

  ReservationState copyWith({
    List<Reservation>? reservations,
    bool? isLoading,
    String? error,
  }) {
    return ReservationState(
      reservations: reservations ?? this.reservations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  List<Reservation> get upcoming => reservations
      .where((r) => r.reservationTime.isAfter(DateTime.now()) && r.status != ReservationStatus.cancelled)
      .toList()
    ..sort((a, b) => a.reservationTime.compareTo(b.reservationTime));

  List<Reservation> get past => reservations
      .where((r) => r.reservationTime.isBefore(DateTime.now()) || r.status == ReservationStatus.cancelled)
      .toList()
    ..sort((a, b) => b.reservationTime.compareTo(a.reservationTime));
}

class ReservationNotifier extends StateNotifier<ReservationState> {
  final ReservationService _reservationService;

  ReservationNotifier(this._reservationService) : super(const ReservationState()) {
    loadReservations();
  }

  Future<void> loadReservations() async {
    state = state.copyWith(isLoading: true);

    try {
      final reservations = await _reservationService.getMyReservations();
      state = state.copyWith(
        reservations: reservations,
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

  Future<void> create({
    required Place place,
    required DateTime reservationTime,
    int? partySize,
    String? notes,
  }) async {
    try {
      final reservation = Reservation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        place: place,
        reservationTime: reservationTime,
        createdAt: DateTime.now(),
        status: ReservationStatus.pending,
        partySize: partySize,
        notes: notes,
      );
      
      final created = await _reservationService.createReservation(reservation);
      state = state.copyWith(
        reservations: [...state.reservations, created],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> cancel(String id) async {
    try {
      await _reservationService.cancelReservation(id);
      await loadReservations();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleSync(String id) async {
    try {
      final reservation = state.reservations.firstWhere((r) => r.id == id);
      final updated = reservation.copyWith(syncToItinerary: !reservation.syncToItinerary);
      await _reservationService.updateReservation(updated);
      await loadReservations();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final reservationProvider = StateNotifierProvider<ReservationNotifier, ReservationState>((ref) {
  final service = ref.watch(reservationServiceProvider);
  return ReservationNotifier(service);
});
