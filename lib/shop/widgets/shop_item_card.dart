import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/models/shop_item.dart';

class ShopItemCard extends StatelessWidget {
  final ShopItemElement shopItem;

  const ShopItemCard(this.shopItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 3), // changes position of shadow
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
                    child:
                        Image.network(shopItem.book.imageUrl, fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${shopItem.book.title} (${shopItem.book.publicationDate.year})",
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF5A4100),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${shopItem.amount} Available',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '\$${shopItem.price}',
                    style: const TextStyle(
                      fontSize: 14,
                      // color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // add your code here to handle the button press
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xfffbbd61),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
