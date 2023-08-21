import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData.from(
  colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      background: Color(0xFFEEEFF5),
      onBackground: Color(0xFF4a4a4a),
      secondary: Color(0xFFe91e63),
      onSecondary: Color(0xFF2a2a2a),
      primary: Color(0xFFc2185b),
      secondaryContainer: Color(0xFFFFFFFF),
      tertiary: Color.fromARGB(255, 50, 197, 55),
      primaryContainer: Colors.white),
);

ThemeData dark = ThemeData.from(
    colorScheme: const ColorScheme.dark(
  brightness: Brightness.dark,
  background: Color(0xFF2a2a2a),
  onBackground: Color(0xFFFFFFFF),
  secondary: Color(0xFFe91e63),
  onSecondary: Color(0xFF2a2a2a),
  secondaryContainer: Color(0xFF444444),
  primary: Color(0xFFe91e63),
  primaryContainer: Color(0xFF3f3f3f),
  tertiary: Color.fromARGB(255, 50, 197, 55),
));

class ThemeService with ChangeNotifier {
  SharedPreferences? prefs;
  String? mode;
  bool? test;
  static String key = "privatekey";
  ThemeService() {
    mode = "system";
    loadSharedPrefs();
  }

  initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  loadSharedPrefs() async {
    await initSharedPrefs();
    mode = prefs!.getString(key);
    notifyListeners();
  }

  saveSharedPrefs() async {
    await initSharedPrefs();
    await prefs!.setString(key, mode!);
    notifyListeners();
  }

  setTheme(String themeMode) {
    mode = themeMode;
    saveSharedPrefs();
    notifyListeners();
  }
}
