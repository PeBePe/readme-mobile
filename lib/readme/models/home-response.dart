// To parse this JSON data, do
//
//     final homeResponse = homeResponseFromJson(jsonString);

import 'dart:convert';

HomeResponse homeResponseFromJson(String str) =>
    HomeResponse.fromJson(json.decode(str));

String homeResponseToJson(HomeResponse data) => json.encode(data.toJson());

class HomeResponse {
  bool status;
  String message;
  List<Post> posts;
  List<NewestBook> newestBooks;
  List<String> categories;
  BestQuote bestQuote;

  HomeResponse({
    required this.status,
    required this.message,
    required this.posts,
    required this.newestBooks,
    required this.categories,
    required this.bestQuote,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
        status: json["status"],
        message: json["message"],
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        newestBooks: List<NewestBook>.from(
            json["newest_books"].map((x) => NewestBook.fromJson(x))),
        categories: List<String>.from(json["categories"].map((x) => x)),
        bestQuote: BestQuote.fromJson(json["best_quote"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
        "newest_books": List<dynamic>.from(newestBooks.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x)),
        "best_quote": bestQuote.toJson(),
      };
}

class BestQuote {
  String? quote;
  String? author;

  BestQuote({
    required this.quote,
    required this.author,
  });

  factory BestQuote.fromJson(Map<String, dynamic> json) => BestQuote(
        quote: json["quote"],
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "quote": quote,
        "author": author,
      };
}

class NewestBook {
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

  NewestBook({
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

  factory NewestBook.fromJson(Map<String, dynamic> json) => NewestBook(
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

class Post {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String content;
  User user;
  Book book;

  Post({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    required this.user,
    required this.book,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        content: json["content"],
        user: User.fromJson(json["user"]),
        book: Book.fromJson(json["book"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "content": content,
        "user": user.toJson(),
        "book": book.toJson(),
      };
}

class Book {
  int id;
  String title;
  String author;
  DateTime publicationDate;
  String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publicationDate,
    required this.imageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        publicationDate: DateTime.parse(json["publication_date"]),
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "publication_date":
            "${publicationDate.year.toString().padLeft(4, '0')}-${publicationDate.month.toString().padLeft(2, '0')}-${publicationDate.day.toString().padLeft(2, '0')}",
        "image_url": imageUrl,
      };
}

class User {
  int id;
  String username;
  String name;

  User({
    required this.id,
    required this.username,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
      };
}
