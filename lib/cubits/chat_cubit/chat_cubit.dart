// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../screens/chat_screen.dart';
import '../../widgets/message_line.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  void sendMessage({required String message}) {
    firestore.collection('messages').add({
      'text': message,
      'sender': signedInUser.email,
      'time': FieldValue.serverTimestamp(),
    });
  }

  void getMessages() {
    firestore
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .listen((event) {
      List<MessageLine> messageWidgets = [];
      final messages = event.docs.reversed;
      for (var message in messages) {
        final messageText = message.get('text');
        final messageSender = message.get('sender');
        final currentUser = signedInUser.email;
        final messageWidget = MessageLine(
          sender: messageSender,
          text: messageText,
          isMe: currentUser == messageSender,
        );
        messageWidgets.add(messageWidget);
      }
      emit(ChatSuccess(messageWidgets: messageWidgets));
    });
  }
}
