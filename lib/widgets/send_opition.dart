// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constant/constant_color.dart';
import '../screens/chat_screen.dart';
import 'custom_text_form_filed.dart';

class SendOpition extends StatelessWidget {
  SendOpition(
      {super.key,
      required this.messageText,
      required this.messageTextController});
  String? messageText;
  TextEditingController messageTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  'sender': signedInUser.email,
                  'time': FieldValue.serverTimestamp(),
                });
              },
              icon: Icon(
                Icons.send,
                color: kPrimaryColor,
              )),
        ],
      ),
    );
  }
}
