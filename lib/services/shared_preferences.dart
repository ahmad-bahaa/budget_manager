
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _currencyKey = 'currency_symbol';
  static const String _dateFormatKey = 'date_format';
  static const String _themeModeKey = 'theme_mode';
  static const String _colorSeedKey = 'color_seed';

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