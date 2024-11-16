import 'package:chat_app/core/utils/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List settingstile = [
    {
      'tile': const SettingsTile(
        tileIcon: 'assets/icons/text-icon.png',
        tileName: 'Language',
        trail: Icon(Icons.arrow_forward_ios_outlined),
      ),
      'route': '/language',
    },
    {
      'tile': const SettingsTile(
        tileIcon: 'assets/icons/volume-loud.png',
        tileName: 'Mute Notification',
        trail: Icon(Icons.arrow_forward_ios_outlined),
      ),
      'route': '/muteNotification',
    },
    {
      'tile': const SettingsTile(
        tileIcon: 'assets/icons/Bell.png',
        tileName: 'Custom Notification',
        trail: Icon(Icons.arrow_forward_ios_outlined),
      ),
      'route': '/customNotification',
    },
    {'tile': const Divider()},
    {
      'tile': const SettingsTile(
        tileIcon: 'assets/icons/add-user.png',
        tileName: 'Invite Friends',
        trail: Icon(Icons.arrow_forward_ios_outlined),
      ),
      'route': '/inviteFriends',
    },
    {
      'tile': const SettingsTile(
        tileIcon: 'assets/icons/groups.png',
        tileName: 'Joined Groups',
        trail: Icon(Icons.arrow_forward_ios_outlined),
      ),
      'route': '/joinedGroups',
    },
    {
      'tile': const SettingsTile(
        tileIcon: 'assets/icons/Notes.png',
        tileName: 'Term of Service',
        trail: Icon(Icons.arrow_forward_ios_outlined),
      ),
      'route': '/termsOfService',
    },
    {
      'tile': const SettingsTile(
        tileIcon: 'assets/icons/layers.png',
        tileName: 'About App',
        trail: Icon(Icons.arrow_forward_ios_outlined),
      ),
      'route': '/aboutApp',
    },
    {
      'tile': const SettingsTile(
        tileIcon: 'assets/icons/question-circle.png',
        tileName: 'Help Service',
        trail: Icon(Icons.arrow_forward_ios_outlined),
      ),
      'route': '/helpService',
    },
    {
      'tile': const SettingsTile(
        tileIcon: 'assets/icons/logout.png',
        tileName: 'Logout',
        color: Colors.red,
        trail: Text(''),
      ),
      'route': 'logout', // Special route key for logout action
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Row(
          children: [
            ImageIcon(
              AssetImage('assets/logos/Logo.png'),
              size: 60,
              color: Colors.white,
            ),
            Text(
              'E-chat',
              style: TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: settingstile.length,
              itemBuilder: (context, index) {
                final item = settingstile[index];
                final isLogout = item['route'] == 'logout';

                return isLogout
                    ? InkWell(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, 'loginpage');
                        },
                        child: item['tile'],
                      )
                    : item['tile']; // Only logout tile is clickable
              },
            ),
          ),
        ],
      ),
    );
  }
}
