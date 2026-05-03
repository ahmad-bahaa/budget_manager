import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/shared_preferences.dart';

final apiKeyProvider = StateNotifierProvider<ApiKeyNotifier, String>((ref) {
  return ApiKeyNotifier();
});

class ApiKeyNotifier extends StateNotifier<String> {
  ApiKeyNotifier() : super('') {
    _loadKey();
  }

  Future<void> _loadKey() async {
    state = await PreferencesService().getGeminiApiKey();
  }

  Future<void> setKey(String key) async {
    state = key;
    await PreferencesService().setGeminiApiKey(key);
  }
}
