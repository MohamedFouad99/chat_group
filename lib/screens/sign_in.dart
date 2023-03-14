// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison, use_build_context_synchronously
import 'package:chat_group/constant/constant_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../helper/show_snack_bar.dart';
import '../widgets/custom_text_form_filed.dart';
import '../widgets/my_button.dart';
import 'chat_screen.dart';

class SignIn extends StatefulWidget {
  static const String screenRoute = 'signin_screen';

  const SignIn({super.key});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
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
                              height: MediaQuery.of(context).size.height * .15),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .35,
                            child:
                                SvgPicture.asset('assets/svg/group_chat2.svg'),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .04),
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
                          const SizedBox(height: 10),
                          MyButton(
                            color: ksecondryColor,
                            title: 'Login',
                            onPresssed: () async {
                              if (formKey.currentState!.validate()) {
                                isLoading = true;
                                setState(() {});
                                try {
                                  await loginUser();
                                } on FirebaseAuthException catch (ex) {
                                  if (ex.code == 'user-not-found') {
                                    showSnackBar(context, 'user not found');
                                  } else if (ex.code == 'wrong-password') {
                                    showSnackBar(context, 'wrong password');
                                  }
                                } catch (ex) {
                                  showSnackBar(context, ex.toString());
                                }
                                isLoading = false;
                                setState(() {});
                              } else {}
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

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (user != null) {
      Navigator.pushReplacementNamed(context, ChatScreen.screenRoute);
      showSnackBar(context, 'Welcome back');
    }
  }
}
