// ignore_for_file: must_be_immutable

import 'package:chat_group/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constant/constant_color.dart';
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
                BlocProvider.of<ChatCubit>(context)
                    .sendMessage(message: messageText ?? "");
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
