import '../models/place.dart';

class ImportService {
  Future<List<Place>> importFromGoogleMaps(String url) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  Future<List<Place>> importFromFile(String filePath) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [];
  }

  Future<List<Place>> importFromClipboard() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }
}
