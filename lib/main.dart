import 'package:flutter/material.dart';
import 'pages/parks_list_page.dart';
import 'pages/parks_map_page.dart';
import 'pages/shop_page.dart';


void main() {
  runApp(const FloridaStateParksApp());
}

class FloridaStateParksApp extends StatelessWidget {
  const FloridaStateParksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Florida State Parks',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ParksListPage(), // 👈 shows list of parks
    ParksMapPage(),  // 👈 shows map view
    ShopPage(),      // 👈 shows shop
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.park), label: "Parks"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Shop"),
        ],
      ),
    );
  }
}
