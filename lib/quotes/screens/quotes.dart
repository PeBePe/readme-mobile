import 'package:flutter/material.dart';
import 'package:readme_mobile/quotes/models/quotes_item.dart';
import 'package:readme_mobile/quotes/screens/edit_form.dart';
import 'package:readme_mobile/quotes/screens/quotes_form.dart';
import 'package:readme_mobile/quotes/widgets/quotes_card.dart'; 
import 'package:readme_mobile/readme/widgets/left_drawer.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final List<Product> _quotes = [];

  Future<void> _navigateAndAddQuote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuotesFormPage()),
    );

    if (result != null) {
      setState(() {
        _quotes.add(Product(
          model: 'quotes_model', // Sesuaikan dengan model Anda
          pk: _quotes.length + 1,
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
      body: GridView.builder(
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
              //key: ValueKey<String>(_quotes[index].pk.toString()),
              quote: _quotes[index],
              onEditPressed: () {
                _editQuote(index);
              },
              //quotes: _quotes,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndAddQuote,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFFAEFDF),
      ),
    );
  }
}
