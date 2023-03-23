import 'package:chat_group/my_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/chat_cubit/chat_cubit.dart';
import 'cubits/register_cubit/register_cubit.dart';
import 'cubits/sign_in_cubit/sign_in_cubit.dart';
import 'cubits/user_cubit/user_cubit.dart';
import 'firebase_options.dart';
import 'screens/chat_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/sign_in.dart';
import 'screens/users_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: MyThemeData.lightTheme,
          darkTheme: MyThemeData.darkTheme,
          themeMode: ThemeMode.dark,
          initialRoute: auth.currentUser != null
              ? ChatScreen.screenRoute
              : WelcomeScreen.screenRoute,
          routes: {
            WelcomeScreen.screenRoute: (context) => const WelcomeScreen(),
            SignIn.screenRoute: (context) => SignIn(),
            RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
            ChatScreen.screenRoute: (context) => ChatScreen(),
            UsersScreen.screenRoute: (context) => UsersScreen(),
          }),
    );
  }
}
