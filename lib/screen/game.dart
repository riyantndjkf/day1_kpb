import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int _hitung = 30;
  int _initValue = 30;
  double _x = 100;
  double _y = 400;
  late Timer _timer;
  late Timer _timer2;
  bool _isDead = false;


  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (_hitung == 0) {
          timer.cancel();
          _hitung = 30;
          _showTimeUpDialog();
        } else {
          _hitung--;
        }
      });
    });
    _timer2 = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_y < -50) {
          _y = 400;
        } else {
          _y -= 3;
        }
      });
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Game'),
          content: const Text('Time Up'),
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

  void hitAnt() {
    if (_isDead) return;
    setState(() {
      _isDead = true;
    });

    _timer2.cancel();
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
                      Positioned(
                        top: _y,
                        left: _x,
                        child: GestureDetector(
                          onTap: hitAnt,
                          child: Image.asset(
                            _isDead ? 'assets/images/dead_ant.png' : 'assets/images/ant.gif',
                            width: 48,
                            height: 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _timer.isActive ? _timer.cancel() : startTimer();
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
