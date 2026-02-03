import 'package:flutter/material.dart';
import '../../app/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingPage> _pages = [
    const OnboardingPage(title: 'SmartRoute에 오신 것을 환영합니다', description: 'AI 기반 경로 최적화로 시간과 비용을 절약하세요', icon: Icons.map_rounded, color: Color(0xFF3A86FF)),
    const OnboardingPage(title: '똑똑한 일정 관리', description: '드래그 앤 드롭으로 쉽게 일정을 관리하고 AI가 최적화합니다', icon: Icons.auto_awesome_rounded, color: Color(0xFF06D6A0)),
    const OnboardingPage(title: '대중교통 통합 검색', description: '버스, 지하철, 도보 경로를 한눈에 비교하세요', icon: Icons.directions_bus_rounded, color: Color(0xFFFF6B6B)),
    const OnboardingPage(title: '예약 및 알림', description: '장소 예약과 알림 기능으로 일정을 놓치지 마세요', icon: Icons.notifications_active_rounded, color: Color(0xFFFFD93D)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Column(children: [Expanded(child: PageView.builder(controller: _pageController, itemCount: _pages.length, onPageChanged: (index) => setState(() => _currentPage = index), itemBuilder: (context, index) => _buildPage(_pages[index]))), Padding(padding: const EdgeInsets.all(24), child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_pages.length, (index) => Container(margin: const EdgeInsets.symmetric(horizontal: 4), width: _currentPage == index ? 24 : 8, height: 8, decoration: BoxDecoration(color: _currentPage == index ? AppTheme.primary : Colors.grey[300], borderRadius: BorderRadius.circular(4))))), const SizedBox(height: 32), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {if (_currentPage == _pages.length - 1) {Navigator.pushReplacementNamed(context, '/');} else {_pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);}}, style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)), child: Text(_currentPage == _pages.length - 1 ? '시작하기' : '다음'))), if (_currentPage < _pages.length - 1) TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/'), child: const Text('건너뛰기'))]))])));
  }

  Widget _buildPage(OnboardingPage page) => Padding(padding: const EdgeInsets.all(40), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(width: 200, height: 200, decoration: BoxDecoration(color: page.color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(page.icon, size: 100, color: page.color)), const SizedBox(height: 48), Text(page.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center), const SizedBox(height: 16), Text(page.description, style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5), textAlign: TextAlign.center)]));

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title, description;
  final IconData icon;
  final Color color;
  const OnboardingPage({required this.title, required this.description, required this.icon, required this.color});
}
