import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constant/constant_color.dart';
import '../widgets/custom_text_form_filed.dart';
import '../widgets/my_button.dart';

class RegistrationScreen extends StatefulWidget {
  static const String screenRoute = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                      color: kPrimaryColor,
                      title: 'Register',
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
