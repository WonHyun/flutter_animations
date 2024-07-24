import 'package:flutter/material.dart';

class AnimateIconButton extends StatelessWidget {
  const AnimateIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.white,
    this.iconColor = Colors.black,
    this.iconSize = 36,
    this.paddingSize = 5,
  });

  final IconData icon;
  final Function() onTap;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final double iconSize;
  final double paddingSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(paddingSize),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            width: 5,
            color: borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 5),
              blurRadius: 8,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
