import 'dart:convert';

class Place {
  final String id;
  final String name;
  final String address;
  final String? roadAddress;
  final double lat;
  final double lng;
  final String? category;
  final String? phone;
  final String? url;
  final double? rating;
  final int? reviewCount;
  final String? imageUrl;
  final Map<String, String>? openingHours;
  final List<String>? tags;
  final bool isFavorite;
  final DateTime? lastVisited;
  final int visitCount;

  const Place({
    required this.id,
    required this.name,
    required this.address,
    this.roadAddress,
    required this.lat,
    required this.lng,
    this.category,
    this.phone,
    this.url,
    this.rating,
    this.reviewCount,
    this.imageUrl,
    this.openingHours,
    this.tags,
    this.isFavorite = false,
    this.lastVisited,
    this.visitCount = 0,
  });

  Place copyWith({
    String? name,
    String? address,
    String? roadAddress,
    double? lat,
    double? lng,
    String? category,
    String? phone,
    String? url,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    Map<String, String>? openingHours,
    List<String>? tags,
    bool? isFavorite,
    DateTime? lastVisited,
    int? visitCount,
  }) {
    return Place(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      roadAddress: roadAddress ?? this.roadAddress,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      url: url ?? this.url,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      openingHours: openingHours ?? this.openingHours,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      lastVisited: lastVisited ?? this.lastVisited,
      visitCount: visitCount ?? this.visitCount,
    );
  }

  factory Place.fromKakao(Map<String, dynamic> json) {
    return Place(
      id: json['id']?.toString() ?? '',
      name: json['place_name'] ?? '',
      address: json['address_name'] ?? '',
      roadAddress: json['road_address_name'],
      lat: double.tryParse(json['y']?.toString() ?? '0') ?? 0.0,
      lng: double.tryParse(json['x']?.toString() ?? '0') ?? 0.0,
      category: json['category_name'],
      phone: json['phone'],
      url: json['place_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'roadAddress': roadAddress,
      'lat': lat,
      'lng': lng,
      'category': category,
      'phone': phone,
      'url': url,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'openingHours': openingHours,
      'tags': tags,
      'isFavorite': isFavorite,
      'lastVisited': lastVisited?.toIso8601String(),
      'visitCount': visitCount,
    };
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      roadAddress: json['roadAddress'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      category: json['category'] as String?,
      phone: json['phone'] as String?,
      url: json['url'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviewCount: json['reviewCount'] as int?,
      imageUrl: json['imageUrl'] as String?,
      openingHours: json['openingHours'] != null ? Map<String, String>.from(json['openingHours'] as Map) : null,
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : null,
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastVisited: json['lastVisited'] != null ? DateTime.parse(json['lastVisited'] as String) : null,
      visitCount: json['visitCount'] as int? ?? 0,
    );
  }

  double distanceTo(double lat2, double lng2) {
    const double earthRadius = 6371.0;
    final dLat = _toRadians(lat2 - lat);
    final dLng = _toRadians(lng2 - lng);
    final a = (dLat / 2).abs() * (dLat / 2).abs() +
        (lat * 0.017453292519943295) * (lat2 * 0.017453292519943295) *
            (dLng / 2).abs() * (dLng / 2).abs();
    final c = 2 * 1.5707963267948966 * a;
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * 0.017453292519943295;

  @override
  String toString() => 'Place(id: $id, name: $name, lat: $lat, lng: $lng)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Place && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
