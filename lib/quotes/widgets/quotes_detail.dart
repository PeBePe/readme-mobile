import 'package:flutter/material.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';

class QuotesDetailPage extends StatelessWidget {
  final Product quotes;

  const QuotesDetailPage({Key? key, required this.quotes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quotes.fields.username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quote: ${quotes.fields.quote}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Created Date: ${quotes.fields.createdAt}"),
            const SizedBox(height: 10),
            Text("Updated at: ${quotes.fields.updatedAt}"),
          ],
        ),
      ),
    );
  }
}
