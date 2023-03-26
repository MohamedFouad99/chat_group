import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// This is a function that displays an AwesomeDialog widget, which is
// a customizable dialog box with various styles and animations. The function
// takes in several required parameters including the BuildContext, the dialog
// content and title, a boolean indicating whether the dialog can be cancelled,
// and a callback function to execute when the "Ok" button is pressed.
// The function sets up the AwesomeDialog widget with the specified parameters
// and then calls the 'show()' method to display the dialog to the user.
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
