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

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Theme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          RadioListTile<String>(
            title: const Text('Temple (Dark Saffron)'),
            value: 'temple',
            groupValue: themeProvider.themeName,
            onChanged: (val) => themeProvider.setTheme(val!),
          ),
          RadioListTile<String>(
            title: const Text('Dark'),
            value: 'dark',
            groupValue: themeProvider.themeName,
            onChanged: (val) => themeProvider.setTheme(val!),
          ),
          RadioListTile<String>(
            title: const Text('Light'),
            value: 'light',
            groupValue: themeProvider.themeName,
            onChanged: (val) => themeProvider.setTheme(val!),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Font Size', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Slider(
            value: fontProvider.fontScale,
            min: 0.8,
            max: 1.6,
            divisions: 8,
            label: '${fontProvider.fontScale.toStringAsFixed(1)}x',
            onChanged: (val) => fontProvider.setFontScale(val),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'ನಮಸ್ಕಾರ (Preview text)',
              style: TextStyle(fontSize: 16 * fontProvider.fontScale),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('About'),
            subtitle: Text('Mantra Sangraha v1.0.0\nSpiritual book reader app.'),
          ),
        ],
      ),
    );
  }
}
