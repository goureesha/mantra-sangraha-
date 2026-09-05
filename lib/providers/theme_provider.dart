import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  String _themeName = 'temple';

  ThemeProvider() {
    _loadTheme();
  }

  String get themeName => _themeName;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _themeName = prefs.getString('theme') ?? 'temple';
    notifyListeners();
  }

  Future<void> setTheme(String name) async {
    _themeName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', name);
    notifyListeners();
  }
}
