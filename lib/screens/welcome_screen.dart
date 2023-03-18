import '../constant/constant_color.dart';
import 'registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/my_button.dart';
import 'sign_in.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String screenRoute = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .35,
                        child: SvgPicture.asset('assets/svg/group_chat.svg'),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .04),
                      const Text(
                        'Chat Group',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff2e386b),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  MyButton(
                    color: ksecondryColor,
                    title: 'Sign In',
                    onPresssed: () {
                      Navigator.pushNamed(context, SignIn.screenRoute);
                    },
                  ),
                  MyButton(
                    color: kPrimaryColor,
                    title: 'Register',
                    onPresssed: () {
                      Navigator.pushNamed(
                          context, RegistrationScreen.screenRoute);
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
