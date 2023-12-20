// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
    bool status;
    String message;
    Data data;

    Product({
        required this.status,
        required this.message,
        required this.data,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String name;
    List<Quote> quotes;
    int quotesCount;
    List<QuotedQuote> quotedQuotes;

    Data({
        required this.name,
        required this.quotes,
        required this.quotesCount,
        required this.quotedQuotes,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        quotes: List<Quote>.from(json["quotes"].map((x) => Quote.fromJson(x))),
        quotesCount: json["quotes_count"],
        quotedQuotes: List<QuotedQuote>.from(json["quoted_quotes"].map((x) => QuotedQuote.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "quotes": List<dynamic>.from(quotes.map((x) => x.toJson())),
        "quotes_count": quotesCount,
        "quoted_quotes": List<dynamic>.from(quotedQuotes.map((x) => x.toJson())),
    };
}

class QuotedQuote {
    int id;
    DateTime citedAt;
    int userIdId;
    int quoteIdId;

    QuotedQuote({
        required this.id,
        required this.citedAt,
        required this.userIdId,
        required this.quoteIdId,
    });

    factory QuotedQuote.fromJson(Map<String, dynamic> json) => QuotedQuote(
        id: json["id"],
        citedAt: DateTime.parse(json["cited_at"]),
        userIdId: json["user_id_id"],
        quoteIdId: json["quote_id_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "cited_at": citedAt.toIso8601String(),
        "user_id_id": userIdId,
        "quote_id_id": quoteIdId,
    };
}

class Quote {
    int id;
    DateTime createdAt;
    DateTime updatedAt;
    String quote;
    int userId;
    String username;
    int citedCount;
    List<CitedUser> citedUsers;

    Quote({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.quote,
        required this.userId,
        required this.username,
        required this.citedCount,
        required this.citedUsers,
    });

    factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        quote: json["quote"],
        userId: json["user_id"],
        username: json["username"],
        citedCount: json["cited_count"],
        citedUsers: List<CitedUser>.from(json["cited_users"].map((x) => CitedUser.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "quote": quote,
        "user_id": userId,
        "username": username,
        "cited_count": citedCount,
        "cited_users": List<dynamic>.from(citedUsers.map((x) => x.toJson())),
    };
}

class CitedUser {
    int userId;
    String username;

    CitedUser({
        required this.userId,
        required this.username,
    });

    factory CitedUser.fromJson(Map<String, dynamic> json) => CitedUser(
        userId: json["user_id"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "username": username,
    };
}
