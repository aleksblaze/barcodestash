import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'barcode_provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'barcode.dart';

class BarcodeDetailsPage extends StatefulWidget {
  final BarcodeIn barcode;

  const BarcodeDetailsPage({Key? key, required this.barcode}) : super(key: key);

  @override
  _BarcodeDetailsPageState createState() => _BarcodeDetailsPageState();
}

class _BarcodeDetailsPageState extends State<BarcodeDetailsPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.barcode.name);
    _loadBarcodeDetails();
  }

  Future<void> _loadBarcodeDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.barcode.imageUrl =
          prefs.getString('barcode_image_${widget.barcode.id}') ?? '';
      widget.barcode.name =
          prefs.getString('barcode_name_${widget.barcode.id}') ??
              widget.barcode.name;
      _nameController.text = widget.barcode.name;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        widget.barcode.imageUrl = pickedFile.path;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'barcode_image_${widget.barcode.id}', pickedFile.path);
      Navigator.pop(context, true); // Return true to indicate changes
    }
  }

  Future<void> _saveBarcodeDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'barcode_name_${widget.barcode.id}', widget.barcode.name);
    Navigator.pop(context, true); // Return true to indicate changes
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8.0, // Adjusted top position to be higher
              left: 8.0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  _saveBarcodeDetails();
                },
              ),
            ),
            Positioned(
              top: 8.0, // Adjusted top position to be higher
              right: 8.0,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Barcode',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Barlow')),
                        content: const Text(
                            'Are you sure you want to delete this barcode?',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Barlow')),
                        actions: <Widget>[
                          TextButton(
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Barlow'),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                  color: Colors.red, fontFamily: 'Barlow'),
                            ),
                            onPressed: () {
                              Provider.of<BarcodeProvider>(context,
                                      listen: false)
                                  .removeBarcode(widget.barcode.id);
                              Navigator.of(context).pushNamed('/');
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0) +
                  const EdgeInsets.only(
                      top: 50.0), // Adjusted padding to include top padding
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.2,
                              blurRadius: 0.2,
                              offset: const Offset(0,
                                  1), // Adjust the offset to move the shadow downwards
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 150,
                        padding: const EdgeInsets.all(10),
                        child: BarcodeWidget(
                          barcode: _getBarcodeType(widget.barcode.type),
                          data: widget.barcode.code,
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 50.0,
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              widget.barcode.name = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: _pickImage,
                        child: const Text('Pick Image'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: _saveBarcodeDetails,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Barcode _getBarcodeType(String type) {
    switch (type) {
      case 'QR Code':
        return Barcode.qrCode();
      case 'Code 128':
        return Barcode.code128();
      case 'EAN-13':
      default:
        return Barcode.ean13();
    }
  }
}
