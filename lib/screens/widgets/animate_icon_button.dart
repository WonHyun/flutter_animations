import 'package:flutter/material.dart';

class AnimateIconButton extends StatelessWidget {
  const AnimateIconButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            width: 5,
            color: Colors.white,
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
