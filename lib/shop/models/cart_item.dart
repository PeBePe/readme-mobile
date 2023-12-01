// To parse this JSON data, do
//
//     final shoppingCartItem = shoppingCartItemFromJson(jsonString);

import 'dart:convert';

ShoppingCartItem shoppingCartItemFromJson(String str) =>
    ShoppingCartItem.fromJson(json.decode(str));

String shoppingCartItemToJson(ShoppingCartItem data) =>
    json.encode(data.toJson());

class ShoppingCartItem {
  bool status;
  String message;
  List<CartItem> cartItems;

  ShoppingCartItem({
    required this.status,
    required this.message,
    required this.cartItems,
  });

  factory ShoppingCartItem.fromJson(Map<String, dynamic> json) =>
      ShoppingCartItem(
        status: json["status"],
        message: json["message"],
        cartItems: List<CartItem>.from(
            json["cart_items"].map((x) => CartItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "cart_items": List<dynamic>.from(cartItems.map((x) => x.toJson())),
      };
}

class CartItem {
  int id;
  int amount;
  Item item;

  CartItem({
    required this.id,
    required this.amount,
    required this.item,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        amount: json["amount"],
        item: Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "item": item.toJson(),
      };
}

class Item {
  int id;
  int price;
  int amount;
  Book book;

  Item({
    required this.id,
    required this.price,
    required this.amount,
    required this.book,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
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
  String lang;

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
        lang: json["lang"],
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
        "lang": lang,
      };
}
