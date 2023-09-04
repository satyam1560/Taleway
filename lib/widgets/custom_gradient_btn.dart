import 'package:flutter/material.dart';

class CustomGradientBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final double? height;
  final double? widht;

  const CustomGradientBtn({
    Key? key,
    required this.onTap,
    required this.label,
    this.height = 38.0,
    this.widht = 75.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: widht,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [
              0.0,
              0.0,
              0.5,
            ],
            colors: [
              // Colors.pink,
              Colors.pink,

              Colors.blueAccent,
              Colors.pink,
            ],
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14.5,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
