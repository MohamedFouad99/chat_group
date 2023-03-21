// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, unnecessary_import, use_build_context_synchronously, unused_local_variable, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../screens/chat_screen.dart';
import '../../widgets/message_line.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  final audioRecorder = Record();
  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  File? imageFile;
  String? photoUrl;
  String? pdfUrl;
  String? recordUrl;
  List<String> members = [];
////////////////////////////////////////////////////////////////////////////////
//AudioRecord
  Future<String> getAudioDirectory() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

//todo refactoring ui
  Future<void> audioRecord(BuildContext context) async {
    String audioDirectory = await getAudioDirectory();
    String audioPath = '$audioDirectory/audio_file.mp3';
    if (await audioRecorder.hasPermission()) {
      await audioRecorder.start(path: audioPath);
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Recording'),
        content: const Text('Recording in progress...'),
        actions: [
          ElevatedButton(
            child: const Text('Stop'),
            onPressed: () async {
              await audioRecorder.stop();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );

    File audioFile = File(audioPath);
    String audioUrl = await uploadFileToFirebase(audioFile);
  }

  Future<String> uploadFileToFirebase(File file) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('audio_messages/${DateTime.now()}.mp3');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    recordUrl = await snapshot.ref.getDownloadURL();
    sendMessage(message: "");
    return recordUrl ?? "";
  }

  //////////////////////////////////////////////////////////////////////////////
  //PDF
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

////////////////////////////////////////////////////////////////////////////////
//Image
  Future<void> pickImage(ImageSource source) async {
    PickedFile? pickedFile = await picker.getImage(source: source);
    imageFile = File(pickedFile!.path);
    Reference ref = storage.ref().child('images/${DateTime.now()}.png');
    UploadTask uploadTask = ref.putFile(imageFile!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    photoUrl = await taskSnapshot.ref.getDownloadURL();
    sendMessage(message: "");
  }

////////////////////////////////////////////////////////////////////////////////
  void sendMessage({
    required String message,
  }) async {
    final messageRef = firestore.collection('messages').doc();

    messageRef.set({
      'text': message,
      'sender': signedInUser.email,
      'image': photoUrl ?? "",
      'pdf': pdfUrl ?? "",
      'record': recordUrl ?? "",
      'time': FieldValue.serverTimestamp(),
      'seen_by': [],
    });
    photoUrl = "";
    pdfUrl = "";
    recordUrl = "";
  }

////////////////////////////////////////////////////////////////////////////////
  String changeDay = "";
  var timestampNextDay;
  void getMessages() {
    getAllMember();
    firestore
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .listen((event) {
      List<MessageLine> messageWidgets = [];
      final messages = event.docs.reversed;
      for (var message in messages) {
        final time = message.get('time');
        final messageText = message.get('text');
        final messageSender = message.get('sender');
        final image = message.get('image');
        final pdf = message.get('pdf');

        final record = message.get('record');
        final seenBy = List<String>.from(message.get('seen_by'));
        final isRead = seenBy.length == members.length - 1;
        final currentUser = signedInUser.email;
        final timestamp = time.toDate();
        final messageRef = message.reference;
        final timeFormatter = DateFormat('h:mm a');
        final dateFormatter = DateFormat('EEE, d/M/y');
        final times = timeFormatter.format(timestamp);
        final dates = dateFormatter.format(timestamp);
        final messageWidget = MessageLine(
          sender: messageSender,
          image: image,
          pdf: pdf,
          record: record,
          text: messageText,
          isMe: currentUser == messageSender,
          isRead: isRead,
          time: times,
          lastDay:
              messageWidgets.length == messages.length - 1 ? timestamp : null,
          date: changeDay == dates || changeDay == "" ? null : timestampNextDay,
          messageRef: messageRef,
        );
        timestampNextDay = timestamp;
        changeDay = dates;
        if (!isRead && !messageWidget.isMe) {
          message.reference.update({
            'seen_by': FieldValue.arrayUnion([currentUser])
          });
        }
        messageWidgets.add(messageWidget);
      }
      timestampNextDay = null;
      emit(ChatSuccess(messageWidgets: messageWidgets));
    });
  }

////////////////////////////////////////////////////////////////////////////
  Future<void> getAllMember() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    final QuerySnapshot querySnapshot = await collectionReference.get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;
    members.clear();
    for (final DocumentSnapshot document in documents) {
      final String email = document.get('email');
      members.add(email);
    }
  }
}
