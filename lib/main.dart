import 'package:barodestash/info.dart';
import 'package:barodestash/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'barcode_provider.dart';
import 'menu.dart';
import 'barcode_creator.dart';
import 'barcodepage.dart';
import 'settings.dart';
import 'about.dart';
import 'barcode_details.dart';
import 'info.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BarcodeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BarcodeProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Barcodes',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: false,
          ),
          localizationsDelegates: [],
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => HomeScreen(),
            '/menu' : (context) => MenuPage(),
            '/barcodepage': (context) => BarcodePage(),
            '/settings': (context) => SettingsPage(),
            '/about': (context) => AboutPage(),
            '/barcode': (context) => BarcodeCreatorPage(),
            '/info': (context) => InfoPage(),
          },
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    MenuPage(),
    BarcodeCreatorPage(),
    BarcodePage(),
    SettingsPage(),
    AboutPage(),
    InfoPage()
  ];

  void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _widgetOptions.elementAt(_selectedIndex),
            if (_selectedIndex == 0)
            Positioned(
              top: 16.0,
              right: 16.0,
              child: Container(
                width: 28.0, // Set the width of the button
                height: 28.0, // Set the height of the button
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: 20),
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.pushNamed(context, '/barcode');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.credit_card : Icons.credit_card_outlined,
                color: _selectedIndex == 0 ? Colors.black : Colors.grey,
              ),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1 ? Icons.account_circle : Icons.account_circle_outlined,
                color: _selectedIndex == 1 ? Colors.black : Colors.grey,
              ),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
          unselectedLabelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 10),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cards',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: BarcodePage(),
          ),
        ],
      ),
    );
  }
}