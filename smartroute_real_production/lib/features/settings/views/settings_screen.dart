import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _location = true;
  bool _autoOptimize = false;
  bool _darkMode = false;
  String _language = '한국어';
  String _theme = '라이트';
  double _mapZoom = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          _section('알림'),
          SwitchListTile(
            title: const Text('푸시 알림'),
            subtitle: const Text('일정 및 예약 알림 받기'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          SwitchListTile(
            title: const Text('일정 시작 알림'),
            subtitle: const Text('일정 시작 30분 전 알림'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
            secondary: const Icon(Icons.schedule_rounded),
          ),
          SwitchListTile(
            title: const Text('예약 알림'),
            subtitle: const Text('예약 1시간 전 알림'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
            secondary: const Icon(Icons.book_online_rounded),
          ),
          _section('위치'),
          SwitchListTile(
            title: const Text('위치 서비스'),
            subtitle: const Text('현재 위치를 사용하여 장소 추천'),
            value: _location,
            onChanged: (v) => setState(() => _location = v),
          ),
          ListTile(
            title: const Text('위치 정확도'),
            subtitle: Text(_location ? '높음' : '낮음'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          _section('일정'),
          SwitchListTile(
            title: const Text('자동 최적화'),
            subtitle: const Text('일정 추가 시 자동으로 최적화'),
            value: _autoOptimize,
            onChanged: (v) => setState(() => _autoOptimize = v),
          ),
          ListTile(
            title: const Text('기본 이동 수단'),
            subtitle: const Text('도보'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showTransportModeDialog,
          ),
          ListTile(
            title: const Text('알림 시간'),
            subtitle: const Text('30분 전'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          _section('지도'),
          ListTile(
            title: const Text('지도 스타일'),
            subtitle: const Text('기본'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          ListTile(
            title: Text('기본 확대/축소 레벨: ${_mapZoom.toInt()}'),
            subtitle: Slider(
              value: _mapZoom,
              min: 10,
              max: 20,
              divisions: 10,
              onChanged: (v) => setState(() => _mapZoom = v),
            ),
          ),
          _section('테마'),
          SwitchListTile(
            title: const Text('다크 모드'),
            subtitle: const Text('어두운 테마 사용'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          ListTile(
            title: const Text('언어'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _showLanguageDialog,
          ),
          _section('계정'),
          ListTile(
            title: const Text('프로필 편집'),
            leading: const Icon(Icons.person_rounded),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          ListTile(
            title: const Text('비밀번호 변경'),
            leading: const Icon(Icons.lock_rounded),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          ListTile(
            title: const Text('연결된 계정'),
            subtitle: const Text('Google, Apple'),
            leading: const Icon(Icons.link_rounded),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          _section('데이터'),
          ListTile(
            title: const Text('캐시 삭제'),
            subtitle: const Text('저장된 데이터 삭제 (256MB)'),
            leading: const Icon(Icons.delete_rounded),
            onTap: _showClearCacheDialog,
          ),
          ListTile(
            title: const Text('데이터 내보내기'),
            subtitle: const Text('내 데이터 다운로드'),
            leading: const Icon(Icons.download_rounded),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          _section('앱 정보'),
          ListTile(
            title: const Text('버전'),
            subtitle: const Text('1.0.0'),
            leading: const Icon(Icons.info_rounded),
          ),
          ListTile(
            title: const Text('서비스 약관'),
            leading: const Icon(Icons.description_rounded),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          ListTile(
            title: const Text('개인정보 처리방침'),
            leading: const Icon(Icons.privacy_tip_rounded),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          ListTile(
            title: const Text('오픈소스 라이선스'),
            leading: const Icon(Icons.code_rounded),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('로그아웃'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.delete_forever_rounded),
              label: const Text('계정 삭제'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary)),
      );

  void _showTransportModeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('기본 이동 수단'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['도보', '자동차', '버스', '지하철', '자전거'].map((mode) => RadioListTile<String>(value: mode, groupValue: '도보', onChanged: (v) => Navigator.pop(context), title: Text(mode))).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('언어 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['한국어', 'English', '日本語', '中文'].map((lang) => RadioListTile<String>(value: lang, groupValue: _language, onChanged: (v) {setState(() => _language = v!); Navigator.pop(context);}, title: Text(lang))).toList(),
        ),
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('캐시 삭제'),
        content: const Text('캐시를 삭제하시겠습니까?\n저장된 지도 데이터가 삭제됩니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          ElevatedButton(onPressed: () {Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('캐시가 삭제되었습니다')));}, child: const Text('삭제')),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('로그아웃 하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          ElevatedButton(onPressed: () {}, child: const Text('로그아웃')),
        ],
      ),
    );
  }
}
