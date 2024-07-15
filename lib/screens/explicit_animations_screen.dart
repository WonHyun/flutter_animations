import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )
    ..addListener(() {
      _range.value = _animationController.value;
    })
    ..addStatusListener((status) {
      // if (status == AnimationStatus.completed) {
      //   _animationController.reverse();
      // } else if (status == AnimationStatus.dismissed) {
      //   _animationController.forward();
      // }
    });

  // late final Animation<Color?> _color = ColorTween(
  //   begin: Colors.amber,
  //   end: Colors.red,
  // ).animate(_animationController);

  late final CurvedAnimation _curved = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
    reverseCurve: Curves.bounceOut,
  );

  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(10),
    ),
    end: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(30),
    ),
  ).animate(_curved);

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_curved);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 1.1,
  ).animate(_curved);

  late final Animation<Offset> _offset = Tween(
    begin: Offset.zero,
    end: const Offset(0, -0.2),
  ).animate(_curved);

  final ValueNotifier<double> _range = ValueNotifier(0.0);

  void _onChanged(double value) {
    _animationController.value = value;
    // _animationController.animateTo(value);
  }

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  bool _isLooping = false;

  void _toggleLooping() {
    _isLooping
        ? _animationController.stop()
        : _animationController.repeat(reverse: true);
    setState(() {
      _isLooping = !_isLooping;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Explicit Animations"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AnimatedBuilder(
            //   animation: _color,
            //   builder: (context, child) {
            //     return Container(
            //       width: 200,
            //       height: 200,
            //       decoration: BoxDecoration(
            //         color: _color.value,
            //       ),
            //     );
            //   },
            // ),
            SlideTransition(
              position: _offset,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: const SizedBox(
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _play,
                  child: const Text("Play"),
                ),
                ElevatedButton(
                  onPressed: _pause,
                  child: const Text("Pause"),
                ),
                ElevatedButton(
                  onPressed: _rewind,
                  child: const Text("Rewind"),
                ),
                ElevatedButton(
                  onPressed: _toggleLooping,
                  child: Text(_isLooping ? "Stop Loop" : "Start Loop"),
                ),
              ],
            ),
            const SizedBox(height: 25),
            ValueListenableBuilder(
                valueListenable: _range,
                builder: (context, value, child) {
                  return Slider(
                    value: value,
                    onChanged: _onChanged,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
