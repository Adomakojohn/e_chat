import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController textfieldController;
  final String hintText;
  final FocusNode? focusNode;
  const MyTextfield(
      {super.key,
      required this.textfieldController,
      required this.hintText,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        maxLines: 2,
        focusNode: focusNode,
        controller: textfieldController,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
