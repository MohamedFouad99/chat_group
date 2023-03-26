import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// method named changeLanguage which takes a new language as an argument
// and saves it to the shared preferences. It also updates the currentLanguage
// property to the new language and notifies all the listeners to the changes
// made to the currentLanguage property.
class LanguageProvider extends ChangeNotifier {
  String currentLanguage = 'en';

  void changeLanguage(String newLanguage) async {
    final prefs = await SharedPreferences.getInstance();
    currentLanguage = newLanguage;
    prefs.setString('language', newLanguage);
    notifyListeners();
  }
}
