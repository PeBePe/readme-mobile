// To parse this JSON data, do
//
//     final postItem = postItemFromJson(jsonString);

import 'dart:convert';

PostItem postItemFromJson(String str) => PostItem.fromJson(json.decode(str));

String postItemToJson(PostItem data) => json.encode(data.toJson());

class PostItem {
    bool status;
    String message;
    Post post;

    PostItem({
        required this.status,
        required this.message,
        required this.post,
    });

    factory PostItem.fromJson(Map<String, dynamic> json) => PostItem(
        status: json["status"],
        message: json["message"],
        post: Post.fromJson(json["post"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "post": post.toJson(),
    };
}

class Post {
    String content;
    DateTime createdAt;
    DateTime updatedAt;
    User user;
    Book book;
    int likesCount;

    Post({
        required this.content,
        required this.createdAt,
        required this.updatedAt,
        required this.user,
        required this.book,
        required this.likesCount,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
        book: Book.fromJson(json["book"]),
        likesCount: json["likes_count"],
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
        "book": book.toJson(),
        "likes_count": likesCount,
    };
}

class Book {
    int id;
    String title;
    String author;
    String imageUrl;
    DateTime publicationDate;

    Book({
        required this.id,
        required this.title,
        required this.author,
        required this.imageUrl,
        required this.publicationDate,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        imageUrl: json["image_url"],
        publicationDate: DateTime.parse(json["publication_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "image_url": imageUrl,
        "publication_date": "${publicationDate.year.toString().padLeft(4, '0')}-${publicationDate.month.toString().padLeft(2, '0')}-${publicationDate.day.toString().padLeft(2, '0')}",
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
