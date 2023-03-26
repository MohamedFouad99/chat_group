// ignore_for_file: must_be_immutable

import 'package:chat_group/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_line.dart';

// This code defines a stateless widget called MessagesList, which renders a
// list of MessageLine widgets using a BlocConsumer to get updates from a ChatCubit.
// When the ChatCubit state changes to ChatSuccess, the listener function updates
// the messageWidgets list with the new messages.The build method returns an
// Expanded widget that contains a ListView widget with reverse set to true,
// meaning that the list is displayed in reverse order. The padding is set to
// provide some margin around each MessageLine widget.
// Finally, the children property of the ListView is set to messageWidgets,
// which contains the list of messages.
class MessagesList extends StatelessWidget {
  MessagesList({super.key});
  List<MessageLine> messageWidgets = [];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatSuccess) {
            messageWidgets = state.messageWidgets;
          }
        },
        builder: (context, state) {
          return ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          );
        },
      ),
    );
  }
}
