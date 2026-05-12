import 'package:budget_manager/firebase_options.dart';
import 'package:budget_manager/providers/budget_providers.dart';
import 'package:budget_manager/providers/language_provider.dart';
import 'package:budget_manager/screens/onboarding_screen.dart';
import 'package:budget_manager/screens/splash_screen.dart';
import 'package:budget_manager/services/home_widget_service.dart';
import 'package:budget_manager/screens/add_transaction_screen.dart';
import 'package:budget_manager/providers/home_widget_provider.dart';
import 'package:budget_manager/utils/transparent_route.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Ensure Flutter bindings are initialized before database setup
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    try {
      // Initialize the database factory for web WITHOUT a web worker
      // This avoids the dependency on sqflite_sw.js
      databaseFactory = createDatabaseFactoryFfiWeb(
        noWebWorker: true,
        options: SqfliteFfiWebOptions(
          sqlite3WasmUri: Uri.parse('sqlite3.wasm'),
        ),
      );
    } catch (e) {
      debugPrint('Error initializing database factory for web: $e');
    }
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

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

class BudgetApp extends ConsumerStatefulWidget {
  final bool showHome;

  const BudgetApp({required this.showHome, super.key});

  @override
  ConsumerState<BudgetApp> createState() => _BudgetAppState();
}

class _BudgetAppState extends ConsumerState<BudgetApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    HomeWidgetService.init(_onWidgetClick);
  }

  void _onWidgetClick(Uri? uri) {
    if (uri == null) return;
    
    Future.delayed(const Duration(milliseconds: 500), () {
      final context = navigatorKey.currentContext;
      if (context == null) return;

      if (uri.host == 'add_transaction') {
        // Push a transparent route that shows the bottom sheet
        navigatorKey.currentState?.push(
          TransparentRoute(
            builder: (ctx) => Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(), // Empty, bottom sheet will slide over
              ),
            ),
          ),
        );

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => const AddTransactionScreen(),
        ).then((_) {
          // When the bottom sheet is closed, if we are in this special mode,
          // close the app to return to the home screen.
          if (navigatorKey.currentState?.canPop() ?? false) {
             navigatorKey.currentState?.pop(); // Pop the transparent route
          }
          SystemNavigator.pop(); // Close the app
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeWidgetSyncProvider, (previous, next) {});
    
    final themeMode = ref.watch(themeModeProvider);
    final colorSeed = ref.watch(themeColorProvider);
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
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

      home: widget.showHome ? SplashScreen() : OnboardingScreen(),
    );
  }
}
