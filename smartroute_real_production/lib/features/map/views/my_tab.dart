import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/itinerary_provider.dart';
import '../../../providers/reservation_provider.dart';
import '../../../providers/map_provider.dart';
import '../../../utils/extensions.dart';

class MyTab extends ConsumerWidget {
  const MyTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final itineraryState = ref.watch(itineraryProvider);
    final reservationState = ref.watch(reservationProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 섹션
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                    ? [AppTheme.darkPrimary, AppTheme.darkSecondary]
                    : [AppTheme.primary, AppTheme.secondary],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'SmartRoute 사용자',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'smartroute@example.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // 통계 카드
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.place,
                      title: '일정',
                      count: itineraryState.items.length,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.favorite,
                      title: '즐겨찾기',
                      count: favorites.length,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.book_online,
                      title: '예약',
                      count: reservationState.reservations.length,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // 설정 목록
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    context: context,
                    icon: isDark ? Icons.light_mode : Icons.dark_mode,
                    title: '다크 모드',
                    trailing: Switch(
                      value: isDark,
                      onChanged: (value) {
                        ref.read(themeModeProvider.notifier).toggleTheme();
                      },
                    ),
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    context: context,
                    icon: Icons.notifications,
                    title: '알림',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.showSnackBar('알림 설정 준비중입니다');
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    context: context,
                    icon: Icons.language,
                    title: '언어',
                    subtitle: '한국어',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.showSnackBar('언어 설정 준비중입니다');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 앱 정보
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    context: context,
                    icon: Icons.info,
                    title: '앱 정보',
                    subtitle: 'Version 1.0.0',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showAppInfo(context);
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    context: context,
                    icon: Icons.help,
                    title: '도움말',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.showSnackBar('도움말 준비중입니다');
                    },
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    context: context,
                    icon: Icons.privacy_tip,
                    title: '개인정보 처리방침',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.showSnackBar('개인정보 처리방침 준비중입니다');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 로그아웃 버튼 (디자인용)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: () {
                  context.showSnackBar('로그인 기능은 준비중입니다');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 60);
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SmartRoute'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('버전: 1.0.0'),
            const SizedBox(height: 8),
            const Text('생활 일정 최적화 네비게이션 앱'),
            const SizedBox(height: 16),
            const Text('개발자 정보', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('© 2026 SmartRoute'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
