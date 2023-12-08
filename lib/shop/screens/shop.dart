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

  Future<List<ShopItemElement>> fetchItem(request) async {
    var url = Uri.https('readme.up.railway.app', '/api/shop', {
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: SizedBox(
            height: 36.0,
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
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        actions: <Widget>[
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Text(
                "All price", // placeholder text
                style: TextStyle(
                    color: Color(0xFF1E1915)), // style for the hint text
              ),
              value: _priceRange.isEmpty
                  ? null
                  : _priceRange, // if _priceRange is empty, set value to null
              onChanged: (String? newValue) {
                setState(() {
                  _priceRange = newValue ?? '';
                });
              },
              items: <String>['', '0-399', '400-699', '700-999', '1000+']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value.isEmpty
                        ? "All price"
                        : value, // if value is empty, display "All price"
                    style: const TextStyle(
                        color:
                            Color(0xFF1E1915)), // style for the dropdown items
                  ),
                );
              }).toList(),
              dropdownColor:
                  Colors.white, // background color of the dropdown items
              icon: const Icon(
                Icons.arrow_drop_down, // icon for the dropdown button
                color: Color(0xFF1E1915), // color of the icon
              ),
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
                      builder: (context) => const ShoppingCartPage()),
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
