import 'package:flutter/material.dart';
import 'screens/registration_screen.dart';
import 'screens/sign_in.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: WelcomeScreen.screenRoute,
        routes: {
          WelcomeScreen.screenRoute: (context) => const WelcomeScreen(),
          SignIn.screenRoute: (context) => const SignIn(),
          RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
        });
  }
}
