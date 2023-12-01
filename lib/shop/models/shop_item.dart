// To parse this JSON data, do
//
//     final shopItem = shopItemFromJson(jsonString);

import 'dart:convert';

ShopItem shopItemFromJson(String str) => ShopItem.fromJson(json.decode(str));

String shopItemToJson(ShopItem data) => json.encode(data.toJson());

class ShopItem {
  bool status;
  String message;
  List<ShopItemElement> shopItems;

  ShopItem({
    required this.status,
    required this.message,
    required this.shopItems,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) => ShopItem(
        status: json["status"],
        message: json["message"],
        shopItems: List<ShopItemElement>.from(
            json["shop_items"].map((x) => ShopItemElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "shop_items": List<dynamic>.from(shopItems.map((x) => x.toJson())),
      };
}

class ShopItemElement {
  int id;
  int price;
  int amount;
  Book book;

  ShopItemElement({
    required this.id,
    required this.price,
    required this.amount,
    required this.book,
  });

  factory ShopItemElement.fromJson(Map<String, dynamic> json) =>
      ShopItemElement(
        id: json["id"],
        price: json["price"],
        amount: json["amount"],
        book: Book.fromJson(json["book"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "amount": amount,
        "book": book.toJson(),
      };
}

class Book {
  int id;
  String isbn;
  String title;
  String description;
  String author;
  String publisher;
  DateTime publicationDate;
  int pageCount;
  String category;
  String imageUrl;
  Lang lang;

  Book({
    required this.id,
    required this.isbn,
    required this.title,
    required this.description,
    required this.author,
    required this.publisher,
    required this.publicationDate,
    required this.pageCount,
    required this.category,
    required this.imageUrl,
    required this.lang,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        isbn: json["isbn"],
        title: json["title"],
        description: json["description"],
        author: json["author"],
        publisher: json["publisher"],
        publicationDate: DateTime.parse(json["publication_date"]),
        pageCount: json["page_count"],
        category: json["category"],
        imageUrl: json["image_url"],
        lang: langValues.map[json["lang"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isbn": isbn,
        "title": title,
        "description": description,
        "author": author,
        "publisher": publisher,
        "publication_date":
            "${publicationDate.year.toString().padLeft(4, '0')}-${publicationDate.month.toString().padLeft(2, '0')}-${publicationDate.day.toString().padLeft(2, '0')}",
        "page_count": pageCount,
        "category": category,
        "image_url": imageUrl,
        "lang": langValues.reverse[lang],
      };
}

enum Lang { EN, ID }

final langValues = EnumValues({"en": Lang.EN, "id": Lang.ID});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
