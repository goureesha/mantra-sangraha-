import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  String _themeName = 'temple';

  String get themeName => _themeName;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _themeName = prefs.getString('theme_mode') ?? 'temple';
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    if (_themeName != theme) {
      _themeName = theme;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_mode', theme);
      notifyListeners();
    }
  }
}
