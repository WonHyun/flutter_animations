import 'dart:math';

import 'package:flutter/material.dart';
import 'widgets/apple_watch_progress_bar.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  );

  late Animation<double> _redProgress = Tween(
    begin: 0.005,
    end: 1.5,
  ).animate(_curve);

  late Animation<double> _greenProgress = Tween(
    begin: 0.005,
    end: 1.5,
  ).animate(_curve);

  late Animation<double> _blueProgress = Tween(
    begin: 0.005,
    end: 1.5,
  ).animate(_curve);

  void _animateValues() {
    final random = Random();
    setState(() {
      _redProgress = Tween(
        begin: _redProgress.value,
        end: random.nextDouble() * 2.0,
      ).animate(_curve);

      _greenProgress = Tween(
        begin: _greenProgress.value,
        end: random.nextDouble() * 2.0,
      ).animate(_curve);

      _blueProgress = Tween(
        begin: _blueProgress.value,
        end: random.nextDouble() * 2.0,
      ).animate(_curve);
    });
    _animationController.forward(from: 0);
  }

  @override
  void initState() {
    super.initState();
    _animateValues();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Apple Watch"),
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: _redProgress,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  AppleWatchProgressBar(
                    progress: _redProgress.value,
                    barColor: Colors.red.shade400,
                    backgroundBarColor: Colors.red.shade400.withOpacity(0.3),
                    size: 350,
                  ),
                  AppleWatchProgressBar(
                    progress: _greenProgress.value,
                    barColor: Colors.green.shade400,
                    backgroundBarColor: Colors.green.shade400.withOpacity(0.3),
                    size: 290,
                  ),
                  AppleWatchProgressBar(
                    progress: _blueProgress.value,
                    barColor: Colors.cyan.shade400,
                    backgroundBarColor: Colors.cyan.shade400.withOpacity(0.3),
                    size: 230,
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
