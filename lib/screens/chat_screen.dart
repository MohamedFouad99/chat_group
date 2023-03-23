// ignore_for_file: avoid_print, use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api
import 'package:chat_group/screens/users_screen.dart';
import 'package:chat_group/screens/welcome_screen.dart';
import 'package:chat_group/widgets/messages_list.dart';
import 'package:chat_group/widgets/send_opition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/chat_cubit/chat_cubit.dart';
import '../cubits/user_cubit/user_cubit.dart';

final firestore = FirebaseFirestore.instance;
late User signedInUser; //to give us the email

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final auth = FirebaseAuth.instance;
  String? messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    BlocProvider.of<ChatCubit>(context).getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BayanatZ Group',
          style: Theme.of(context).textTheme.headline2,
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.dark_mode)),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<UserCubit>(context).getuser();
              Navigator.pushNamed(context, UsersScreen.screenRoute);
            },
            icon: const Icon(Icons.group),
          ),
          IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacementNamed(
                  context, WelcomeScreen.screenRoute);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessagesList(),
            SendOpition(
                messageText: messageText,
                messageTextController: messageTextController),
          ],
        ),
      ),
    );
  }

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
}
