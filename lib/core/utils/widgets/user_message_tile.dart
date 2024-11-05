import 'package:flutter/material.dart';

class UserMessageTile extends StatelessWidget {
  final String text;
  final String subtitleText;
  final void Function()? onTap;
  const UserMessageTile({
    super.key,
    required this.subtitleText,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(9),
          width: 300,
          height: 80,
          child: ListTile(
            subtitle: Text(subtitleText),
            leading: const Icon(Icons.person_3),
            title: Text(
              text,
              style: const TextStyle(
                fontSize: 19,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
