import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/models/shop_item.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/shop/screens/shop_item_detail.dart';

class ShopItemCard extends StatefulWidget {
  final ShopItemElement shopItem;

  const ShopItemCard(this.shopItem, {super.key});

  @override
  State<ShopItemCard> createState() => _ShopItemCardState();
}

class _ShopItemCardState extends State<ShopItemCard> {
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
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShopItemDetailPage(shopItem: widget.shopItem),
                    ),
                  );
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 220,
                      width: 150,
                      child: Image.network(widget.shopItem.book.imageUrl,
                          fit: BoxFit.fill),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${widget.shopItem.book.title} (${widget.shopItem.book.publicationDate.year})",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Spacer(),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A4100),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${widget.shopItem.amount} Available',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.stars,
                          color: Color(0xfffbbd61),
                          size: 22,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${widget.shopItem.price}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: widget.shopItem.amount > 0
                      ? () async {
                          final response = await request.post(
                            "http://10.0.2.2:8000/api/shop/add-to-cart/${widget.shopItem.id}",
                            "",
                          );
                          String message = response['message'];
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                              content: Text(message),
                            ));
                        }
                      : null, // disable the button when the shop item amount is 0
                  style: TextButton.styleFrom(
                    backgroundColor: widget.shopItem.amount > 0
                        ? const Color(0xfffbbd61)
                        : Colors.grey
                            .shade600, // change the background color when the button is disabled
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.shopItem.amount > 0
                        ? 'Add to Cart'
                        : 'Out of Stock', // change the text when the button is disabled
                    style: const TextStyle(
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
