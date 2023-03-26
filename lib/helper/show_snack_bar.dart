import 'package:flutter/material.dart';

// The SnackBar widget is a small temporary message that appears at the bottom of
// the screen and automatically disappears after a short time.
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
