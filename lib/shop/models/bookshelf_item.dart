// To parse this JSON data, do
//
//     final bookshelfItem = bookshelfItemFromJson(jsonString);

import 'dart:convert';
import 'package:readme_mobile/shop/models/shop_item.dart';

BookshelfItem bookshelfItemFromJson(String str) =>
    BookshelfItem.fromJson(json.decode(str));

String bookshelfItemToJson(BookshelfItem data) => json.encode(data.toJson());

class BookshelfItem {
  bool status;
  String message;
  List<BookshelfItemElement> bookshelfItems;

  BookshelfItem({
    required this.status,
    required this.message,
    required this.bookshelfItems,
  });

  factory BookshelfItem.fromJson(Map<String, dynamic> json) => BookshelfItem(
        status: json["status"],
        message: json["message"],
        bookshelfItems: List<BookshelfItemElement>.from(json["bookshelf_items"]
            .map((x) => BookshelfItemElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "bookshelf_items":
            List<dynamic>.from(bookshelfItems.map((x) => x.toJson())),
      };
}

class BookshelfItemElement {
  int id;
  int amount;
  ShopItemElement item;

  BookshelfItemElement({
    required this.id,
    required this.amount,
    required this.item,
  });

  factory BookshelfItemElement.fromJson(Map<String, dynamic> json) =>
      BookshelfItemElement(
        id: json["id"],
        amount: json["amount"],
        item: ShopItemElement.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "item": item.toJson(),
      };
}
