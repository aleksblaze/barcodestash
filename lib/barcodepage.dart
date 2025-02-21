import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'barcode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'barcode_details.dart';

class BarcodePage extends StatefulWidget {
  @override
  _BarcodePageState createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload data or perform any necessary updates here
    setState(() {});
  }

  Future<String?> _loadImagePath(String barcodeId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('barcode_image_$barcodeId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BarcodeProvider>(
        builder: (context, barcodeProvider, child) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of items per row
              crossAxisSpacing: 0.0, // Spacing between columns
              mainAxisSpacing: 2.0, // Spacing between rows
              childAspectRatio: 1.5, // Aspect ratio of each item
            ),
            padding: const EdgeInsets.all(0.0),
            itemCount: barcodeProvider.barcodes.length,
            itemBuilder: (context, index) {
              final barcode = barcodeProvider.barcodes[index];
              return FutureBuilder<String?>(
                future: _loadImagePath(barcode.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final imageUrl = snapshot.data ?? '';
                  return Card(
                    color: imageUrl.length > 3 ? Colors.white : barcode.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BarcodeDetailsPage(barcode: barcode),
                          ),
                        ).then((result) {
                          if (result == true) {
                            // Refresh the state when returning from BarcodeDetailsPage
                            setState(() {});
                          }
                        });
                      },
                        child: Stack(
                        children: [
                          if (imageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9.0),
                            child: Image.file(
                            File(imageUrl),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            ),
                          )
                          else
                          Container(
                            decoration: BoxDecoration(
                            color: barcode.color,
                            borderRadius: BorderRadius.circular(9.0),
                            ),
                            child: Center(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                barcode.name[0], // First letter of the name
                                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              ),
                            ),
                            
                            ),
                          ),
                          Positioned(
                          bottom: 5.0,
                          left: 8.0,
                          right: 8.0,
                          child: Text(
                            barcode.name,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          ),
                        ],
                        ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}