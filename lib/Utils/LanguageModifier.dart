import 'package:flutter/material.dart';

var eng = Language.English;
var hindi = Language.Hindi;
var guj = Language.Gujarati;

enum Language { English, Hindi, Gujarati }

class LanguageModifier extends ChangeNotifier {
  Language currentLang = eng;

  setLang(Language lang) {
    if (lang == Language.English) {
      currentLang = eng;
      return notifyListeners();
    } else if (lang == Language.Hindi) {
      currentLang = hindi;
      return notifyListeners();
    } else if (lang == Language.Gujarati) {
      currentLang = guj;
      return notifyListeners();
    }
  }
}