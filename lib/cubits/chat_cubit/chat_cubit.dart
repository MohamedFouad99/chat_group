// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../screens/chat_screen.dart';
import '../../widgets/message_line.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  File? imageFile;
  String? photoUrl;
  Future<void> pickImage(ImageSource source) async {
    PickedFile? pickedFile = await picker.getImage(source: source);
    imageFile = File(pickedFile!.path);
    Reference ref = storage.ref().child('images/${DateTime.now()}.png');
    UploadTask uploadTask = ref.putFile(imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    photoUrl = await taskSnapshot.ref.getDownloadURL();
    sendMessage(message: "");
  }

  void sendMessage({required String message}) async {
    firestore.collection('messages').add({
      'text': message,
      'sender': signedInUser.email,
      'image': photoUrl,
      'time': FieldValue.serverTimestamp(),
    });
    photoUrl = "";
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
        final image = message.get('image');
        final currentUser = signedInUser.email;
        final messageWidget = MessageLine(
          sender: messageSender,
          image: image,
          text: messageText,
          isMe: currentUser == messageSender,
        );
        messageWidgets.add(messageWidget);
      }
      emit(ChatSuccess(messageWidgets: messageWidgets));
    });
  }
}
