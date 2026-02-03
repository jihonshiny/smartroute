import '../models/itinerary_item.dart';
import '../models/reservation.dart';
import '../models/notification.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      type: NotificationType.reservation,
      title: '예약 확정',
      body: '스타벅스 강남점 예약이 확정되었습니다 (오늘 14:00)',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      id: '2',
      type: NotificationType.itinerary,
      title: '일정 시작 알림',
      body: '30분 후 KB국민은행 방문 예정입니다',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    AppNotification(
      id: '3',
      type: NotificationType.system,
      title: 'AI 최적화 완료',
      body: '오늘 일정이 35분, 4.2km 절약되도록 최적화되었습니다',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  Future<void> initialize() async {
    print('Notification service initialized');
  }

  Future<List<AppNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_notifications);
  }

  Future<int> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _notifications.where((n) => !n.isRead).length;
  }

  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  Future<void> clearAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _notifications.clear();
  }

  Future<void> deleteNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _notifications.removeWhere((n) => n.id == id);
  }

  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  Future<void> scheduleItineraryReminder(ItineraryItem item, Duration before) async {
    if (item.startTime == null) return;
    final notificationTime = item.startTime!.subtract(before);
    print('Scheduled reminder for ${item.place.name} at $notificationTime');
  }

  Future<void> scheduleReservationReminder(Reservation reservation, Duration before) async {
    final notificationTime = reservation.reservationTime.subtract(before);
    print('Scheduled reservation reminder for ${reservation.place.name} at $notificationTime');
  }

  Future<void> cancelNotification(String id) async {
    print('Cancelled notification: $id');
  }

  Future<void> cancelAllNotifications() async {
    print('Cancelled all notifications');
  }

  Future<void> showInstantNotification(String title, String body) async {
    print('Notification: $title - $body');
  }
}

