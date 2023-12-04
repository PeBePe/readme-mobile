// To parse this JSON data, do
//
//     final bookshelfItem = bookshelfItemFromJson(jsonString);

import 'dart:convert';

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
  Item item;

  BookshelfItemElement({
    required this.id,
    required this.amount,
    required this.item,
  });

  factory BookshelfItemElement.fromJson(Map<String, dynamic> json) =>
      BookshelfItemElement(
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
