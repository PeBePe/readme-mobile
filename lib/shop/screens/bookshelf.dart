import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/widgets/bookshelf_item_card.dart';
import 'package:readme_mobile/shop/models/bookshelf_item.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/constants/constants.dart';

class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  Future<List<BookshelfItemElement>> fetchItem(request) async {
    var data = await request.get("$baseUrl/shop/bookshelf");

    List<BookshelfItemElement> items = [];
    for (var i = 0; i < data['bookshelf_items'].length; i++) {
      items.add(BookshelfItemElement.fromJson(data['bookshelf_items'][i]));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Text(
          'Bookshelf',
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchItem(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data.isEmpty) {
            return const Center(
              child: Text(
                'Your bookshelf is empty. Buy some books from the shop!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              itemCount: (snapshot.data.length / 2).ceil(),
              itemBuilder: (context, index) {
                int start = index * 2;
                int end = start + 2;
                if (end > snapshot.data.length) {
                  end = snapshot.data.length;
                }
                List items = snapshot.data.sublist(start, end);
                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...items.map<Widget>((item) {
                            return Flexible(
                              fit: FlexFit.tight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: BookshelfItemCard(item),
                              ),
                            );
                          }).toList(),
                          // If it's the last row and the total number of items is odd, add an empty widget
                          if (index == snapshot.data.length ~/ 2 &&
                              snapshot.data.length.isOdd)
                            Flexible(child: Container()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0), // add a gap between each row
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
