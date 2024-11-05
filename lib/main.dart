import 'package:chat_app/core/utils/theme/theme.dart';
import 'package:chat_app/feature/authentication/auth.dart';
import 'package:chat_app/feature/authentication/sign_up_page.dart';
import 'package:chat_app/feature/chat/presentation/pages/bottom_nav_bar.dart';
import 'package:chat_app/feature/chat/presentation/pages/homepage.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'feature/authentication/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const BottomNavBarPage(),
      theme: CAppTheme.lightTheme,
      darkTheme: CAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: {
        'homepage': (context) => HomePage(),
        'loginpage': (context) => const LoginPage(),
        'signuppage': (context) => const SignUpPage(),
        'myauthpage': (context) => const MyAuth(),
      },
    );
  }
}
