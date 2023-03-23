import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String currentLanguage = 'en';

  void changeLanguage(String newLanguage) async {
    final prefs = await SharedPreferences.getInstance();
    currentLanguage = newLanguage;
    prefs.setString('language', newLanguage);
    notifyListeners();
  }
}
