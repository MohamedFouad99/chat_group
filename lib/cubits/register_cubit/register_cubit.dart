// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

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
//pickImage(): a method that allows the user to pick an image from
//their device's gallery.
  Future<void> pickImage(ImageSource source) async {
    PickedFile? pickedFile = await picker.getImage(source: source);
    emit(PickedImageSuccess(imageFile: File(pickedFile!.path)));
  }

//registerUser(): a method that handles the registration process by creating
//a new user account with the given email and password, uploading the user's
//profile image to FirebaseStorage, and storing the user's information in
//FirebaseFirestore. The method emits a loading state while it performs the
//registration process, and then either emits a RegisterSuccess state or a
//RegisterFailure state if an error occurs during the registration process.
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
      } else if (e.code == 'invalid-email') {
        emit(RegisterFailure(errorMessage: 'invalid-email'));
      }
    } catch (e) {
      emit(RegisterFailure(errorMessage: e.toString()));
    }
  }
}
