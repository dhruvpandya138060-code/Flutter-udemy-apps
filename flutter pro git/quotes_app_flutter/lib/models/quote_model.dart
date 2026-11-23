class Quote {
  final String text;
  final String author;
  const Quote({required this.text, required this.author});
  factory Quote.fromJson(Map<String, dynamic> data) => Quote(
    text: (data['quote'] ?? '').toString(),
    author: (data['author'] ?? 'Unknown').toString(),
  );
}
