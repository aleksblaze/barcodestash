import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'barcode_provider.dart';
import 'barcode.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class BarcodeCreatorPage extends StatefulWidget {
  @override
  _BarcodeCreatorState createState() => _BarcodeCreatorState();
}

class _BarcodeCreatorState extends State<BarcodeCreatorPage> {
  String _imageUrl = '';
  String _barcodeName = '';
  String _barcodeCode = '';
  String _barcodeType = 'EAN-13'; // Default barcode type
  Color _barcodeColor = Colors.primaries[Random().nextInt(Colors.primaries.length)]; // Generate random color

  final TextEditingController _barcodeNameController = TextEditingController();
  final TextEditingController _barcodeCodeController = TextEditingController();

  @override
  void dispose() {
    _barcodeNameController.dispose();
    _barcodeCodeController.dispose();
    super.dispose();
  }

  void _detectBarcodeType(String code) {
    if (RegExp(r'^[0-9]{13}$').hasMatch(code)) {
      _barcodeType = 'EAN-13';
    } else if (RegExp(r'^[0-9]{12}$').hasMatch(code)) {
      _barcodeType = 'UPC-A';
    } else if (RegExp(r'^[0-9]{8}$').hasMatch(code)) {
      _barcodeType = 'EAN-8';
    } else if (RegExp(r'^[0-9]{14}$').hasMatch(code)) {
      _barcodeType = 'ITF-14';
    } else if (RegExp(r'^[0-9A-Z]{1,128}$').hasMatch(code)) {
      _barcodeType = 'Code 128';
    } else {
      _barcodeType = 'EAN-128';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8.0,
              left: 8.0,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(16.0) + const EdgeInsets.only(top: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter the store name and the number for your card',
                      style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _barcodeNameController,
                      decoration: InputDecoration(
                        labelText: 'Barcode Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _barcodeName = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Barcode Code',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _barcodeCode = value;
                          _detectBarcodeType(value);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            if (_barcodeName.isNotEmpty && _barcodeCode.isNotEmpty) {
                              final newBarcode = BarcodeIn(
                                id: Uuid().v4(),
                                name: _barcodeName,
                                code: _barcodeCode,
                                type: _barcodeType,
                                color: _barcodeColor,
                                imageUrl: _imageUrl,
                              );
                              // Save the new barcode
                              Provider.of<BarcodeProvider>(context, listen: false).addBarcode(newBarcode);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Barcode saved successfully')),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please enter both barcode name and code')),
                              );
                            }
                          },
                          child: Text('Save'),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}