// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  bool status;
  String message;
  ProfileResponseUser user;

  ProfileResponse({
    required this.status,
    required this.message,
    required this.user,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        status: json["status"],
        message: json["message"],
        user: ProfileResponseUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user": user.toJson(),
      };
}

class ProfileResponseUser {
  int id;
  String username;
  String email;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  DateTime birthdate;
  String biodata;
  String phone;
  int loyaltyPoint;
  String? quote;
  List<CitedQuote> citedQuotes;
  List<Review> reviews;

  ProfileResponseUser({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.birthdate,
    required this.biodata,
    required this.phone,
    required this.loyaltyPoint,
    this.quote,
    required this.citedQuotes,
    required this.reviews,
  });

  factory ProfileResponseUser.fromJson(Map<String, dynamic> json) =>
      ProfileResponseUser(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        birthdate: DateTime.parse(json["birthdate"]),
        biodata: json["biodata"],
        phone: json["phone"],
        loyaltyPoint: json["loyalty_point"],
        quote: json["quote"],
        citedQuotes: List<CitedQuote>.from(
            json["cited_quotes"].map((x) => CitedQuote.fromJson(x))),
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name": name,
        "birthdate":
            "${birthdate.year.toString().padLeft(4, '0')}-${birthdate.month.toString().padLeft(2, '0')}-${birthdate.day.toString().padLeft(2, '0')}",
        "biodata": biodata,
        "phone": phone,
        "loyalty_point": loyaltyPoint,
        "quote": quote,
        "cited_quotes": List<dynamic>.from(citedQuotes.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };
}

class CitedQuote {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String quote;
  CitedQuoteUser user;

  CitedQuote({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.quote,
    required this.user,
  });

  factory CitedQuote.fromJson(Map<String, dynamic> json) => CitedQuote(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        quote: json["quote"],
        user: CitedQuoteUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "quote": quote,
        "user": user.toJson(),
      };
}

class CitedQuoteUser {
  int id;
  String name;

  CitedQuoteUser({
    required this.id,
    required this.name,
  });

  factory CitedQuoteUser.fromJson(Map<String, dynamic> json) => CitedQuoteUser(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Review {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String content;
  Book book;

  Review({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.content,
    required this.book,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        content: json["content"],
        book: Book.fromJson(json["book"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "content": content,
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
