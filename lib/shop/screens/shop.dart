import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/widgets/shop_item_card.dart';
import 'package:readme_mobile/readme/widgets/left_drawer.dart';
import 'package:readme_mobile/shop/models/shop_item.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/shop/screens/shopping_cart.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String _searchTerm = '';
  String _priceRange = '';
  ValueNotifier<int> loyaltyPoints = ValueNotifier<int>(0);

  Future<List<ShopItemElement>> fetchItem(request) async {
    var url = Uri.http('10.0.2.2:8000', '/api/shop', {
      'q': _searchTerm,
      'pricerange': _priceRange,
    });
    var data = await request.get(url.toString());

    List<ShopItemElement> items = [];
    for (var i = 0; i < data['shop_items'].length; i++) {
      items.add(ShopItemElement.fromJson(data['shop_items'][i]));
    }
    return items;
  }

  Future<int> fetchProfile(request) async {
    var url = Uri.http('10.0.2.2:8000', '/api/profile');
    var data = await request.get(url.toString());
    if (data['status']) {
      loyaltyPoints.value = data['user']['loyalty_point'];
      return loyaltyPoints.value;
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // center the widgets
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: SizedBox(
                  height: 38.0,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchTerm = value;
                      });
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.tune, color: Color(0xFF1E1915)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('Filter by price range'),
                      children: <String>[
                        '',
                        '0-399',
                        '400-699',
                        '700-999',
                        '1000+'
                      ].map((String value) {
                        return SimpleDialogOption(
                          onPressed: () {
                            setState(() {
                              if (value == '1000+') {
                                _priceRange = '1000-10000000';
                              } else {
                                _priceRange = value;
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            value.isEmpty ? "All price" : value,
                            style: const TextStyle(color: Color(0xFF1E1915)),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: FutureBuilder(
              future: fetchProfile(request),
              builder: (context, AsyncSnapshot snapshot) {
                return Row(
                  children: <Widget>[
                    const Icon(
                      Icons.stars,
                      color: Color(0xfffbbd61),
                      size: 28,
                    ),
                    const SizedBox(width: 2),
                    ValueListenableBuilder<int>(
                      valueListenable: loyaltyPoints,
                      builder: (context, value, child) {
                        return Text(
                          '$value',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              iconSize: 30.0,
              color: const Color(0xFF1E1915),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShoppingCartPage(loyaltyPoints)),
                );
              },
            ),
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
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ShopItemCard(item),
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
