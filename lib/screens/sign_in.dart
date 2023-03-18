// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison, use_build_context_synchronously
import 'package:chat_group/constant/constant_color.dart';
import 'package:chat_group/cubits/sign_in_cubit/sign_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../cubits/chat_cubit/chat_cubit.dart';
import '../helper/show_snack_bar.dart';
import '../widgets/custom_text_form_filed.dart';
import '../widgets/my_button.dart';
import 'chat_screen.dart';

class SignIn extends StatelessWidget {
  static const String screenRoute = 'signin_screen';
  late String email;
  late String password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInLoading) {
          isLoading = true;
        } else if (state is SignInSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushReplacementNamed(context, ChatScreen.screenRoute);
          showSnackBar(context, 'Welcome back');
          isLoading = false;
        } else if (state is SignInFailure) {
          showSnackBar(context, state.errorMessage);
          isLoading = false;
        }
      },
      builder: (context, state) => Scaffold(
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
                                height:
                                    MediaQuery.of(context).size.height * .15),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .35,
                              child: SvgPicture.asset(
                                  'assets/svg/group_chat2.svg'),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .04),
                            CustomTextFiled(
                              keyBoardType: TextInputType.emailAddress,
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
                              keyBoardType: TextInputType.visiblePassword,
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
                                  BlocProvider.of<SignInCubit>(context)
                                      .loginUser(
                                          email: email, password: password);
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
      ),
    );
  }
}
