import 'package:chat_group/constant/constant_color.dart';
import 'package:chat_group/screens/users_screen.dart';
import 'package:chat_group/screens/welcome_screen.dart';
import 'package:chat_group/widgets/custom_text_form_filed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/messages_list.dart';

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
  final firestore = FirebaseFirestore.instance;
  String? messageText; //to give us the message
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ksecondryColor,
        title: const Text('BayanatZ Group'),
        actions: [
          IconButton(
            onPressed: () {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MessagesList(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.mic,
                      color: kPrimaryColor,
                    )),
                Expanded(
                    child: CustomTextFiled(
                  hint: 'Write message..',
                  controller: messageTextController,
                  onChange: (value) {
                    messageText = value;
                  },
                  prefixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.image,
                        color: kPrimaryColor,
                      )),
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.picture_as_pdf,
                        color: kPrimaryColor,
                      )),
                )),
                IconButton(
                    onPressed: () {
                      messageTextController.clear();
                      firestore.collection('messages').add({
                        'text': messageText,
                        'senderName': signedInUser.displayName,
                        'senderEmail': signedInUser.email,
                        'time': FieldValue.serverTimestamp(),
                      });
                    },
                    icon: Icon(
                      Icons.send,
                      color: kPrimaryColor,
                    )),
              ],
            ),
          ),
        ],
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
