// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

// This code defines a SettingsScreen class which extends StatelessWidget and
// displays a screen that allows the user to change the app's theme and language.
// It defines two dropdown menus, one for selecting the app theme and the other
// for selecting the app language. The selected values of each dropdown menu are
// stored in dropdownvalue and dropdownvalueLanguage respectively.
// The class also makes use of Provider to get the current ThemeProvider and
// LanguageProvider instances, which are used to change the app's theme and
// language based on the selected values from the dropdown menus.
class SettingsScreen extends StatelessWidget {
  static const String screenRoute = 'settings_screen';
  SettingsScreen({super.key});
  String? dropdownvalue;
  String? dropdownvalueLanguage;
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var languageProvider = Provider.of<LanguageProvider>(context);
    var items = [
      AppLocalizations.of(context)!.light,
      AppLocalizations.of(context)!.dark,
    ];
    var itemsLanguage = [
      AppLocalizations.of(context)!.english,
      AppLocalizations.of(context)!.arabic,
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.setting,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.mode,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton(
                    isExpanded: true,
                    elevation: 0,
                    underline: const SizedBox(),
                    value: languageProvider.currentLanguage == 'en' &&
                            themeProvider.themeMode == ThemeMode.light
                        ? 'light'
                        : languageProvider.currentLanguage == 'en' &&
                                themeProvider.themeMode == ThemeMode.dark
                            ? 'dark'
                            : languageProvider.currentLanguage == 'ar' &&
                                    themeProvider.themeMode == ThemeMode.light
                                ? 'نهاري'
                                : 'داكن',
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      dropdownvalue = newValue!;
                      if (newValue == AppLocalizations.of(context)!.light) {
                        themeProvider.changeTheme(ThemeMode.light);
                      } else {
                        themeProvider.changeTheme(ThemeMode.dark);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              Text(
                AppLocalizations.of(context)!.language,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton(
                    isExpanded: true,
                    elevation: 0,
                    underline: const SizedBox(),
                    value: languageProvider.currentLanguage == 'en'
                        ? 'english'
                        : 'العربية',
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: itemsLanguage.map((String itemsLanguage) {
                      return DropdownMenuItem(
                        value: itemsLanguage,
                        child: Text(itemsLanguage),
                      );
                    }).toList(),
                    onChanged: (String? newValueLanguage) {
                      dropdownvalueLanguage = newValueLanguage!;
                      if (newValueLanguage == 'arabic') {
                        languageProvider.changeLanguage('ar');
                      } else {
                        languageProvider.changeLanguage('en');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
