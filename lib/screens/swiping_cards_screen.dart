import 'dart:math';

import 'package:flutter/foundation.dart';
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

  late final ColorTween _leftColor = ColorTween(
    begin: Colors.white,
    end: Colors.red,
  );

  late final ColorTween _rightColor = ColorTween(
    begin: Colors.white,
    end: Colors.green,
  );

  late final Tween<double> _buttonSize = Tween(
    begin: 5.0,
    end: 8.0,
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
          final scale = _scale.transform(
              clampDouble(_position.value.abs() / size.width, 0.0, 1.0));
          final leftBackgroundColor = _position.value >= 0
              ? Colors.white
              : _leftColor.transform(
                  clampDouble(_position.value.abs() / size.width, 0.0, 1.0));
          final rightBackgroundColor = _position.value <= 0
              ? Colors.white
              : _rightColor.transform(
                  clampDouble(_position.value.abs() / size.width, 0.0, 1.0));
          final leftIconColor = _position.value >= 0
              ? Colors.red
              : _leftColor.transform(clampDouble(
                  1 - (_position.value.abs() / size.width), 0.0, 1.0));
          final rightIconColor = _position.value <= 0
              ? Colors.green
              : _rightColor.transform(clampDouble(
                  1 - (_position.value.abs() / size.width), 0.0, 1.0));
          final leftSize = _position.value >= 0
              ? 5.0
              : _buttonSize.transform(_position.value.abs() / size.width);
          final rightSize = _position.value <= 0
              ? 5.0
              : _buttonSize.transform(_position.value.abs() / size.width);
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 50,
                child: Transform.scale(
                  scale: scale,
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
                left: 100,
                bottom: 50,
                child: AnimateIconButton(
                  icon: Icons.close,
                  iconColor: leftIconColor ?? Colors.red,
                  backgroundColor: leftBackgroundColor ?? Colors.white,
                  paddingSize: leftSize,
                  onTap: () => _swipeCard(Direction.left),
                ),
              ),
              Positioned(
                right: 100,
                bottom: 50,
                child: AnimateIconButton(
                  icon: Icons.check,
                  iconColor: rightIconColor ?? Colors.green,
                  backgroundColor: rightBackgroundColor ?? Colors.white,
                  paddingSize: rightSize,
                  onTap: () => _swipeCard(Direction.right),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
