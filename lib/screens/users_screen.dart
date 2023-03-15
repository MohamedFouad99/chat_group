import 'package:chat_group/constant/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final List<String> names = [];
final List<String> emails = [];
final List<String> photos = [];

class UsersScreen extends StatelessWidget {
  static const String screenRoute = 'users_screen';

  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    getuser();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ksecondryColor, title: const Text('Group Member')),
      body: ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(photos[index]),
              ),
              title: Text(names[index]),
              subtitle: Text(emails[index]),
            );
          }),
    );
  }
}

Future<void> getuser() async {
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  final QuerySnapshot querySnapshot = await collectionReference.get();
  final List<DocumentSnapshot> documents = querySnapshot.docs;

  for (final DocumentSnapshot document in documents) {
    final String name = document.get('displayName');
    final String email = document.get('email');
    final String photo = document.get('photoUrl');

    names.add(name);
    emails.add(email);
    photos.add(photo);
  }
}
