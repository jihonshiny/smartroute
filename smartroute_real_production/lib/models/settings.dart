import 'itinerary_item.dart';

class AppSettings {
  final bool notificationsEnabled;
  final bool locationEnabled;
  final bool autoOptimize;
  final bool darkMode;
  final String language;
  final String mapStyle;
  final double mapZoom;
  final TransportMode defaultTransportMode;
  final int reminderMinutes;
  final bool showTraffic;
  final bool saveHistory;
  final bool shareLocation;
  final String distanceUnit;
  final String temperatureUnit;

  const AppSettings({
    this.notificationsEnabled = true,
    this.locationEnabled = true,
    this.autoOptimize = false,
    this.darkMode = false,
    this.language = 'ko',
    this.mapStyle = 'default',
    this.mapZoom = 15.0,
    this.defaultTransportMode = TransportMode.walk,
    this.reminderMinutes = 30,
    this.showTraffic = false,
    this.saveHistory = true,
    this.shareLocation = false,
    this.distanceUnit = 'km',
    this.temperatureUnit = 'celsius',
  });

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? locationEnabled,
    bool? autoOptimize,
    bool? darkMode,
    String? language,
    String? mapStyle,
    double? mapZoom,
    TransportMode? defaultTransportMode,
    int? reminderMinutes,
    bool? showTraffic,
    bool? saveHistory,
    bool? shareLocation,
    String? distanceUnit,
    String? temperatureUnit,
  }) => AppSettings(
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        locationEnabled: locationEnabled ?? this.locationEnabled,
        autoOptimize: autoOptimize ?? this.autoOptimize,
        darkMode: darkMode ?? this.darkMode,
        language: language ?? this.language,
        mapStyle: mapStyle ?? this.mapStyle,
        mapZoom: mapZoom ?? this.mapZoom,
        defaultTransportMode: defaultTransportMode ?? this.defaultTransportMode,
        reminderMinutes: reminderMinutes ?? this.reminderMinutes,
        showTraffic: showTraffic ?? this.showTraffic,
        saveHistory: saveHistory ?? this.saveHistory,
        shareLocation: shareLocation ?? this.shareLocation,
        distanceUnit: distanceUnit ?? this.distanceUnit,
        temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      );
}
