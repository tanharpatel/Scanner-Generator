import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;
String spTheme;

setTheme(String theme) async {
  prefs = await SharedPreferences.getInstance();
  prefs.setString("spTheme", theme);
}

getTheme() async {
  prefs = await SharedPreferences.getInstance();
  spTheme = prefs.getString("spTheme");
  return spTheme;
}