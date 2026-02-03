import 'place.dart';

enum ReservationStatus { pending, confirmed, cancelled, completed }

class Reservation {
  final String id;
  final Place place;
  final DateTime reservationTime;
  final DateTime createdAt;
  final ReservationStatus status;
  final String? notes;
  final int? partySize;
  final String? confirmationCode;
  final bool syncToItinerary;

  const Reservation({
    required this.id,
    required this.place,
    required this.reservationTime,
    required this.createdAt,
    required this.status,
    this.notes,
    this.partySize,
    this.confirmationCode,
    this.syncToItinerary = false,
  });

  Reservation copyWith({
    Place? place,
    DateTime? reservationTime,
    ReservationStatus? status,
    String? notes,
    int? partySize,
    String? confirmationCode,
    bool? syncToItinerary,
  }) {
    return Reservation(
      id: id,
      place: place ?? this.place,
      reservationTime: reservationTime ?? this.reservationTime,
      createdAt: createdAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      partySize: partySize ?? this.partySize,
      confirmationCode: confirmationCode ?? this.confirmationCode,
      syncToItinerary: syncToItinerary ?? this.syncToItinerary,
    );
  }
}
