class BackupService {
  Future<void> createBackup() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> restoreBackup(String backupId) async {
    await Future.delayed(const Duration(seconds: 3));
  }

  Future<List<Backup>> getBackups() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Backup(id: '1', createdAt: DateTime.now().subtract(const Duration(days: 1)), size: 1024 * 512),
      Backup(id: '2', createdAt: DateTime.now().subtract(const Duration(days: 7)), size: 1024 * 480),
      Backup(id: '3', createdAt: DateTime.now().subtract(const Duration(days: 30)), size: 1024 * 450),
    ];
  }

  Future<void> deleteBackup(String backupId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> enableAutoBackup() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

class Backup {
  final String id;
  final DateTime createdAt;
  final int size;

  const Backup({required this.id, required this.createdAt, required this.size});

  String get formattedSize {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}
