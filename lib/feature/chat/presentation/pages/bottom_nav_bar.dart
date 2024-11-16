import 'package:chat_app/feature/chat/presentation/pages/groups_page.dart';
import 'package:chat_app/feature/chat/presentation/pages/homepage.dart';
import 'package:chat_app/feature/chat/presentation/pages/menu_page.dart';
import 'package:chat_app/feature/chat/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const GroupsPage(),
    const ProfilePage(),
    const MenuPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildIcon(String image, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: isSelected
          ? Container(
              height: 100,
              width: 90,
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF40C4FF), Color(0xFF03A9F4)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(image, color: Colors.white, height: 30),
                  const SizedBox(height: 2),
                  Text(label, style: const TextStyle(color: Colors.white)),
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(image, height: 30),
                const SizedBox(height: 2),
                Text(label, style: const TextStyle(color: Colors.grey)),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        height: 110,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(16),
            topEnd: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(66, 144, 142, 142),
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          elevation: 10,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIcon('assets/icons/chat-home.png', 'Home', 0),
                _buildIcon('assets/icons/groups.png', 'Groups', 1),
                _buildIcon('assets/icons/user-profile.png', 'Profile', 2),
                _buildIcon('assets/icons/menu.png', 'More', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
