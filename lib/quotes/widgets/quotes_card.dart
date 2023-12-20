import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/edit_form.dart';

class QuoteCard extends StatefulWidget {
  late Quote quote;
  final Function() onEditPressed;
  final Function() onDeletePressed;
  final String loggedInUsername;
  final List<QuotedQuote> quotedQuotes;

  QuoteCard({
    Key? key,
    required this.quote,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.loggedInUsername,
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

  void _showCitedUsersDialog() {
  // Mengambil daftar pengguna yang mengutip quote
  List<CitedUser> citedUsers = widget.quote.citedUsers;
  int countCitedUsers = widget.quote.citedCount;

  // Menampilkan jumlah pengguna yang mengutip
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Cited by $countCitedUsers User${countCitedUsers != 1 ? "s" : ""}'),
        content: setupAlertDialogContainer(citedUsers),
      );
    },
  );
}

Widget setupAlertDialogContainer(List<CitedUser> citedUsers) {
  return Container(
    height: 300.0,
    width: 300.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: citedUsers.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text("🙈 ${citedUsers[index].username}"),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0), // Sesuaikan padding dengan gaya yang Anda inginkan
          child: Text("Go to our website 'readme.up.railway.app' if u also want to cite this user 😁"),
        ),
      ],
    ),
  );
}
 
  @override
  Widget build(BuildContext context) {
    Quote quote = widget.quote;

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(5.0),
      color: Color.fromARGB(255, 255, 249, 239),
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
                if (quote.username == widget.loggedInUsername)
                  ElevatedButton(
                    onPressed: _editQuote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Edit Quote'),
                  ),
                if (quote.username == widget.loggedInUsername)
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