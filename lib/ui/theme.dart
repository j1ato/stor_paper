import 'package:flutter/material.dart';

// theme for components within the app 

ThemeData buildTheme() {
  final ThemeData base = ThemeData();

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      display1: base.display1.copyWith(
          fontFamily: 'Cinzel',
          fontSize: 52,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.bold),
      display2: base.display2.copyWith(
          fontFamily: 'Cinzel',
          fontSize: 22,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.bold),
      subtitle: base.subtitle.copyWith(
          fontFamily: 'Cinzel',
          fontSize: 18,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.bold),
      body1: base.body1.copyWith(
        fontFamily: 'Lato',
        fontSize: 16,
        color: Colors.white.withOpacity(0.8),
      ),
      body2: base.body2.copyWith(
          fontFamily: 'Lato',
          fontSize: 14,
          color: Colors.white.withOpacity(0.5),
          textBaseline: TextBaseline.ideographic),
      caption: base.caption.copyWith(
        fontFamily: 'Lato',
        fontSize: 12,
        color: Colors.white.withOpacity(0.5),
      ),
      button: base.button.copyWith(
        fontFamily: 'Lato',
        fontSize: 12,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }

  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    appBarTheme: AppBarTheme(
      color: Colors.black12,
      elevation: 0,
    ),
    dialogBackgroundColor: const Color(0xF0111114).withOpacity(0.8),
    bottomAppBarColor: Colors.black,
    scaffoldBackgroundColor: const Color(0xF0020202),
    buttonColor: const Color(0xF0111114).withOpacity(0.03),
    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xF0111114),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 20,
    ),
  );
}
