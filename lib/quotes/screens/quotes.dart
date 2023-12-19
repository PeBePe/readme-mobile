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
  final List<Quote> _quotes = [];
  //late String _loggedInUser;

  @override
  void initState() {
    super.initState();
    //_loggedInUser = response['username'];
    _fetchQuotes();
  }

  Future<void> _fetchQuotes() async {
    final url = Uri.parse("$baseUrl/quotes/");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<Quote> quotes = parseQuotes(response.body);

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

  List<Quote> parseQuotes(String responseBody) {
  final Map<String, dynamic> jsonData = jsonDecode(responseBody);

  final List<dynamic> quotesData = jsonData['data']['quotes'];

  List<Quote> quotesList = quotesData.map<Quote>((json) {
    return Quote(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      quote: json['quote'],
      userId: json['user_id'],
      username: json['username'],
    );
  }).toList();

  return quotesList;
}

Future<void> _navigateAndAddQuote() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const QuotesFormPage()),
  );

  if (result != null) {
    setState(() {
      final newQuote = Quote(
        id: int.parse(result['id']), // Konversi ID dari string ke int
        createdAt: DateTime.parse(result['createdAt']),
        updatedAt: DateTime.parse(result['updatedAt']),
        quote: result['quote'],
        userId: 1, // Sesuaikan sesuai dengan user ID Anda, atau dapatkan dari result jika perlu
        username: result['username'],
      );
      _quotes.add(newQuote);
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
                    quotedQuotes: [],
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
