// ignore_for_file: must_be_immutable

import 'package:chat_group/my_theme.dart';
import 'package:chat_group/providers/language_provider.dart';
import 'package:chat_group/providers/theme_provider.dart';
import 'package:chat_group/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  late LanguageProvider providerLanguage;
  late ThemeProvider provider;

  final auth = FirebaseAuth.instance;
  MyApp({super.key}) {
    sharedPref();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ThemeProvider>(context);
    providerLanguage = Provider.of<LanguageProvider>(context);
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
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale:
              Locale(Provider.of<LanguageProvider>(context).currentLanguage),
          supportedLocales: const [
            Locale('en'), // English
            Locale('ar'), // Arabic
          ],
          theme: MyThemeData.lightTheme,
          darkTheme: MyThemeData.darkTheme,
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          initialRoute: auth.currentUser != null
              ? ChatScreen.screenRoute
              : WelcomeScreen.screenRoute,
          routes: {
            WelcomeScreen.screenRoute: (context) => const WelcomeScreen(),
            SignIn.screenRoute: (context) => SignIn(),
            RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
            ChatScreen.screenRoute: (context) => ChatScreen(),
            UsersScreen.screenRoute: (context) => UsersScreen(),
            SettingsScreen.screenRoute: (context) => SettingsScreen(),
          }),
    );
  }

  void sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    providerLanguage.changeLanguage(prefs.getString('language') ?? 'en');
    if (prefs.getString('theme') == 'light') {
      provider.changeTheme(ThemeMode.light);
    } else if (prefs.getString('theme') == 'dark') {
      provider.changeTheme(ThemeMode.dark);
    } else {
      provider.changeTheme(ThemeMode.dark);
    }
  }
}
