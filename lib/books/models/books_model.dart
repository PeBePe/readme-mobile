// To parse this JSON data, do
//
//     final books = booksFromJson(jsonString);

import 'dart:convert';

Books booksFromJson(String str) => Books.fromJson(json.decode(str));

String booksToJson(Books data) => json.encode(data.toJson());

class Books {
    bool status;
    String message;
    List<Book> books;
    List<String> categories;

    Books({
        required this.status,
        required this.message,
        required this.books,
        required this.categories,
    });

    factory Books.fromJson(Map<String, dynamic> json) => Books(
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
        lang: langValues.map[json["lang"]]!,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "isbn": isbn,
        "title": title,
        "description": description,
        "author": author,
        "publisher": publisher,
        "publication_date": "${publicationDate.year.toString().padLeft(4, '0')}-${publicationDate.month.toString().padLeft(2, '0')}-${publicationDate.day.toString().padLeft(2, '0')}",
        "page_count": pageCount,
        "category": category,
        "image_url": imageUrl,
        "lang": langValues.reverse[lang],
    };
}

enum Lang {
    EN,
    ID
}

final langValues = EnumValues({
    "en": Lang.EN,
    "id": Lang.ID
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
