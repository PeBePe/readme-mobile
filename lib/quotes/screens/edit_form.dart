import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/quotes.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class QuotesEditPage extends StatefulWidget {
  final Product quote;

  const QuotesEditPage({Key? key, required this.quote}) : super(key: key);

  @override
  _QuotesEditPageState createState() => _QuotesEditPageState();
}

class _QuotesEditPageState extends State<QuotesEditPage> {
  String _editedQuote = "";

  @override
  void initState() {
    super.initState();
    _editedQuote = widget.quote.fields.quote;
  }

  void _submitEdit() {
    // Kirim data kembali ke QuotesPage dengan quote yang telah diubah
    final editedQuote = Product(
      model: widget.quote.model,
      pk: widget.quote.pk,
      fields: Fields(
        createdAt: widget.quote.fields.createdAt,
        updatedAt: DateTime.now(), 
        quote: _editedQuote, // Mengubah isi quote
        user: widget.quote.fields.user,
        username: widget.quote.fields.username,
      ),
    );

    Navigator.pop(context, editedQuote);
  }

  @override
  Widget build(BuildContext context) {
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
                  labelText: "Quotes",
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
                onPressed: _submitEdit,
                child: const Text('Submit Edited Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
