import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:readme_mobile/constants/constants.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/quotes.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class QuotesFormPage extends StatefulWidget {
  const QuotesFormPage(
      {Key? key, required this.loggedInUsername, required this.existingQuotes})
      : super(key: key);
  final String loggedInUsername;
  final List<Quote> existingQuotes;

  @override
  State<QuotesFormPage> createState() => _QuotesFormPageState();
}

class _QuotesFormPageState extends State<QuotesFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _quote = "";
  // final _dateCreated = DateTime.now();
  // final _dateUpdated = DateTime.now();

  void _submitQuote(request) async {
    // if (_formKey.currentState!.validate()) {
    // Periksa apakah sudah ada quote dengan username yang sama
    //   bool quoteExists = widget.existingQuotes.any((quote) => quote.username == widget.loggedInUsername);

    //   if (quoteExists) {
    //     // Tampilkan Snackbar jika quote sudah ada
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Anda sudah pernah membuat quote, satu akun hanya boleh membuat satu quote saja')),
    //     );
    //   } else {
    //     // Jika belum ada, tambahkan quote baru
    //     final newQuote = Quote(
    //       id: DateTime.now().millisecondsSinceEpoch, // Menghasilkan ID unik
    //       createdAt: _dateCreated,
    //       updatedAt: _dateUpdated,
    //       quote: _quote,
    //       userId: 1,
    //       username: widget.loggedInUsername,
    //       citedCount: 0,
    //       citedUsers: [],
    //     );
    //     Navigator.pop(context, newQuote);
    //   }
    // }

    final response =
        await request.post('$baseUrl/quotes/create-quotes/', {"quote": _quote});
    print(response);

    if (response["status"]) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil membuat quote!'),
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
          title: const Text('Gagal membuat quote!'),
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
    //   if (response['status'] == true && response.containsKey('post')) {
    //     final int postId = response['post']['id'];
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Post created successfully')),
    //     );
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => PostDetail(postId: postId),
    //       ),
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Failed to create post')),
    //     );
    //   }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Content cannot be empty')),
    //   );
    // }
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
                      _submitQuote(request);
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
        ));
  }
}
