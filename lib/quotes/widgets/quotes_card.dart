import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/edit_form.dart';
import 'package:http/http.dart' as http;

class QuoteCard extends StatefulWidget {
  late Quote quote;
  final Function() onEditPressed;
  final Function() onDeletePressed;
  //final String loggedInUsername;
  final List<QuotedQuote> quotedQuotes;

  QuoteCard({
    Key? key,
    required this.quote,
    required this.onEditPressed,
    required this.onDeletePressed,
    //required this.loggedInUsername,
    required this.quotedQuotes,
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

  // Mendapatkan daftar pengguna yang mensitasi quote
  void _showCitedUsersDialog() {
    var citedQuotes = widget.quotedQuotes.where((q) => q.quoteIdId == widget.quote.id).toList();

    // Menampilkan daftar pengguna yang mengutip
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cited by:'),
          content: setupAlertDialogContainer(citedQuotes),
        );
      },
    );
  }

  Widget setupAlertDialogContainer(List<QuotedQuote> citedQuotes) {
    return Container(
      height: 300.0, // Sesuaikan sesuai kebutuhan Anda
      width: 300.0, // Sesuaikan sesuai kebutuhan Anda
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: citedQuotes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            //title: Text(users[index]),
            title: Text("User ID: ${citedQuotes[index].userIdId}"),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Quote quote = widget.quote;

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
              quote.username,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '"' + quote.quote + '"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Created Date: ' + DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(quote.createdAt.toLocal()),
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            Text(
              'Updated at: ' + DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(quote.updatedAt.toLocal()),
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tambahkan kondisi untuk tombol Edit Quote
                //if (quote.username == widget.loggedInUsername)
                  ElevatedButton(
                    onPressed: _editQuote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Edit Quote'),
                  ),
                // Tambahkan kondisi untuk tombol Delete Quote
                //if (quote.username == widget.loggedInUsername)
                  ElevatedButton(
                    onPressed: widget.onDeletePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete Quote'),
                  ),
              ],
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _showCitedUsersDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 239, 189, 95),
                foregroundColor: Colors.white,
              ),
              child: const Text('Cited Quote'),
            )
          ],
        ),
      ),
    );
  }
}