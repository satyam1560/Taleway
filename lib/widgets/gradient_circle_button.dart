import 'package:flutter/material.dart';

class GradientCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final double size;
  final double? iconSize;

  const GradientCircleButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.iconSize = 24.0,
    this.size = 45.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [
              0.02,
              0.1,
              0.5,
            ],
            colors: [
              Colors.pink,
              Colors.blueAccent,
              Colors.pink,
            ],
          ),
          borderRadius: BorderRadius.circular(70.0),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
