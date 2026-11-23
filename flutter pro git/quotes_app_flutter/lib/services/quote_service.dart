import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';
class QuoteService {
  Future<Quote> fetchQuote() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/quotes/random'))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw Exception('Failed to load quote (${response.statusCode})');
    }
    return Quote.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
