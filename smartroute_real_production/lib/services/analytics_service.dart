class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    print('Event: $eventName ${parameters != null ? parameters.toString() : ''}');
  }

  void logScreenView(String screenName) {
    print('Screen: $screenName');
  }

  void logSearch(String query) {
    logEvent('search', parameters: {'query': query});
  }

  void logPlaceView(String placeId, String placeName) {
    logEvent('place_view', parameters: {'place_id': placeId, 'place_name': placeName});
  }

  void logRouteOptimized(int placeCount, int timeSaved) {
    logEvent('route_optimized', parameters: {'place_count': placeCount, 'time_saved': timeSaved});
  }

  void logReservationCreated(String placeName) {
    logEvent('reservation_created', parameters: {'place_name': placeName});
  }
}
