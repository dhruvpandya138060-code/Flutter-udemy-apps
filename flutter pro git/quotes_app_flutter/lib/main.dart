import 'package:flutter/material.dart';
import 'screens/quote_screen.dart';

void main() => runApp(const QuotesApp());
class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    title: 'Quote App', debugShowCheckedModeBanner: false,
    home: QuoteScreen(),
  );
}
