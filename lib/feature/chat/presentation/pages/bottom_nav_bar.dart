import 'package:flutter/material.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _selectedIndex = 0;

  // List of widgets to display for each tab
  final List<Widget> _widgetOptions = <Widget>[
    const Text('Home',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    const Text('Search',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    const Text('Notifications',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    const Text('Profile',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 900,
              width: 400,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
