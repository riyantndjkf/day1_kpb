import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Highscore extends StatelessWidget {
  const Highscore({super.key});

  Future<Map<String, Object>> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user': prefs.getString('top_user') ?? '-',
      'point': prefs.getInt('top_point') ?? 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('High Score')),
      body: FutureBuilder<Map<String, Object>>(
        future: _loadHighScore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final highScore = snapshot.data ?? {'user': '-', 'point': 0};
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, size: 72),
                const SizedBox(height: 16),
                Text(
                  highScore['user'] as String,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text('Point: ${highScore['point']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
