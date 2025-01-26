import 'package:flutter/material.dart';
import 'barcode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BarcodeProvider with ChangeNotifier {
  List<BarcodeIn> _barcodes = [];

  List<BarcodeIn> get barcodes => _barcodes;

  BarcodeProvider() {
    _loadBarcodes();
  }

  void addBarcode(BarcodeIn barcode) {
    _barcodes.add(barcode);
    _saveBarcodes();
    notifyListeners();
  }

  void removeBarcode(String id) {
    _barcodes.removeWhere((barcode) => barcode.id == id);
    _saveBarcodes();
    notifyListeners();
  }

  void _saveBarcodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> barcodeList = _barcodes.map((barcode) => jsonEncode(barcode.toJson())).toList();
    prefs.setStringList('barcodes', barcodeList);
  }

  void _loadBarcodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? barcodeList = prefs.getStringList('barcodes');
    if (barcodeList != null) {
      _barcodes = barcodeList.map((barcode) => BarcodeIn.fromJson(jsonDecode(barcode))).toList();
      notifyListeners();
    }
  }
}