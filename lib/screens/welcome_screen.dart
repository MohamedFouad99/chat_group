import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/my_button.dart';
import 'registration_screen.dart';
import 'sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String screenRoute = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Text(
                        AppLocalizations.of(context)!.chatgroup,
                        style: Theme.of(context).textTheme.headline1,
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  MyButton(
                    color: Theme.of(context).colorScheme.secondary,
                    title: AppLocalizations.of(context)!.signIn,
                    onPresssed: () {
                      Navigator.pushNamed(context, SignIn.screenRoute);
                    },
                  ),
                  MyButton(
                    color: Theme.of(context).colorScheme.primary,
                    title: AppLocalizations.of(context)!.register,
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
