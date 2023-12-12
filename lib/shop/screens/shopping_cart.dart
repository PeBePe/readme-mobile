import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/models/cart_item.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/shop/widgets/cart_item_card.dart';

class ShoppingCartPage extends StatefulWidget {
  final ValueNotifier<int> loyaltyPoints;

  const ShoppingCartPage(this.loyaltyPoints, {super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  ValueNotifier<int> total = ValueNotifier<int>(0);

  Future<List<CartItem>> fetchItem(request) async {
    var data = await request.get('http://10.0.2.2:8000/api/shop/cart');

    List<CartItem> items = [];
    int newTotal = 0;
    for (var i = 0; i < data['cart_items'].length; i++) {
      items.add(CartItem.fromJson(data['cart_items'][i]));
      newTotal += items[i].item.price * items[i].amount;
    }

    total.value = newTotal;

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.stars,
                  color: Color(0xfffbbd61),
                  size: 28,
                ),
                const SizedBox(width: 2),
                Text(
                  widget.loyaltyPoints.value.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchItem(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty. Add books from the shop!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
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
                                child: CartItemCard(
                                  cartItem: item,
                                  total: total,
                                  onDelete: (item) {
                                    setState(() {
                                      items.remove(item);
                                    });
                                  },
                                ),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: total,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Total price: ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.stars,
                      color: Color(0xfffbbd61),
                      size: 28,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfffbbd61), // background color
                foregroundColor: Colors.white, // text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final response = await request.post(
                  "http://10.0.2.2:8000/api/shop/cart/checkout",
                  "",
                );
                String message = response['message'];
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(message),
                  ));
                if (response['status']) {
                  widget.loyaltyPoints.value -= total.value;
                  setState(() {}); // rebuild the widget
                }
              },
              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
