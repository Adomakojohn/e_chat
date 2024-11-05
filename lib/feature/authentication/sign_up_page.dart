import 'package:chat_app/core/utils/widgets/error_message.dart';
import 'package:chat_app/feature/authentication/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/utils/widgets/buttons.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscureText = true;

  void createUser() async {
    final auth = AuthServices();
    auth.signUpWithEmailAndPassword(
      emailController.text,
      passwordController.text,
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacementNamed(context, 'homepage');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showErrorMessage(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showErrorMessage(context, 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: screenHeight * 0.02,
            child: ClipPath(
              clipper: MyClipperClass(),
              child: Container(
                height: screenHeight * 0.4,
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
                height: screenHeight * 0.35,
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Color(0xFF40c4ff),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.1,
            left: screenWidth * 0.05,
            child: const Text(
              "CREATE AN",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: screenWidth * 0.05,
            child: const Text(
              "ACCOUNT",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.09,
            right: screenWidth * 0.05,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'loginpage');
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
                  'Log In',
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: screenWidth * 0.85,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                        gapPadding: 4,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                        gapPadding: 4,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  width: screenWidth * 0.85,
                  child: TextField(
                    controller: passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
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
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                        gapPadding: 4,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                        gapPadding: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.24,
            child: MyButton(
              buttonText: 'Create Account',
              onTap: () async {
                createUser();
              },
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Or Continue with"),
                SizedBox(width: screenWidth * 0.02),
                GestureDetector(
                  child: Text(
                    "Google",
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
          if (isLoading)
            Positioned(
              bottom: screenHeight * 0.45,
              child: const CircularProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.transparent,
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
