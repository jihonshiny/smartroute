import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../utils/date_utils.dart';

enum NotificationType { reservation, itinerary, system, promotion }

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      type: NotificationType.reservation,
      title: '예약 확정',
      body: '스타벅스 강남점 예약이 확정되었습니다 (오늘 14:00)',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      type: NotificationType.itinerary,
      title: '일정 시작 알림',
      body: '30분 후 KB국민은행 방문 예정입니다',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      type: NotificationType.system,
      title: 'AI 최적화 완료',
      body: '오늘 일정이 35분, 4.2km 절약되도록 최적화되었습니다',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      type: NotificationType.promotion,
      title: '이벤트 안내',
      body: 'SmartRoute 프리미엄 무료 체험 이벤트',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  List<NotificationItem> get _unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          if (_unreadNotifications.isNotEmpty)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('모두 읽음'),
            ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('알림 설정')),
              const PopupMenuItem(value: 'clear', child: Text('모두 지우기')),
            ],
            onSelected: (value) {
              if (value == 'clear') {
                _clearAll();
              }
            },
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_rounded, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('알림이 없습니다', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : ListView.separated(
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationTile(notification);
              },
            ),
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _notifications.removeWhere((n) => n.id == notification.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('알림이 삭제되었습니다')),
        );
      },
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getNotificationColor(notification.type),
            size: 24,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(
              DateTimeUtils.formatRelative(notification.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        isThreeLine: true,
        onTap: () => _markAsRead(notification.id),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.reservation:
        return Icons.book_online_rounded;
      case NotificationType.itinerary:
        return Icons.list_alt_rounded;
      case NotificationType.system:
        return Icons.info_rounded;
      case NotificationType.promotion:
        return Icons.local_offer_rounded;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.reservation:
        return Colors.blue;
      case NotificationType.itinerary:
        return Colors.green;
      case NotificationType.system:
        return Colors.orange;
      case NotificationType.promotion:
        return Colors.purple;
    }
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = NotificationItem(
          id: _notifications[index].id,
          type: _notifications[index].type,
          title: _notifications[index].title,
          body: _notifications[index].body,
          timestamp: _notifications[index].timestamp,
          isRead: true,
          actionUrl: _notifications[index].actionUrl,
        );
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications.clear();
      _notifications.addAll(
        _notifications.map((n) => NotificationItem(
              id: n.id,
              type: n.type,
              title: n.title,
              body: n.body,
              timestamp: n.timestamp,
              isRead: true,
              actionUrl: n.actionUrl,
            )),
      );
    });
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
  }
}
