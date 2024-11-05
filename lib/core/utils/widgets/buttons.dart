import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final void Function()? onTap;
  final String buttonText;
  const MyButton({
    super.key,
    this.onTap,
    required this.buttonText,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        height: 60,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            begin: Alignment(-0, 0),
            colors: [
              Color(0xFF40C4FF),
              Color(0xFF03A9F4),
            ],
          ),
        ),
        child: Text(
          widget.buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
