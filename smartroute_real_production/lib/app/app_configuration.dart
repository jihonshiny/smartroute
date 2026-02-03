class AppConfiguration {
  // Map Settings
  static const double defaultMapZoom = 15.0;
  static const double minMapZoom = 5.0;
  static const double maxMapZoom = 20.0;
  static const int maxMarkersOnMap = 50;
  static const Duration markerAnimationDuration = Duration(milliseconds: 300);
  
  // Route Settings
  static const double maxRouteDistance = 100.0;
  static const int maxWaypoints = 10;
  static const double walkingSpeed = 4.0;
  static const double drivingSpeed = 40.0;
  static const int routeCalculationTimeout = 30;
  
  // Search Settings
  static const int maxSearchResults = 50;
  static const int recentSearchLimit = 10;
  static const Duration searchDebounce = Duration(milliseconds: 500);
  
  // Cache Settings
  static const int maxCacheSize = 100;
  static const Duration cacheDuration = Duration(hours: 24);
  
  // UI Settings
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Notification Settings
  static const int defaultReminderMinutes = 30;
  static const int maxNotifications = 100;
  
  // API Settings
  static const int apiTimeout = 30;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
}
