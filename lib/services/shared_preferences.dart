
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _currencyKey = 'currency_symbol';
  static const String _dateFormatKey = 'date_format';

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