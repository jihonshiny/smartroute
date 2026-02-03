import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {'icon': Icons.map_rounded, 'title': '스마트 경로 추천', 'desc': 'AI가 최적의 경로를 자동으로 계산합니다', 'color': AppTheme.primary},
    {'icon': Icons.list_alt_rounded, 'title': '편리한 일정 관리', 'desc': '드래그 앤 드롭으로 간편하게 관리하세요', 'color': AppTheme.accent},
    {'icon': Icons.directions_bus_rounded, 'title': '대중교통 통합', 'desc': '버스, 지하철 경로를 한번에 비교하세요', 'color': Colors.orange},
    {'icon': Icons.book_online_rounded, 'title': '간편한 예약', 'desc': '원하는 장소를 미리 예약하세요', 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (ctx, i) => _buildPage(_pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? AppTheme.primary : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: _currentPage < _pages.length - 1
                        ? ElevatedButton(
                            onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                            child: const Text('다음'),
                          )
                        : ElevatedButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                            child: const Text('시작하기'),
                          ),
                  ),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                      child: const Text('건너뛰기'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(colors: [(page['color'] as Color).withValues(alpha: 0.3), (page['color'] as Color).withValues(alpha: 0.1)]),
              shape: BoxShape.circle,
            ),
            child: Icon(page['icon'] as IconData, size: 100, color: page['color'] as Color),
          ),
          const SizedBox(height: 48),
          Text(page['title'] as String, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(page['desc'] as String, style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
