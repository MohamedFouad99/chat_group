// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

part of 'chat_cubit.dart';

//This code defines the state of the chat feature in a Flutter app using
//the Cubit architecture.
//The ChatState is an abstract class that represents the state of the chat feature.
//It has two subclasses: ChatInitial and ChatSuccess.
//ChatInitial represents the initial state of the chat feature before any messages are loaded.
//ChatSuccess represents the state of the chat feature after messages have been
//successfully loaded. It has a property messageWidgets, which is a list of
//MessageLine objects representing the messages in the chat.
@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatSuccess extends ChatState {
  List<MessageLine> messageWidgets;
  ChatSuccess({
    required this.messageWidgets,
  });
}
