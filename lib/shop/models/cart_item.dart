// To parse this JSON data, do
//
//     final shoppingCartItem = shoppingCartItemFromJson(jsonString);

import 'dart:convert';
import 'package:readme_mobile/shop/models/shop_item.dart';

ShoppingCartItem shoppingCartItemFromJson(String str) =>
    ShoppingCartItem.fromJson(json.decode(str));

String shoppingCartItemToJson(ShoppingCartItem data) =>
    json.encode(data.toJson());

class ShoppingCartItem {
  bool status;
  String message;
  List<CartItem> cartItems;

  ShoppingCartItem({
    required this.status,
    required this.message,
    required this.cartItems,
  });

  factory ShoppingCartItem.fromJson(Map<String, dynamic> json) =>
      ShoppingCartItem(
        status: json["status"],
        message: json["message"],
        cartItems: List<CartItem>.from(
            json["cart_items"].map((x) => CartItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "cart_items": List<dynamic>.from(cartItems.map((x) => x.toJson())),
      };
}

class CartItem {
  int id;
  int amount;
  ShopItemElement item;

  CartItem({
    required this.id,
    required this.amount,
    required this.item,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        amount: json["amount"],
        item: ShopItemElement.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "item": item.toJson(),
      };
}
