import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool configured = false;
  String? error;
  try {
    // Run `flutterfire configure` for your own Firebase project first.
    // The CLI generates lib/firebase_options.dart. Then replace the line below with:
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Firebase.initializeApp();
    configured = true;
  } catch (e) { error = e.toString(); }
  runApp(MaterialApp(debugShowCheckedModeBanner: false,
    home: configured ? const HomeScreen() : Scaffold(
      appBar: AppBar(title: const Text('Firebase Setup Required')),
      body: Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(
        'Configure Firebase for this platform before using Cloud Firestore.\n\n'
        'Run flutterfire configure, import firebase_options.dart, and initialize '
        'Firebase using DefaultFirebaseOptions.currentPlatform.\n\n$error'))),
    ),
  ));
}
