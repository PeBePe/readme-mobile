import 'package:flutter/material.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/widgets/quotes_card.dart'; // Pastikan ini adalah path yang benar
import 'package:readme_mobile/readme/widgets/left_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuotesPage extends StatefulWidget {
  //final String username;

  //const QuotesPage({Key? key, required this.username}) : super(key: key);
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  // Inisialisasi dummyQuotes di sini
  late final List<Product> dummyQuotes;

  @override
  void initState() {
    super.initState();
    // Isi dummyQuotes dengan data contoh
    dummyQuotes = [
      Product(
        model: 'Model 1',
        pk: 1,
        fields: Fields(
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          quote: 'This is a sample quote 1',
          user: 1,
          username: 'user 1',
          //user: 1,
        ),
      ),
      // Tambahkan item lain jika perlu
      Product(
        model: 'Model 1',
        pk: 1,
        fields: Fields(
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          quote: 'This is a sample quote 2',
          user: 1,
          username: "user 2",
          //user: 1,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Text('Quotes'),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     'Some Quotes to Cheer Up $username\'s Day 🥂',
          //     style: const TextStyle(
          //       fontSize: 24,
          //       fontWeight: FontWeight.bold,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Menampilkan dua card dalam satu baris
                childAspectRatio: 1.0, // Mengatur agar card menjadi persegi
              ),
              itemCount: dummyQuotes.length,
              itemBuilder: (BuildContext context, int index) {
                return QuoteCard(quote: dummyQuotes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
