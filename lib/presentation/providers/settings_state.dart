import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState with ChangeNotifier {
  SettingsState({required this.prefs});
  SharedPreferences prefs;
  var _currentLang = const Locale('ar');
  Locale get curretnLang => _currentLang;

  void getSavedLang() async {
    print("getSavedLang started");
    if (prefs.containsKey("lang")) {
      _currentLang = Locale(prefs.getString("lang")!);
    }
    notifyListeners();
  }

  void setLang(String locale) {
    print("setLang $locale");
    _currentLang = Locale(locale);
    notifyListeners();
  }
}
