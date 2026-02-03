import 'place.dart';

class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String placeId;
  final Place? place;
  final double rating;
  final String? comment;
  final List<String>? photos;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int helpfulCount;
  final bool isHelpful;
  final Map<String, int>? ratings;

  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.placeId,
    this.place,
    required this.rating,
    this.comment,
    this.photos,
    this.tags,
    required this.createdAt,
    this.updatedAt,
    this.helpfulCount = 0,
    this.isHelpful = false,
    this.ratings,
  });

  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? placeId,
    Place? place,
    double? rating,
    String? comment,
    List<String>? photos,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? helpfulCount,
    bool? isHelpful,
    Map<String, int>? ratings,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      placeId: placeId ?? this.placeId,
      place: place ?? this.place,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      photos: photos ?? this.photos,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isHelpful: isHelpful ?? this.isHelpful,
      ratings: ratings ?? this.ratings,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'userPhotoUrl': userPhotoUrl,
        'placeId': placeId,
        'rating': rating,
        'comment': comment,
        'photos': photos,
        'tags': tags,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'helpfulCount': helpfulCount,
        'isHelpful': isHelpful,
        'ratings': ratings,
      };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        userPhotoUrl: json['userPhotoUrl'] as String?,
        placeId: json['placeId'] as String,
        rating: (json['rating'] as num).toDouble(),
        comment: json['comment'] as String?,
        photos: json['photos'] != null ? List<String>.from(json['photos'] as List) : null,
        tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
        helpfulCount: json['helpfulCount'] as int? ?? 0,
        isHelpful: json['isHelpful'] as bool? ?? false,
        ratings: json['ratings'] != null ? Map<String, int>.from(json['ratings'] as Map) : null,
      );
}
