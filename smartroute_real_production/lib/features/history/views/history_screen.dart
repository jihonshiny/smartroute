import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../models/visit_history.dart';
import '../../../services/history_service.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/common/empty_state.dart';

final historyServiceProvider = Provider((ref) => HistoryService());

final historyProvider = FutureProvider<List<VisitHistory>>((ref) async {
  final service = ref.watch(historyServiceProvider);
  return await service.getHistory();
});

final categoryStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final service = ref.watch(historyServiceProvider);
  return await service.getCategoryStats();
});

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('방문 기록'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.filter_list_rounded),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('전체')),
              const PopupMenuItem(value: 'today', child: Text('오늘')),
              const PopupMenuItem(value: 'week', child: Text('이번 주')),
              const PopupMenuItem(value: 'month', child: Text('이번 달')),
            ],
            onSelected: (value) {
              setState(() {
                _filterPeriod = value;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primary,
          tabs: const [
            Tab(text: '타임라인'),
            Tab(text: '지도'),
            Tab(text: '통계'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTimelineTab(),
          _buildMapTab(),
          _buildStatsTab(),
        ],
      ),
    );
  }

  Widget _buildTimelineTab() {
    final historyAsync = ref.watch(historyProvider);

    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('오류: $error')),
      data: (history) {
        if (history.isEmpty) {
          return EmptyState(
            icon: Icons.history_rounded,
            title: '방문 기록이 없습니다',
            subtitle: '장소를 방문하면 기록이 남습니다',
          );
        }

        final groupedHistory = _groupHistoryByDate(history);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groupedHistory.length,
          itemBuilder: (context, index) {
            final date = groupedHistory.keys.elementAt(index);
            final items = groupedHistory[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDateHeader(date),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${items.length}개 방문',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                ...items.map((item) => _buildHistoryCard(item)).toList(),
                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHistoryCard(VisitHistory history) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showHistoryDetail(history),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.place_rounded,
                  color: AppTheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.place.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          DateTimeUtils.formatTime(history.visitedAt),
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        if (history.durationMinutes > 0) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.timer_rounded, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${history.durationMinutes}분',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                    if (history.rating != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < history.rating!.floor() ? Icons.star : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_rounded, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('지도 뷰', style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 8),
          Text('방문한 장소들이 지도에 표시됩니다', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    final statsAsync = ref.watch(categoryStatsProvider);

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('오류: $error')),
      data: (stats) {
        if (stats.isEmpty) {
          return EmptyState(
            icon: Icons.bar_chart_rounded,
            title: '통계 데이터가 없습니다',
            subtitle: '장소를 방문하면 통계가 생성됩니다',
          );
        }

        final sortedEntries = stats.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        final totalVisits = stats.values.fold(0, (sum, count) => sum + count);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      '총 방문 횟수',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalVisits',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '카테고리별 방문',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...sortedEntries.map((entry) {
              final percentage = (entry.value / totalVisits * 100).round();
              return _buildStatBar(
                entry.key,
                entry.value,
                percentage,
                _getCategoryColor(entry.key),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildStatBar(String label, int count, int percentage, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  '$count회 ($percentage%)',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<DateTime, List<VisitHistory>> _groupHistoryByDate(List<VisitHistory> history) {
    final grouped = <DateTime, List<VisitHistory>>{};
    
    for (final item in history) {
      final date = DateTime(
        item.visitedAt.year,
        item.visitedAt.month,
        item.visitedAt.day,
      );
      
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(item);
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

  Color _getCategoryColor(String category) {
    final colors = {
      '카페': Colors.brown,
      '식당': Colors.orange,
      '은행': Colors.blue,
      '병원': Colors.red,
      '약국': Colors.green,
      '쇼핑': Colors.purple,
      '마트': Colors.teal,
    };
    return colors[category] ?? Colors.grey;
  }

  void _showHistoryDetail(VisitHistory history) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              history.place.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              Icons.location_on_rounded,
              '주소',
              history.place.address,
            ),
            _buildDetailRow(
              Icons.access_time_rounded,
              '방문 시간',
              DateTimeUtils.formatDateTime(history.visitedAt),
            ),
            if (history.durationMinutes > 0)
              _buildDetailRow(
                Icons.timer_rounded,
                '체류 시간',
                '${history.durationMinutes}분',
              ),
            if (history.rating != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    '평점',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < history.rating!.floor() ? Icons.star : Icons.star_border,
                        size: 20,
                        color: Colors.amber,
                      );
                    }),
                  ),
                ],
              ),
            ],
            if (history.notes != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                '메모',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(history.notes!),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Edit history
                    },
                    icon: const Icon(Icons.edit_rounded),
                    label: const Text('수정'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Delete history
                    },
                    icon: const Icon(Icons.delete_rounded),
                    label: const Text('삭제'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
