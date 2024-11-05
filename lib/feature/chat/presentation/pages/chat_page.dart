import 'package:chat_app/core/utils/widgets/chat_bubble.dart';
import 'package:chat_app/core/utils/widgets/my_textfield.dart';
import 'package:chat_app/feature/authentication/auth_service.dart';
import 'package:chat_app/feature/chat/data/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String receiverID;
  const ChatPage({
    super.key,
    required this.recieverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();

  final ChatServices chatServices = ChatServices();

  final AuthServices authServices = AuthServices();

  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(
      () {
        if (myFocusNode.hasFocus) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () => scrollDown(),
          );
        }
      },
    );
    //scroll to last message upon opening chat page
    Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
      () => scrollDown(),
    );
  }

  final ScrollController scrollController = ScrollController();
  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    myFocusNode.dispose();
  }

//send message
  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatServices.sendMessage(widget.receiverID, messageController.text);
    }
    messageController.clear();
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.recieverEmail),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildUserInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = authServices.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: chatServices.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("loading...");
        }
        return ListView(
          controller: scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data["senderID"] == authServices.getCurrentUser()!.uid;

    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        MyChatBubble(
          textfieldMessage: data["message"],
          isSender: isCurrentUser,
        ),
      ],
    );
  }

  Widget _buildUserInput() {
    return Container(
      height: 100,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () async {},
            icon: const Icon(
              Icons.add,
              color: Colors.blueAccent,
              size: 32,
            ),
          ),
          MyTextfield(
            focusNode: myFocusNode,
            textfieldController: messageController,
            hintText: 'Type a message...',
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
