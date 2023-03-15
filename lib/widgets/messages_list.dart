// ignore_for_file: must_be_immutable

import 'package:chat_group/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'message_line.dart';

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
