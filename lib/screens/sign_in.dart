// ignore_for_file: library_private_types_in_public_api
import 'package:chat_group/constant/constant_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/custom_text_form_filed.dart';
import '../widgets/my_button.dart';

class SignIn extends StatefulWidget {
  static const String screenRoute = 'signin_screen';

  const SignIn({super.key});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
                    SizedBox(height: MediaQuery.of(context).size.height * .15),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .35,
                      child: SvgPicture.asset('assets/svg/group_chat2.svg'),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .04),
                    const CustomTextFiled(
                      hint: 'Enter Your Email',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const CustomTextFiled(
                      hint: 'Enter Your Password',
                      obscure: true,
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                      color: ksecondryColor,
                      title: 'Login',
                      onPresssed: () {},
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
