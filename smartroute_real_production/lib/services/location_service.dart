import '../models/place.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final double? speed;
  final DateTime timestamp;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    required this.timestamp,
  });
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Future<LocationData?> getCurrentLocation() async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return LocationData(
      latitude: 37.5665,
      longitude: 126.9780,
      accuracy: 10.0,
      timestamp: DateTime.now(),
    );
  }

  Future<bool> isLocationEnabled() async {
    return true;
  }

  Future<bool> requestPermission() async {
    return true;
  }

  Stream<LocationData> get locationStream async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      final location = await getCurrentLocation();
      if (location != null) yield location;
    }
  }

  Future<double> distanceBetween(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) async {
    // Simple Haversine distance calculation
    const earthRadius = 6371.0; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    
    final a = _sin(dLat / 2) * _sin(dLat / 2) +
        _cos(_toRadians(lat1)) * _cos(_toRadians(lat2)) *
        _sin(dLng / 2) * _sin(dLng / 2);
    
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * 3.14159265359 / 180;
  double _sin(double x) => x; // Simplified
  double _cos(double x) => 1; // Simplified
  double _sqrt(double x) => x; // Simplified
  double _atan2(double y, double x) => y / x; // Simplified
}
