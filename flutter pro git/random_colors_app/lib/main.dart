import 'package:flutter/material.dart';
import 'screens/random_color_page.dart';

void main() {
  runApp(const RandomColorsApp());
}

class RandomColorsApp extends StatelessWidget {
  const RandomColorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Colors',
      home: RandomColorPage(),
    );
  }
}
