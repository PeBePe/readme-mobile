import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readme_mobile/constants/constants.dart';
import 'dart:convert';

import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/edit_form.dart';
import 'package:readme_mobile/quotes/screens/quotes_form.dart';
import 'package:readme_mobile/quotes/widgets/quotes_card.dart';
import 'package:readme_mobile/readme/widgets/left_drawer.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({Key? key}) : super(key: key);

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final List<Product> _quotes = [];

  @override
  void initState() {
    super.initState();
    _fetchQuotes();
  }

  Future<void> _fetchQuotes() async {
    final url = Uri.parse("$baseUrl/quotes/");
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<Product> quotes = parseQuotes(response.body);
        setState(() {
          _quotes.clear();
          _quotes.addAll(quotes);
        });
      } else {
        print("Gagal mengambil kutipan. Status: ${response.statusCode}");
      }
    } catch (error) {
      print("Terjadi kesalahan: $error");
    }
  }

  List<Product> parseQuotes(String responseBody) {
  final Map<String, dynamic> jsonData = jsonDecode(responseBody);

  // Mengambil data quotes dari dalam key "data"
  final List<dynamic> quotesData = jsonData['data']['quotes'];

  // Mengonversi data quotes menjadi objek Product
  List<Product> quotesList = quotesData.map<Product>((json) {
    return Product(
      model: 'quotes_model',
      pk: json['id'],
      fields: Fields(
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        quote: json['quote'],
        user: json['user_id'],
        username: jsonData['data']['name'], // Mengambil username dari key "name"
      ),
    );
  }).toList();

  return quotesList;
}

  // ... (metode _navigateAndAddQuote, _editQuote, _deleteQuote, build, dll)
  Future<void> _navigateAndAddQuote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuotesFormPage()),
    );

    if (result != null) {
      setState(() {
        _quotes.add(Product(
          model: 'quotes_model', 
          pk: _quotes.length + 1,
          fields: Fields(
            createdAt: result['date'],
            updatedAt: result['date'],
            quote: result['quote'],
            user: 1, 
            username: result['username'],
          ),
        ));
      });
    }
  }

    void _editQuote(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuotesEditPage(quote: _quotes[index])),
    );

    if (result != null) {
      setState(() {
        // Update quote di list
        _quotes[index] = result;
      });
    }
  }

  void _deleteQuote(int index) {
    setState(() {
      _quotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ... (Bagian build yang sudah ada)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
              ),
              itemCount: _quotes.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _editQuote(index);
                  },
                  child: QuoteCard(
                    quote: _quotes[index],
                    onEditPressed: () {
                      _editQuote(index);
                    },
                    onDeletePressed: () {
                      _deleteQuote(index);
                    },
                    currentUserID: _quotes[index].fields.user,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Terdapat ${_quotes.length} Quotes dalam Profilemu!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndAddQuote,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFFAEFDF),
      ),
    );
  }
}
