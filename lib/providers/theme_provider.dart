import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// The class has a changeTheme() method that takes a ThemeMode argument and
// updates the themeMode property with the new mode. It also saves the updated
// theme mode to SharedPreferences and notifies listeners of the change using
// the notifyListeners() method.
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  void changeTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    themeMode = mode;
    prefs.setString('theme', mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}
