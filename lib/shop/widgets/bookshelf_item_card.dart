import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/models/bookshelf_item.dart';
import 'package:readme_mobile/shop/screens/shop_item_detail.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';

class BookshelfItemCard extends StatefulWidget {
  final BookshelfItemElement bookshelfItem;

  const BookshelfItemCard(this.bookshelfItem, {super.key});

  @override
  State<BookshelfItemCard> createState() => _BookshelfItemCardState();
}

class _BookshelfItemCardState extends State<BookshelfItemCard> {
  @override
  Widget build(BuildContext context) {
    // final request = context.watch<CookieRequest>();
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
                      builder: (context) => ShopItemDetailPage(
                        shopItem: widget.bookshelfItem.item,
                        openedFromCart: false,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 220,
                      width: 150,
                      child: Image.network(
                          widget.bookshelfItem.item.book.imageUrl,
                          fit: BoxFit.fill),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${widget.bookshelfItem.item.book.title} (${widget.bookshelfItem.item.book.publicationDate.year})",
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
              Text(
                'Amount: ${widget.bookshelfItem.amount}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
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
                    '${widget.bookshelfItem.item.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
