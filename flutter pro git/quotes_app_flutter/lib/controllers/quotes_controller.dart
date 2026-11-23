import 'package:flutter/foundation.dart';
import '../models/quote_model.dart';
import '../services/quote_service.dart';
class QuotesController extends ChangeNotifier {
  final QuoteService _service;
  QuotesController(this._service);
  Quote? quote;
  bool loading = false;
  String? error;
  Future<void> fetchDetails() async {
    loading = true; error = null; notifyListeners();
    try { quote = await _service.fetchQuote(); }
    catch (e) { error = e.toString(); }
    finally { loading = false; notifyListeners(); }
  }
}
