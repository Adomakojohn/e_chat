import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class MyChatBubble extends StatelessWidget {
  final String textfieldMessage;
  final bool isSender;
  const MyChatBubble(
      {super.key, required this.textfieldMessage, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return BubbleNormal(
      padding: const EdgeInsets.all(3),
      sent: false,
      text: textfieldMessage,
      tail: true,
      color: isSender ? const Color.fromARGB(255, 38, 95, 194) : Colors.white,
      delivered: false,
      isSender: isSender,
      textStyle: TextStyle(
        color: isSender ? Colors.white : Colors.black,
        fontSize: 21,
      ),
    );
  }
}
