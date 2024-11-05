import 'package:chat_app/core/utils/widgets/buttons.dart';
import 'package:chat_app/feature/authentication/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscureText = true;

  void login() async {
    final authService = AuthServices();
    setState(() {
      isLoading = true;
    });
    try {
      await authService.signInWithEmailPassword(
        emailController.text,
        passwordController.text,
      );
      Navigator.pushReplacementNamed(context, 'homepage');
    } catch (e) {
      if (e.toString() == 'user-not-found') {
        showErrorMessage('No user found for that email.');
      } else if (e.toString() == 'wrong-password') {
        showErrorMessage('Wrong password provided for that user.');
      } else {
        showErrorMessage(e.toString());
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: screenHeight * 0.023,
            child: ClipPath(
              clipper: MyClipperClass(),
              child: Container(
                height: screenHeight * 0.35, // Adjust height
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Color(0xFFecf9ff),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: MyClipperClass(),
              child: Container(
                height: screenHeight * 0.32, // Adjust height
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Color(0xFF40c4ff),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.12,
            left: screenWidth * 0.1,
            child: const Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.2,
            left: screenWidth * 0.1,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login with email",
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "or phone",
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.1,
            right: screenWidth * 0.04,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'signuppage');
              },
              child: Container(
                alignment: Alignment.center,
                width: screenWidth * 0.4,
                height: screenHeight * 0.08,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.blue),
                        gapPadding: 4,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.blue),
                        gapPadding: 4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: screenWidth * 0.9,
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.blue),
                        gapPadding: 4,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.blue),
                        gapPadding: 4,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.3,
            child: MyButton(
              buttonText: 'Log In',
              onTap: () async {
                login();
              },
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Or Continue with"),
                const SizedBox(width: 5),
                GestureDetector(
                  child: Text(
                    "mobile number",
                    style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
                const SizedBox(width: 5),
                const Text("or", style: TextStyle(fontSize: 15)),
                const SizedBox(width: 5),
                GestureDetector(
                  child: Text(
                    "Google",
                    style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Positioned(
              bottom: screenHeight * 0.3,
              child: const CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class MyClipperClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0.0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 4, size.height - 8, size.width / 3, size.height - 6);
    path.quadraticBezierTo(
        3 * size.width / 4, size.height - 20, size.width, size.height - 85);
    path.lineTo(size.width, 0);
    path.lineTo(0.0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
