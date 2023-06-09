import 'package:flutter/material.dart';

//This is a custom reusable widget called MyButton. It is a stateless widget
// that takes in some required parameters in its constructor.
// These parameters are the button's color, title, and the onPresssed
// callback function that gets triggered when the button is pressed.
class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.color,
      required this.title,
      required this.onPresssed});
  final Color color;
  final String title;
  final VoidCallback onPresssed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          onPressed: onPresssed,
          minWidth: 200,
          height: 42,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
