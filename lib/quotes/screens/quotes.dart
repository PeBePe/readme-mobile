import 'package:flutter/material.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/quotes_form.dart';
import 'package:readme_mobile/quotes/widgets/quotes_card.dart'; 
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
    dummyQuotes = []; // List ini sekarang kosong dan siap untuk diisi dengan data baru
  }

  Future<void> _navigateAndAddQuote() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const QuotesFormPage()),
  );

  if (result != null) {
    setState(() {
      // Tambahkan data baru ke list
      dummyQuotes.add(Product(
        model: 'Model Baru', // Sesuaikan sesuai kebutuhan
        pk: dummyQuotes.length + 1, // Atau gunakan cara yang lebih baik untuk mengatur primary key
        fields: Fields(
          createdAt: result['date'],
          updatedAt: result['date'],
          quote: result['quote'],
          user: 1, // Sesuaikan dengan logika user Anda
          username: result['username'],
        ),
      ));
    });
  }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigator.push untuk membuka QuotesFormPage
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuotesFormPage()),
          );

          // Setelah QuotesFormPage ditutup, Anda dapat menangani hasil yang dikirim kembali di sini
          if (result != null) {
            setState(() {
              // Tambahkan data baru ke list
              dummyQuotes.add(Product(
                model: 'Model Baru',
                pk: dummyQuotes.length + 1,
                fields: Fields(
                  createdAt: result['date'],
                  updatedAt: result['date'],
                  quote: result['quote'],
                  user: 1, // Sesuaikan dengan logika user Anda
                  username: result['username'],
                ),
              ));
            });
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFFAEFDF),
      ),
    );
  }
}