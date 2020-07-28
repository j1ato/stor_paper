import 'package:flutter/material.dart';

// theme for components within the app 

ThemeData buildTheme() {
  final ThemeData base = ThemeData();

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
          fontFamily: 'Cinzel',
          fontSize: 52,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.bold),
      headline2: base.headline2.copyWith(
          fontFamily: 'Cinzel',
          fontSize: 22,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.bold),
      subtitle1: base.subtitle1.copyWith(
          fontFamily: 'Cinzel',
          fontSize: 18,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.bold),
      bodyText1: base.bodyText1.copyWith(
        fontFamily: 'Lato',
        fontSize: 16,
        color: Colors.white.withOpacity(0.8),
      ),
      bodyText2: base.bodyText2.copyWith(
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
        fontSize: 15,
        color: Colors.white.withOpacity(0.8),
        fontWeight: FontWeight.w800,
      ),
    );
  }

  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    appBarTheme: AppBarTheme(
      color: Colors.grey,
      elevation: 0,
    ),
    dialogBackgroundColor: const Color(0xF0111114).withOpacity(0.8),
    bottomAppBarColor: const Color(0xF0D7D9E1),
    scaffoldBackgroundColor: const Color(0xF0D7D9E1),
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
