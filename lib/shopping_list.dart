import 'shopping_item.dart';

class ShoppingList {
  final String id;
  final String name;
  List<ShoppingItem> items;

  ShoppingList({
    required this.id,
    required this.name,
    this.items = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      name: json['name'],
      items: (json['items'] as List).map((item) => ShoppingItem.fromJson(item)).toList(),
    );
  }
}