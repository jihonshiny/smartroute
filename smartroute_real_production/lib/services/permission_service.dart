class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  Future<bool> requestLocationPermission() async {
    print('Requesting location permission');
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<bool> requestNotificationPermission() async {
    print('Requesting notification permission');
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<bool> requestCameraPermission() async {
    print('Requesting camera permission');
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<bool> requestStoragePermission() async {
    print('Requesting storage permission');
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<bool> hasLocationPermission() async {
    return true;
  }

  Future<bool> hasNotificationPermission() async {
    return true;
  }

  Future<Map<String, bool>> getAllPermissions() async {
    return {
      'location': true,
      'notification': true,
      'camera': false,
      'storage': false,
    };
  }
}
