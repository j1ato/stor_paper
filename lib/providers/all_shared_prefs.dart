import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// methods used to save and retrieve scroll offset and 
// textsize between app restarts
// convert to change notifier

class AllSharedPrefs extends ChangeNotifier {
  static double value;

  Future<void> saveOffset(String storyKey, double scrollPosition) async {
    final prefs = await SharedPreferences.getInstance();
    final value = scrollPosition;
    AllSharedPrefs.value = scrollPosition;
    await prefs.setDouble(storyKey, value);
  }

  Future<void> saveTextSize(String storyKey, double textSize) async {
    final prefs = await SharedPreferences.getInstance();
    final value = textSize;
    await prefs.setDouble(storyKey, value);
  }

  Future<double> readOffset(String storyKey) async {
    final prefs = await SharedPreferences.getInstance();
    return value = prefs.getDouble(storyKey) ?? 0;
  }

  Future<double> readTextSize(String storyKey) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getDouble(storyKey) ?? 15;
    return value;
  }
}
