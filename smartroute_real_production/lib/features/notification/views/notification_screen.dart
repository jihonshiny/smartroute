import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/notification.dart';
import '../../../services/notification_service.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/common/empty_state.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.getNotifications();
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.getUnreadCount();
});

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadCountAsync = ref.watch(unreadCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          unreadCountAsync.when(
            data: (count) => count > 0
                ? TextButton(
                    onPressed: () async {
                      await ref.read(notificationServiceProvider).markAllAsRead();
                      ref.invalidate(notificationsProvider);
                      ref.invalidate(unreadCountProvider);
                    },
                    child: const Text('모두 읽음'),
                  )
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('알림 설정')),
              const PopupMenuItem(value: 'clear', child: Text('모두 삭제')),
            ],
            onSelected: (value) async {
              if (value == 'clear') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('알림 삭제'),
                    content: const Text('모든 알림을 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('취소'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('삭제'),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true && mounted) {
                  await ref.read(notificationServiceProvider).clearAll();
                  ref.invalidate(notificationsProvider);
                  ref.invalidate(unreadCountProvider);
                }
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: notificationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('오류: $error')),
              data: (notifications) {
                if (notifications.isEmpty) {
                  return EmptyState(
                    icon: Icons.notifications_off_rounded,
                    title: '알림이 없습니다',
                    subtitle: '새로운 알림이 도착하면 여기에 표시됩니다',
                  );
                }

                final filteredNotifications = _filterNotifications(notifications);

                if (filteredNotifications.isEmpty) {
                  return EmptyState(
                    icon: Icons.filter_alt_off_rounded,
                    title: '필터에 맞는 알림이 없습니다',
                    subtitle: '다른 필터를 선택해보세요',
                  );
                }

                final groupedNotifications = _groupNotificationsByDate(filteredNotifications);

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupedNotifications.length,
                  itemBuilder: (context, index) {
                    final date = groupedNotifications.keys.elementAt(index);
                    final items = groupedNotifications[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            _formatDateHeader(date),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ...items.map((notif) => _buildNotificationCard(notif)).toList(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      ('all', '전체', Icons.apps_rounded),
      ('unread', '읽지 않음', Icons.mark_email_unread_rounded),
      ('itinerary', '일정', Icons.event_rounded),
      ('reservation', '예약', Icons.book_online_rounded),
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _filter == filter.$1;
          
          return FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(filter.$3, size: 16, color: isSelected ? Colors.white : AppTheme.primary),
                const SizedBox(width: 4),
                Text(filter.$2),
              ],
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _filter = filter.$1;
              });
            },
            selectedColor: AppTheme.primary,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await ref.read(notificationServiceProvider).deleteNotification(notification.id);
        ref.invalidate(notificationsProvider);
        ref.invalidate(unreadCountProvider);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: notification.isRead ? null : AppTheme.primary.withValues(alpha: 0.05),
        child: InkWell(
          onTap: () async {
            if (!notification.isRead) {
              await ref.read(notificationServiceProvider).markAsRead(notification.id);
              ref.invalidate(notificationsProvider);
              ref.invalidate(unreadCountProvider);
            }
            _handleNotificationTap(notification);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTypeColor(notification.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      notification.typeIcon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            DateTimeUtils.formatRelative(notification.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<AppNotification> _filterNotifications(List<AppNotification> notifications) {
    switch (_filter) {
      case 'unread':
        return notifications.where((n) => !n.isRead).toList();
      case 'itinerary':
        return notifications.where((n) => n.type == NotificationType.itinerary).toList();
      case 'reservation':
        return notifications.where((n) => n.type == NotificationType.reservation).toList();
      default:
        return notifications;
    }
  }

  Map<DateTime, List<AppNotification>> _groupNotificationsByDate(List<AppNotification> notifications) {
    final grouped = <DateTime, List<AppNotification>>{};
    
    for (final notif in notifications) {
      final date = DateTime(
        notif.createdAt.year,
        notif.createdAt.month,
        notif.createdAt.day,
      );
      
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(notif);
    }
    
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
  }

  String _formatDateHeader(DateTime date) {
    if (DateTimeUtils.isToday(date)) {
      return '오늘';
    } else if (DateTimeUtils.isYesterday(date)) {
      return '어제';
    } else {
      return DateTimeUtils.formatDate(date);
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.itinerary:
        return Colors.blue;
      case NotificationType.reservation:
        return Colors.green;
      case NotificationType.review:
        return Colors.orange;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.promotion:
        return Colors.purple;
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    // Handle notification navigation based on type
    switch (notification.type) {
      case NotificationType.itinerary:
        // Navigate to itinerary tab
        break;
      case NotificationType.reservation:
        // Navigate to reservation tab
        break;
      case NotificationType.review:
        // Navigate to review screen
        break;
      case NotificationType.system:
        // Show dialog or navigate
        break;
      case NotificationType.promotion:
        // Show promotion details
        break;
    }
  }
}
