import 'package:flutter/material.dart';

/// Displays the name supplied through the /dashboard named route.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Text(
          'Hi, $username!',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
