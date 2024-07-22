import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animations/screens/widgets/swipable_image_card.dart';

import 'widgets/animate_icon_button.dart';

enum Direction {
  left,
  right,
}

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final Tween<double> _rotaion = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );

  void _whenSwipeComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;

    if (_position.value.abs() >= bound) {
      _swipeCard(
        _position.value.isNegative ? Direction.left : Direction.right,
      );
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  void _swipeCard(Direction direction) {
    final dropZone = size.width + 100;
    int factor;

    switch (direction) {
      case Direction.left:
        factor = -1;
      case Direction.right:
        factor = 1;
    }
    _position
        .animateTo(
          dropZone * factor,
          curve: Curves.easeOut,
        )
        .whenComplete(_whenSwipeComplete);
  }

  int _index = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swiping Cards"),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotaion
                  .transform((_position.value + size.width / 2) / size.width) *
              pi /
              180;
          final scale = _scale.transform(_position.value.abs() / size.width);
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 50,
                child: Transform.scale(
                  scale: min(scale, 1.0),
                  child: SwipableImageCard(index: _index == 5 ? 1 : _index + 1),
                ),
              ),
              Positioned(
                top: 50,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: SwipableImageCard(index: _index),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                child: AnimatedBuilder(
                    animation: _position,
                    builder: (context, child) {
                      return Row(
                        children: [
                          AnimateIconButton(
                            icon: Icons.close,
                            iconSize: 36,
                            iconColor: Colors.red,
                            onTap: () => _swipeCard(Direction.left),
                          ),
                          const SizedBox(width: 20),
                          AnimateIconButton(
                            icon: Icons.check,
                            iconSize: 36,
                            iconColor: Colors.green,
                            onTap: () => _swipeCard(Direction.right),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
