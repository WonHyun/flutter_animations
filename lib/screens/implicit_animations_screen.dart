import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;

  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Implicit Animations"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceOut,
              width: size.width * 0.4,
              height: size.width * 0.4,
              transform: Matrix4.rotationZ(_visible ? 1 : 0),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: _visible ? Colors.red : Colors.amber,
                borderRadius: BorderRadius.circular(_visible ? 100 : 0),
              ),
            ),
            const SizedBox(height: 10),
            TweenAnimationBuilder(
              tween: ColorTween(begin: Colors.blue, end: Colors.white),
              duration: const Duration(milliseconds: 2000),
              curve: Curves.bounceInOut,
              builder: (context, value, child) {
                return Image.network(
                  "https://docs.flutter.dev/assets/images/dash/Dashatars.png",
                  color: value,
                  colorBlendMode: BlendMode.colorBurn,
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _trigger,
              child: const Text("Go!"),
            ),
          ],
        ),
      ),
    );
  }
}
