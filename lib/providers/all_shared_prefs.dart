import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// methods used to save and retrieve scroll offset and 
// textsize between app restarts
// convert to change notifier

class AllSharedPrefs extends ChangeNotifier {

  Future<void> saveOffset(String storyKey, double scrollPosition) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(storyKey, scrollPosition);
  }

  Future<void> saveTextSize(String storyKey, double textSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(storyKey, textSize);
  }

  Future<double> readOffset(String storyKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(storyKey) ?? 0;
  }

  Future<double> readTextSize(String storyKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(storyKey) ?? 15;
  }
}
