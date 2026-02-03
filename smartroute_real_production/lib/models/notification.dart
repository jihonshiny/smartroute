enum NotificationType {
  itinerary,
  reservation,
  review,
  system,
  promotion,
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.data,
    this.imageUrl,
    this.actionUrl,
  });

  AppNotification copyWith({
    bool? isRead,
    String? actionUrl,
  }) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      data: data,
      imageUrl: imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  String get typeIcon {
    switch (type) {
      case NotificationType.itinerary:
        return '📍';
      case NotificationType.reservation:
        return '📅';
      case NotificationType.review:
        return '⭐';
      case NotificationType.system:
        return '🔔';
      case NotificationType.promotion:
        return '🎁';
    }
  }
}
