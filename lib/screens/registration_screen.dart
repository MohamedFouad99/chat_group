// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:chat_group/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_group/cubits/register_cubit/register_cubit.dart';
import 'package:chat_group/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../helper/show_snack_bar.dart';
import '../widgets/custom_text_form_filed.dart';
import '../widgets/my_button.dart';

class RegistrationScreen extends StatelessWidget {
  static const String screenRoute = 'register_screen';
  late String displayName;
  late String email;
  late String password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  File? imageFile;
  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushReplacementNamed(context, ChatScreen.screenRoute);
          showSnackBar(
              context, AppLocalizations.of(context)!.accountSuccessfully);
          isLoading = false;
        } else if (state is RegisterFailure) {
          showSnackBar(context, state.errorMessage);
          isLoading = false;
        } else if (state is PickedImageSuccess) {
          imageFile = state.imageFile;
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                                      MediaQuery.of(context).size.height * .05),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .35,
                                child: SvgPicture.asset(
                                    'assets/svg/group_chat3.svg'),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .04),
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
                                hint: AppLocalizations.of(context)!.name,
                                textStyle:
                                    Theme.of(context).textTheme.subtitle1,
                                keyBoardType: TextInputType.text,
                                onChange: (value) {
                                  displayName = value!;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              CustomTextFiled(
                                hint: AppLocalizations.of(context)!.email,
                                textStyle:
                                    Theme.of(context).textTheme.subtitle1,
                                keyBoardType: TextInputType.emailAddress,
                                onChange: (value) {
                                  email = value!;
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              CustomTextFiled(
                                hint: AppLocalizations.of(context)!.password,
                                textStyle:
                                    Theme.of(context).textTheme.subtitle1,
                                keyBoardType: TextInputType.visiblePassword,
                                onChange: (value) {
                                  password = value!;
                                },
                                obscure: true,
                              ),
                              const SizedBox(height: 8),
                              const SizedBox(height: 10),
                              imageFile == null
                                  ? MyButton(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      title:
                                          AppLocalizations.of(context)!.photo,
                                      onPresssed: () {
                                        BlocProvider.of<RegisterCubit>(context)
                                            .pickImage(ImageSource.gallery);
                                      },
                                    )
                                  : const SizedBox(),
                              MyButton(
                                color: Theme.of(context).colorScheme.primary,
                                title: AppLocalizations.of(context)!.register,
                                onPresssed: () async {
                                  if (formKey.currentState!.validate()) {
                                    BlocProvider.of<RegisterCubit>(context)
                                        .registerUser(
                                      email: email,
                                      password: password,
                                      displayName: displayName,
                                      imageFile: imageFile!,
                                    );
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
      },
    );
  }
}
