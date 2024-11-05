import 'package:chat_app/feature/authentication/auth_service.dart';
import 'package:chat_app/feature/chat/data/chat_services.dart';
import 'package:chat_app/feature/chat/presentation/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/widgets/user_message_tile.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatServices chatService = ChatServices();
  final AuthServices authServices = AuthServices();

  final bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: const Row(
          children: [
            ImageIcon(
              AssetImage(
                'assets/logos/Logo.png',
              ),
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
        leading: IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, 'loginpage');
          },
          icon: const Icon(Icons.logout_rounded),
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error...");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != authServices.getCurrentUser()!.email) {
      return UserMessageTile(
        subtitleText: 'hello',
        text: userData["email"],
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  recieverEmail: userData['email'],
                  receiverID: userData['uid'],
                ),
              ));
        },
      );
    } else {
      return const SizedBox();
    }
  }
}
