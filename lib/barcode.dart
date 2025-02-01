import 'package:flutter/material.dart';

class BarcodeIn {
  final String id;
  String name;
  final String code;
  String type;
  Color color; // Add color field
  String imageUrl; // Add imageUrl field

  BarcodeIn({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.color, // Add color field
    required this.imageUrl, // Add imageUrl field
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      'color': color.value, // Store color as an integer
      'imageUrl': imageUrl,
    };
  }

  factory BarcodeIn.fromJson(Map<String, dynamic> json) {
    return BarcodeIn(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      type: json['type'] ?? 'GS1-128',
      color: Color(json['color'] ?? 0xFFFFFFFF), // Retrieve color from integer
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}