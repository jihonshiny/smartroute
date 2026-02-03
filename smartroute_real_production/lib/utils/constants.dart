class AppConstants {
  // API
  static const int apiTimeout = 30;
  static const int maxRetries = 3;

  // Pagination
  static const int itemsPerPage = 20;
  static const int maxSearchResults = 50;

  // Map
  static const double defaultZoom = 15.0;
  static const double minZoom = 5.0;
  static const double maxZoom = 20.0;
  static const int markerAnimationDuration = 300;

  // Route
  static const double maxRouteDistanceKm = 100.0;
  static const int maxWaypointsPerRoute = 10;
  static const double avgWalkingSpeedKmh = 4.0;
  static const double avgDrivingSpeedKmh = 40.0;

  // Cache
  static const int cacheDurationHours = 24;
  static const int maxCacheSize = 100;

  // Animation
  static const int shortAnimationMs = 200;
  static const int mediumAnimationMs = 300;
  static const int longAnimationMs = 500;

  // Notifications
  static const int reminderMinutesBefore = 20;
  static const int reservationReminderMinutes = 30;
}

class RouteConstants {
  static const String home = '/';
  static const String map = '/map';
  static const String itinerary = '/itinerary';
  static const String transit = '/transit';
  static const String reservation = '/reservation';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String statistics = '/statistics';
  static const String placeDetail = '/place-detail';
  static const String search = '/search';
}

class PreferenceKeys {
  static const String theme = 'theme';
  static const String language = 'language';
  static const String notifications = 'notifications';
  static const String locationPermission = 'location_permission';
  static const String autoOptimize = 'auto_optimize';
  static const String lastLocation = 'last_location';
  static const String recentSearches = 'recent_searches';
  static const String favorites = 'favorites';
}
