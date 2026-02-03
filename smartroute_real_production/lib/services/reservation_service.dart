import '../models/reservation.dart';
import '../models/place.dart';

class ReservationService {
  static final ReservationService _instance = ReservationService._internal();
  factory ReservationService() => _instance;
  ReservationService._internal();

  final List<Reservation> _reservations = [
    Reservation(
      id: 'res_1',
      place: Place(
        id: 'place_1',
        name: '스타벅스 강남점',
        address: '서울시 강남구',
        lat: 37.5012,
        lng: 127.0396,
      ),
      reservationTime: DateTime.now().add(const Duration(hours: 2)),
      createdAt: DateTime.now(),
      status: ReservationStatus.confirmed,
      confirmationCode: 'STB12345',
      notes: '창가 자리 부탁드립니다',
    ),
    Reservation(
      id: 'res_2',
      place: Place(
        id: 'place_2',
        name: '헤어샵 컷트',
        address: '서울시 강남구',
        lat: 37.5000,
        lng: 127.0360,
      ),
      reservationTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
      createdAt: DateTime.now(),
      status: ReservationStatus.pending,
    ),
    Reservation(
      id: 'res_3',
      place: Place(
        id: 'place_3',
        name: '병원 진료',
        address: '서울시 강남구',
        lat: 37.5015,
        lng: 127.0400,
      ),
      reservationTime: DateTime.now().add(const Duration(days: 2)),
      createdAt: DateTime.now(),
      status: ReservationStatus.confirmed,
      confirmationCode: 'MED67890',
    ),
  ];

  Future<List<Reservation>> getMyReservations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_reservations);
  }

  Future<Reservation> createReservation(Reservation reservation) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _reservations.add(reservation);
    return reservation;
  }

  Future<void> updateReservation(Reservation reservation) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _reservations.indexWhere((r) => r.id == reservation.id);
    if (index != -1) {
      _reservations[index] = reservation;
    }
  }

  Future<void> cancelReservation(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _reservations.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reservations[index] = _reservations[index].copyWith(
        status: ReservationStatus.cancelled,
      );
    }
  }

  Future<Reservation?> getReservationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _reservations.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }
}
