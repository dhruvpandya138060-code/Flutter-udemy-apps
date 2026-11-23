import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('First App'),
        ),
        body: Container(
          color: Colors.red,
          child: const Center(
            child: Text(
              'Hello from first app',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
