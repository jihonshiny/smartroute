import 'package:flutter/material.dart';
import '../../../models/place.dart';
import '../../../app/theme.dart';
import '../../../utils/date_utils.dart';

class VisitHistory {
  final Place place;
  final DateTime visitedAt;
  final int durationMinutes;
  final double? rating;
  final String? notes;

  const VisitHistory({
    required this.place,
    required this.visitedAt,
    required this.durationMinutes,
    this.rating,
    this.notes,
  });
}

class VisitHistoryScreen extends StatelessWidget {
  const VisitHistoryScreen({super.key});

  List<VisitHistory> get _mockHistory => [
        VisitHistory(
          place: Place(id: '1', name: 'KB국민은행', address: '서울 강남구', lat: 37.5, lng: 127.0),
          visitedAt: DateTime.now().subtract(const Duration(hours: 3)),
          durationMinutes: 25,
          rating: 4.5,
        ),
        VisitHistory(
          place: Place(id: '2', name: '이마트', address: '서울 강남구', lat: 37.5, lng: 127.0),
          visitedAt: DateTime.now().subtract(const Duration(days: 1)),
          durationMinutes: 45,
          rating: 4.0,
        ),
        VisitHistory(
          place: Place(id: '3', name: '스타벅스', address: '서울 강남구', lat: 37.5, lng: 127.0),
          visitedAt: DateTime.now().subtract(const Duration(days: 2)),
          durationMinutes: 30,
          rating: 5.0,
          notes: '친구와 만남',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final history = _mockHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('방문 기록'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'filter', child: Text('필터')),
              const PopupMenuItem(value: 'sort', child: Text('정렬')),
              const PopupMenuItem(value: 'export', child: Text('내보내기')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final visit = history[index];
          return _buildHistoryCard(context, visit);
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, VisitHistory visit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.place_rounded, color: AppTheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(visit.place.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(visit.place.address, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(DateTimeUtils.formatRelative(visit.visitedAt), style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                const SizedBox(width: 16),
                Icon(Icons.timer_rounded, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${visit.durationMinutes}분 체류', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
            if (visit.rating != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  ...List.generate(5, (i) => Icon(
                        i < visit.rating!.floor() ? Icons.star : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      )),
                  const SizedBox(width: 8),
                  Text(visit.rating!.toStringAsFixed(1), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
            if (visit.notes != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.note_rounded, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(child: Text(visit.notes!, style: TextStyle(fontSize: 12, color: Colors.grey[700]))),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
