import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/edit_form.dart';

// Mengubah QuoteCard menjadi StatefulWidget
class QuoteCard extends StatefulWidget {
  final Product quote;
  final Function() onEditPressed;
  //final List<Product> quotes;

  const QuoteCard({Key? key, required this.quote, required this.onEditPressed}) : super(key: key);
  //const QuoteCard({Key? key, required this.quote, required this.onEditPressed, required this.quotes}) : super(key: key);

  @override
  _QuoteCardState createState() => _QuoteCardState();
}

// Membuat kelas State untuk QuoteCard
class _QuoteCardState extends State<QuoteCard> {
  // Fungsi untuk mengedit quote (opsional, tergantung pada logika yang Anda butuhkan)
  void _editQuote(BuildContext context, Product quote) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuotesEditPage(quote: quote)),
    );

    if (result != null) {
      setState(() {
      // Misalnya, result adalah objek Product yang baru
      //widget.quote = result; 
    });
    widget.onEditPressed(); //biar isi quotes berubah
  }
  }

  //fungsi buat bikin tombol delete
//   void _deleteQuote(BuildContext context, Product quote) {
//   setState(() {
//     widget.quotes.remove(quote);
//   });
// }

  @override
  Widget build(BuildContext context) {
    // Mengakses fields dari quote
    Fields fields = widget.quote.fields;

    // Membangun UI untuk QuoteCard
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(5.0),
      color: Color.fromARGB(255, 253, 233, 204),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              fields.username,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              '"' + fields.quote + '"',
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              'Created at: ' + DateFormat('dd MMM yyyy').format(fields.createdAt),
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            Text(
              'Updated at: ' + DateFormat('dd MMM yyyy').format(fields.updatedAt),
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _editQuote(context, widget.quote);
              },
              child: const Text('Edit Quotes'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Panggil fungsi untuk menghapus quote
            //     _deleteQuote(context, widget.quote);
            //   },
            //   child: const Text('Delete Quotes'),
            // ),
          ],
        ),
      ),
    );
  }
}
