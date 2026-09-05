import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JapaCounter extends StatefulWidget {
  const JapaCounter({super.key});

  @override
  State<JapaCounter> createState() => _JapaCounterState();
}

class _JapaCounterState extends State<JapaCounter> {
  int _count = 0;
  int _target = 108;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt('japa_count') ?? 0;
      _target = prefs.getInt('japa_target') ?? 108;
    });
  }

  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('japa_count', _count);
    await prefs.setInt('japa_target', _target);
  }

  void _increment() {
    HapticFeedback.mediumImpact();
    setState(() {
      _count++;
      _saveCount();
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
      _saveCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Japa Counter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              DropdownButton<int>(
                value: _target,
                items: [108, 1008].map((e) => DropdownMenuItem(value: e, child: Text('Target: $e'))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _target = val;
                      _saveCount();
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _increment,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _count / _target,
                    strokeWidth: 8,
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_count',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text('/ $_target', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
