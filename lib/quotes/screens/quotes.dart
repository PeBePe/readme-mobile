import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readme_mobile/constants/constants.dart';
import 'dart:convert';

import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/edit_form.dart';
import 'package:readme_mobile/quotes/screens/quotes_form.dart';
import 'package:readme_mobile/quotes/widgets/quotes_card.dart';
import 'package:readme_mobile/readme/widgets/left_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({Key? key}) : super(key: key);

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final List<Quote> _quotes = [];
  late String _loggedInUser;
  String _searchQuote = '';

  @override
  void initState() {
    super.initState();
    _fetchLoggedInUser();
    _fetchQuotes();
  }

  // Simpan data username yang sedang login
  Future<void> _fetchLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedInUser = prefs.getString('loggedInUsername') ?? '';
    setState(() {
      _loggedInUser = loggedInUser;
    });
  }

  // Fungsi untuk melakukan pencarian berdasarkan username atau isi quote
  void _performSearch(String query) {
    setState(() {
      _searchQuote = query;
    });
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
      citedCount: json['cited_count'],
      citedUsers: (json['cited_users'] as List)
          .map((citedUserJson) => CitedUser.fromJson(citedUserJson))
          .toList(),
    );
  }).toList();

  return quotesList;
}

  Future<void> _navigateAndAddQuote() async {
  final newQuote = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => QuotesFormPage(loggedInUsername: _loggedInUser, existingQuotes: _quotes)),
  );

  if (newQuote != null) {
    setState(() {
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
    // Filter berdasarkan username atau isi quote
    List<Quote> filteredQuotes = _quotes.where((quote) {
      final usernameMatch = quote.username.toLowerCase().contains(_searchQuote.toLowerCase());
      final quoteMatch = quote.quote.toLowerCase().contains(_searchQuote.toLowerCase());
      return usernameMatch || quoteMatch;
    }).toList();

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Some Quotes to Cheer Up ${_loggedInUser}'s Day 🥂",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _performSearch,
              decoration: InputDecoration(
                labelText: 'Cari quotes favoritmu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
              ),
              itemCount: filteredQuotes.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _editQuote(index);
                  },
                  child: QuoteCard(
                    quote: filteredQuotes[index],
                    onEditPressed: () {
                      _editQuote(index);
                    },
                    onDeletePressed: () {
                      _deleteQuote(index);
                    },
                    quotedQuotes: [],
                    loggedInUsername: _loggedInUser,
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
