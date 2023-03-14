// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:chat_group/screens/chat_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/constant_color.dart';
import '../helper/show_snack_bar.dart';
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
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
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

      Navigator.pushReplacementNamed(context, ChatScreen.screenRoute);
      showSnackBar(context, 'You created a new account successfully.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email.');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    isLoading = false;
    setState(() {});
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Center(
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  BoxConstraints customConstraints = const BoxConstraints(
                    maxWidth: 700,
                  );
                  return SizedBox(
                    width: customConstraints.maxWidth,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .05),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .35,
                            child:
                                SvgPicture.asset('assets/svg/group_chat3.svg'),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .04),
                          imageFile == null
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    const Spacer(),
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        image: DecorationImage(
                                          image: FileImage(imageFile!),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                          const SizedBox(
                            height: 16,
                          ),
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
                          const SizedBox(height: 10),
                          imageFile == null
                              ? MyButton(
                                  color: ksecondryColor,
                                  title: 'choose photo',
                                  onPresssed: () {
                                    pickImage(ImageSource.gallery);
                                  },
                                )
                              : SizedBox(),
                          MyButton(
                            color: kPrimaryColor,
                            title: 'Register',
                            onPresssed: () async {
                              if (formKey.currentState!.validate()) {
                                isLoading = true;
                                setState(() {});
                                await registerUser();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
