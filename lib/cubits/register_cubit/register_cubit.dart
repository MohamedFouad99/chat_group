// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    PickedFile? pickedFile = await picker.getImage(source: source);
    emit(PickedImageSuccess(imageFile: File(pickedFile!.path)));
    // imageFile = File(pickedFile!.path);
  }

  Future<void> registerUser(
      {required String displayName,
      required String email,
      required String password,
      required File imageFile}) async {
    emit(RegisterLoading());
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Reference ref =
          storage.ref().child('users/${userCredential.user!.uid}/profile.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String photoUrl = await taskSnapshot.ref.getDownloadURL();

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
      });
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(errorMessage: 'weak-password'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errorMessage: 'email-already-in-use'));
      }
    } catch (e) {
      emit(RegisterFailure(errorMessage: e.toString()));
    }
  }
}
