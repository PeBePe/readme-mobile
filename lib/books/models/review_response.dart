// To parse this JSON data, do
//
//     final reviewResponse = reviewResponseFromJson(jsonString);

import 'dart:convert';

ReviewResponse reviewResponseFromJson(String str) =>
    ReviewResponse.fromJson(json.decode(str));

String reviewResponseToJson(ReviewResponse data) => json.encode(data.toJson());

class ReviewResponse {
  bool status;
  String message;
  List<Review> reviews;

  ReviewResponse({
    required this.status,
    required this.message,
    required this.reviews,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
        status: json["status"],
        message: json["message"],
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };
}

class Review {
  int id;
  String content;
  String createdAt;
  String updatedAt;
  User user;

  Review({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        content: json["content"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user": user.toJson(),
      };
}

class User {
  int id;
  String name;
  String username;
  String biodata;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.biodata,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        biodata: json["biodata"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "biodata": biodata,
      };
}
