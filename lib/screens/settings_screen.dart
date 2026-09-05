import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mantra_app/providers/theme_provider.dart';
import 'package:mantra_app/providers/font_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final fontProvider = context.watch<FontProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Theme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        RadioListTile<String>(
          title: const Text('Temple (Saffron Dark)'),
          subtitle: const Text('Default sacred theme'),
          value: 'temple',
          groupValue: themeProvider.themeName,
          onChanged: (v) => themeProvider.setTheme(v!),
        ),
        RadioListTile<String>(
          title: const Text('Dark'),
          value: 'dark',
          groupValue: themeProvider.themeName,
          onChanged: (v) => themeProvider.setTheme(v!),
        ),
        RadioListTile<String>(
          title: const Text('Light'),
          value: 'light',
          groupValue: themeProvider.themeName,
          onChanged: (v) => themeProvider.setTheme(v!),
        ),
        const Divider(height: 32),
        const Text('Font Size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Slider(
          value: fontProvider.fontScale,
          min: 0.8,
          max: 1.6,
          divisions: 8,
          label: '${(fontProvider.fontScale * 100).round()}%',
          onChanged: (v) => fontProvider.setFontScale(v),
        ),
        Center(
          child: Text(
            'ಮಂತ್ರ ಸಂಗ್ರಹ - Preview',
            style: TextStyle(fontSize: 18 * fontProvider.fontScale),
          ),
        ),
        const Divider(height: 32),
        const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('Mantra Sangraha'),
          subtitle: Text('Version 1.0.0\n3 books • 54 chapters\nOffline mantra library'),
        ),
      ],
    );
  }
}
