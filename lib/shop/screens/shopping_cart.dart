import 'package:flutter/material.dart';
import 'package:readme_mobile/readme/widgets/left_drawer.dart';
import 'package:readme_mobile/shop/models/cart_item.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/shop/widgets/cart_item_card.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  Future<List<CartItem>> fetchItem(request) async {
    var data = await request.get('http://10.0.2.2:8000/api/shop/cart');

    List<CartItem> items = [];
    for (var i = 0; i < data['cart_items'].length; i++) {
      items.add(CartItem.fromJson(data['cart_items'][i]));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Shopping Cart',
          ),
        ),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchItem(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              itemCount: (snapshot.data.length / 2)
                  .ceil(), // calculate the number of rows
              itemBuilder: (context, index) {
                int start = index * 2;
                int end = start + 2;
                if (end > snapshot.data.length) {
                  end = snapshot.data.length;
                }
                return Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: snapshot.data
                            .sublist(start, end)
                            .map<Widget>((item) {
                          return Flexible(
                            fit: FlexFit.tight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CartItemCard(item),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16.0), // add a gap between each row
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
