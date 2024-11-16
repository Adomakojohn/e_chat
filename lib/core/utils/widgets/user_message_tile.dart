import 'package:flutter/material.dart';

class UserMessageTile extends StatelessWidget {
  final String text;
  final String subtitleText;
  final Widget? trailing;
  final void Function()? onTap;
  const UserMessageTile({
    this.trailing,
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
        padding: const EdgeInsets.all(4.5),
        child: ListTile(
          trailing: trailing,
          subtitle: Text(subtitleText),
          leading: const Icon(Icons.person_3),
          title: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
