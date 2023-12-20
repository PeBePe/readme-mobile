import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:readme_mobile/constants/constants.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/quotes.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class QuotesEditPage extends StatefulWidget {
  final Quote quote;

  const QuotesEditPage({Key? key, required this.quote}) : super(key: key);

  @override
  _QuotesEditPageState createState() => _QuotesEditPageState();
}

class _QuotesEditPageState extends State<QuotesEditPage> {
  String _editedQuote = "";

  @override
  void initState() {
    super.initState();
    _editedQuote = widget.quote.quote;
  }

  Future<void> _submitEdit(request) async {
    // final editedQuote = Quote(
    //   id: widget.quote.id,
    //   createdAt: widget.quote.createdAt,
    //   updatedAt: DateTime.now(),
    //   quote: _editedQuote,
    //   userId: widget.quote.userId,
    //   username: widget.quote.username,
    //   citedCount: widget.quote.citedCount,
    //   citedUsers: widget.quote.citedUsers,
    // );

    final response = await request.post(
        '$baseUrl/quotes/edit-quote/${widget.quote.id}/',
        {"quote": _editedQuote});
    print(response);

    if (response["status"]) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil mengedit quote!'),
          content: Text(response['message']),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      Navigator.pop(context);
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gagal mengedit quote!'),
          content: Text(response['message']),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Quotes'),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: _editedQuote,
                decoration: InputDecoration(
                  hintText: "Isi quotes yang ingin kamu ubah",
                  labelText: "Edit Quote",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _editedQuote = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _submitEdit(request);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Update Quotes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
