import 'package:budget_manager/providers/budget_providers.dart';
import 'package:budget_manager/providers/language_provider.dart';
import 'package:budget_manager/screens/onboarding_screen.dart';
import 'package:budget_manager/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensure Flutter bindings are initialized before database setup
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();

  // Check if the user has seen the onboarding screen
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('has_seen_onboarding') ?? false;
  ShowcaseView.register(
    // options
  );
  runApp(
    // ProviderScope is required to store the state of all Riverpod providers
    ProviderScope(child: BudgetApp(showHome: showHome)),
  );
}

class BudgetApp extends ConsumerWidget {
  final bool showHome;

  const BudgetApp({required this.showHome, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final colorSeed = ref.watch(themeColorProvider);
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      locale: currentLocale,
      // This is crucial for RTL support
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

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

      home: showHome ? SplashScreen() : OnboardingScreen(),
    );
  }
}
