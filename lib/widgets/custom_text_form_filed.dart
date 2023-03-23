import 'package:flutter/material.dart';

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
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Filed is required';
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
