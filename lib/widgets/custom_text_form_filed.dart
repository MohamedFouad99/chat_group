import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// This code defines a custom text field widget that extends StatelessWidget.
// It takes in several parameters, including hint, keyboardType, maxLines,
// onSaved, controller, obscure, prefixIcon, suffixIcon, textStyle, and onChange.
// In the build method, it returns a TextFormField widget with customized
// properties such as keyboardType, controller, obscureText, onSaved, maxLines,
// textAlign, cursorColor, and decoration. It also defines validator to check if
// the input value is empty or not. The decoration parameter includes prefixIcon,
// suffixIcon, hintText, and border properties.
// The buildBorder method creates an OutlineInputBorder with a rounded border
// radius of 8 and a borderSide of a specified color or white if not provided.
class CustomTextFiled extends StatelessWidget {
  const CustomTextFiled(
      {super.key,
      required this.hint,
      required this.keyBoardType,
      this.maxLines = 1,
      this.onSaved,
      this.controller,
      this.obscure = false,
      this.prefixIcon,
      this.suffixIcon,
      this.textStyle,
      this.onChange});
  final String hint;
  final TextEditingController? controller;
  final int maxLines;
  final bool obscure;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChange;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyBoardType;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyBoardType,
      controller: controller,
      obscureText: obscure,
      onSaved: onSaved,
      onChanged: onChange,
      // validator: (text) {
      //   if (text == null || text.trim().isEmpty) {
      //     return 'Please enter Email';
      //   }

      //   bool emailValid = RegExp(
      //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //       .hasMatch(text);
      //   if (!emailValid) {
      //     return 'email format not valid';
      //   }
      //   return null;
      // },
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return AppLocalizations.of(context)!.filedRequired;
        } else {
          return null;
        }
      },
      maxLines: maxLines,
      textAlign: TextAlign.center,
      cursorColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: textStyle,
        border: buildBorder(),
        enabledBorder: buildBorder(Theme.of(context).colorScheme.secondary),
        focusedBorder: buildBorder(Theme.of(context).colorScheme.primary),
      ),
    );
  }

  OutlineInputBorder buildBorder([color]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color ?? Colors.white));
}
