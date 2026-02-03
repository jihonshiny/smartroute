import '../models/itinerary_item.dart';
import '../models/visit_history.dart';

class ExportService {
  Future<String> exportItineraryToJSON(List<ItineraryItem> items) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return '';
  }

  Future<String> exportHistoryToCSV(List<VisitHistory> history) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return '';
  }

  Future<void> exportToPDF(List<ItineraryItem> items) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> exportToCalendar(List<ItineraryItem> items) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
