import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});
  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _itineraryReminders = true;
  bool _reservationReminders = true;
  bool _promotions = false;
  int _reminderMinutes = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('알림 설정')),
      body: ListView(
        children: [
          SwitchListTile(title: const Text('일정 알림'), value: _itineraryReminders, onChanged: (v) => setState(() => _itineraryReminders = v)),
          SwitchListTile(title: const Text('예약 알림'), value: _reservationReminders, onChanged: (v) => setState(() => _reservationReminders = v)),
          SwitchListTile(title: const Text('프로모션'), value: _promotions, onChanged: (v) => setState(() => _promotions = v)),
          ListTile(title: const Text('알림 시간'), subtitle: Text('$_reminderMinutes분 전'), onTap: () {}),
        ],
      ),
    );
  }
}

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});
  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _locationTracking = true;
  bool _analytics = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('개인정보 설정')),
      body: ListView(
        children: [
          SwitchListTile(title: const Text('위치 추적'), value: _locationTracking, onChanged: (v) => setState(() => _locationTracking = v)),
          SwitchListTile(title: const Text('사용 통계'), value: _analytics, onChanged: (v) => setState(() => _analytics = v)),
          ListTile(leading: const Icon(Icons.download_rounded), title: const Text('내 데이터 다운로드'), onTap: () {}),
          ListTile(leading: const Icon(Icons.delete_rounded, color: Colors.red), title: const Text('계정 삭제'), onTap: () {}),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('앱 정보')), body: ListView(children: [Container(padding: const EdgeInsets.all(32), child: Column(children: [Container(width: 100, height: 100, decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]), borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.map_rounded, size: 50, color: Colors.white)), const SizedBox(height: 16), const Text('SmartRoute', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Version 1.0.0')])), const Divider(), ListTile(leading: const Icon(Icons.description_rounded), title: const Text('이용약관'), onTap: () {}), ListTile(leading: const Icon(Icons.privacy_tip_rounded), title: const Text('개인정보 처리방침'), onTap: () {}), ListTile(leading: const Icon(Icons.help_rounded), title: const Text('도움말'), onTap: () {})]));
}
