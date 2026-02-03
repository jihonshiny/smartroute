import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme.dart';
import 'features/map/views/main_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: SmartRouteApp()));
}

class SmartRouteApp extends ConsumerWidget {
  const SmartRouteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp(
      title: 'SmartRoute',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const MainScreen(),
    );
  }
}
