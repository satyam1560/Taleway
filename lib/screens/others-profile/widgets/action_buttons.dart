import 'package:flutter/material.dart';
import 'package:viewstories/widgets/gradient_circle_button.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const ActionButtons({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          GradientCircleButton(onTap: onTap, icon: icon),
          const SizedBox(width: 10.0),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
