import 'package:flutter/material.dart';
import 'pages/parks_list_page.dart';
import 'pages/parks_map_page.dart';
import 'pages/park_detail_page.dart';
import 'pages/shop_page.dart'; // <-- your shop page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  int _currentIndex = 0;
  Map? _selectedPark;

  void _onParkSelected(Map park) {
    setState(() {
      _selectedPark = park;
      _currentIndex = 0; // switch to List/Detail tab
    });
  }

  void _clearSelectedPark() {
    setState(() {
      _selectedPark = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      // Tab 0: List or Detail
      _selectedPark == null
          ? ParksListPage(
              onParkSelected: (park) {
                setState(() {
                  _selectedPark = park;
                });
              },
            )
          : ParkDetailPage(
              park: _selectedPark!,
              onBack: _clearSelectedPark,
            ),

      // Tab 1: Map
      ParksMapPage(onParkSelected: _onParkSelected),

      // Tab 2: Shop
      const ShopPage(),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Parks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Shop",
          ),
        ],
      ),
    );
  }
}
