import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PreferencesService {
  static const String _currencyKey = 'currency_symbol';
  static const String _dateFormatKey = 'date_format';
  static const String _themeModeKey = 'theme_mode';
  static const String _colorSeedKey = 'color_seed';
  static const String _cycleStartDayKey = 'cycle_start_day';
  static const String _geminiApiKey = 'gemini_api_key';
  static const String _lastUpdatedKey = 'last_updated';

  final _secureStorage = const FlutterSecureStorage();

  Future<void> updateLastUpdated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastUpdatedKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<DateTime> getLastUpdated() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_lastUpdatedKey) ?? 0;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<Map<String, dynamic>> getAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      _currencyKey: prefs.getString(_currencyKey),
      _dateFormatKey: prefs.getString(_dateFormatKey),
      _themeModeKey: prefs.getString(_themeModeKey),
      _colorSeedKey: prefs.getInt(_colorSeedKey),
      _cycleStartDayKey: prefs.getInt(_cycleStartDayKey),
    };
  }

  Future<void> restoreSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    if (settings[_currencyKey] != null)
      await prefs.setString(_currencyKey, settings[_currencyKey]);
    if (settings[_dateFormatKey] != null)
      await prefs.setString(_dateFormatKey, settings[_dateFormatKey]);
    if (settings[_themeModeKey] != null)
      await prefs.setString(_themeModeKey, settings[_themeModeKey]);
    if (settings[_colorSeedKey] != null)
      await prefs.setInt(_colorSeedKey, settings[_colorSeedKey]);
    if (settings[_cycleStartDayKey] != null)
      await prefs.setInt(_cycleStartDayKey, settings[_cycleStartDayKey]);
  }

  Future<void> setGeminiApiKey(String key) async {
    await _secureStorage.write(key: _geminiApiKey, value: key);
  }

  Future<String> getGeminiApiKey() async {
    return await _secureStorage.read(key: _geminiApiKey) ?? '';
  }

  Future<void> setCycleStartDay(int day) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_cycleStartDayKey, day);
  }

  Future<int> getCycleStartDay() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_cycleStartDayKey) ?? 1; // Default to 1st
  }

  // 1. THEME MODE (Saved as String: 'system', 'light', 'dark')
  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString());
  }

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_themeModeKey);
    if (savedMode == 'ThemeMode.light') return ThemeMode.light;
    if (savedMode == 'ThemeMode.dark') return ThemeMode.dark;
    return ThemeMode.system; // Default
  }

  // 2. PRIMARY COLOR (Saved as Integer)
  Future<void> setColorSeed(int colorValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorSeedKey, colorValue);
  }

  Future<int> getColorSeed() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to Green (0xFF4CAF50) if nothing is saved
    return prefs.getInt(_colorSeedKey) ?? 0xFF4CAF50;
  }

  // Save Currency
  Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
  }

  // Get Currency (Default to $)
  Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey) ?? '\$';
  }

  // Save Date Format
  Future<void> setDateFormat(String format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dateFormatKey, format);
  }

  // Get Date Format (Default to MM/dd/yyyy)
  Future<String> getDateFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dateFormatKey) ?? 'MM/dd/yyyy';
  }
}
