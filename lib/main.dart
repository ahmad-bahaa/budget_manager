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
    const ProviderScope(
      child: BudgetApp(),
    ),
  );
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Budget Pro',
      debugShowCheckedModeBanner: false,

      // --- Theme Configuration ---
      // Light Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.grey[900],
          surfaceTintColor: Colors.transparent,
        ),
      ),

      // Uses the system setting for Light/Dark mode
      themeMode: ThemeMode.system,

      home: const DashboardScreen(),
    );
  }
}