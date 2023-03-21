import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

void showAwsomeDialog(
    {required BuildContext context,
    required String content,
    required String title,
    required bool isCanclelable,
    required void Function() btnOkOnPress}) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    borderSide: const BorderSide(
      color: Colors.green,
      width: 1,
    ),
    width: MediaQuery.of(context).size.width * .95,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(14),
    ),
    dismissOnTouchOutside: isCanclelable,
    dismissOnBackKeyPress: isCanclelable,
    headerAnimationLoop: true,
    animType: AnimType.scale,
    title: title,
    desc: content,
    showCloseIcon: false,
    btnCancelOnPress: () {},
    btnOkOnPress: btnOkOnPress,
  ).show();
}
