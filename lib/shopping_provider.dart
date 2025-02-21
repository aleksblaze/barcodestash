import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'shopping_list.dart';
import 'shopping_item.dart';

class ShoppingProvider with ChangeNotifier {
  List<ShoppingList> _shoppingLists = [];

  List<ShoppingList> get shoppingLists => _shoppingLists;

  ShoppingProvider() {
    loadFromPrefs();
  }

  void addShoppingList(String name) {
    final newList = ShoppingList(id: Uuid().v4(), name: name);
    _shoppingLists.add(newList);
    notifyListeners();
    _saveToPrefs();
  }

  void addShoppingItem(String listId, String itemName) {
    final list = _shoppingLists.firstWhere((list) => list.id == listId);
    final newItem = ShoppingItem(id: Uuid().v4(), name: itemName);
    list.items = List.from(list.items)..add(newItem); // Create a new list with the new item
    notifyListeners();
    _saveToPrefs();
  }

  void toggleItemBought(String listId, String itemId, int quantity, double price) {
    final list = _shoppingLists.firstWhere((list) => list.id == listId);
    final item = list.items.firstWhere((item) => item.id == itemId);
    item.isBought = !item.isBought;
    item.quantity = quantity;
    item.price = price;
    list.items = List.from(list.items); // Create a new list to ensure it's modifiable
    notifyListeners();
    _saveToPrefs();
  }

  void completePurchase(String listId) {
    _shoppingLists.removeWhere((list) => list.id == listId);
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_shoppingLists.map((list) => list.toJson()).toList());
    prefs.setString('shopping_lists', data);
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('shopping_lists');
    if (data != null) {
      final decoded = jsonDecode(data) as List;
      _shoppingLists = decoded.map((json) => ShoppingList.fromJson(json)).toList();
      notifyListeners();
    }
  }
}