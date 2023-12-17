import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/edit_form.dart';

class QuoteCard extends StatefulWidget {
  late Product quote;
  final Function() onEditPressed;
  final Function() onDeletePressed;
  final int currentUserID; // Tambahkan properti untuk menyimpan ID pengguna yang saat ini masuk

  QuoteCard({
    Key? key,
    required this.quote,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.currentUserID,
  }) : super(key: key);

  @override
  _QuoteCardState createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting(); // Inisialisasi format tanggal dan zona waktu lokal
    Intl.defaultLocale = 'id_ID';
  }

  void _editQuote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuotesEditPage(quote: widget.quote)),
    );

    if (result != null) {
      setState(() {
        widget.quote = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Fields fields = widget.quote.fields;

    // Periksa apakah pengguna yang membuat quote sesuai dengan pengguna yang saat ini masuk
    final bool isCurrentUserQuote = fields.user == widget.currentUserID;

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(5.0),
      color: const Color.fromARGB(255, 253, 233, 204),
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
            Text(
              '"' + fields.quote + '"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Created Date: ' + DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(fields.createdAt. toLocal()),
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            Text(
              'Updated at: ' + DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(fields.updatedAt.toLocal()),
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10.0), 
            if (isCurrentUserQuote) // Hanya tampilkan tombol jika pengguna yang membuat quote sama dengan pengguna saat ini
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _editQuote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Edit Quotes'),
                  ),
                  ElevatedButton(
                    onPressed: widget.onDeletePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete Quotes'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
