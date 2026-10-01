import 'package:flutter/material.dart';

/// A reusable custom text widget that enforces consistent Purrdle typography.
///
/// Refactor: extracted from main.dart into its own file so it can be imported
/// by any view without importing the app entry point. Added an optional [color]
/// parameter (default: Colors.pink) to support the white AppBar title on
/// StatsScreen without needing a separate widget.
class PurrdleText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;

  // Fix: added const (lint: prefer_const_constructors_in_immutables)
  const PurrdleText(
    this.text, {
    super.key,
    this.size = 24.0,
    this.color = const Color(0xFFE91E8C), // Colors.pink — must be const literal
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Courier',
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}
