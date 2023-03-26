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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  String changeDay = "";
  var timestampNextDay;
////////////////////////////////////////////////////////////////////////////////
//AudioRecord

//This code defines three functions that deal with recording and uploading
// audio files to Firebase. The [getAudioDirectory()] function returns the path
//to the application's documents directory, which will be used to save the recorded
// audio file. The [audioRecord()] function first gets the audio directory path,
// then checks if the app has permission to access the device's microphone.
// If permission is granted, the function starts recording and shows a dialog to
// indicate that the recording is in progress. When the user stops the recording,
// the audio file is uploaded to Firebase using the [uploadFileToFirebase()] function,
// which returns a download URL for the file. The URL is then used to send a message
// containing the audio file to the appropriate recipient.

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
        title: Text(AppLocalizations.of(context)!.recording),
        content: Text(AppLocalizations.of(context)!.recordingProgress),
        actions: [
          ElevatedButton(
            child: Text(AppLocalizations.of(context)!.stop),
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
  // This code defines a function called pickFile() that allows the user to
  //select a PDF file from their device and upload it to Firebase.
  //The function uses the FilePicker plugin to prompt the user to select a file
  //with the ".pdf" extension. If a file is selected, the function creates a File
  //object from the selected file and uploads it to Firebase Storage using the
  //putFile() method of a Reference object. Once the upload is complete,
  //the function retrieves the download URL for the uploaded file and stores it
  //in the pdfUrl variable.

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

// This code defines a function called pickImage() that allows the user to
//select an image from device's photo gallery, and then upload the image
//to Firebase. The function uses the ImagePicker plugin to prompt the user
//to select an image from photo gallery, and then creates a File object from
//the selected image. The File object is then uploaded to Firebase Storage
//using the putFile() method of a Reference object, which specifies the name
//and location of the file in Firebase. Once the upload is complete,
//the function retrieves the download URL for the uploaded image
//and stores it in the photoUrl variable

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

// This code defines a function called sendMessage() that sends a message to
//Firestore with the message text, sender email, and any associated media
//files (image, PDF, and record). The function creates a new document in the
//messages collection using the doc() method, which generates a unique document ID.
//The document data is then set using the set() method, which takes a map
//of key-value pairs representing the fields and values to be stored in the document.
//The function also sets the time field to the current server timestamp using the FieldValue.
//serverTimestamp() method. Finally, any associated media URLs (photoUrl, pdfUrl, and recordUrl)
//are reset to an empty string to prevent them from being sent with subsequent messages.

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

// This code defines a function called getMessages which retrieves and displays
//messages from a Firestore database. It first calls a function called getAllMember
//which is not shown in the code snippet. It then queries the Firestore collection
//named 'messages', orders the messages by their timestamp in ascending order and
//listens to any changes to the collection. Once it receives new messages,
//it extracts various fields such as the message text, sender, image, pdf,
//record, and seen_by, and creates a MessageLine widget for each message.
//For each message, it checks whether the message has been read by all members
//except the current user, and if not, it updates the Firestore database with
//the current user's ID. Finally, the function emits a state with a list of
//MessageLine widgets to update the chat interface.

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
  //This function retrieves all members' emails from the Firestore 'users' collection
  //and stores them in a list called 'members'. It first creates a
  //CollectionReference object for the 'users' collection and retrieves all
  //documents in the collection using get(). Then, it loops through the documents
  //and extracts the 'email' field from each document and adds it to
  //the 'members' list. The list is cleared before adding the emails to avoid duplicates.
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
