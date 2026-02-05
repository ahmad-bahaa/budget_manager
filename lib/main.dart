import 'package:budget_manager/providers/budget_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before database setup
  WidgetsFlutterBinding.ensureInitialized();

  // // 1. Initialize Notification Service
  // final notificationService = NotificationService();
  // await notificationService.init();
  //
  // // 2. Request Permissions (Android 13+) & Schedule
  // await notificationService.requestPermissions();
  // await notificationService.scheduleDailyNotification();

  runApp(
    // ProviderScope is required to store the state of all Riverpod providers
    const ProviderScope(child: BudgetApp()),
  );
}

class BudgetApp extends ConsumerWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final colorSeed = ref.watch(themeColorProvider);
    return MaterialApp(
      title: 'Personal Budget Pro',
      debugShowCheckedModeBanner: false,
      // Dynamic Theme Mode (Light/Dark/System)
      themeMode: themeMode,
      // --- Theme Configuration ---
      // Light Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorSeed,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: colorSeed,
          foregroundColor: Colors.white,
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorSeed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,

        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.grey[900],
          surfaceTintColor: Colors.transparent,
        ),
      ),

      home: const DashboardScreen(),
    );
  }
}
