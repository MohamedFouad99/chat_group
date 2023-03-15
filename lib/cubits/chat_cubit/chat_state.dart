// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatSuccess extends ChatState {
  List<MessageLine> messageWidgets;
  ChatSuccess({
    required this.messageWidgets,
  });
}
