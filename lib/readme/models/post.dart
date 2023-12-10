// To parse this JSON data, do
//
//     final postItem = postItemFromJson(jsonString);

import 'dart:convert';

List<PostItem> postItemFromJson(String str) =>
    List<PostItem>.from(json.decode(str).map((x) => PostItem.fromJson(x)));

String postItemToJson(List<PostItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostItem {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String content;
  User user;
  Book book;
  int likeCount;

  PostItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    required this.user,
    required this.book,
    required this.likeCount,
  });

  factory PostItem.fromJson(Map<String, dynamic> json) => PostItem(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        content: json["content"],
        user: User.fromJson(json["user"]),
        book: Book.fromJson(json["book"]),
        likeCount: json["like_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "content": content,
        "user": user.toJson(),
        "book": book.toJson(),
        "like_count": likeCount,
      };
}

class Book {
  int id;
  String title;
  String imageUrl;
  String author;
  DateTime publicationDate;

  Book({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.publicationDate,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        imageUrl: json["image_url"],
        author: json["author"],
        publicationDate: DateTime.parse(json["publication_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image_url": imageUrl,
        "author": author,
        "publication_date":
            "${publicationDate.year.toString().padLeft(4, '0')}-${publicationDate.month.toString().padLeft(2, '0')}-${publicationDate.day.toString().padLeft(2, '0')}",
      };
}

class User {
  int id;
  String username;
  String name;
  String biodata;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.biodata,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        biodata: json["biodata"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "biodata": biodata,
      };
}
