import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:readme_mobile/quotes/screens/quotes.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class QuotesFormPage extends StatefulWidget {
  const QuotesFormPage({Key? key}) : super(key: key);

  @override
  State<QuotesFormPage> createState() => _QuotesFormPageState();
}

class _QuotesFormPageState extends State<QuotesFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _quote = "";
  final _dateCreated = DateTime.now();
  final _dateUpdated = DateTime.now();

  void _submitQuote() {
  // Kirim data kembali ke QuotesPage
  Navigator.pop(context, {
    'username': _username,
    'quote': _quote,
    'date': DateTime.now(),
  });
}


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Daftarkan Qoutes ke Dalam Daftar Kamu!',
          ),
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Isi username sesuai dengan nama akun kamu",
                    labelText: "Username Pengguna",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _username = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Username tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Isi quotes yang ingin kamu tulis",
                    labelText: "Quotes",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _quote = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Quotes tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Proses data dan navigasi kembali ke laman quotes
                      _submitQuote();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Submit Quotes'),
                ),
              ),
              // ISI ALLIGN DISINI
            ],
          ),
        ),
      )
    );
  }
}
