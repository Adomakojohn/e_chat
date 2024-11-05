// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String tileIcon;
  final String tileName;
  final dynamic trail;
  final Color? color;
  final void Function()? onTap;
  const SettingsTile({
    super.key,
    this.color,
    this.onTap,
    required this.tileIcon,
    required this.tileName,
    required this.trail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        tileColor: Colors.white,
        leading: Image.asset(
          tileIcon,
          height: 30,
        ),
        trailing: trail,
        title: Text(
          tileName,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 19,
          ),
        ),
      ),
    );
  }
}
