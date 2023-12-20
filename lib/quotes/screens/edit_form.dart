import 'dart:convert';

import 'package:flutter/material.dart';
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

  void _submitEdit() {
    final editedQuote = Quote(
      id: widget.quote.id,
      createdAt: widget.quote.createdAt,
      updatedAt: DateTime.now(),
      quote: _editedQuote,
      userId: widget.quote.userId,
      username: widget.quote.username,
      citedCount: widget.quote.citedCount,
      citedUsers: widget.quote.citedUsers,
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
                onPressed: _submitEdit,
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
