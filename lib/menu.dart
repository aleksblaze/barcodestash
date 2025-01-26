import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class MenuPage extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<MenuPage> {
  String profileImageUrl = '';
  String name = 'No name';
  bool isNameChanged = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImageUrl = prefs.getString('profileImageUrl') ?? '';
      name = prefs.getString('name') ?? 'No name';
      isNameChanged = name != 'No name';
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImageUrl', profileImageUrl);
    await prefs.setString('name', name);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImageUrl = pickedFile.path;
      });
      _saveProfile();
    }
  }

  Future<void> _changeName() async {
    TextEditingController nameController = TextEditingController(text: name);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Change Name', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Barlow')),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Barlow'),),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  isNameChanged = true;
                });
                _saveProfile();
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Barlow'),
            ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),
                Text(
                  'Account',
                  style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold, fontFamily: 'Barlow'),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: profileImageUrl.isNotEmpty
                                ? FileImage(File(profileImageUrl))
                                : null,
                            child: profileImageUrl.isEmpty
                                ? Icon(Icons.person, size: 50)
                                : null,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        TextButton(
                          onPressed: _changeName,
                          child: Text(isNameChanged ? 'Change Name' : 'Add Name', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Settings',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/about');
                          },
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outlined, color: Colors.black),
                              SizedBox(width: 10),
                              Text('About', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                            ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
