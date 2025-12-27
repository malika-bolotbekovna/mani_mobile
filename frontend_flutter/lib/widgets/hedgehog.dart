import 'package:flutter/material.dart';

class Hedgehog extends StatelessWidget {
  final double size;
  const Hedgehog({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/fox.webp',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
