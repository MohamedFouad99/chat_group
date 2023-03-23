// ignore_for_file: must_be_immutable

import 'package:chat_group/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
              onPressed: () {
                BlocProvider.of<ChatCubit>(context).audioRecord(context);
              },
              icon: Icon(
                Icons.mic,
                color: Theme.of(context).colorScheme.primary,
              )),
          Expanded(
              child: CustomTextFiled(
            hint: 'Write message..',
            keyBoardType: TextInputType.text,
            controller: messageTextController,
            onChange: (value) {
              messageText = value;
            },
            prefixIcon: IconButton(
                onPressed: () {
                  BlocProvider.of<ChatCubit>(context)
                      .pickImage(ImageSource.gallery);
                },
                icon: Icon(
                  Icons.image,
                  color: Theme.of(context).colorScheme.primary,
                )),
            suffixIcon: IconButton(
                onPressed: () {
                  BlocProvider.of<ChatCubit>(context).pickFile();
                },
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Theme.of(context).colorScheme.primary,
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
                color: Theme.of(context).colorScheme.primary,
              )),
        ],
      ),
    );
  }
}
