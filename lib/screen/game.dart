import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../main.dart';

class _Ant {
  _Ant({required this.x, required this.y, required this.dx, required this.dy});

  double x;
  double y;
  double dx;
  double dy;
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int _hitung = 30;
  int _initValue = 30;
  late Timer _timer;
  late Timer _timer2;
  int _point = 0;
  bool _gameOver = false;
  final Random _random = Random();
  final List<_Ant> _ants = [
    _Ant(x: 20, y: 40, dx: 2.0, dy: 1.0),
    _Ant(x: 120, y: 150, dx: -3.0, dy: 1.5),
    _Ant(x: 220, y: 250, dx: 1.0, dy: -4.0),
  ];

  static const double _playAreaSize = 320;
  static const double _antSize = 48;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _gameOver = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_hitung <= 1) {
        setState(() {
          _hitung = 0;
        });
        timer.cancel();
        _timer2.cancel();
        _showTimeUpDialog();
      } else {
        setState(() {
          _hitung--;
        });
      }
    });
    _timer2 = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted || _gameOver) return;
      setState(() {
        for (final ant in _ants) {
          ant.x += ant.dx;
          ant.y += ant.dy;
          if (_isOutside(ant)) {
            _respawnAnt(ant);
          }
        }
      });
    });
  }

  bool _isOutside(_Ant ant) {
    return ant.x < -_antSize ||
        ant.x > _playAreaSize ||
        ant.y < -_antSize ||
        ant.y > _playAreaSize;
  }

  void _respawnAnt(_Ant ant) {
    ant.x = _random.nextDouble() * (_playAreaSize - _antSize);
    ant.y = _random.nextDouble() * (_playAreaSize - _antSize);
    final speed = 1.5 + _random.nextDouble() * 2.5;
    ant.dx = (_random.nextBool() ? 1 : -1) * speed;
    ant.dy = (_random.nextBool() ? 1 : -1) * speed;
  }

  void _showTimeUpDialog() async {
    if (_gameOver) return;
    _gameOver = true;
    await saveHighScore(_point);
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Time Up\nYour total score: $_point'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String formatTime(int hitung) {
    final hours = (hitung ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((hitung % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (hitung % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer2.cancel();
    super.dispose();
  }

  void hitAnt(_Ant ant) {
    if (_gameOver) return;
    setState(() {
      _point++;
      _respawnAnt(ant);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 20.0,
                  percent: 1 - (_hitung / _initValue),
                  center: Text(formatTime(_hitung)),
                  progressColor: Colors.red,
                ),
                const SizedBox(height: 12),
                LinearPercentIndicator(
                  center: Text(formatTime(_hitung)),
                  width: MediaQuery.of(context).size.width - 32,
                  lineHeight: 20.0,
                  percent: 1 - (_hitung / _initValue),
                  backgroundColor: Colors.grey,
                  progressColor: Colors.red,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 320,
                  width: 320,
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      for (final ant in _ants)
                        Positioned(
                          left: ant.x,
                          top: ant.y,
                          child: GestureDetector(
                            onTap: () => hitAnt(ant),
                            child: Image.asset(
                              'assets/images/ant.gif',
                              width: _antSize,
                              height: _antSize,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_timer.isActive) {
                        _timer.cancel();
                      } else {
                        if (_hitung == 0) {
                          _hitung = _initValue;
                          _point = 0;
                          for (final ant in _ants) {
                            _respawnAnt(ant);
                          }
                        }
                        startTimer();
                      }
                    });
                  },
                  child: Text(_timer.isActive ? 'Stop' : 'Start'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
