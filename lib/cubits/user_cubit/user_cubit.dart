// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

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
