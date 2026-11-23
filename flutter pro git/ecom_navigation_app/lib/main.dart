import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const EcomApp());

class EcomApp extends StatelessWidget {
  const EcomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecom App - Navigation Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFBFF),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args = settings.arguments;
          final username = args is Map<String, String>
              ? (args['username']?.trim().isNotEmpty == true
                  ? args['username']!.trim()
                  : 'Dhruv')
              : 'Dhruv';
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => DashboardScreen(username: username),
          );
        }
        return null;
      },
    );
  }
}
