// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

// This code defines a function getuser that retrieves user data from the
// Firestore database. It first creates three empty lists to store user names,
// emails, and profile photos. It then retrieves a collection of documents from
// the Firestore database, iterates through each document and extracts the name,
// email, and profile photo for each user, and adds them to their respective lists.
// Finally, it emits a UserSuccess state with the lists of names, emails, and
// profile photos as arguments.
  void getuser() async {
    final List<String> names = [];
    final List<String> emails = [];
    final List<String> photos = [];
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    final QuerySnapshot querySnapshot = await collectionReference.get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;
    names.clear();
    emails.clear();
    photos.clear();
    for (final DocumentSnapshot document in documents) {
      final String name = document.get('displayName');
      final String email = document.get('email');
      final String photo = document.get('photoUrl');

      names.add(name);
      emails.add(email);
      photos.add(photo);
    }
    emit(UserSuccess(names, emails, photos));
  }
}
