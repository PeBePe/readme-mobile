// To parse this JSON data, do
//
//     final bookDetailResponse = bookDetailResponseFromJson(jsonString);

import 'dart:convert';

BookDetailResponse bookDetailResponseFromJson(String str) =>
    BookDetailResponse.fromJson(json.decode(str));

String bookDetailResponseToJson(BookDetailResponse data) =>
    json.encode(data.toJson());

class BookDetailResponse {
  bool status;
  String message;
  Book book;
  dynamic user;

  BookDetailResponse({
    required this.status,
    required this.message,
    required this.book,
    required this.user,
  });

  factory BookDetailResponse.fromJson(Map<String, dynamic> json) =>
      BookDetailResponse(
        status: json["status"],
        message: json["message"],
        book: Book.fromJson(json["book"]),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "book": book.toJson(),
        "user": user,
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
