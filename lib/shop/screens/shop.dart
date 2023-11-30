import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/widgets/shop_item_card.dart';
import 'package:readme_mobile/readme/widgets/left_drawer.dart';
import 'package:readme_mobile/shop/models/shop_item.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Future<List<ShopItemElement>> fetchItem(request) async {
    var data = await request.get('http://10.0.2.2:8000/api/shop');

    List<ShopItemElement> items = [];
    for (var i = 0; i < data['shop_items'].length; i++) {
      items.add(ShopItemElement.fromJson(data['shop_items'][i]));
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
            'Shop',
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
                              child: ShopItemCard(item),
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
