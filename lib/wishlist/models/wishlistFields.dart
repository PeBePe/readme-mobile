// To parse this JSON data, do
//
//     final wishlist = wishlistFromJson(jsonString);

import 'dart:convert';

Wishlist wishlistFromJson(String str) => Wishlist.fromJson(json.decode(str));

String wishlistToJson(Wishlist data) => json.encode(data.toJson());

class Wishlist {
  bool status;
  String message;
  List<WishlistElement> wishlists;

  Wishlist({
    required this.status,
    required this.message,
    required this.wishlists,
  });

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        status: json["status"],
        message: json["message"],
        wishlists: List<WishlistElement>.from(
            json["wishlists"].map((x) => WishlistElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "wishlists": List<dynamic>.from(wishlists.map((x) => x.toJson())),
      };
}

class WishlistElement {
  int id;
  DateTime wishlistDate;
  String note;
  int userId;
  Book book;

  WishlistElement({
    required this.id,
    required this.wishlistDate,
    required this.note,
    required this.userId,
    required this.book,
  });

  factory WishlistElement.fromJson(Map<String, dynamic> json) =>
      WishlistElement(
        id: json["id"],
        wishlistDate: DateTime.parse(json["wishlist_date"]),
        note: json["note"],
        userId: json["user_id"],
        book: Book.fromJson(json["book"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "wishlist_date": wishlistDate.toIso8601String(),
        "note": note,
        "user_id": userId,
        "book": book.toJson(),
      };
}

class Book {
  int id;
  String title;
  String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image_url": imageUrl,
      };
}
