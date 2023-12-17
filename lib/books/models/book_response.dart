// To parse this JSON data, do
//
//     final bookResponse = bookResponseFromJson(jsonString);

import 'dart:convert';

BookResponse bookResponseFromJson(String str) =>
    BookResponse.fromJson(json.decode(str));

String bookResponseToJson(BookResponse data) => json.encode(data.toJson());

class BookResponse {
  bool status;
  String message;
  List<Book> books;
  List<String> categories;

  BookResponse({
    required this.status,
    required this.message,
    required this.books,
    required this.categories,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) => BookResponse(
        status: json["status"],
        message: json["message"],
        books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
        categories: List<String>.from(json["categories"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "books": List<dynamic>.from(books.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x)),
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
  int reviewCount;

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
    required this.reviewCount,
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
        reviewCount: json["review_count"],
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
        "review_count": reviewCount,
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
