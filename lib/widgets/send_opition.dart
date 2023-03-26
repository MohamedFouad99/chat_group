// ignore_for_file: must_be_immutable

import 'package:chat_group/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'custom_text_form_filed.dart';

// This is a StatelessWidget called SendOption that displays a row of buttons and
// a text field for the user to enter a message to be sent. It takes in two
// required parameters: messageText which is a String variable that holds the
// user's input message, and messageTextController which is a TextEditingController
// used to control the text field widget.The widget returns a Padding widget
// containing a Row widget with three IconButtons and an Expanded widget that
// contains a custom TextField called CustomTextFiled with a prefix and suffix
// IconButton.When the user presses the send button, it clears the messageTextController
// and calls the sendMessage method from the ChatCubit to send the user's message.
// When the user presses the microphone button, it calls the audioRecord method
// from the ChatCubit to record the user's voice message. When the user presses
// the image or PDF buttons, it calls the pickImage or pickFile method from the
// ChatCubit, respectively, to allow the user to select and send an image or PDF file.
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
            hint: AppLocalizations.of(context)!.writing,
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
