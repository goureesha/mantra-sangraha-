import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider with ChangeNotifier {
  double _fontScale = 1.0;

  double get fontScale => _fontScale;

  FontProvider() {
    _loadFontScale();
  }

  Future<void> _loadFontScale() async {
    final prefs = await SharedPreferences.getInstance();
    _fontScale = prefs.getDouble('font_scale') ?? 1.0;
    notifyListeners();
  }

  Future<void> setFontScale(double scale) async {
    if (scale < 0.8) scale = 0.8;
    if (scale > 1.6) scale = 1.6;
    if (_fontScale != scale) {
      _fontScale = scale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('font_scale', scale);
      notifyListeners();
    }
  }

  void increment() => setFontScale(_fontScale + 0.1);
  void decrement() => setFontScale(_fontScale - 0.1);
}
