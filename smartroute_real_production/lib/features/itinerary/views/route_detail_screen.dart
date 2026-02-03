import 'package:flutter/material.dart';
import '../../../models/route.dart';
import '../../../models/itinerary_item.dart';
import '../../../app/theme.dart';

class RouteDetailScreen extends StatelessWidget {
  final RouteModel route;
  const RouteDetailScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('경로 상세')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (route.isOptimized)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                      child: const Text('AI 최적화 완료', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _stat(Icons.place_rounded, '${route.items.length}개'),
                      _stat(Icons.access_time_rounded, route.formattedDuration),
                      _stat(Icons.straighten_rounded, route.formattedDistance),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...route.items.asMap().entries.map((e) => _placeCard(e.value, e.key + 1)),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String text) => Column(children: [Icon(icon, color: AppTheme.primary), const SizedBox(height: 8), Text(text, style: const TextStyle(fontWeight: FontWeight.w600))]);
  
  Widget _placeCard(ItineraryItem item, int order) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: CircleAvatar(backgroundColor: AppTheme.primary, child: Text('$order', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          title: Text(item.place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(item.place.address),
        ),
      );
}
