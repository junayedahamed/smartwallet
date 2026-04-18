import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {
  SettingsController._();
  static SettingsController instance = SettingsController._();
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  
  String _locale = 'en';
  String get locale => _locale;

  String _currency = '৳';
  String get currency => _currency;

  void setThemeMode(ThemeMode value) {
    if (value == _themeMode) {
      return;
    }
    _themeMode = value;
    notifyListeners();
    _updateThemeMode(value);
  }

  void setLocale(String value) {
    if (value == _locale) return;
    _locale = value;
    notifyListeners();
    _saveString("localeKey", value);
  }

  void setCurrency(String value) {
    if (value == _currency) return;
    _currency = value;
    notifyListeners();
    _saveString("currencyKey", value);
  }

  Future<void> loadSettings() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int index = pref.getInt("theme") ?? 0;
    _themeMode = ThemeMode.values[index % 3];
    
    _locale = pref.getString("localeKey") ?? 'en';
    _currency = pref.getString("currencyKey") ?? '৳';
    
    notifyListeners();
  }

  Future<void> _updateThemeMode(ThemeMode value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("theme", value.index);
  }

  Future<void> _saveString(String key, String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }
}
