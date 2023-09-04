import 'package:flutter/material.dart';

class CustomIcons extends StatelessWidget {
  final double? size;
  final IconData icon;
  final VoidCallback onTap;

  const CustomIcons({
    Key? key,
    this.size = 35.0,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Colors.pink,
              Colors.purpleAccent,
            ],
          ),
        ),
        // child:

        child: GestureDetector(
          onTap: onTap,
          child: Icon(
            icon,
            color: Colors.white,
            size: 24.0,
          ),
        )

        //  Padding(
        //   padding: const EdgeInsets.all(2.0),
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(60.0),
        //     child: Image.network(
        //       imageUrl ?? errorImage,
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        );
  }
}
