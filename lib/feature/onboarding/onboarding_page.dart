import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  final String onboardImage;
  final String onboardMainText;
  final String onboardSecondText;
  final String onboardThirdText;

  const OnboardingPage({
    super.key,
    required this.onboardImage,
    required this.onboardMainText,
    required this.onboardSecondText,
    required this.onboardThirdText,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: ClipPath(
              clipper: MyClipperClass(),
              child: Container(
                height: screenHeight * 0.5, // Adjusted height
                width: screenWidth, // Full screen width
                decoration: const BoxDecoration(
                  color: Color(0xFFecf9ff),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: ClipPath(
              clipper: MyClipperClass(),
              child: Container(
                height: screenHeight * 0.43, // Adjusted height
                width: screenWidth, // Full screen width
                decoration: const BoxDecoration(
                  color: Color(0xFFc4edff),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.5, // Adjusted bottom position
            child: Image.asset(
              widget.onboardImage,
              height: screenHeight * 0.53,
              width: screenWidth * 0.7,
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
              child: Text(
                widget.onboardMainText,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? Colors.white
                      : Colors.blue[800],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.5,
            child: Text(
              widget.onboardSecondText,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w400,
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.blue[800],
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.47, // Adjusted bottom position
            child: Text(
              widget.onboardThirdText,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w400,
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipperClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start at the top left corner of the container
    path.moveTo(0.0, 0.0);

    // Draw a curve at the top of the container
    path.quadraticBezierTo(
        size.width / 4, 55, size.width / 2, 60); // First curve
    path.quadraticBezierTo(
        3 * size.width / 4, 55, size.width, 0); // Second curve

    // Continue the path to the bottom right corner
    path.lineTo(size.width, size.height);

    // Close the path by going to the bottom left corner
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
