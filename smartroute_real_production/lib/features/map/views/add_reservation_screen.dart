import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/place.dart';
import '../../../providers/reservation_provider.dart';
import '../../../providers/map_provider.dart';
import '../../../app/theme.dart';
import '../../../utils/extensions.dart';

class AddReservationScreen extends ConsumerStatefulWidget {
  final Place? preselectedPlace;

  const AddReservationScreen({super.key, this.preselectedPlace});

  @override
  ConsumerState<AddReservationScreen> createState() => _AddReservationScreenState();
}

class _AddReservationScreenState extends ConsumerState<AddReservationScreen> {
  Place? _selectedPlace;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _partySize = 2;
  String _notes = '';
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedPlace = widget.preselectedPlace;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('예약 추가', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 장소 선택
            const Text(
              '장소',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _showPlaceSelector(favorites),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: AppTheme.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedPlace?.name ?? '장소를 선택하세요',
                        style: TextStyle(
                          fontSize: 17,
                          color: _selectedPlace == null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 날짜 선택
            const Text(
              '날짜',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppTheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(_selectedDate),
                      style: const TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 시간 선택
            const Text(
              '시간',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectTime(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: AppTheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 인원 선택
            const Text(
              '인원',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people, color: AppTheme.primary, size: 24),
                      const SizedBox(width: 12),
                      Text('$_partySize명', style: const TextStyle(fontSize: 17)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _partySize > 1 ? () => setState(() => _partySize--) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 28,
                      ),
                      IconButton(
                        onPressed: _partySize < 20 ? () => setState(() => _partySize++) : null,
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 28,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 메모
            const Text(
              '메모 (선택사항)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '특별한 요청사항이 있으신가요?',
                prefixIcon: const Icon(Icons.note_alt_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => _notes = value,
            ),

            const SizedBox(height: 32),

            // 예약 버튼
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedPlace == null ? null : _createReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: const Text(
                  '예약하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ko', 'KR'),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _showPlaceSelector(List<Place> favorites) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '장소 선택',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: favorites.isEmpty
                    ? const Center(
                        child: Text(
                          '즐겨찾기가 없습니다\n먼저 장소를 즐겨찾기에 추가하세요',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final place = favorites[index];
                          return ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(place.name),
                            subtitle: Text(place.address),
                            onTap: () {
                              setState(() => _selectedPlace = place);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createReservation() async {
    if (_selectedPlace == null) return;

    final reservationTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    await ref.read(reservationProvider.notifier).create(
          place: _selectedPlace!,
          reservationTime: reservationTime,
          partySize: _partySize,
          notes: _notes.isEmpty ? null : _notes,
        );

    if (mounted) {
      context.showSnackBar('✅ 예약이 추가되었습니다!');
      Navigator.pop(context);
    }
  }
}
