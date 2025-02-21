import 'package:flutter/material.dart';

class ShoppingItem {
  final String id;
  final String name;
  bool isBought;
  int quantity;
  double price;

  ShoppingItem({
    required this.id,
    required this.name,
    this.isBought = false,
    this.quantity = 1,
    this.price = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isBought': isBought,
      'quantity': quantity,
      'price': price,
    };
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      isBought: json['isBought'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}