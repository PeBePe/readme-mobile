import 'package:flutter/material.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';

class QuotesDetailPage extends StatelessWidget {
  final Product quotes;

  const QuotesDetailPage({Key? key, required this.quotes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Quote quote = quotes.data.quotes[0];

    return Scaffold(
      appBar: AppBar(
        title: Text(quote.username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quote: ${quote.quote}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Created Date: ${quote.createdAt}"),
            const SizedBox(height: 10),
            Text("Updated at: ${quote.updatedAt}"),
          ],
        ),
      ),
    );
  }
}
