import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/models/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CartItemCard(this.cartItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
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
              Column(
                children: [
                  SizedBox(
                    height: 220,
                    width: 150,
                    child: Image.network(cartItem.item.book.imageUrl,
                        fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${cartItem.item.book.title} (${cartItem.item.book.publicationDate.year})",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      // color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.stars,
                    color: Color(0xfffbbd61),
                    size: 28,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${cartItem.item.price}',
                    style: const TextStyle(
                      fontSize: 18,
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
                                // Add your onPressed code here
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
                                '${cartItem.amount}',
                                style: const TextStyle(
                                  fontSize: 18,
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
                                // Add your onPressed code here
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
                      onPressed: () => {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 22,
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
}
