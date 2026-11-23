import 'dart:math';
import 'package:flutter/material.dart';

/// Demonstrates how StatefulWidget and setState can update the UI.
class RandomColorPage extends StatefulWidget {
  const RandomColorPage({super.key});

  @override
  State<RandomColorPage> createState() => _RandomColorPageState();
}

class _RandomColorPageState extends State<RandomColorPage> {
  final Random _random = Random();
  Color _backgroundColor = const Color(0xFF2196F3);

  Color _getRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1,
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    // A bright background gets dark text, a dark background gets white text.
    return ThemeData.estimateBrightnessForColor(backgroundColor) ==
            Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  void _changeColor() {
    setState(() {
      Color nextColor = _getRandomColor();
      while (nextColor == _backgroundColor) {
        nextColor = _getRandomColor();
      }
      _backgroundColor = nextColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: Text(
          'Tap the button to change colors!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _getContrastColor(_backgroundColor),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeColor,
        tooltip: 'Change background color',
        child: const Icon(Icons.color_lens),
      ),
    );
  }
}
