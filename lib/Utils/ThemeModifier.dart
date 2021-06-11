import 'package:flutter/material.dart';

var darkTheme = ThemeMode.dark;
var lightTheme = ThemeMode.light;
var systemTheme = ThemeMode.system;

enum ThemeType { Light, Dark, System }

class ThemeModifier extends ChangeNotifier {
  ThemeMode currentTheme = systemTheme;

  setTheme(ThemeType themeType) {
    if (themeType == ThemeType.System) {
      currentTheme = systemTheme;
      return notifyListeners();
    } else if (themeType == ThemeType.Light) {
      currentTheme = lightTheme;
      return notifyListeners();
    } else if (themeType == ThemeType.Dark) {
      currentTheme = darkTheme;
      return notifyListeners();
    }
  }
}