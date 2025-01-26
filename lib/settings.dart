import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  bool switchValue = false;
  String _selectedTheme = 'Light';
  
  
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SwitchListTile(
                title: Text('Dark mode'),
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    value = value;
                  });
                },
              ),
            ],
          ),
        ));
  }
}
