import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/models/cart_item.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:readme_mobile/shop/screens/shop_item_detail.dart';
import 'package:readme_mobile/constants/constants.dart';

class CartItemCard extends StatefulWidget {
  final CartItem cartItem;
  final Function(CartItem) onDelete;
  final ValueNotifier<int> total;

  const CartItemCard({
    required this.cartItem,
    required this.onDelete,
    required this.total,
    Key? key,
  }) : super(key: key);

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShopItemDetailPage(
                        shopItem: widget.cartItem.item,
                        openedFromCart: true,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 150 / 220,
                      child: Image.network(widget.cartItem.item.book.imageUrl,
                          fit: BoxFit.fill),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${widget.cartItem.item.book.title} (${widget.cartItem.item.book.publicationDate.year})",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.stars,
                    color: Color(0xfffbbd61),
                    size: 26,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${widget.cartItem.item.price * widget.cartItem.amount}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xfffbbd61),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            height: 40,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                decrementCartItem(
                                    widget.cartItem.id.toString(), request);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: const Color(0xfffbbd61),
                            height: 40,
                            child: Center(
                              child: Text(
                                '${widget.cartItem.amount}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xfffbbd61),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            height: 40,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                incrementCartItem(
                                    widget.cartItem.id.toString(), request);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      onPressed: () {
                        deleteCartItem(widget.cartItem, request);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> incrementCartItem(
      String cartItemId, CookieRequest request) async {
    var url = Uri.parse('$baseUrl/shop/cart/increment-cart-item/$cartItemId');
    var response = await http.put(url, headers: request.headers);
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      setState(() {
        widget.cartItem.amount += 1;
        widget.total.value += widget.cartItem.item.price;
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text("Not enough stock!"),
        ));
    }
  }

  Future<void> decrementCartItem(
      String cartItemId, CookieRequest request) async {
    var url = Uri.parse('$baseUrl/shop/cart/decrement-cart-item/$cartItemId');
    var response = await http.put(url, headers: request.headers);
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      setState(() {
        if (widget.cartItem.amount > 0) {
          widget.cartItem.amount -= 1;
          widget.total.value -= widget.cartItem.item.price;
        }
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text("Not enough stock!"),
        ));
    }
  }

  Future<void> deleteCartItem(CartItem cartItem, CookieRequest request) async {
    var url = Uri.parse('$baseUrl/shop/cart/remove-from-cart/${cartItem.id}');
    var response = await http.delete(url, headers: request.headers);
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      widget.onDelete(cartItem);
    }
    String message = responseData['message'];
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
      ));
  }
}
