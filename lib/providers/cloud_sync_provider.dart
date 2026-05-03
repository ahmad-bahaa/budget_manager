import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_helper.dart';
import '../services/firebase_sync_service.dart';
import '../services/shared_preferences.dart';
import 'api_key_provider.dart';
import 'budget_providers.dart';
import 'savings_goals_provider.dart';

enum SyncStatus { idle, syncing, success, error, noConnection }

class CloudSyncState {
  final SyncStatus status;
  final String? userEmail;
  final DateTime? lastSynced;
  final String? errorMessage;

  CloudSyncState({
    required this.status,
    this.userEmail,
    this.lastSynced,
    this.errorMessage,
  });

  CloudSyncState copyWith({
    SyncStatus? status,
    String? userEmail,
    DateTime? lastSynced,
    String? errorMessage,
  }) {
    return CloudSyncState(
      status: status ?? this.status,
      userEmail: userEmail ?? this.userEmail,
      lastSynced: lastSynced ?? this.lastSynced,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CloudSyncNotifier extends StateNotifier<CloudSyncState> {
  final Ref ref;
  final FirebaseSyncService _syncService = FirebaseSyncService();
  final PreferencesService _prefs = PreferencesService();

  CloudSyncNotifier(this.ref)
      : super(CloudSyncState(status: SyncStatus.idle)) {
    _init();
  }

  Future<void> _init() async {
    final user = await _syncService.signInSilently();
    if (user != null) {
      state = state.copyWith(userEmail: user.email);
    }
  }

  Future<void> signIn() async {
    try {
      final user = await _syncService.signIn();
      if (user != null) {
        state = state.copyWith(userEmail: user.email);
      }
    } catch (e) {
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await _syncService.signOut();
    state = CloudSyncState(status: SyncStatus.idle);
  }

  Future<void> syncNow() async {
    print('CloudSyncNotifier: Starting syncNow()');
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      print('CloudSyncNotifier: No internet connection');
      state = state.copyWith(status: SyncStatus.noConnection);
      return;
    }

    state = state.copyWith(status: SyncStatus.syncing);

    try {
      print('CloudSyncNotifier: Downloading data from Firebase');
      final cloudData = await _syncService.downloadData();
      final localLastUpdated = await _prefs.getLastUpdated();
      print('CloudSyncNotifier: Local last updated: $localLastUpdated');

      if (cloudData == null) {
        print('CloudSyncNotifier: No cloud data found, uploading local data');
        await _uploadLocalData();
      } else {
        final cloudLastUpdated =
            DateTime.fromMillisecondsSinceEpoch(cloudData['last_updated'] ?? 0);
        print('CloudSyncNotifier: Cloud last updated: $cloudLastUpdated');

        if (cloudLastUpdated.isAfter(localLastUpdated)) {
          print('CloudSyncNotifier: Cloud data is newer, applying to local');
          await _applyCloudData(cloudData);
        } else if (localLastUpdated.isAfter(cloudLastUpdated)) {
          print('CloudSyncNotifier: Local data is newer, uploading to cloud');
          await _uploadLocalData();
        } else {
          print('CloudSyncNotifier: Local and cloud data are in sync');
        }
      }

      state = state.copyWith(
        status: SyncStatus.success,
        lastSynced: DateTime.now(),
      );
      print('CloudSyncNotifier: syncNow() completed successfully');
    } catch (e, stack) {
      print('CloudSyncNotifier: Error during syncNow(): $e');
      print('CloudSyncNotifier: Stack trace: $stack');
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _uploadLocalData() async {
    print('CloudSyncNotifier: _uploadLocalData() started');
    final data = await _serializeLocalData();
    print('CloudSyncNotifier: Data serialized, uploading to Firebase');
    await _syncService.uploadData(data);
    print('CloudSyncNotifier: _uploadLocalData() finished');
  }

  Future<Map<String, dynamic>> _serializeLocalData() async {
    final db = DatabaseHelper.instance;
    final categories = await db.getAllCategories();
    final transactions = await db.getAllTransactions();
    final savingsGoals = ref.read(savingsGoalsProvider);
    final settings = await _prefs.getAllSettings();
    final lastUpdated = await _prefs.getLastUpdated();
    final geminiApiKey = ref.read(apiKeyProvider);

    return {
      'categories': categories.map((c) => c.toMap()).toList(),
      'transactions': transactions.map((t) => t.toMap()).toList(),
      'savings_goals': savingsGoals.map((g) => g.toMap()).toList(),
      'settings': settings,
      'gemini_api_key': geminiApiKey,
      'last_updated': lastUpdated.millisecondsSinceEpoch,
    };
  }

  Future<void> _applyCloudData(Map<String, dynamic> data) async {
    final db = DatabaseHelper.instance;
    final dbInstance = await db.database;
    await dbInstance.transaction((txn) async {
      await txn.delete('transactions');
      await txn.delete('categories');
      for (var catMap in data['categories']) {
        await txn.insert('categories', catMap);
      }
      for (var txMap in data['transactions']) {
        await txn.insert('transactions', txMap);
      }
    });

    final List<dynamic> goalsRaw = data['savings_goals'] ?? [];
    final goalsJson = json.encode(goalsRaw);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savings_goals', goalsJson);

    await _prefs.restoreSettings(data['settings'] ?? {});
    
    final String cloudApiKey = data['gemini_api_key'] ?? '';
    if (cloudApiKey.isNotEmpty) {
      await ref.read(apiKeyProvider.notifier).setKey(cloudApiKey);
    }

    await prefs.setInt('last_updated', data['last_updated']);

    ref.invalidate(categoriesProvider);
    ref.invalidate(transactionsProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(currencyProvider);
    ref.invalidate(dateFormatProvider);
    ref.invalidate(themeModeProvider);
    ref.invalidate(themeColorProvider);
    ref.invalidate(cycleStartDayProvider);
    ref.invalidate(apiKeyProvider);
  }
}

final cloudSyncProvider =
    StateNotifierProvider<CloudSyncNotifier, CloudSyncState>((ref) {
  return CloudSyncNotifier(ref);
});
