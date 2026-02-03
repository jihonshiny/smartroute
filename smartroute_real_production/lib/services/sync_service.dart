import 'dart:async';

class SyncService {
  final StreamController<SyncStatus> _statusController = StreamController.broadcast();
  
  Stream<SyncStatus> get statusStream => _statusController.stream;
  
  Future<void> syncData() async {
    _statusController.add(SyncStatus.syncing);
    await Future.delayed(const Duration(seconds: 2));
    _statusController.add(SyncStatus.completed);
  }

  Future<void> enableAutoSync() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> disableAutoSync() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void dispose() {
    _statusController.close();
  }
}

enum SyncStatus { idle, syncing, completed, failed }
