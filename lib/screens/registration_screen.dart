// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:chat_group/screens/chat_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/constant_color.dart';
import '../widgets/custom_text_form_filed.dart';
import '../widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  static const String screenRoute = 'registration_screen';

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();

  late String displayName;
  late String email;
  late String password;
  late String photoUrl;
  Future<void> registerUser() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Upload photo to Firebase Storage
      Reference ref =
          storage.ref().child('users/${userCredential.user!.uid}/profile.jpg');
      UploadTask uploadTask = ref.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      photoUrl = await taskSnapshot.ref.getDownloadURL();

      // Save user data to Firestore
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
      });

      // Navigate to home screen
      Navigator.pushReplacementNamed(context, ChatScreen.screenRoute);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  File? imageFile;

  Future<void> pickImage(ImageSource source) async {
    PickedFile? pickedFile = await picker.getImage(source: source);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Center(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              BoxConstraints customConstraints = const BoxConstraints(
                maxWidth: 700,
              );
              return SizedBox(
                width: customConstraints.maxWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .05),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .35,
                      child: SvgPicture.asset('assets/svg/group_chat3.svg'),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .04),
                    CustomTextFiled(
                      hint: 'Enter Your Name',
                      onChange: (value) {
                        displayName = value!;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextFiled(
                      hint: 'Enter Your Email',
                      onChange: (value) {
                        email = value!;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextFiled(
                      hint: 'Enter Your Password',
                      onChange: (value) {
                        password = value!;
                      },
                      obscure: true,
                    ),
                    const SizedBox(height: 8),
                    imageFile == null
                        ? SizedBox.shrink()
                        : Image.file(
                            imageFile!,
                            height: 200.0,
                            width: 200.0,
                            fit: BoxFit.cover,
                          ),
                    const SizedBox(height: 10),
                    MyButton(
                      color: kPrimaryColor,
                      title: 'choose photo',
                      onPresssed: () {
                        pickImage(ImageSource.gallery);
                      },
                    ),
                    MyButton(
                      color: kPrimaryColor,
                      title: 'Register',
                      onPresssed: () {
                        registerUser();
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
