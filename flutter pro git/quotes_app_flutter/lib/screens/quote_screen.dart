import 'package:flutter/material.dart';
import '../controllers/quotes_controller.dart';
import '../services/quote_service.dart';
class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});
  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}
class _QuoteScreenState extends State<QuoteScreen> {
  late final QuotesController controller;
  @override
  void initState() {
    super.initState();
    controller = QuotesController(QuoteService())..addListener(_refresh);
    controller.fetchDetails();
  }
  void _refresh() { if (mounted) setState(() {}); }
  @override
  void dispose() { controller.removeListener(_refresh); controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('QuoteScreen')),
    body: Center(child: Padding(
      padding: const EdgeInsets.all(24),
      child: controller.loading
        ? const CircularProgressIndicator()
        : controller.error != null
          ? Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Could not load a quote.'),
              const SizedBox(height: 8),
              Text(controller.error!, textAlign: TextAlign.center),
              TextButton(onPressed: controller.fetchDetails, child: const Text('Try again')),
            ])
          : Column(mainAxisSize: MainAxisSize.min, children: [
              Text(controller.quote?.text ?? 'No quote',
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              Text(controller.quote?.author ?? '', textAlign: TextAlign.center),
            ]),
    )),
    floatingActionButton: FloatingActionButton(
      onPressed: controller.loading ? null : controller.fetchDetails,
      child: const Icon(Icons.refresh),
    ),
  );
}
