// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:file_picker/file_picker.dart';
import '../../screens/chat_screen.dart';
import '../../widgets/message_line.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  File? imageFile;
  String? photoUrl;
  String? pdfUrl;

  Future<void> pickFile() async {
    FilePickerResult? pickedPdf = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (pickedPdf != null) {
      final file = File(pickedPdf.files.single.path!);
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('pdf/${DateTime.now()}.pdf');
      final TaskSnapshot task = await storageRef.putFile(file);
      pdfUrl = await task.ref.getDownloadURL();
    }
    sendMessage(message: "");
  }

  Future<void> pickImage(ImageSource source) async {
    PickedFile? pickedFile = await picker.getImage(source: source);
    imageFile = File(pickedFile!.path);
    Reference ref = storage.ref().child('images/${DateTime.now()}.png');
    UploadTask uploadTask = ref.putFile(imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    photoUrl = await taskSnapshot.ref.getDownloadURL();
    sendMessage(message: "");
  }

  void sendMessage({
    required String message,
  }) async {
    firestore.collection('messages').add({
      'text': message,
      'sender': signedInUser.email,
      'image': photoUrl ?? "",
      'pdf': pdfUrl ?? "",
      'time': FieldValue.serverTimestamp(),
    });
    photoUrl = "";
    pdfUrl = "";
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
        final pdf = message.get('pdf');
        final currentUser = signedInUser.email;
        final messageWidget = MessageLine(
          sender: messageSender,
          image: image,
          pdf: pdf,
          text: messageText,
          isMe: currentUser == messageSender,
        );
        messageWidgets.add(messageWidget);
      }
      emit(ChatSuccess(messageWidgets: messageWidgets));
    });
  }
}
