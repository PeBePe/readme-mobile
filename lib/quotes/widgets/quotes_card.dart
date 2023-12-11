import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';

class QuoteCard extends StatelessWidget {
  final Product quote;

  const QuoteCard({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Fields fields = quote.fields;

    return Card( //#FAEFDF
      elevation: 4.0, // Menambahkan sedikit bayangan untuk efek kedalaman
      margin: const EdgeInsets.all(5.0), // Margin di sekeliling card
      color: Color.fromARGB(255, 253, 233, 204),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding di dalam card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              fields.username, // Deskripsi quote
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '"' + fields.quote + '"', // Username
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                //color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              'Created at: ' + DateFormat('dd MMM yyyy').format(fields.createdAt), // Date added dengan format yang diinginkan
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            Text(
              'Updated at: ' + DateFormat('dd MMM yyyy').format(fields.createdAt), // Date added dengan format yang diinginkan
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
