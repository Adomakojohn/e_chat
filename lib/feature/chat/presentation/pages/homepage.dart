import 'package:chat_app/core/utils/widgets/user_message_tile.dart';
import 'package:chat_app/feature/authentication/auth_service.dart';
import 'package:chat_app/feature/chat/data/chat_services.dart';
import 'package:chat_app/feature/chat/presentation/pages/chat_page.dart';
import 'package:chat_app/feature/chat/presentation/pages/search_user_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatServices chatService = ChatServices();
  final AuthServices authServices = AuthServices();
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade800,
        title: isSearch
            ? const SizedBox(
                width: 500,
                child: TextField(),
              )
            : Row(
                children: [
                  const ImageIcon(
                    AssetImage('assets/logos/Logo.png'),
                    size: 60,
                    color: Colors.white,
                  ),
                  const Text(
                    'E-chat',
                    style: TextStyle(
                        fontSize: 21,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchUserPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
      body: FutureBuilder<String?>(
        future: authServices.getCurrentUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No current user found.'));
          }

          String currentUserId = snapshot.data!;

          // StreamBuilder to fetch recent chats sorted by last message timestamp
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: chatService.getRecentChats(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No chats yet.'),
                    Text("Text other users by searching for their emails !"),
                  ],
                ));
              }

              List<Map<String, dynamic>> recentChats = snapshot.data!;

              return ListView.builder(
                itemCount: recentChats.length,
                itemBuilder: (context, index) {
                  final chat = recentChats[index];
                  final memberEmails =
                      chat['membersEmails'] as List<Map<String, String>>;

                  // Get the first member email from the list
                  final otherUser =
                      memberEmails.isNotEmpty ? memberEmails.first : null;
                  final otherUserEmail = otherUser != null
                      ? otherUser['email'] ?? 'Unknown User'
                      : 'Unknown User';
                  final lastMessage = chat['lastMessage'] ?? 'No messages yet';
                  final lastMessageTime = chat['lastMessageTime'];

                  return UserMessageTile(
                    trailing: const Text(''),
                    text: otherUserEmail, // Display the other user's email here
                    subtitleText: lastMessage, // Display last message here
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiverID:
                                otherUser != null ? otherUser['uid']! : '',
                            recieverEmail: otherUserEmail,
                          ),
                        ),
                      );
                    },
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
