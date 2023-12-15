import 'package:flutter/material.dart';
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
    // Hitung jumlah quotes
    final numberOfQuotes = _quotes.length;

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
              itemCount: numberOfQuotes,
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
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Terdapat $numberOfQuotes Quotes dalam Profilemu!',
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
