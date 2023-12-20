// To parse this JSON data, do
//
//     final like = likeFromJson(jsonString);

import 'dart:convert';

List<Like> likeFromJson(String str) => List<Like>.from(json.decode(str).map((x) => Like.fromJson(x)));

String likeToJson(List<Like> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Like {
    Model model;
    int pk;
    Fields fields;

    Like({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Like.fromJson(Map<String, dynamic> json) => Like(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    DateTime createdAt;
    int userId;
    int postId;

    Fields({
        required this.createdAt,
        required this.userId,
        required this.postId,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        createdAt: DateTime.parse(json["created_at"]),
        userId: json["user_id"],
        postId: json["post_id"],
    );

    Map<String, dynamic> toJson() => {
        "created_at": createdAt.toIso8601String(),
        "user_id": userId,
        "post_id": postId,
    };
}

enum Model {
    POST_LIKE
}

final modelValues = EnumValues({
    "post.like": Model.POST_LIKE
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
